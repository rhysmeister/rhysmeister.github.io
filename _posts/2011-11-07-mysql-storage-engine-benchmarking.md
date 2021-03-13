---
layout: post
title: MySQL Storage engine benchmarking
date: 2011-11-07 20:49:37.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- Benchmark
- InnoDB
- MyISAM
- MySQL
meta:
  tweetbackscheck: '1613478798'
  _edit_last: '1'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/mysql-storage-engine-benchmarking/1384";s:7:"tinyurl";s:26:"http://tinyurl.com/ce2a7vk";s:4:"isgd";s:19:"http://is.gd/sDUbvU";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-storage-engine-benchmarking/1384/"
---
Here's a stored procedure I use to perform some simple benchmarking of inserts for [MySQL](http://dev.mysql.com "MySQL"). It takes three parameters; **p\_table\_type** which should be set to the storage engine you wish to benchmark i.e. 'MyISAM', 'InnoDB', **p\_inserts** ; set this to the number of inserts to perform. **p\_autocommit** ; set the [autocommit](http://dev.mysql.com/doc/refman/5.0/en/innodb-transaction-model.html "InnoDB autocommit variable") variable (relevant to [InnoDB](http://www.innodb.com/ "InnoDB Storage Engine") only) to 0 or 1.

```
DELIMITER $$
USE `test`$$
DROP PROCEDURE IF EXISTS `table_engine_test`$$
        CREATE DEFINER=`root`@`%`
        PROCEDURE `table_engine_test`(IN p_table_type VARCHAR(20),
                                      IN p_inserts INT,
                                      IN p_autocommit TINYINT)
                SQL SECURITY INVOKER
        BEGIN

                DECLARE sql_string VARCHAR(300);

                # Set session autocommit
                SET SESSION autocommit = p_autocommit;

                # TABLE TO hold session times
                CREATE TABLE IF NOT EXISTS test_session
                             (
                                          Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                                          table_type VARCHAR(20) NOT NULL ,
                                          inserts INT NOT NULL,
                                          autocommit TINYINT NOT NULL,
                                          started DATETIME NULL ,
                                          finished DATETIME NULL
                             );

                CREATE TABLE IF NOT EXISTS test_session_inserts
                             (
                                          id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
                                          test_session_id INTEGER NOT NULL ,
                                          started DATETIME NOT NULL ,
                                          finished DATETIME NOT NULL
                             );

                # clean up ANY existing test TABLE
                DROP TABLE IF EXISTS test_table_type;

                SET sql_string = CONCAT('CREATE TABLE test_table_type
					(
						id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
						random INTEGER,
						text1 VARCHAR(10) NOT NULL,
						text2 VARCHAR(10) NOT NULL
					)ENGINE = ', p_table_type);
                # PREPARE SQL AND EXECUTE
                SET @q = sql_string;
                PREPARE stmt FROM @q;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
                # START the test session
                INSERT
                INTO test_session
                       (
                              table_type,
                              inserts,
                              autocommit,
                              started
                       )
                       VALUES
                       (
                              p_table_type,
                              p_inserts,
                              p_autocommit,
                              NOW()
                       );

                SET @id = LAST_INSERT_ID();
                SET @i = 0;
                while_loop: WHILE (@i < p_inserts) DO
                # Generate VALUES for insert
                SET @random = RAND();
                SET @text1 = SUBSTRING(MD5(RAND()), -10);
                SET @text2 = SUBSTRING(MD5(RAND()), -10);
                SET @started = NOW();
                # INSERT the test row
                INSERT
                INTO test_table_type
                       (
                              random,
                              text1 ,
                              text2
                       )
                       VALUES
                       (
                              @random,
                              @text1 ,
                              @text2
                       );

                # record INSERT times
                        INSERT
                        INTO test_session_inserts
                               (
                                      test_session_id,
                                      started ,
                                      finished
                               )
                               VALUES
                               (
                                      @id ,
                                      @started,
                                      NOW()
                               );

                        # increment counter
                        SET @i = @i + 1;
                END WHILE while_loop;
                # Finish the session
                UPDATE test_session
                SET finished = NOW()
                WHERE id = @id;

END$$
DELIMITER ;
```

Run your tests like so...

```
CALL table_engine_test('MyISAM', 10000, 0);
CALL table_engine_test('InnoDB', 10000, 0);
CALL table_engine_test('InnoDB', 10000, 1);
CALL table_engine_test('MyISAM', 100000, 0);
CALL table_engine_test('InnoDB', 100000, 0);
CALL table_engine_test('InnoDB', 100000, 1);
```

The **test\_session** contains some summary information about each of the tests;

```
SELECT *
FROM test_session;
```

[![mysql_table_engine_test]({{ site.baseurl }}/assets/2011/11/mysql_table_engine_test_thumb.png "mysql\_table\_engine\_test")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/11/mysql_table_engine_test.png)

Calculate the time taken for each test with the following query;

```
SELECT *, TIMEDIFF(finished, started) AS seconds
FROM test_session;
```

Happy Benchmarking!

