---
layout: post
title: Assign a user role for all databases
date: 2011-07-04 14:54:56.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- T-SQL
tags: []
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  _wp_old_slug: assign
  tweetbackscheck: '1613141124'
  shorturls: a:3:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/assign-user-role-databases/1275";s:7:"tinyurl";s:26:"http://tinyurl.com/69pbwhd";s:4:"isgd";s:19:"http://is.gd/rcOVYO";}
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/assign-user-role-databases/1275/"
---
I'm moving the backup jobs we run onto specific users and need to assign the [db\_backupoperator](http://msdn.microsoft.com/en-us/library/ms189041%28v=sql.90%29.aspx) role to the user for each database. Very tedious to do in [SSMS](http://msdn.microsoft.com/en-us/library/ms174173.aspx "SQL Server Management Studio") so  
here's a quick script I knocked up.

The script will assign a specific database role to all databases on a SQL Server. The user will be created in the database if it doesn't already exist. Just make sure the login exists at a server level, set the **@user** and **@role** variables and you're good to go.

```
DECLARE @sql VARCHAR(MAX),
		@user VARCHAR(100),
		@role VARCHAR(100);

SET @user = 'DOMAIN\backupuser'; -- set the user here (server level login must exist)
SET @role = 'db_backupoperator'; -- set the role to assign

-- Create the user if it doesn't exist in the current db
SET @sql = 'USE ?;
			IF NOT EXISTS (SELECT *
						   FROM sys.database_principals
						   WHERE [name] = ''' + @user + ''')
			BEGIN
				CREATE USER [' + @user + '] FOR LOGIN [' + @user + ']
			END;';

EXEC sp_MSforeachdb @sql;

-- Assign the role to the db user
SET @sql = 'USE ?;
			EXEC sp_addrolemember ''' + @role + ''', ''' + @user + ''';';

EXEC sp_MSforeachdb @sql;
```
