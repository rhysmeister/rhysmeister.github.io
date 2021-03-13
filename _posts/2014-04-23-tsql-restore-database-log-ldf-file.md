---
layout: post
title: 'TSQL: Restore a database without a log (ldf) file'
date: 2014-04-23 18:30:29.000000000 +02:00
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
- ldf
- log
- SQL Server
- TSQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613478933'
  shorturls: a:3:{s:9:"permalink";s:74:"http://www.youdidwhatwithtsql.com/tsql-restore-database-log-ldf-file/1898/";s:7:"tinyurl";s:26:"http://tinyurl.com/lhw7vpt";s:4:"isgd";s:19:"http://is.gd/gDI2uf";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-restore-database-log-ldf-file/1898/"
---
I had to restore a bunch of databases missing a log file today. This was only a test server but I wanted to get it running as quickly as possible.

The script here is based on the advice in this [blog post from sqlskills](https://www.sqlskills.com/blogs/paul/checkdb-from-every-angle-emergency-mode-repair-the-very-very-last-resort/ "ldf missing"). Note that this is very dodgy and should only be used as a last resort (i.e. no backups) in a production environment.

This script here will generate the commands required to create a new log file. Execute the commands one-by-one to get the database online.

```
DECLARE @script VARCHAR(MAX);
SELECT TOP 1 @script = 'ALTER DATABASE [' + [name] + '] SET EMERGENCY;' + CHAR(13)
		+ 'ALTER DATABASE [' + [name] + '] SET SINGLE_USER;' + CHAR(13)
		+ 'DBCC CHECKDB (N''' + [name] + ''',REPAIR_ALLOW_DATA_LOSS) WITH ALL_ERRORMSGS, NO_INFOMSGS;' + CHAR(13)
		+ 'ALTER DATABASE [' + [name] + '] SET MULTI_USER;' + CHAR(13)
FROM sys.databases
WHERE state_desc = 'RECOVERY_PENDING';
PRINT @script;
```
