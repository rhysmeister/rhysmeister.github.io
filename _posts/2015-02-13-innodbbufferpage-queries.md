---
layout: post
title: innodb_buffer_page queries
date: 2015-02-13 17:53:42.000000000 +01:00
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
- buffer_pool
- information_schema
- InnoDB
- mariadb
- MySQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613450917'
  shorturls: a:3:{s:9:"permalink";s:64:"http://www.youdidwhatwithtsql.com/innodbbufferpage-queries/2041/";s:7:"tinyurl";s:26:"http://tinyurl.com/p3c8xdp";s:4:"isgd";s:19:"http://is.gd/otwHCq";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/innodbbufferpage-queries/2041/"
---
If you want to get some high level statistics on the buffer pool in [MySQL](http://dev.mysql.com/ "MySQL") / [MariaDB](https://mariadb.org/ "MariaDB") you can use the [INNODB\_BUFFER\_POOL\_STATS](http://dev.mysql.com/doc/refman/5.6/en/innodb-buffer-pool-stats-table.html "INNODB\_BUFFER\_POOL\_STATS") table in the [information\_schema](http://dev.mysql.com/doc/refman/5.6/en/innodb-i_s-tables.html "information\_schema database") database.

If you need a little more detail then the [INNODB\_BUFFER\_PAGE](http://dev.mysql.com/doc/refman/5.6/en/innodb-buffer-page-table.html "INNODB\_BUFFER\_PAGE") table is a good place to start. This view contains details about each page in the buffer pool. So we can use this to get database level details all the way down to individual indexes. Here's a few queries to get you started...

**Buffer pool consumption by database**

```
SELECT bp.POOL_ID,
		NULLIF(SUBSTRING(bp.TABLE_NAME, 1, LOCATE(".", bp.TABLE_NAME) - 1), '') AS db_name,
		(COUNT(*) * 16) / 1024 / 1024 AS buffer_pool_consumption_gb
FROM `INNODB_BUFFER_PAGE` bp
GROUP BY bp.POOL_ID, db_name
ORDER BY buffer_pool_consumption_gb DESC;
```

The 'NULL' database here will consist of various INNODB internal structures, for example the UNDO LOG. You can inspect these pages individually with..

```
SELECT *
FROM `INNODB_BUFFER_PAGE` bp
WHERE bp.TABLE_NAME IS NULL;
```

**Buffer pool consumption by database/table & page type**

```
SELECT bp.POOL_ID, NULLIF(SUBSTRING(bp.TABLE_NAME, 1, LOCATE(".", bp.TABLE_NAME) - 1), '') AS db_name, bp.PAGE_TYPE, bp.TABLE_NAME, (COUNT(*) * 16) / 1024 / 1024 AS buffer_pool_consumption_gb
FROM `INNODB_BUFFER_PAGE` bp
GROUP BY bp.POOL_ID, db_name, bp.PAGE_TYPE, bp.TABLE_NAME
ORDER BY bp.POOL_ID, db_name, bp.PAGE_TYPE, bp.TABLE_NAME, buffer_pool_consumption_gb DESC;
```

**Buffer pool consumption by index**

```
SELECT bp.POOL_ID,
		NULLIF(SUBSTRING(bp.TABLE_NAME, 1, LOCATE(".", bp.TABLE_NAME) - 1), '') AS db_name,
		bp.TABLE_NAME,
		bp.INDEX_NAME, (COUNT(*) * 16) / 1024 / 1024 AS buffer_pool_consumption_gb
FROM `INNODB_BUFFER_PAGE` bp
GROUP BY bp.POOL_ID, db_name, bp.TABLE_NAME, bp.INDEX_NAME
ORDER BY bp.POOL_ID, db_name, bp.PAGE_TYPE, buffer_pool_consumption_gb DESC;
```
