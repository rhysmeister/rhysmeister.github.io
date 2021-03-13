---
layout: post
title: Generate PK drops and creates using TSQL
date: 2014-02-05 10:36:05.000000000 +01:00
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
- constraints
- primary key
- TSQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613478620'
  shorturls: a:3:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/generate-pk-drops-creates-tsql/1755/";s:7:"tinyurl";s:26:"http://tinyurl.com/qcqfcls";s:4:"isgd";s:19:"http://is.gd/17mD3L";}
  _wp_old_slug: generate-pk-drops-creat
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/generate-pk-drops-creates-tsql/1755/"
---
Here's just a couple of queries I used to generate PK drops and creates using the [sys.key\_constraints](http://technet.microsoft.com/en-us/library/ms174321.aspx "sys.key\_constraints") view. I wanted to do this for a database using [Poor Mans Partitioning](http://www.youdidwhatwithtsql.com/sql-server-partitioning-paupers/1692/ "Poor Mans Partitioning").

Generate drops...

```
SELECT 'ALTER TABLE ' + OBJECT_SCHEMA_NAME(t.[object_id]) + '.' + t.name + ' DROP CONSTRAINT ' + c.[name] + ';'
FROM sys.key_constraints c
INNER JOIN sys.tables t
	ON t.object_id = c.parent_object_id
WHERE t.name LIKE 'table_pattern_%'
AND c.[type] = 'PK';
```

Generate creates...

```
SELECT 'ALTER TABLE ' + OBJECT_SCHEMA_NAME(t.[object_id]) + '.' + t.name + ' ADD CONSTRAINT '
		 + ' PK_' + t.name + ' PRIMARY KEY CLUSTERED (new, columns, in , pk) FILLFACTOR=100;'
FROM sys.tables t
WHERE t.name LIKE 'table_pattern_%';
```
