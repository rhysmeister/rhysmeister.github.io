---
layout: post
title: 'TSQL: Create SQL Logins using certificates and asymmetric keys 70-462'
date: 2014-07-22 21:57:03.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SQL Server
- T-SQL
tags:
- asymmetric keys
- certificates
- SQL Server
meta:
  _edit_last: '1'
  tweetbackscheck: '1613477723'
  shorturls: a:3:{s:9:"permalink";s:97:"http://www.youdidwhatwithtsql.com/tsql-create-sql-logins-certificates-asymmetric-keys-70462/1939/";s:7:"tinyurl";s:26:"http://tinyurl.com/puqptcn";s:4:"isgd";s:19:"http://is.gd/3jUIsy";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-create-sql-logins-certificates-asymmetric-keys-70462/1939/"
---
Here's some TSQL for creating sql logins using [certificates](http://msdn.microsoft.com/en-us/library/ms187798.aspx "SQL Server Certificates") and [asymmetric keys](http://msdn.microsoft.com/en-gb/library/ms174430(v=sql.110).aspx "asymmetric keys"). Explanatory comments are included.

```
CREATE CERTIFICATE myCert
ENCRYPTION BY PASSWORD = 'Secret2014'
WITH SUBJECT = 'My certificate for sql logins';

USE [master]
GO

-- create sql user with the cert
CREATE LOGIN [sql_user_a] FROM CERTIFICATE [myCert];
GO

-- create key
CREATE ASYMMETRIC KEY myKey
WITH ALGORITHM = RSA_2048
ENCRYPTION BY PASSWORD = 'Secret2014';
GO

-- sql user with key
CREATE LOGIN [sql_user_b] FROM ASYMMETRIC KEY [myKey];
GO
```
