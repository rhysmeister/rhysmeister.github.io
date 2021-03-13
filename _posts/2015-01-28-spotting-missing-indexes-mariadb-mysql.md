---
layout: post
title: Spotting missing indexes for MariaDB & MySQL
date: 2015-01-28 17:52:34.000000000 +01:00
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
- mariadb
- MySQL
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/spotting-missing-indexes-mariadb-mysql/2036/";s:7:"tinyurl";s:26:"http://tinyurl.com/nwe4apq";s:4:"isgd";s:19:"http://is.gd/9kLiAE";}
  tweetbackscheck: '1613463919'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/spotting-missing-indexes-mariadb-mysql/2036/"
---
Here's a query I use for [MySQL](http://dev.mysql.com/ "MySQL") / [MariaDB](https://mariadb.org/ "MariaDB")&nbsp;to spot any columns that might need indexing. &nbsp;It uses a bunch of [information\_schema](https://mariadb.com/kb/en/mariadb/information-schema-tables/) views to flag any columns that end with the characters "id" that are not indexed. This tests that the column is located&nbsp;at the head of the index through the **ORDINAL\_POSITION** clause. So if it's in an index at position 2, or higher, this won't count.

```
SELECT t.TABLE_SCHEMA, t.TABLE_NAME, c.COLUMN_NAME, IFNULL(kcu.CONSTRAINT_NAME, 'Not indexed') AS `Index`
FROM information_schema.TABLES t
INNER JOIN information_schema.`COLUMNS` c
	ON c.TABLE_SCHEMA = t.TABLE_SCHEMA
	AND c.TABLE_NAME = t.TABLE_NAME
	AND c.COLUMN_NAME LIKE '%Id'
LEFT JOIN information_schema.`KEY_COLUMN_USAGE` kcu
	ON kcu.TABLE_SCHEMA = t.TABLE_SCHEMA
	AND kcu.TABLE_NAME = t.TABLE_NAME
	AND kcu.COLUMN_NAME = c.COLUMN_NAME
	AND kcu.ORDINAL_POSITION = 1
WHERE kcu.TABLE_SCHEMA IS NULL
AND t.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'mysql');
```

The idea here is that any columns that are named&nbsp; **business\_key\_id** should probably be indexed. This will give us a list of columns that we can consider for indexing. As usual, your mileage may vary according to your own database design. Do you have any better ideas?

