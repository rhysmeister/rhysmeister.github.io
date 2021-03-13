---
layout: post
title: MySQL clone of sp_msforeachtable
date: 2010-02-13 19:56:47.000000000 +01:00
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
- sp_MsForEachTale
meta:
  tweetbackscheck: '1613463871'
  twittercomments: a:2:{s:11:"27378462559";s:7:"retweet";s:11:"27378434572";s:7:"retweet";}
  shorturls: a:4:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/mysql-clone-of-sp_msforeachtable/624";s:7:"tinyurl";s:26:"http://tinyurl.com/y965eg6";s:4:"isgd";s:18:"http://is.gd/8jVfG";s:5:"bitly";s:20:"http://bit.ly/dvLbbm";}
  tweetcount: '2'
  _edit_last: '1'
  _sg_subscribe-to-comments: sonny.public@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-clone-of-sp_msforeachtable/624/"
---
Many [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) DBAs and Developers get a&nbsp; lot of use out of the [undocumented sp\_MsForEachTable](http://connect.microsoft.com/SQLServer/feedback/details/264676/sp-msforeachtable-provide-supported-documented-version) system stored procedure. Here's an attempt at creating a functional version for [MySQL](http://www.mysql.com). The procedure makes use of [prepared statements](http://rpbouman.blogspot.com/2005/11/mysql-5-prepared-statement-syntax-and.html), which do have some limitations, so some uses may not translate across. This is far from production ready so use with lots of caution.

Create the below stored procedure in the database you wish to use it in.

```
DELIMITER $$

DROP PROCEDURE IF EXISTS `usp_mysql_foreachtable`$$

CREATE PROCEDURE `usp_mysql_foreachtable`(IN sql_string VARCHAR(1000))
    LANGUAGE SQL
    NOT DETERMINISTIC
    COMMENT 'Functional clone of sp_MsForEachTable'
    BEGIN

	DECLARE var_tablename VARCHAR(100);
	DECLARE last_row BIT;

	DECLARE table_cursor CURSOR FOR SELECT TABLE_NAME
					FROM information_schema.TABLES
					WHERE TABLE_TYPE = 'BASE TABLE'
					AND TABLE_SCHEMA = DATABASE();

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET last_row = 1;

	OPEN table_cursor;
	FETCH table_cursor INTO var_tablename;

	SET last_row = 0;
	SET @var = '';

	lbl_table_cursor: LOOP

		SET @qry = REPLACE(sql_string, '?', var_tablename);

		PREPARE q FROM @qry;
		EXECUTE q;
		DEALLOCATE PREPARE q;

		FETCH table_cursor INTO var_tablename;
		IF last_row = 1 THEN
			LEAVE lbl_table_cursor;
		END IF;
	END LOOP lbl_table_cursor;

	CLOSE table_cursor;

    END$$

DELIMITER ;
```

Usage is quite simple, just pass in a query with a '?' in place of where the table name should be. I have verified the below use cases function as expected.

**Select 5 rows from each table**

```
CALL usp_mysql_foreachtable('SELECT * FROM ? LIMIT 5;');
```

**Count the number of rows in each table**

```
CALL usp_mysql_foreachtable('SELECT ''?'', COUNT(*) AS Rows FROM ?');
```

**Repair all tables in the database**

```
CALL usp_mysql_foreachtable('REPAIR TABLE ?');
```

**Change all tables to use the InnoDb storage engine**

```
CALL usp_mysql_foreachtable('ALTER TABLE ? ENGINE=InnoDB');
```

**Reset the AUTO\_INCREMENT to zero in all tables**

```
CALL usp_mysql_foreachtable('ALTER TABLE ? AUTO_INCREMENT = 0');
```
