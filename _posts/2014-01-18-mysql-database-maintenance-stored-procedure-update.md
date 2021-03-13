---
layout: post
title: MySQL Database Maintenance Stored Procedure Update
date: 2014-01-18 17:26:56.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- DBA
- MySQL
- partitioning
meta:
  _edit_last: '1'
  tweetbackscheck: '1613447542'
  shorturls: a:3:{s:9:"permalink";s:90:"http://www.youdidwhatwithtsql.com/mysql-database-maintenance-stored-procedure-update/1738/";s:7:"tinyurl";s:26:"http://tinyurl.com/oucouaa";s:4:"isgd";s:19:"http://is.gd/vlavVL";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-database-maintenance-stored-procedure-update/1738/"
---
This is just a quick update of a stored procedure to assist with MySQL Database Maintenance. I originally posted this [back in 2012](http://www.youdidwhatwithtsql.com/mysql-database-maintenance-stored-procedure/1452/ "MySQL Database Maintenance").

The Stored Procedure&nbsp;allows you to run&nbsp;[OPTIMIZE TABLE](http://dev.mysql.com/doc/refman/5.5/en/optimize-table.html "MySQL OPTIMIZE TABLE")&nbsp;or&nbsp;[ANALYZE TABLE](http://dev.mysql.com/doc/refman/5.5/en/analyze-table.html "MySQL ANALYZE TABLE")&nbsp;on all (or most) tables in a MySQL database.

In this version I've added some simple logging and automatic recognition of [partitioned tables](http://dev.mysql.com/doc/refman/5.1/en/partitioning-maintenance.html "MySQL Partitioning")&nbsp;to take advantage of the manageability improvements they bring.

```
DELIMITER $$

DROP PROCEDURE IF EXISTS `db_maintenance`$$

CREATE DEFINER=`root`@`%` PROCEDURE `db_maintenance`(
		IN p_mode TINYINT,
		IN p_database VARCHAR(128)
    )
BEGIN

		###################################################
		# Author: Rhys Campbell #
                # Created: 2014-01-18 #
                ###################################################
		DECLARE done TINYINT;
		DECLARE my_table VARCHAR(128);
		DECLARE is_partitioned TINYINT;

		# Table cursor
		DECLARE table_cursor CURSOR FOR SELECT t.TABLE_NAME,
													 IF(t.CREATE_OPTIONS LIKE '%partitioned%', 1, 0) AS is_partitioned
										FROM INFORMATION_SCHEMA.TABLES t
										WHERE t.TABLE_SCHEMA = p_database
										AND NOT EXISTS (SELECT *
														FROM db_maintenance_table_excludes t2
														WHERE t2.database_name = t.TABLE_SCHEMA
														AND t2.table_name = t.TABLE_NAME)
										AND t.TABLE_TYPE = 'BASE TABLE';

		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

		SET done = 0;

		OPEN table_cursor;

		table_loop: LOOP
		FETCH table_cursor INTO my_table,
								 is_partitioned;

		# Leave the loop if we're done
		IF (done = 1) THEN
			LEAVE table_loop;
		END IF;

			IF (is_partitioned = 0) THEN

				IF(p_mode = 1) THEN # Optimize
					SET @q = CONCAT('OPTIMIZE TABLE ', p_database, '.', my_table);
				ELSE # Analyze
					SET @q = CONCAT('ANALYZE TABLE ', p_database, '.', my_table);
				END IF;

				# Start log statement
				INSERT INTO db_maintenance_log
				(
					db,
					statement,
					started
				)
				VALUES
				(
					p_database,
					@q,
					NOW()
				);

				SET @id = LAST_INSERT_ID();

				PREPARE stmt FROM @q;
				EXECUTE stmt;

				# End log statement
				UPDATE db_maintenance_log
				SET finished = NOW()
				WHERE id = @id;

			ELSE # Partitioned tables
				BEGIN

					DECLARE var_partition_name VARCHAR(255);
					DECLARE partitions_done TINYINT;

					DECLARE partition_cursor CURSOR FOR SELECT PARTITION_NAME
														      FROM INFORMATION_SCHEMA.PARTITIONS
														      WHERE TABLE_SCHEMA = p_database
														      AND TABLE_NAME = my_table;

					DECLARE CONTINUE HANDLER FOR NOT FOUND SET partitions_done = 1;

					SET partitions_done = 0;

					OPEN partition_cursor;

							partition_loop: LOOP

									FETCH partition_cursor INTO var_partition_name;

									# Leave the loop if we're done
									IF (partitions_done = 1) THEN
										LEAVE table_loop;
									END IF;

									IF (p_mode = 1) THEN # Optimize
										SET @q = CONCAT('ALTER TABLE ', p_database, '.', my_table, ' OPTIMIZE PARTITION ', var_partition_name);
									ELSE
										SET @q = CONCAT('ALTER TABLE ', p_database, '.', my_table, ' ANALYZE PARTITION ', var_partition_name);
									END IF;

									# Start log statement
									INSERT INTO db_maintenance_log
									(
										db,
										statement,
										started
									)
									VALUES
									(
										p_database,
										@q,
										NOW()
									);

									SET @id = LAST_INSERT_ID();

									PREPARE stmt FROM @q;
									EXECUTE stmt;

									# End log statement
									UPDATE db_maintenance_log
									SET finished = NOW()
									WHERE id = @id;

								END LOOP partition_loop;

						# Clean up
						CLOSE partition_cursor;
				END;
			END IF;

		END LOOP table_loop;

		# Clean up
		CLOSE table_cursor;

		# Purge old records from the db_maintenance_log table
		DELETE FROM db_maintenance_log
		WHERE started <= DATE_SUB(NOW(), INTERVAL 6 MONTH);

    END$$

DELIMITER ;
```

Tables are retrieved from INFORMATION\_SCHEMA and I use the below table to hold any tables I want to exclude from automatic maintenance.

```
CREATE TABLE db_maintenance_table_excludes ( database_name VARCHAR(128), table_name VARCHAR(128), PRIMARY KEY ( database_name, table_name ) );
```

Here's the DDL for the logging table...

```
CREATE TABLE `db_maintenance_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `db` varchar(128) NOT NULL,
  `statement` varchar(1024) NOT NULL,
  `started` datetime DEFAULT NULL,
  `finished` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_started` (`started`)
)
```

Usage is as follows...

```
# Run OPTIMIZE TABLE
CALL `db_maintenance`(1, 'db_name');
# Run ANALYZE TABLE
CALL `db_maintenance`(2, 'db_name');
```
