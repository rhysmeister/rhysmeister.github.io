---
layout: post
title: Find out members of a database role in SQL Server
date: 2013-08-07 12:22:04.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
- T-SQL
tags:
- database role
- dmv
- SQL Server
meta:
  twittercomments: a:0:{}
  _edit_last: '1'
  tweetbackscheck: '1613291082'
  shorturls: a:3:{s:9:"permalink";s:69:"http://www.youdidwhatwithtsql.com/find-members-group-sql-server/1638/";s:7:"tinyurl";s:26:"http://tinyurl.com/l5nlhzv";s:4:"isgd";s:19:"http://is.gd/YLNUcv";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/find-members-group-sql-server/1638/"
---
Just a quick post with a query to identify members of a specific [database role](http://technet.microsoft.com/en-us/library/ms189121.aspx "SQL Server Database Roles") in MSSQL.

```
SELECT dp2.name
FROM sys.database_role_members dbrm
INNER JOIN sys.database_principals dp
	ON dp.principal_id = dbrm.role_principal_id
INNER JOIN sys.database_principals dp2
	ON dp2.principal_id = dbrm.member_principal_id
WHERE dp.name = 'Database Role';
```

You may want to use this in conjunction with a previous post on identifying [AD group members with Powershel](http://www.youdidwhatwithtsql.com/powershell-active-directory-group/1633/ "AD Group Members Powershell")l.

