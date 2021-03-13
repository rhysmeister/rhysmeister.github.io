---
layout: post
title: TokuDB file & table sizes with information_schema
date: 2015-06-12 11:01:41.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MariaDB
- MySQL
tags:
- information_schema
- TokuDB
meta:
  _edit_last: '1'
  tweetbackscheck: '1613432726'
  shorturls: a:3:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/tokudb-file-table-sizes-informationschema/2104/";s:7:"tinyurl";s:26:"http://tinyurl.com/obz4esr";s:4:"isgd";s:19:"http://is.gd/aYrIeh";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tokudb-file-table-sizes-informationschema/2104/"
---
Here's a few queries using the information\_schema.TokuDB\_fractal\_tree\_info to get the on disk size in MB for [TokuDB](http://www.tokutek.com/tokudb-for-mysql/) tables.

This first one will sum up the on disk size for tables using the TokuDB engine.

```
SELECT table_schema, table_name, SUM(ROUND(bt_size_allocated / 1024 / 1024, 2)) AS table_size_mb
FROM information_schema.`TokuDB_fractal_tree_info`
WHERE table_schema = 'database_name'
GROUP BY table_schema, table_name;
```

To get a breakdown of the files making up a&nbsp;specific table run the following...

```
SELECT internal_file_name, SUM(ROUND(bt_size_allocated / 1024 / 1024, 2)) AS file_size_mb
FROM information_schema.`TokuDB_fractal_tree_info`
WHERE `table_schema` = 'database_name'
AND `table_name` = 'table_name'
GROUP BY internal_file_name
WITH ROLLUP
```

The figure might be slightly off the actual on disk size. I've never noticed a difference of more than 0.01% so it's close enough for most purposes.

