---
layout: post
title: Rename MySQL Stored Procedures
date: 2010-07-14 21:47:04.000000000 +02:00
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
  twittercomments: a:1:{i:143781710214074368;s:7:"retweet";}
  tweetbackscheck: '1613461089'
  shorturls: a:4:{s:9:"permalink";s:68:"http://www.youdidwhatwithtsql.com/rename-mysql-stored-procedures/819";s:7:"tinyurl";s:26:"http://tinyurl.com/23sfwqo";s:4:"isgd";s:18:"http://is.gd/ds7GX";s:5:"bitly";s:20:"http://bit.ly/ciINoU";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/rename-mysql-stored-procedures/819/"
---
I’ve previously blogged about the limitations of [MySQL Alter Procedure Syntax](http://www.youdidwhatwithtsql.com/mysql-alter-procedure-syntax/788) and I came across a thread on the [MySQL forums](http://forums.mysql.com/read.php?10,274538,274563#msg-274563) with a possible solution. I thought it might be handy to wrap this up into a stored procedure akin to [SQL Server’s sp\_rename](http://msdn.microsoft.com/en-us/library/ms188351.aspx).

This procedure will allow you to easily rename MySQL Stored Procedures in any database. Please be aware that this does update the MySQL system tables and has only had minimal testing. As with all tips you find on the Internet please use with caution!

```
DELIMITER $$

USE `mysql`$$

DROP PROCEDURE IF EXISTS `mysp_rename_proc`$$

CREATE DEFINER=`root`@`%` PROCEDURE `mysp_rename_proc`(IN p_proc_name VARCHAR(64), IN p_new_name VARCHAR(64), IN p_db VARCHAR(64))
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Use to rename stored procedures.'
BEGIN
    proc: BEGIN
	# A few tests to see if the input is sensible
	IF CHARACTER_LENGTH(IFNULL(p_proc_name, '')) = 0 OR CHARACTER_LENGTH(IFNULL(p_new_name, '')) = 0
		OR CHARACTER_LENGTH(IFNULL(p_db, '')) = 0 THEN
	BEGIN
		SELECT 'Error: One of more of the input parameters is zero in length.' AS Error;
		LEAVE proc;
	END;
	ELSEIF (SELECT COUNT(*)
		 FROM mysql.proc
		 WHERE `name` = p_proc_name
		 AND `type` = 'PROCEDURE'
		 AND db = p_db) = 0 THEN
	BEGIN
		SELECT 'Error: The procedure specified in p_proc_name does not exist in this database.' AS Error;
		LEAVE proc;
	END;
	ELSEIF (SELECT COUNT(*)
		 FROM mysql.proc
		 WHERE `name` = p_new_name
		 AND `type` = 'PROCEDURE'
		 AND db = p_db) = 1 THEN
	BEGIN
		SELECT 'Error: Unable to rename the procedure specified in p_proc_name as it already exists in this database.' AS Error;
		LEAVE proc;
	END;
	END IF;

	# Rename the proc
	UPDATE `mysql`.`proc`
	SET `name` = p_new_name,
	specific_name = p_new_name
	WHERE db = p_db
	AND `name` = p_proc_name
	AND `type` = 'PROCEDURE';

	# Update any associated privileges
	UPDATE `mysql`.`procs_priv`
	SET Routine_name = p_new_name
	WHERE db = p_db
	AND Routine_name = p_proc_name
	AND Routine_type = 'PROCEDURE';

	# Check update rowcount to see if privileges need to be flushed
	IF(SELECT ROW_COUNT()) > 0 THEN
	BEGIN
		FLUSH PRIVILEGES;
	END;
	END IF;

    END proc;
    END$$

DELIMITER ;
```

Usage is as follows;

```
CALL mysp_rename_proc('usp_proc', 'usp_new_proc_name', 'database_proc_exists_in');
```

As the thread poster mentions the Stored Procedure is callable by it’s old name as well as the new one until you reconnect. There doesn’t seem to be any suitable [FLUSH](http://dev.mysql.com/doc/refman/5.1/en/flush.html) command to resolve this.

If you liked this you may like;

[MySQL Clone of SP\_SpaceUsed](http://www.youdidwhatwithtsql.com/mysql-clone-of-sp_spaceused/636)

[MySQL Clone of SP\_MsForEachTable](http://www.youdidwhatwithtsql.com/mysql-clone-of-sp_msforeachtable/624)

