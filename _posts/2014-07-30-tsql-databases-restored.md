---
layout: post
title: 'TSQL: When were databases last restored'
date: 2014-07-30 11:21:34.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
- T-SQL
tags: []
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:63:"http://www.youdidwhatwithtsql.com/tsql-databases-restored/1943/";s:7:"tinyurl";s:26:"http://tinyurl.com/p6p87pa";s:4:"isgd";s:19:"http://is.gd/l242u2";}
  tweetbackscheck: '1613411526'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-databases-restored/1943/"
---
Here's a couple of queries I've modified from [When was the last time your SQL Server database was restored?](http://www.mssqltips.com/sqlservertip/1724/when-was-the-last-time-your-sql-server-database-was-restored/ "When was the last time your SQL Server database was restored")

This first query shows restore times by database and restore type.

```
DECLARE @dbname sysname, @days int
SET @dbname = NULL --substitute for whatever database name you want

-- Max data / restore type
SELECT rsh.destination_database_name AS [Database],
                                CASE
                                                WHEN rsh.restore_type = 'D'
                                                                                THEN 'Database'
                                                WHEN rsh.restore_type = 'F'
                                                                                THEN 'File'
                                                WHEN rsh.restore_type = 'G'
                                                                                THEN 'Filegroup'
                                                WHEN rsh.restore_type = 'I'
                                                                                THEN 'Differential'
                                                WHEN rsh.restore_type = 'L'
                                                                                THEN 'Log'
                                                WHEN rsh.restore_type = 'V'
                                                                                THEN 'Verifyonly'
                                                WHEN rsh.restore_type = 'R'
                                                                                THEN 'Revert'
                                                ELSE rsh.restore_type
                                END AS [Restore Type],
                                MAX(rsh.restore_date) AS [Restore Started]
                                --bmf.physical_device_name AS [Restored From],
                                --rf.destination_phys_name AS [Restored To]
FROM msdb.dbo.restorehistory rsh

LEFT JOIN msdb.dbo.backupset bs
	 ON rsh.backup_set_id = bs.backup_set_id
LEFT JOIN msdb.dbo.restorefile rf
	ON rsh.restore_history_id = rf.restore_history_id
LEFT JOIN msdb.dbo.backupmediafamily bmf
	ON bmf.media_set_id = bs.media_set_id
WHERE /*rsh.restore_date >= DATEADD(dd, ISNULL(@days, -30), GETDATE()) --want to search for previous days
AND*/ destination_database_name = ISNULL(@dbname, destination_database_name) --if no dbname, then return all
GROUP BY rsh.destination_database_name,
                                CASE
                                                WHEN rsh.restore_type = 'D'
                                                                                THEN 'Database'
                                                WHEN rsh.restore_type = 'F'
                                                                                THEN 'File'
                                                WHEN rsh.restore_type = 'G'
                                                                                THEN 'Filegroup'
                                                WHEN rsh.restore_type = 'I'
                                                                                THEN 'Differential'
                                                WHEN rsh.restore_type = 'L'
                                                                                THEN 'Log'
                                                WHEN rsh.restore_type = 'V'
                                                                                THEN 'Verifyonly'
                                                WHEN rsh.restore_type = 'R'
                                                                                THEN 'Revert'
                                                ELSE rsh.restore_type
                                END
ORDER BY MAX(rsh.restore_date) DESC
GO
```

This next query shows last full restore for a database. I've modified the query to join from [sys.databases](http://msdn.microsoft.com/en-gb/library/ms178534(v=sql.105).aspx "sys.databases system view") so a record is returned even for databases that do not have a restore record.

```
-- Max database restore
SELECT d.[name] AS [Database],
	MAX(rsh.restore_date) AS [Restore Started]
FROM sys.databases d
LEFT JOIN msdb.dbo.restorehistory rsh
	ON rsh.destination_database_name = d.[name]
	AND rsh.restore_type = 'D'
LEFT JOIN msdb.dbo.backupset bs
	ON rsh.backup_set_id = bs.backup_set_id
LEFT JOIN msdb.dbo.restorefile rf
	ON rsh.restore_history_id = rf.restore_history_id
LEFT JOIN msdb.dbo.backupmediafamily bmf
	ON bmf.media_set_id = bs.media_set_id
GROUP BY d.[name]
ORDER BY MAX(rsh.restore_date) DESC
GO
```
