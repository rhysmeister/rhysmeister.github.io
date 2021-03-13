---
layout: post
title: 'TSQL: Transparent Data Encryption exercise for 70-462'
date: 2014-06-23 22:51:29.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
tags:
- 70-462
- Encryption
- SQL Server
- TDE
meta:
  _edit_last: '1'
  tweetbackscheck: '1612926268'
  shorturls: a:3:{s:9:"permalink";s:87:"http://www.youdidwhatwithtsql.com/tsql-transparent-data-encryption-exercise-70462/1919/";s:7:"tinyurl";s:26:"http://tinyurl.com/o6sybxc";s:4:"isgd";s:19:"http://is.gd/Q1qpN9";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-transparent-data-encryption-exercise-70462/1919/"
---
Here’s some TSQL for the WingTipToys2012 [Transparent Data Encryption (TDE)](http://msdn.microsoft.com/en-gb/library/bb934049(v=sql.110).aspx "SQL Server Transparent Data Encryption") exercise in the [70-462](https://www.microsoft.com/learning/en-gb/exam-70-462.aspx "Administering Microsoft SQL Server 2012 Databases") training materials.

```
CREATE DATABASE WingTipToys2012;
GO

USE WingTipToys2012;
GO

USE [master];
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SecretPa$$w0rd';
GO

CREATE CERTIFICATE server_cert WITH SUBJECT = 'My DEK Certificate';
GO

USE WingTipToys2012;
GO

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_128
ENCRYPTION BY SERVER CERTIFICATE server_cert;
GO

ALTER DATABASE WingTipToys2012
SET ENCRYPTION ON;
GO

-- Create tables
CREATE TABLE dbo.aeroplanes
(
	[model] VARCHAR(MAX)
) WITH (DATA_COMPRESSION = ROW);
GO

CREATE TABLE dbo.helicopters
(
	[model] VARCHAR(MAX)
) WITH (DATA_COMPRESSION = ROW);
GO

-- While we're here backup the certificate
USE [master];
GO
BACKUP CERTIFICATE server_cert
TO FILE = 'server_cert'
WITH PRIVATE KEY
(
	FILE = 'private_key_file',
	ENCRYPTION BY PASSWORD = 'Secret2014'
);
GO
```
