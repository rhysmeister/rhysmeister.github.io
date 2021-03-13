---
layout: post
title: MySQL Cursor bug?
date: 2012-11-07 21:39:14.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MySQL
tags:
- cursor
- MySQL
- null values
- Stored Procedures
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  tweetbackscheck: '1613420930'
  shorturls: a:3:{s:9:"permalink";s:55:"http://www.youdidwhatwithtsql.com/mysql-cursor-bug/1507";s:7:"tinyurl";s:26:"http://tinyurl.com/cn7sdm4";s:4:"isgd";s:19:"http://is.gd/KOSYPo";}
  _sg_subscribe-to-comments: clement.francis@happiestminds.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-cursor-bug/1507/"
---
I came across this little funny with MySQL cursors today. This may be documented somewhere in [the manual](http://dev.mysql.com/doc/refman/5.0/en/fetch.html "MySQL manual") but I couldn't find it. Thought I'd post it here for anyone else experiencing cursor issues with MySQL. First, a quick illustration of the issue...

This stored procedure has valid syntax and compiles (in 5.1 & 5.4).

```
DELIMITER $$

DROP PROCEDURE IF EXISTS `test`.`usp_cursor_test`$$

CREATE
    PROCEDURE `test`.`usp_cursor_test`()
    LANGUAGE SQL
    BEGIN

	DECLARE done INT DEFAULT FALSE;
        DECLARE table_schema VARCHAR(100);
        DECLARE table_name VARCHAR(100);

        DECLARE my_cursor CURSOR FOR SELECT TABLE_SCHEMA, TABLE_NAME
                                     FROM INFORMATION_SCHEMA.TABLES
                                     WHERE TABLE_TYPE = 'BASE TABLE';

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

        OPEN my_cursor;

        table_loop: LOOP

		FETCH my_cursor INTO table_schema,
				     table_name;

		IF done THEN
			LEAVE table_loop;
		END IF;

		SELECT table_schema, table_name;

	END LOOP;

        CLOSE my_cursor;

    END$$

DELIMITER ;
```

If you call this stored procedure;

```
CALL usp_cursor_test();
```

You'll observe a load of null records are returned. What's going on here? After a little head scratching I discovered this was due to my FETCH statement using variable names the same as the cursor values. The fix is quite simple;

```
DELIMITER $$

DROP PROCEDURE IF EXISTS `test`.`usp_cursor_test`$$

CREATE
    PROCEDURE `test`.`usp_cursor_test`()
    LANGUAGE SQL
    BEGIN

	DECLARE done INT DEFAULT FALSE;
        DECLARE p_table_schema VARCHAR(100);
        DECLARE p_table_name VARCHAR(100);

        DECLARE my_cursor CURSOR FOR SELECT TABLE_SCHEMA, TABLE_NAME
                                     FROM INFORMATION_SCHEMA.TABLES
                                     WHERE TABLE_TYPE = 'BASE TABLE';

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

        OPEN my_cursor;

        table_loop: LOOP

		FETCH my_cursor INTO p_table_schema,
				     p_table_name;

		IF done THEN
			LEAVE table_loop;
		END IF;

		SELECT p_table_schema, p_table_name;

	END LOOP;

        CLOSE my_cursor;

    END$$

DELIMITER ;
```

Simply ensure your variables names don't match the cursor column names and you're good to go. This doesn't just affect the [INFOMRATION\_SCHEMA](http://dev.mysql.com/doc/refman/5.5/en/information-schema.html "MySQL INFORMATION\_SCHEMA") database. I've tested this using one of my own databases and the issue happens just the same.

While this is a little annoying, it's good practice to append your variable names with something like **p\_** in my opinion to make your code more readable.

