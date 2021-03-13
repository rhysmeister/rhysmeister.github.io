---
layout: post
title: TSQL to generate date lookup table data
date: 2011-11-10 13:20:43.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613151643'
  shorturls: a:3:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/tsql-generate-date-lookup-table-data/1387";s:7:"tinyurl";s:26:"http://tinyurl.com/cpu4n2x";s:4:"isgd";s:19:"http://is.gd/l0dggd";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-generate-date-lookup-table-data/1387/"
---
I needed to generate a range of data about dates for a lookup table. There's an elegant solution using a [recursive cte](http://msdn.microsoft.com/en-us/library/ms186243.aspx "Recurive common table expression")&nbsp;that does the job;

```
WITH daysCte
(
	d
)
AS
(
	SELECT CONVERT(DATETIME, '1 January 2011') AS d -- starting date
	UNION ALL
	SELECT DATEADD(D, 1, d)
	FROM daysCte
	WHERE DATEPART(yyyy, d) <= 2012 -- stop year
)
SELECT d,
	   DATEPART(wk, d) AS week_number,
	   DATENAME(dw, d) AS day_name,
	   DATENAME(m, d) AS month_name,
	   DATENAME(q, d) AS [quarter]
FROM daysCte
OPTION (MAXRECURSION 800); -- set > number of days you want data for
```

This will display something looking like below;

```
d week_number	day_name	month_name	quarter
2011-01-01 00:00:00.000	1 Saturday	January 1
2011-01-02 00:00:00.000	2 Sunday January 1
2011-01-03 00:00:00.000	2 Monday January 1
2011-01-04 00:00:00.000	2 Tuesday January 1
2011-01-05 00:00:00.000	2 Wednesday	January 1
2011-01-06 00:00:00.000	2 Thursday	January 1
2011-01-07 00:00:00.000	2 Friday January 1
```
