---
layout: post
title: MySQL Database Maintenance Stored Procedure
date: 2012-03-02 14:31:21.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags: []
meta:
  _edit_last: '1'
  twittercomments: a:0:{}
  _wp_old_slug: mysql-database-maintenance-stored-procedu
  tweetbackscheck: '1613416670'
  shorturls: a:3:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/mysql-database-maintenance-stored-procedure/1452";s:7:"tinyurl";s:26:"http://tinyurl.com/84wgztn";s:4:"isgd";s:19:"http://is.gd/EoXoie";}
  tweetcount: '0'
  _sg_subscribe-to-comments: harald.jordan@redstream.at
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-database-maintenance-stored-procedure/1452/"
---
 **UPDATED VERSION:** [MySQL Database Maintenance Stored Procedure](http://www.youdidwhatwithtsql.com/mysql-database-maintenance-stored-procedure-update/1738/ "MySQL Database Maintenance Stored Procedure")

Here's a very simple stored procedure I use to run some maintenance on MySQL tables. It allows you to run [OPTIMIZE TABLE](http://dev.mysql.com/doc/refman/5.5/en/optimize-table.html "MySQL OPTIMIZE TABLE") or [ANALYZE TABLE](http://dev.mysql.com/doc/refman/5.5/en/analyze-table.html "MySQL ANALYZE TABLE") on all (or most) tables in a MySQL database.

```
DELIMITER $$

DROP PROCEDURE IF EXISTS `db_maintenance`$$

CREATE
    DEFINER = 'root'@'%'
    PROCEDURE db_maintenance
    (
		IN p_mode TINYINT,
		IN p_database VARCHAR(128)
    )
    LANGUAGE SQL
    SQL SECURITY INVOKER
    BEGIN

		##################################################
		# Author: Rhys Campbell #
		# Created: 2012-03-02 #
		# Description: Performs Analyze or Optimize #
		# actions on all tables in the provided db. #
		##################################################

		DECLARE done TINYINT;
		DECLARE my_table VARCHAR(128);

		# Table cursor
		DECLARE table_cursor CURSOR FOR SELECT t.TABLE_NAME
						FROM INFORMATION_SCHEMA.TABLES t
						WHERE t.TABLE_SCHEMA = p_database
						AND NOT EXISTS (SELECT *
								FROM db_maintenance_table_excludes t2 WHERE t2.database_name = t.TABLE_SCHEMA
														AND t2.table_name = t.TABLE_NAME)
										AND t.TABLE_TYPE = 'BASE TABLE';

		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

		SET done = 0;

		OPEN table_cursor;

		table_loop: LOOP

		FETCH table_cursor INTO my_table;

		# Leave the loop if we're done
		IF (done = 1) THEN
			LEAVE table_loop;
		END IF;

		# Now lets do the table maintenance
		IF(p_mode = 1) THEN # Optimize

			SET @q = CONCAT('OPTIMIZE TABLE ', p_database, '.', my_table);
			PREPARE stmt FROM @q;
			EXECUTE stmt;

		ELSEIF (p_mode = 2) THEN # Analyze

			SET @q = CONCAT('ANALYZE TABLE ', p_database, '.', my_table);
			PREPARE stmt FROM @q;
			EXECUTE stmt;

		END IF;

		END LOOP table_loop;

		# Clean up
		CLOSE table_cursor;

    END$$

DELIMITER ;
```

Tables are retrieved from [INFORMATION\_SCHEMA](http://dev.mysql.com/doc/refman/5.5/en/information-schema.html "INFORMATION\_SCHEMA") and I use the below table to hold any tables I want to exclude from automatic maintenance.

```
CREATE TABLE db_maintenance_table_excludes
(
	database_name VARCHAR(128),
	table_name VARCHAR(128),
	PRIMARY KEY
	(
		database_name,
		table_name
	)
);
```

Usage is as follows;

```
# Run OPTIMIZE TABLE
CALL `db_maintenance`(1, 'db_name');
# Run ANALYZE TABLE
CALL `db_maintenance`(2, 'db_name');
```
