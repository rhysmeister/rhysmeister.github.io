---
layout: post
title: Moving user databases the TSQL way
date: 2013-08-08 19:41:25.000000000 +02:00
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
- SQL Server
- sys.master_files
- TSQL
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/moving-user-databases-tsql/1643/";s:7:"tinyurl";s:26:"http://tinyurl.com/lccnx8s";s:4:"isgd";s:19:"http://is.gd/jFx44r";}
  tweetbackscheck: '1612926759'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/moving-user-databases-tsql/1643/"
---
Here's a few queries I built to construct the commands needed to move user database files in SQL Server 2208 R2. The queries are based on the procedure outlined [here](http://technet.microsoft.com/en-us/library/ms345483(v=sql.105).aspx "SQL Server move user databases"). As with all scripts on the Internet take care with this. It worked fine for my circumstances but may not in yours. Be careful and take backups!

Select the appropriate user databases by database\_id

```
SELECT *
FROM sys.databases;
```

Take databases offline.

```
-- set specific user databases to move offline. This will rollback any active transactions
-- to put it into an offline status quicker.
SELECT 'ALTER DATABASE [' + [name] + '] SET OFFLINE WITH ROLLBACK IMMEDIATE;'
FROM sys.databases
WHERE database_id IN (5,6,7,8,9,10,11,12,13,14,15);
```

Generate file move commands.

```
-- Generate move commands for dos. Different locations for data and log files
-- Ensure these are appropriate for your system
SELECT 'move "' + mf.physical_name + '" ' +
		CASE
			WHEN mf.type_desc = 'ROWS' THEN '"G:\SQLData\'
			WHEN mf.type_desc = 'LOG' THEN '"H:\SQLLogs\'
		END + RIGHT(mf.physical_name, CHARINDEX('\', REVERSE(mf.physical_name))-1) + '"'
FROM sys.master_files mf
INNER JOIN sys.databases d
	ON d.database_id = mf.database_id
WHERE d.database_id IN (5,6,7,8,9,10,11,12,13,14,15);
```

Now move commands for MSSQL.

```
-- Move command for mssql
SELECT 'ALTER DATABASE [' + d.[name] + '] MODIFY FILE ( NAME = ' + mf.[name] + ', FILENAME = ''' +
		CASE
			WHEN mf.type_desc = 'ROWS' THEN 'G:\SQLData\'
			WHEN mf.type_desc = 'LOG' THEN 'H:\SQLLogs\'
		END + RIGHT(mf.physical_name, CHARINDEX('\', REVERSE(mf.physical_name))-1) + ''');'
FROM sys.master_files mf
INNER JOIN sys.databases d
	ON d.database_id = mf.database_id
WHERE d.database_id IN (5,6,7,8,9,10,11,12,13,14,15);
```

Now bbring your user databases back online.

```
-- Return user databases to online status
SELECT 'ALTER DATABASE [' + [name] + '] SET ONLINE;'
FROM sys.databases
WHERE database_id IN (5,6,7,8,9,10,11,12,13,14,15);
```

**UPDATE:** My syntax highlighter has got confused over this TSQL. I've confirmed they copy'n'paste into SSMS ok.

