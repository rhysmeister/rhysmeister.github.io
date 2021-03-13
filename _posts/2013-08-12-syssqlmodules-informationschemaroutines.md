---
layout: post
title: Use sys.sql_modules not INFORMATION_SCHEMA.ROUTINES
date: 2013-08-12 17:56:29.000000000 +02:00
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
- sys.sql_modules
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461738'
  _wp_old_slug: sysmodules-informationschemaroutines
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/syssqlmodules-informationschemaroutines/1658/";s:7:"tinyurl";s:26:"http://tinyurl.com/lq9nelm";s:4:"isgd";s:19:"http://is.gd/QZAAMi";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/syssqlmodules-informationschemaroutines/1658/"
---
Have you ever tried using [INFORMATION\_SCHEMA.ROUTINES](http://technet.microsoft.com/en-us/library/ms188757.aspx "INFORMATION\_SCHEMA.ROUTINES") in SQL Server for searching for all procs referencing a specific object? Perhaps something like this;

```
SELECT *
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_DEFINITION LIKE '%table_name%';
```

Has this ever bitten you? If not then you've been lucky so far. The **ROUTINE\_DEFINITION** column is limited to 4000 characters so you cannot depend on this to return all the appropriate objects. To be sure you are correctly searching your system use the [sys.sql\_modules](http://technet.microsoft.com/en-us/library/ms175081.aspx "sys.sql\_modules") view.

```
SELECT OBJECT_SCHEMA_NAME(o.[object_id]) AS [schema_name],
		o.[name] AS [object_name],
		*
FROM sys.sql_modules sm
INNER JOIN sys.objects o
	ON o.[object_id] = sm.[object_id]
WHERE sm.[definition] LIKE '%table_name%'
ORDER BY [schema_name],
		 [object_name];
```
