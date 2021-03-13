---
layout: post
title: 'TSQL: User-Defined Server Roles 70-462'
date: 2014-07-16 20:01:09.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SQL Server
- T-SQL
tags:
- SQL Server
- TSQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461428'
  shorturls: a:3:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/tsql-userdefined-server-roles-70462/1929/";s:7:"tinyurl";s:26:"http://tinyurl.com/ls6syf7";s:4:"isgd";s:19:"http://is.gd/pyj5fv";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-userdefined-server-roles-70462/1929/"
---
Just a little TSQL for the [User-Defined Server Roles](http://msdn.microsoft.com/en-us/library/ee677610.aspx "SQL Server User-Defined Server Roles")&nbsp;exercise in the 70-462 training materials. Explanatory comments are included.

```
USE [master];
GO

-- Create server role
CREATE SERVER ROLE [Login_Manager];
GO

-- Assign permission to server role
GRANT ALTER ANY LOGIN TO [Login_Manager];
GO

-- Add login to role
ALTER SERVER ROLE [Login_Manager] ADD MEMBER [CONTSO\domain_group_b];
GO

-- Create server role
CREATE SERVER ROLE [Database_Creator];
GO

-- Allow role to create databases
GRANT CREATE ANY DATABASE TO [Database_Creator];
GO

-- Add login to this role
ALTER SERVER ROLE [Database_Creator] ADD MEMBER [CONTSO\domain_user_b];
GO
```
