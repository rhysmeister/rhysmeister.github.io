---
layout: post
title: 'TSQL: Backup a database to multiple files'
date: 2014-10-03 15:49:02.000000000 +02:00
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
- backup
- SQL Server
- TSQL
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/tsql-backup-database-multiple-files/1991/";s:7:"tinyurl";s:26:"http://tinyurl.com/o4v4zx9";s:4:"isgd";s:19:"http://is.gd/R1ImqZ";}
  tweetbackscheck: '1613447481'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-backup-database-multiple-files/1991/"
---
I wanted to see how much I could reduce backup times by specifying multiple files in the[BACKUP TSQL](http://msdn.microsoft.com/en-GB/library/ms186865.aspx "BACKUP TSQL") command. Here's a script I wrote to do this and I present a summary of the results below. The times are based on a database that produced a backup file(s) of approximately 51GB. You mileages will vary here based on a whole bunch of factors. Therefore consider these results illustrative and do your own testing.

```
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- Single file
BACKUP DATABASE dbname
TO DISK = '\\path\to\backup\location\single_file_backup.bak';
GO

-- Two files
BACKUP DATABASE dbname
TO DISK = '\\path\to\backup\location\two_files_file1.bak',
DISK = '\\path\to\backup\location\two_files_file2.bak'
GO

-- Five files
BACKUP DATABASE dbname
TO DISK = '\\path\to\backup\location\five_files_file1.bak',
DISK = '\\path\to\backup\location\five_files_file2.bak',
DISK = '\\path\to\backup\location\five_files_file3.bak',
DISK = '\\path\to\backup\location\five_files_file4.bak',
DISK = '\\path\to\backup\location\five_files_file5.bak'
GO

-- Ten files
BACKUP DATABASE dbname
TO DISK = '\\path\to\backup\location\ten_files_file1.bak',
DISK = '\\path\to\backup\location\ten_files_file2.bak',
DISK = '\\path\to\backup\location\ten_files_file3.bak',
DISK = '\\path\to\backup\location\ten_files_file4.bak',
DISK = '\\path\to\backup\location\ten_files_file5.bak',
DISK = '\\path\to\backup\location\ten_files_file6.bak',
DISK = '\\path\to\backup\location\ten_files_file7.bak',
DISK = '\\path\to\backup\location\ten_files_file8.bak',
DISK = '\\path\to\backup\location\ten_files_file9.bak',
DISK = '\\path\to\backup\location\ten_files_file10.bak'
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
```

Results are as follows...

| Files | 1 | 2 | 5 | 10 |
| CPU time (ms) | 16878 | 13527 | 16159 | 21745 |
| Elapsed time (ms) | 1983023 | 1545460 | 1372302 | 1237149 |

[![tsql_multiple_backup_files_sql_server]({{ site.baseurl }}/assets/2014/10/tsql_multiple_backup_files_sql_server.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/10/tsql_multiple_backup_files_sql_server.png)

