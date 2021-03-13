---
layout: post
title: What permissions have your users really got?
date: 2014-02-17 13:00:48.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
- T-SQL
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613308937'
  shorturls: a:3:{s:9:"permalink";s:57:"http://www.youdidwhatwithtsql.com/permissions-users/1773/";s:7:"tinyurl";s:26:"http://tinyurl.com/ovjlcbm";s:4:"isgd";s:19:"http://is.gd/dyOYHZ";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/permissions-users/1773/"
---
Here's a TSQL script to audit the permissions of certain AD users access to a SQL Server instance. This script uses the [EXECUTE AS LOGIN](http://msdn.microsoft.com/en-us/library/ms181362.aspx "EXECUTE AS LOGIN TSQL Clause") clause and the system function [sys.fn\_my\_permissions](http://technet.microsoft.com/en-us/library/ms176097.aspx "TSQL sys.fn\_my\_permissions System function."). All databases on the SQL Server instance are queried and the script will output results containing the assigned user permissions. To get started all you need to do is change the INSERT into #users to contain the users you want to audit.  
Check out this post if you want to [audit users in a particular AD group](http://www.youdidwhatwithtsql.com/powershell-active-directory-group/1633/ "Powershell AD Group"). It might save you a little more time.

```
CREATE TABLE #users
(
	username VARCHAR(50) NOT NULL PRIMARY KEY CLUSTERED
);

INSERT INTO #users
(
	username
)
VALUES('DOMAIN\user1'),
('DOMAIN\user2'),
('DOMAIN\user3');

CREATE TABLE #permission_results
(
	username VARCHAR(50) NOT NULL,
	[database] VARCHAR(50) NOT NULL,
	[entity_name] VARCHAR(50) NOT NULL,
	subentity_name VARCHAR(50) NOT NULL,
	[permission_name] VARCHAR(50) NOT NULL
);

DECLARE user_cursor CURSOR FOR SELECT [username]
							   FROM #users;

DECLARE @username VARCHAR(50),
		@sql NVARCHAR(4000);

-- Open the cursor and get the first result
OPEN user_cursor;
FETCH NEXT FROM user_cursor INTO @username;

WHILE (@@FETCH_STATUS = 0)
BEGIN

	DECLARE db_cursor CURSOR FOR SELECT [name]
								 FROM sys.databases;
	DECLARE @database_name VARCHAR(50);

	OPEN db_cursor;
	FETCH NEXT FROM db_cursor INTO @database_name;

	WHILE (@@FETCH_STATUS = 0)
	BEGIN

		SET @sql = 'USE [' + @database_name + '];
					EXECUTE AS LOGIN = ''' + @username + ''';
					INSERT INTO #permission_results
					SELECT SUSER_NAME(), DB_NAME(), * FROM sys.fn_my_permissions (''?'', ''DATABASE'' );
					REVERT;'; -- Revert to avoid error

		BEGIN TRY

			EXEC sp_executesql @sql;

		END TRY
		BEGIN CATCH

			-- If we hit here then the current user probably doesn't have access
			DECLARE @error_message VARCHAR(1000);
			SET @error_message = ERROR_MESSAGE();
			PRINT 'Current user = ' + @username + '.' + @error_message;

		END CATCH;

		FETCH NEXT FROM db_cursor INTO @database_name;

	END;

	-- Clean up db_cursor
	CLOSE db_cursor;
	DEALLOCATE db_cursor;

	FETCH NEXT FROM user_cursor INTO @username;

END

-- Clean up
CLOSE user_cursor;
DEALLOCATE user_cursor;

SELECT *
FROM #permission_results
ORDER BY username;

DROP TABLE #users;
DROP TABLE #permission_results;
```

If the user does not have access to a database then this will not be included in the output result-set. Instead a message will be printed;

```
The server principal "DOMAIN\user1" is not able to access the database "model" under the current security context.
```

The output will look something like this;

```
DOMAIN\user1	master	database CONNECT
DOMAIN\user1	master	database SHOWPLAN
DOMAIN\user1	master	database VIEW DATABASE STATE
DOMAIN\user1	userdb1	database CONNECT
DOMAIN\user1	userdb1	database SHOWPLAN
DOMAIN\user1	userdb1	database SELECT
DOMAIN\user1	userdb1	database INSERT
DOMAIN\user1	userdb1	database UPDATE
DOMAIN\user1	userdb1	database DELETE
DOMAIN\user1	userdb1	database EXECUTE
DOMAIN\user1	userdb1	database VIEW DATABASE STATE
```
