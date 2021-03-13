---
layout: post
title: 'TSQL: Accuracy of DATETIME'
date: 2014-04-14 16:08:36.000000000 +02:00
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
  shorturls: a:3:{s:9:"permalink";s:62:"http://www.youdidwhatwithtsql.com/tsql-accuracy-datetime/1871/";s:7:"tinyurl";s:26:"http://tinyurl.com/qhxpekm";s:4:"isgd";s:19:"http://is.gd/HYSBE3";}
  tweetbackscheck: '1613245480'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-accuracy-datetime/1871/"
---
Here's something I didn't know about the [DATETIME](http://msdn.microsoft.com/en-us/library/ms187819.aspx "DATETIME SQL Server") data type in SQL Server....

```
SELECT CAST('2014-04-10 00:00:00.000' AS DATETIME)
UNION ALL
SELECT CAST('2014-04-10 00:00:00.001' AS DATETIME)
UNION ALL
SELECT CAST('2014-04-10 00:00:00.002' AS DATETIME)
UNION ALL
SELECT CAST('2014-04-10 00:00:00.003' AS DATETIME)
UNION ALL
SELECT CAST('2014-04-10 00:00:00.004' AS DATETIME)
UNION ALL
SELECT CAST('2014-04-10 00:00:00.005' AS DATETIME)
UNION ALL
SELECT CAST('2014-04-10 00:00:00.006' AS DATETIME)
UNION ALL
SELECT CAST('2014-04-10 00:00:00.007' AS DATETIME)
UNION ALL
SELECT CAST('2014-04-10 00:00:00.008' AS DATETIME)
UNION ALL
SELECT CAST('2014-04-10 00:00:00.009' AS DATETIME)
```

The resultset will be as follows...

```
2014-04-14 00:00:00.000
2014-04-14 00:00:00.000
2014-04-14 00:00:00.003
2014-04-14 00:00:00.003
2014-04-14 00:00:00.003
2014-04-14 00:00:00.007
2014-04-14 00:00:00.007
2014-04-14 00:00:00.007
2014-04-14 00:00:00.007
2014-04-14 00:00:00.010
```

The sharp eyed amongst you would have noticed some values milliseconds have been rounded. This is explained the the "accuracy section of the documentation for [DATETIME](http://msdn.microsoft.com/en-us/library/ms187819.aspx "DATETIME SQL Server")...

> Rounded to increments of .000, .003, or .007 seconds

If this is an issue for your application then you should consider using [DATETIME2](http://msdn.microsoft.com/en-us/library/bb677335(v=sql.105).aspx "DATETIME2 SQL Server").

