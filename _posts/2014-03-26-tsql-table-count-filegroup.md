---
layout: post
title: 'TSQL: Table count per filegroup'
date: 2014-03-26 16:08:19.000000000 +01:00
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
  tweetbackscheck: '1613422581'
  _wp_old_slug: tsql
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/tsql-table-count-filegroup/1868/";s:7:"tinyurl";s:26:"http://tinyurl.com/o4c4cnd";s:4:"isgd";s:19:"http://is.gd/QAgKby";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-table-count-filegroup/1868/"
---
Here's a query that uses the SQL Server System [Catalog Views](http://technet.microsoft.com/en-us/library/ms174365.aspx "SQL Server Catalog Views")&nbsp;to return a table count per table. I used this to check even table distribution in a data warehouse.

```
SELECT ds.name AS filegroup_name,
		COUNT(DISTINCT t.[object_id]) AS table_count
FROM sys.tables t
INNER JOIN sys.indexes i
	ON t.[object_id] = i.[object_id]
	AND i.is_primary_key = 1
INNER JOIN sys.filegroups ds
	ON i.data_space_id = ds.data_space_id
INNER JOIN sys.partitions p
	ON i.[object_id] = p.[object_id]
	AND i.index_id = p.index_id
GROUP BY ds.name;
```

The resultset will look something like...

```
filegroup_name table_count
file_1 5
file_2 5
file_3 5
file_4 5
```
