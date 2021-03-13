---
layout: post
title: Audit VLFs on your SQL Server
date: 2011-10-04 21:47:55.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
- SQL Server
- T-SQL
tags:
- Virtual Log Files
- VLF
meta:
  twittercomments: a:0:{}
  tweetcount: '0'
  shorturls: a:3:{s:9:"permalink";s:68:"http://www.youdidwhatwithtsql.com/audit-vlfs-on-your-sql-server/1358";s:7:"tinyurl";s:26:"http://tinyurl.com/6krm2qx";s:4:"isgd";s:19:"http://is.gd/kdwhD2";}
  tweetbackscheck: '1613461013'
  _sg_subscribe-to-comments: stephenmills@hotmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/audit-vlfs-on-your-sql-server/1358/"
---
I've been [reading a bit about VLFs](http://sqlblog.com/blogs/linchi_shea/archive/2009/02/09/performance-impact-a-large-number-of-virtual-log-files-part-i.aspx) (Virtual Log Files) this week. I've found quite a few interesting links, especially this one, informing us that there's such a thing as [too few or too many VLFs.](http://sqlskills.com/BLOGS/KIMBERLY/post/Transaction-Log-VLFs-too-many-or-too-few.aspx)

We can view details about VLFs using the DBCC LOGINFO TSQL command. This only works against the current database context but I decided to make this process less tedious, and human-readable, so I knocked up a quick script;

```
-- Create a temp table to hold log info
CREATE TABLE #tmp_log_info
(
      FileId INTEGER,
      FileSize BIGINT,
      StartOffSet BIGINT,
      [Status] INTEGER,
      FSeqNo INTEGER,
      Parity SMALLINT,
      CreateLSN NUMERIC(38,0)
);

-- Same as above but with database name
-- Can insert in one statement
CREATE TABLE #log_info
(
      FileId INTEGER,
      FileSize BIGINT,
      StartOffSet BIGINT,
      [Status] INTEGER,
      FSeqNo INTEGER,
      Parity SMALLINT,
      CreateLSN NUMERIC(38,0),
      [Database] VARCHAR(128)
);

EXEC sp_MsForEachDb 'INSERT INTO #tmp_log_info EXEC(''DBCC LOGINFO(?)'');
                              INSERT INTO #log_info
                               SELECT *, ''?''
                              FROM #tmp_log_info;
                              TRUNCATE TABLE #tmp_log_info;';

SELECT [Database],
            COUNT(*) AS Vlf_count,
            CAST(MAX(FileSize) AS FLOAT) / 1048576 AS biggest_vlf_MB,
            CAST(MIN(FileSize) AS FLOAT) / 1048576 AS smallest_vlf_MB
FROM #log_info
GROUP BY [Database]
ORDER BY COUNT(*) DESC;

-- Clean up
DROP TABLE #tmp_log_info;
DROP TABLE #log_info;
```

This will display a summary report for all databases on the instance of SQL Server.

**Database -** The database the log file belongs to.

**Vlf\_count -** The total number of VLFs.

**biggest\_vlf\_MB -** The biggest virtual log file in MB.

**smallest\_vlf\_MB -** The smallest virtual log file in MB.

```
Database	Vlf_count	biggest_vlf_MB	smallest_vlf_MB
msdb 26 0.4453125	0.2421875
master 5 0.25 0.2421875
model 3 0.25 0.2421875
tempdb 2 0.25 0.2421875
ft_test 2 0.3125 0.2421875
```

**UPDATE:** Just found a [very similar post here](http://sqlserverpedia.com/blog/sql-server-bloggers/find-the-number-of-vlfs-for-all-databases/).

**UPDATE:** Thought I'd try to bring something to the table and come up with a pure-powershell way to do this but it doesn't seem that the VLF information is exposed;

```
$server = "localhost";
# Load SMO
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;
# create server objects
$srv = New-Object Microsoft.SqlServer.Management.SMO.Server $server;
$db = $srv.Databases["tempdb"];

foreach($log in $db.LogFiles)
{
	Write-Host $log.Name;
	Write-Host "=================";
	# Output each property
	foreach($p in $log.Properties)
	{
		Write-Host $p.Name;
	}
}
```

Exposed logfile properties...

```
templog
=================
FileName
Growth
GrowthType
ID
MaxSize
Size
UsedSpace
BytesReadFromDisk
BytesWrittenToDisk
IsOffline
IsReadOnly
IsReadOnlyMedia
IsSparse
NumberOfDiskReads
NumberOfDiskWrites
PolicyHealthState
VolumeFreeSpace
```

If anyone knows a way I'd be interested to hear. Cheers

