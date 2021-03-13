---
layout: post
title: Statistical System functions in TSQL
date: 2011-07-28 13:55:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- fn_virtualfilestats
- TSQL
meta:
  tweetbackscheck: '1613012333'
  shorturls: a:3:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/statistical-system-functions-in-tsql/1281";s:7:"tinyurl";s:26:"http://tinyurl.com/3r3ag55";s:4:"isgd";s:19:"http://is.gd/0qf1hn";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/statistical-system-functions-in-tsql/1281/"
---
TSQL has a bunch of [statistical system functions](http://msdn.microsoft.com/en-us/library/ms177520.aspx) that can be used to return information about the system. This includes details about the number of connection attempts, cpu time, and total reads and writes and more.

Many of these functions will be useful for performance monitoring. All of these functions return values that indicate cumulative activity since the last restart of SQL Server.

```
SELECT @@CONNECTIONS AS ConnectionAttempts,
	   @@CPU_BUSY AS CpuTime,
	   @@IDLE AS IdleTime,
	   @@IO_BUSY AS IoTime,
	   @@PACKET_ERRORS AS PacketErrors,
	   @@PACK_RECEIVED AS PacketsReceived,
	   @@PACK_SENT AS PacketsSent,
	   @@TIMETICKS AS MicrosecondsPerTick, -- Computer dependant
	   @@TOTAL_ERRORS AS TotalDiskWriteErrors,
	   @@TOTAL_READ AS TotalDiskReads,
	   @@TOTAL_WRITE AS TotalDiskWrites;
```

[![tsql statistical system functions]({{ site.baseurl }}/assets/2011/07/tsql_statistical_system_functions_thumb.png "tsql statistical system functions")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Statistical-System-function-in-TSQL_BF61/tsql_statistical_system_functions.png)

An additional interesting function is [fn\_virtualfilestats](http://msdn.microsoft.com/en-us/library/ms187309.aspx "fn\_virtualfilestats") which can return I/O stats about a database or particular database file. This is essentially the same as the [sys.dm\_io\_virtual\_file\_stats](http://msdn.microsoft.com/en-us/library/ms190326.aspx) dmv. To retrieve information about a particular database run the following TSQL;

```
SELECT *
FROM fn_virtualfilestats (DB_ID(), NULL);
```

[![fn_virtualfilestats_TSQL_Function]({{ site.baseurl }}/assets/2011/07/fn_virtualfilestats_TSQL_Function_thumb.png "fn\_virtualfilestats\_TSQL\_Function")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Statistical-System-function-in-TSQL_BF61/fn_virtualfilestats_TSQL_Function.png)

