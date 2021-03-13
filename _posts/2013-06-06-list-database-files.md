---
layout: post
title: Get a list of all your database files
date: 2013-06-06 10:08:18.000000000 +02:00
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
- database files
- SQL Server
- TSQL
meta:
  _edit_last: '1'
  tweetcount: '0'
  twittercomments: a:0:{}
  tweetbackscheck: '1613423369'
  shorturls: a:3:{s:9:"permalink";s:59:"http://www.youdidwhatwithtsql.com/list-database-files/1588/";s:7:"tinyurl";s:26:"http://tinyurl.com/lynqgtc";s:4:"isgd";s:19:"http://is.gd/ybHM9N";}
  _sg_subscribe-to-comments: john.campbell@alanticus.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/list-database-files/1588/"
---
I needed a list of all the database files on a SQL Server instance. Here's how to get this easily.

First create a temp table to hold the data like so..

```
SELECT *
INTO #db_files
FROM sys.database_files;
```

Truncate it so we don't duplicate nay data.

```
TRUNCATE TABLE #db_files;
```

Next we use the sp\_Msforeachdb to get our database file information.

```
EXEC sp_MSforeachdb 'USE ?
		     INSERT INTO #db_files
		     SELECT *
		     FROM sys.database_files';
```

View the data and tidy up once done.

```
SELECT *
FROM #db_files
ORDER BY physical_name;

DROP TABLE #db_files;
```
