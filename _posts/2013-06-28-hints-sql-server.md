---
layout: post
title: Using Hints in SQL Server
date: 2013-06-28 12:23:47.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SQL Server
- T-SQL
tags:
- query hint
- sharepoint
- SQL Server
- tfs
- TSQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613450519'
  shorturls: a:3:{s:9:"permalink";s:56:"http://www.youdidwhatwithtsql.com/hints-sql-server/1603/";s:7:"tinyurl";s:26:"http://tinyurl.com/qbadv5g";s:4:"isgd";s:19:"http://is.gd/lWhbfx";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/hints-sql-server/1603/"
---
Query hints are bad right? I confess to using them on odd occasions but only when other attempts to find a solution have failed. Microsoft emphasize this themselves;

> Because the SQL Server query optimizer typically selects the best execution plan for a query, we recommend that \<join\_hint\>, \<query\_hint\>, and \<table\_hint\> be used only as a last resort by experienced developers and database administrators.  
> [source](http://msdn.microsoft.com/en-us/library/ms187713(v=sql.105).aspx "Query Hints SQL Server")

So you'd assume that Microsoft products make very little use of query hints right? Wrong. I've been working a little with [Sharepoint](http://www.microsoft.com/en-gb/business/products/sharepoint-2013.aspx "Microsoft Sharepoint")&nbsp;and [TFS&nbsp;](http://msdn.microsoft.com/en-gb/vstudio/ff637362.aspx "Microsoft Team Foundation Server")&nbsp;databases and noticed the very liberal use of query hints in stored procedures. Check out these counts for a selected number of hints in the WSS\_Content db;

```
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_DEFINITION LIKE '%FORCE ORDER%';

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_DEFINITION LIKE '%OPTION (%)%';

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_DEFINITION LIKE '%FORCESEEK%';

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_DEFINITION LIKE '%HOLDLOCK%';

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_DEFINITION LIKE '%NOLOCK%';
```

Wow! It would be interesting to hear the justification for these.

[![query_hint_counts_sql_server]({{ site.baseurl }}/assets/2013/06/query_hint_counts_sql_server.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2013/06/query_hint_counts_sql_server.png)

