---
layout: post
title: 'TSQL: Restore a multiple file backup'
date: 2014-10-10 18:48:00.000000000 +02:00
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
- TSQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613278885'
  shorturls: a:3:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/tsql-restore-multiple-file-backup/1997/";s:7:"tinyurl";s:26:"http://tinyurl.com/mex86mz";s:4:"isgd";s:19:"http://is.gd/DM88g7";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-restore-multiple-file-backup/1997/"
---
Just a follow up post using the backup files created in [TSQL: Backup a database to multiple files](http://www.youdidwhatwithtsql.com/tsql-backup-database-multiple-files/1991/ "TSQL Backup a database to multiple files"). Here's the script I used...

```
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Single file restore
RESTORE DATABASE dbname
FROM DISK = '\\path\to\backup\location\tmp\single_file_backup.bak'
WITH RECOVERY,
MOVE 'dbname' TO 'd:\SQLData\dbname.mdf',
MOVE 'dbname_log' TO	'E:\SQLLogs\dbname_2.LDF',
MOVE 'ftrow_ForumTextSearch' TO	'E:\ForumTextSearch\dbname_2\tmp_ftrow_ForumTextSearch.ndf';
GO

DROP DATABASE dbname;
GO

-- Two file restore
RESTORE DATABASE dbname
FROM DISK = '\\path\to\backup\location\tmp\two_files_file1.bak',
DISK = '\\path\to\backup\location\tmp\two_files_file2.bak'
WITH RECOVERY,
MOVE 'dbname' TO 'd:\SQLData\dbname.mdf',
MOVE 'dbname_log' TO	'E:\SQLLogs\dbname_2.LDF',
MOVE 'ftrow_ForumTextSearch' TO	'E:\ForumTextSearch\dbname_2\tmp_ftrow_ForumTextSearch.ndf';
GO

DROP DATABASE dbname;
GO

-- Five file restore
RESTORE DATABASE dbname
FROM DISK = '\\path\to\backup\location\tmp\five_files_file1.bak',
DISK = '\\path\to\backup\location\tmp\five_files_file2.bak',
DISK = '\\path\to\backup\location\tmp\five_files_file3.bak',
DISK = '\\path\to\backup\location\tmp\five_files_file4.bak',
DISK = '\\path\to\backup\location\tmp\five_files_file5.bak'
WITH RECOVERY,
MOVE 'dbname' TO 'd:\SQLData\dbname.mdf',
MOVE 'dbname_log' TO	'E:\SQLLogs\dbname_2.LDF',
MOVE 'ftrow_ForumTextSearch' TO	'E:\ForumTextSearch\dbname_2\tmp_ftrow_ForumTextSearch.ndf';
GO

DROP DATABASE dbname;
GO

-- Ten file restore
RESTORE DATABASE dbname
FROM DISK = '\\path\to\backup\location\tmp\ten_files_file1.bak',
DISK = '\\path\to\backup\location\tmp\ten_files_file2.bak',
DISK = '\\path\to\backup\location\tmp\ten_files_file3.bak',
DISK = '\\path\to\backup\location\tmp\ten_files_file4.bak',
DISK = '\\path\to\backup\location\tmp\ten_files_file5.bak',
DISK = '\\path\to\backup\location\tmp\ten_files_file6.bak',
DISK = '\\path\to\backup\location\tmp\ten_files_file7.bak',
DISK = '\\path\to\backup\location\tmp\ten_files_file8.bak',
DISK = '\\path\to\backup\location\tmp\ten_files_file9.bak',
DISK = '\\path\to\backup\location\tmp\ten_files_file10.bak'
WITH RECOVERY,
MOVE 'dbname' TO 'd:\SQLData\dbname.mdf',
MOVE 'dbname_log' TO	'E:\SQLLogs\dbname_2.LDF',
MOVE 'ftrow_ForumTextSearch' TO	'E:\ForumTextSearch\dbname_2\tmp_ftrow_ForumTextSearch.ndf';
GO

DROP DATABASE dbname;
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO
```

The results are less than exciting...

| Files | 1 | 2 | 5 | 10 |
| CPU time (ms) | 39577 | 37595 | 35162 | 32790 |
| Elapsed time (ms) | 1478788 | 1443965 | 1450444 | 1454009 |

I've [sexed up my results](http://en.wikipedia.org/wiki/September_dossier "Sexed Up")&nbsp;a bit on these graphs by leaving the restore times in ms...

[![tsql_multiple_backup_files_sql_server]({{ site.baseurl }}/assets/2014/10/tsql_multiple_backup_files_sql_server1.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/10/tsql_multiple_backup_files_sql_server1.png)

&nbsp;

Have a more sensible scale and the truth is less sexy&nbsp;(minutes instead of ms)...

[![]({{ site.baseurl }}/assets/2014/10/tsql_restore_multiple_files_minutes1.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/10/tsql_restore_multiple_files_minutes1.png)

Now I'm aware this isn't the best of tests. I had a quick glance through the [documentation](http://msdn.microsoft.com/en-GB/library/ms186858.aspx "TSQL RESTORE")&nbsp;and I couldn't see any indication that the RESTORE command was multi-threaded. I kept an eye on [sys.dm\_exec\_requests](http://msdn.microsoft.com/en-gb/library/ms177648.aspx "sys.dm\_exec\_requests DMV")&nbsp;and it&nbsp;didn't indicate this either. I guess a better test might be to see if having multiple data files has any significant effect. Fill your boots if you fancy having a go!

&nbsp;

&nbsp;

&nbsp;

&nbsp;

