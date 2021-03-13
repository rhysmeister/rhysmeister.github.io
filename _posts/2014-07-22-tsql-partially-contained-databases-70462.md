---
layout: post
title: 'TSQL: Partially Contained Databases 70-462'
date: 2014-07-22 21:31:33.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
tags:
- Partially contained Databases
- SQL Server
- TSQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461836'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:80:"http://www.youdidwhatwithtsql.com/tsql-partially-contained-databases-70462/1937/";s:7:"tinyurl";s:26:"http://tinyurl.com/meslpbh";s:4:"isgd";s:19:"http://is.gd/R1Eetu";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-partially-contained-databases-70462/1937/"
---
Here's some TSQL for the [Partially Contained Databases](http://msdn.microsoft.com/en-gb/library/ff929071(v=sql.110).aspx "SQL Server 2012 Partially Contained Databases") section of the [70-462](https://www.microsoft.com/learning/en-gb/exam-70-462.aspx "70-462 Administering SQL Server 2012 Databases"). Explanatory comments are included.

```
-- enable show advanced options and view current config
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
EXEC sp_configure;
GO
-- enable the feature
EXEC sp_configure 'contained database authentication', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
-- view changed options
EXEC sp_configure;
GO

-- create the partially contained database
CREATE DATABASE partial_containment_db
CONTAINMENT = PARTIAL;
GO

USE partial_containment_db;
GO
-- create a contained user from a windows account
CREATE USER [contso\contained_user_b];
GO
-- create a contained user that uses sql auth
CREATE USER [contained_user_c] WITH PASSWORD = 'Pa$$w0rd';
GO
```
