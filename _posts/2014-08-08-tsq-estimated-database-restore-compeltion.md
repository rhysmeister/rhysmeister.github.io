---
layout: post
title: 'TSQL: Estimated database restore completion'
date: 2014-08-08 13:35:15.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- T-SQL
tags:
- restore
- TSQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613257715'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/tsq-estimated-database-restore-compeltion/1960/";s:7:"tinyurl";s:26:"http://tinyurl.com/k9qylys";s:4:"isgd";s:19:"http://is.gd/iWNR74";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsq-estimated-database-restore-compeltion/1960/"
---
Here's a query proving you approximate percentage compeled, and estimated finish time, of any database restores happening on a SQL Server instance...

```
SELECT st.[text],
		r.percent_complete,
		DATEADD(SECOND, r.estimated_completion_time/1000, GETDATE()) AS estimated_completion_time,
		r.total_elapsed_time
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.[sql_handle]) st
WHERE [command] = 'RESTORE DATABASE';
```

The resultset will look something like below...

```
text percent_complete	estimated_completion_time	total_elapsed_time
RESTRE DATABASE d... 47.57035 2014-08-08 13:49:48.373 958963
```
