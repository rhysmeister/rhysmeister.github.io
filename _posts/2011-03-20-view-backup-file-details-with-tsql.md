---
layout: post
title: View backup file details with TSQL
date: 2011-03-20 16:46:43.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- T-SQL
tags:
- Backups
- SQL Server
- TSQL
meta:
  tweetbackscheck: '1613447914'
  shorturls: a:3:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/view-backup-file-details-with-tsql/1073";s:7:"tinyurl";s:26:"http://tinyurl.com/67uyg79";s:4:"isgd";s:19:"http://is.gd/nubNhx";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/view-backup-file-details-with-tsql/1073/"
---
In order to automate testing of backups it's useful to be able to query backup files to access various bits of meta-data. We can do this with the [RESTORE FILELISTONLY](http://msdn.microsoft.com/en-us/library/ms173778.aspx "RESTORE FILELISTONLY") TSQL command. In the simplest format the command is as follows;

```
RESTORE FILELISTONLY
FROM DISK = 'c:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\Backup\AdventureWorks_20110320.bak';
```

[![restore filelistonly tsql]({{ site.baseurl }}/assets/2011/03/restore_filelistonly_tsql_thumb.png "restore filelistonly tsql")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/View-backup-file-details-with-TSQL_E57D/restore_filelistonly_tsql.png)

This doesn't help us much with automation. We need to get this resultset into a table so we can make use of the information it provides in our stored procedures. We can do this with a bit of trickery with the [EXECUTE](http://msdn.microsoft.com/en-us/library/ms188332.aspx "TSQL EXECUTE command") command.

```
-- Define a table variable to hold our resultset
-- Will only be accessible in the current batch.
-- Consider using a temp table for other needs
DECLARE @filelist TABLE
(
	LogicalName NVARCHAR(128) NOT NULL PRIMARY KEY CLUSTERED,
	PhysicalName NVARCHAR(260) NOT NULL,
	[Type] CHAR(1) NOT NULL,
	FileGroupName NVARCHAR(128) NULL,
	Size NUMERIC(20,0) NOT NULL,
	MaxSize NUMERIC(20,0) NOT NULL,
	FileId BIGINT NOT NULL,
	CreateLSN NUMERIC(25,0) NOT NULL,
	DropLSN NUMERIC(25,0) NULL,
	UniqueId UNIQUEIDENTIFIER NOT NULL,
	ReadOnlyLSN NUMERIC(25,0) NULL,
	ReadWriteLSN NUMERIC(25,0) NULL,
	BackupSizeInBytes BIGINT NOT NULL,
	SourceBlockSize INT NOT NULL,
	FileGroupId INT NOT NULL,
	LogGroupGUID UNIQUEIDENTIFIER NULL,
	DifferentialBaseLSN NUMERIC(25,0) NULL,
	DifferentialBaseGUID UNIQUEIDENTIFIER NOT NULL,
	IsReadOnly BIT NOT NULL,
	IsPresent BIT NOT NULL,
	TDEThumbprint VARBINARY(32) NULL
);

-- Insert the data from the RESTORE FILELISTONLY command
-- into our table variable
INSERT INTO @filelist
EXECUTE
(
	'RESTORE FILELISTONLY
	FROM DISK = ''c:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\Backup\AdventureWorks_20110320.bak'''
);

-- Show that the table variable contains the data
SELECT *
FROM @filelist;
```
