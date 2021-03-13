---
layout: post
title: MySQL Group By
date: 2012-04-01 14:40:41.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- GROUP BY
- MySQL
meta:
  tweetbackscheck: '1613316812'
  shorturls: a:3:{s:9:"permalink";s:53:"http://www.youdidwhatwithtsql.com/mysql-group-by/1471";s:7:"tinyurl";s:26:"http://tinyurl.com/c4w5q5m";s:4:"isgd";s:19:"http://is.gd/JpTe4G";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-group-by/1471/"
---
Many people are caught out by MySQL's implementation of GROUP BY. By default MySQL does not require that you GROUP BY all non-aggregated columns. For example the following is an illegal query in SQL Server (as well as rather nonsensical);

```
SELECT *
FROM INFORMATION_SCHEMA.TABLES
GROUP BY TABLE_SCHEMA;
```

This will generate the following error;

```
Msg 8120, Level 16, State 1, Line 1
Column 'INFORMATION_SCHEMA.TABLES.TABLE_CATALOG' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.
```

While in MySQL this query would return a resultset. I believe this was implemented for performance reasons as it would clearly be more efficient grouping on one column than multiple ones. Obviously you introduce a degree of uncertainty as to what will be presented in your final resultset. That may be tolerable for some use cases but if you want the more standard functionality here's what you have to do;

First check your [sql\_mode](http://dev.mysql.com/doc/refman/5.0/en/server-sql-mode.html "MySQL sql\_mode") with the following;

```
SHOW VARIABLES LIKE '%sql_mode%';
```

This will return the value for your server which you'll want to take a note of in case you want to revert changes. To change the default behaviour we need to add [ONLY\_FULL\_GROUP\_BY](http://dev.mysql.com/doc/refman/5.0/en/server-sql-mode.html#sqlmode_only_full_group_by "MySQL ONLY\_FULL\_GROUP\_BY sql\_mode") to the sql\_mode;

```
SET sql_mode := CONCAT(@@sql_mode,',ONLY_FULL_GROUP_BY');
```

Run this query again;

```
SELECT *
FROM INFORMATION_SCHEMA.TABLES
GROUP BY TABLE_SCHEMA;
```

and we will get the following error;

```
Query : SELECT * FROM INFORMATION_SCHEMA.TABLES GROUP BY TABLE_SCHEMA
Error Code : 1055
'TABLES.TABLE_CATALOG' isn't in GROUP BY
```

This will require MySQL queries to use the standard GROUP BY implementation. This would be a breaking change for some queries so be very careful in production systems. Of course, to make this change permanent you'll need to add it to your [my.cnf](http://dev.mysql.com/doc/refman/5.1/en/option-files.html "MySQL Option Files").

