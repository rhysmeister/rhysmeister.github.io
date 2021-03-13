---
layout: post
title: 'TSQL: Database Mirroring with Certificates'
date: 2014-08-03 22:58:04.000000000 +02:00
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
- Database Mirroring
- SQL Server
- TSQL
meta:
  _edit_last: '1'
  twittercomments: a:0:{}
  tweetbackscheck: '1613452171'
  shorturls: a:3:{s:9:"permalink";s:76:"http://www.youdidwhatwithtsql.com/tsql-database-mirroring-certificates/1951/";s:7:"tinyurl";s:26:"http://tinyurl.com/pfhft6v";s:4:"isgd";s:19:"http://is.gd/JHTZKV";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-database-mirroring-certificates/1951/"
---
Here's some more TSQL for the [70-462](https://www.microsoft.com/learning/en-gb/exam-70-462.aspx "Administering SQL Server 2012 Databases") exam. The script shows the actions needed to configure database mirroring using certificates for authentication. Explanatory notes are included but you're likely to need the training materials for this to make sense. TSQL is not included for the backup/restore parts needed for database mirroring.

```
SELECT *
FROM sys.symmetric_keys;
GO

-- Create a database master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Secret1234';
GO

-- Create certificate (SQL-A)
CREATE CERTIFICATE SQL_A_Cert
WITH SUBJECT = 'My Mirroring certificate'
GO

-- Create certificate (SQL-B)
CREATE CERTIFICATE SQL_B_Cert
WITH SUBJECT = 'My Mirroring certificate'
GO

-- Endpoint (SQL-A) certificate authentication
CREATE ENDPOINT Endpoint_Mirroring
AS TCP (LISTENER_IP = ALL, LISTENER_PORT = 7024)
FOR DATABASE_MIRRORING (AUTHENTICATION = CERTIFICATE SQL_A_Cert, ROLE = ALL);
GO

-- Endpoint (SQL-B) certificate authentication
CREATE ENDPOINT Endpoint_Mirroring
AS TCP (LISTENER_IP = ALL, LISTENER_PORT = 7024)
FOR DATABASE_MIRRORING (AUTHENTICATION = CERTIFICATE SQL_B_Cert, ROLE = ALL);
GO

-- Backup certificate SQL-A
BACKUP CERTIFICATE SQL_A_Cert TO FILE = 'C:\backup\SQL_A_Cert.cer';

-- Backup certificate SQL-B
BACKUP CERTIFICATE SQL_B_Cert TO FILE = 'C:\backup\SQL_B_Cert.cer';

-- SQL-A create login for sql_b
CREATE LOGIN SQL_B_login WITH PASSWORD = 'Pa$$w0rd';
GO

CREATE USER SQL_B_user FROM LOGIN SQL_B_login;
GO

-- SQL-B create login for sql_a
CREATE LOGIN SQL_A_login WITH PASSWORD = 'Pa$$w0rd';
GO

CREATE USER SQL_A_user FROM LOGIN SQL_A_login;
GO

-- create cert on sql-a from sql_b backup
CREATE CERTIFICATE SQL_B_Cert
FROM FILE = 'c:\backup\sql_b_cert.cer';
GO

-- create cert on sql-b from sql_a backup
CREATE CERTIFICATE SQL_A_Cert
FROM FILE = 'c:\backup\sql_a_cert.cer';
GO

-- on sql-a
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO SQL_B_login;
GO

-- on sql-b
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO SQL_A_login;
GO

-- on sql-b
SELECT *
FROM sys.endpoints
ALTER ENDPOINT Endpoint_Mirroring STATE = STARTED;
ALTER DATABASE [AdventureMirror] SET PARTNER = 'TCP://sql-a:7024';
GO

-- on sql-a
SELECT *
FROM sys.endpoints
ALTER ENDPOINT Endpoint_Mirroring STATE = STARTED;

ALTER DATABASE [AdventureMirror] SET PARTNER = 'TCP://sql-b:7024';
GO

-- DMVs to check the setup
SELECT *
FROM sys.database_mirroring
WHERE mirroring_guid IS NOT NULL;

SELECT *
FROM sys.database_mirroring_endpoints;
```
