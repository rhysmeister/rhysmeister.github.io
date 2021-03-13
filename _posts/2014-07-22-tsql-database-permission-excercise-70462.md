---
layout: post
title: 'TSQL: Database Permission Exercise for 70-462'
date: 2014-07-22 23:05:52.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SQL Server
- T-SQL
tags:
- Database Permissions
- SQL Server
- TSQL
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:80:"http://www.youdidwhatwithtsql.com/tsql-database-permission-excercise-70462/1941/";s:7:"tinyurl";s:26:"http://tinyurl.com/qhr22o8";s:4:"isgd";s:19:"http://is.gd/uygvDA";}
  tweetbackscheck: '1613461824'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-database-permission-excercise-70462/1941/"
---
Here's the TSQL for an exercise, involving database permissions, from the [70-462](https://www.microsoft.com/learning/en-gb/exam-70-462.aspx "70-462 Administering SQL Server 2012 Databases"). Explanatory comments are included.

```
CREATE DATABASE Saturn;
GO

USE Saturn;
GO
CREATE ROLE Moon_Table_Editors;
GO

-- Create tables
CREATE TABLE Mimas
(
	id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	column1 VARCHAR(100) NOT NULL
);
GO
CREATE TABLE Thethys
(
	id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	column1 VARCHAR(100) NOT NULL
);
GO
CREATE TABLE Hyperion
(
	id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	column1 VARCHAR(100) NOT NULL
);
GO

CREATE SCHEMA Orbits;
GO

-- Add permissions to the tole
GRANT SELECT, REFERENCES, INSERT, UPDATE, DELETE, VIEW DEFINITION ON SCHEMA::Orbits TO Moon_Table_Editors;
GO

-- Check these permissions
SELECT dp.name, pm.[permission_name]
FROM sys.database_principals dp
INNER JOIN sys.database_permissions pm
	ON pm.grantee_principal_id = dp.principal_id
WHERE dp.[name] = 'Moon_Table_Editors';

-- Now we want to modify these permissions to include only SELECT and REFERENCES
REVOKE INSERT, UPDATE, DELETE, VIEW DEFINITION ON SCHEMA::Orbits TO Moon_Table_Editors;

-- Check this has worked...
SELECT dp.name, pm.[permission_name]
FROM sys.database_principals dp
INNER JOIN sys.database_permissions pm
	ON pm.grantee_principal_id = dp.principal_id
WHERE dp.[name] = 'Moon_Table_Editors';

-- Now create a new role called Moon_Table_Designers
CREATE ROLE Moon_Table_Designers;
GO

-- This role should be able to create tables in the Orbits schema only
GRANT CREATE TABLE TO Moon_Table_Designers;
GO
GRANT ALTER ON SCHEMA::Orbits TO Moon_Table_Designers;
GO

-- Create a user to test this
CREATE USER [user1] FOR LOGIN [user1];
GO
EXEC sp_addrolemember 'Moon_Table_Designers', 'user1';
GO

-- Impersonate this user
EXECUTE AS USER = 'user1';
GO

CREATE TABLE dbo.ShouldNotCreate
(
	id INTEGER NOT NULL PRIMARY KEY
);
GO

CREATE TABLE Orbits.TableShouldCreate
(
	id INTEGER NOT NULL PRIMARY KEY
);
GO

REVERT;
GO

-- Check which tables exist
SELECT *
FROM sys.tables
WHERE [name] IN ('ShouldNotCreate', 'TableShouldCreate');
GO
```
