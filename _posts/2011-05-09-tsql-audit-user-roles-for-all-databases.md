---
layout: post
title: 'TSQL: Audit user roles for all databases'
date: 2011-05-09 21:33:43.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags: []
meta:
  shorturls: a:3:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/tsql-audit-user-roles-for-all-databases/1085";s:7:"tinyurl";s:26:"http://tinyurl.com/6jax5sm";s:4:"isgd";s:19:"http://is.gd/4VUi6z";}
  tweetbackscheck: '1613479408'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-audit-user-roles-for-all-databases/1085/"
---
A while ago Thomas LaRock ([blog](http://thomaslarock.com) | [twitter](https://twitter.com/#!/SQLRockstar)) posted a script that used [sysusers](http://msdn.microsoft.com/en-us/library/ms179871.aspx) and the sp\_helpusers proc to audit user groups setup in your database. The original post is [here](http://thomaslarock.com/2011/03/march-madness-sql-server-system-tables-sysusers/). I'm busy documenting my environment and thought this would be a great addition to the info I collect.

The only issue I had with this script is that it would only audit users in the current database context. I want to automate this collection for all databases... so here's an updated script that does precisely that;

```
IF OBJECT_ID('tempdb..#user_table') IS NOT NULL
BEGIN
	DROP TABLE #user_table;
END;

-- tmp Table to hold the user data
CREATE TABLE #user_table
(
	ServerName NVARCHAR(100) NULL,
	[Database] NVARCHAR(256) NULL,
	UserName NVARCHAR(128) NOT NULL,
	GroupName NVARCHAR(128) NULL,
	LoginName NVARCHAR(128) NULL,
	DefDBName NVARCHAR(256) NULL,
	DefSchemaName NVARCHAR(100) NULL,
	UserID INTEGER NOT NULL,
	[SID] UNIQUEIDENTIFIER NULL
);

DECLARE @sql NVARCHAR(MAX);
SET @sql = '

	DECLARE @name SYSNAME,
			@sql_string NVARCHAR(MAX);

	-- Cursor containing all users for the current database context
	DECLARE usr_name CURSOR READ_ONLY FOR SELECT [name]
										  FROM sysusers
										  WHERE hasdbaccess = 1
										  AND [name] NOT LIKE ''#%''
										  AND [name] NOT IN (''guest'');

	OPEN usr_name;
	FETCH NEXT FROM usr_name INTO @name;

	WHILE (@@FETCH_STATUS = 0) -- This loop processes each database
	BEGIN

		-- if it''s a windows login surround with square brackets
		IF (@name LIKE ''%\%'')
		BEGIN
			SET @name = ''['' + @name + '']'';
		END

		SET @sql_string = N''EXEC sp_helpuser '' + @name;

		INSERT INTO #user_table
		(
			UserName,
			GroupName,
			LoginName,
			DefDBName,
			DefSchemaName,
			UserId,
			[SID]
		)
		EXEC(@sql_string);

		-- Add Server & database name to dataset
		UPDATE #user_table
		SET ServerName = @@SERVERNAME,
		[Database] = DB_NAME()
		WHERE ServerName IS NULL
		AND [Database] IS NULL;

		-- Get the next database user
		FETCH NEXT FROM usr_name INTO @name; -- Get next user

	END

	-- Clean up
	CLOSE usr_name;
	DEALLOCATE usr_name;';

-- Add USE database statement to change db context
SET @sql = 'USE ?; ' + @sql;
-- Execute the string for each database
EXEC sp_MSforeachDB @sql;

SELECT *
FROM #user_table
ORDER BY LoginName, [Database];
```

This will return a database similar to below.

[![sql_server_user_roles]({{ site.baseurl }}/assets/2011/05/sql_server_user_roles_thumb.png "sql\_server\_user\_roles")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Audit-user-roles-for-all-databases_12D0E/sql_server_user_roles.png)

