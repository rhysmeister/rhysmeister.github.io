---
layout: post
title: MySQL clone of sp_spaceused
date: 2010-02-14 16:58:03.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- MySQL
- sp_spaceused
meta:
  tweetbackscheck: '1613472374'
  shorturls: a:4:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/mysql-clone-of-sp_spaceused/636";s:7:"tinyurl";s:26:"http://tinyurl.com/y9bo3wl";s:4:"isgd";s:18:"http://is.gd/8nemd";s:5:"bitly";s:20:"http://bit.ly/cx70NZ";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-clone-of-sp_spaceused/636/"
---
Following on from yesterdays blog post, a [MySQL clone of sp\_MsForEachTable](http://www.youdidwhatwithtsql.com/mysql-clone-of-sp_msforeachtable/624), here's an attempt at a clone of [sp\_spaceused](http://msdn.microsoft.com/en-us/library/ms188776.aspx). There's a few issues to be aware of involving the storage engine in use. For example the row count is accurate for [MyISAM](http://en.wikipedia.org/wiki/MyISAM) while with [InnoDb](http://en.wikipedia.org/wiki/InnoDB) it seems to be just an estimate. This estimate can vary from execution-to-execution. The procedure derives its information from [INFORMATION\_SCHEMA.TABLES](http://dev.mysql.com/doc/refman/5.1/en/tables-table.html). To get started create the below procedure in the database you wish to use it in.

```
DELIMITER $$

DROP PROCEDURE IF EXISTS `usp_mysql_spaceused`$$

CREATE PROCEDURE `usp_mysql_spaceused`(IN var_tablename VARCHAR(255))
    LANGUAGE SQL
    NOT DETERMINISTIC
    COMMENT 'Clone of MSSQL sp_spaceused'
    BEGIN
	# Based on http://msdn.microsoft.com/en-us/library/ms188776.aspx
	IF var_tablename = '' OR var_tablename IS NULL THEN

		-- db info, unallocated_space only reported for InnoDB tables
		SELECT table_schema AS database_name,
		       CONCAT(ROUND(SUM(data_length + index_length + data_free)/ 1024 / 1024, 2), '(MB)') AS database_size,
		       CONCAT(ROUND(SUM(data_free) / 1024 /1024, 2), '(MB)') AS unallocated_space
		FROM information_schema.TABLES
		WHERE table_schema = DATABASE()
		GROUP BY table_schema;

		SELECT CONCAT(ROUND(SUM(data_length + index_length + data_free) / 1024 /1024, 2), '(MB)') AS reserved,
		       CONCAT(ROUND(SUM(data_length) / 1024 /1024, 2), '(MB)') AS data,
		       CONCAT(ROUND(SUM(index_length) / 1024 /1024, 2), '(MB)') AS index_size,
		       CONCAT(ROUND(SUM(data_free) / 1024 /1024, 2), '(MB)') AS unused
		FROM information_schema.TABLES
		WHERE TABLE_SCHEMA = DATABASE();

	ELSE

		-- table info
		-- does the table exist in the current db?
		IF NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE TABLE_NAME = var_tablename) THEN

			SELECT 'Table does not exist.' AS error;
		ELSE

			-- rows is estimate based for InnoDb (often a fair bit out)
			-- MyISAM is accurate
			SELECT var_tablename AS `name`,
			       table_rows AS rows,
			       CONCAT(ROUND(SUM(data_length + index_length + data_free) / 1024 /1024, 2), '(MB)') AS reserved,
			       CONCAT(ROUND(SUM(data_length) / 1024 /1024, 2), '(MB)') AS data,
			       CONCAT(ROUND(SUM(index_length) / 1024 /1024, 2), '(MB)') AS index_size,
			       CONCAT(ROUND(SUM(data_free) / 1024 /1024, 2), '(MB)') AS unused -- InnoDb only MySQL 5.1.28
			FROM information_schema.TABLES
			WHERE TABLE_SCHEMA = DATABASE()
			AND TABLE_NAME = var_tablename;

		END IF;

	END IF;

    END$$

DELIMITER ;
```

Usage is as follows.

**Get database size information**

To get database level information the procedure should be called with an empty string or NULL.

```
-- Empty string or null to get db info
CALL usp_mysql_spaceused('');
```

Two resultset are returned. Similar to the ones described on the [sp\_spaceused documentation](http://msdn.microsoft.com/en-us/library/ms188776.aspx) page.

[![usp_mysql_spaceused resultset 1]({{ site.baseurl }}/assets/2010/02/usp_mysql_spaceused_resultset_1_thumb.png "usp\_mysql\_spaceused resultset 1")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/usp_mysql_spaceused_resultset_1.png)

[![usp_mysql_spaceused resultset 2]({{ site.baseurl }}/assets/2010/02/usp_mysql_spaceused_resultset_2_thumb.png "usp\_mysql\_spaceused resultset 2")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/usp_mysql_spaceused_resultset_2.png)

**Get table size information**

<font color="#666666">To get information on the size of a table just call the procedure with the appropriate table name.</font>

```
CALL usp_mysql_spaceused('City');
```

[![usp_mysql_spaceused_table_resultset]({{ site.baseurl }}/assets/2010/02/usp_mysql_spaceused_table_resultset_thumb.png "usp\_mysql\_spaceused\_table\_resultset")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/usp_mysql_spaceused_table_resultset.png)

