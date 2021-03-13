---
layout: post
title: MySQL ALTER PROCEDURE Syntax
date: 2010-06-03 12:15:37.000000000 +02:00
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
- Stored Procedures
meta:
  _edit_last: '1'
  tweetbackscheck: '1613224109'
  shorturls: a:4:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/mysql-alter-procedure-syntax/788";s:7:"tinyurl";s:26:"http://tinyurl.com/24hdkez";s:4:"isgd";s:18:"http://is.gd/cATdz";s:5:"bitly";s:20:"http://bit.ly/dubued";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: cade@roux.org
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-alter-procedure-syntax/788/"
---
I usually use [SQLYog](http://www.webyog.com/en/sqlyog_feature_matrix.php "SQLYog MySQL GUI Tool") to write any stored procedures for MySQL. Whenever you alter a procedure the editor essentially generates SQL to drop and then recreate it.

```
DELIMITER $$

USE `db`$$

DROP PROCEDURE IF EXISTS `my_proc`$$

CREATE DEFINER=`root`@`%` PROCEDURE `my proc`()
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Just an example proc.'
BEGIN
       # // proc defintition
END$$

DELIMITER ;
```

I've always wondered why it did this as opposed to using the [ALTER PROCEDURE Syntax](http://dev.mysql.com/doc/refman/5.5/en/alter-procedure.html "MySQL ALTER PROCEDURE syntax").&nbsp; I attempted to use this syntax but couldn't get it to parse whatever I did. As usual the manual explains all;

> This statement can be used to change the characteristics of a stored procedure. More than one change may be specified in an ALTER PROCEDURE statement. However, you cannot change the parameters or body of a stored procedure using this statement; to make such changes, you must drop and re-create the procedure using DROP PROCEDURE and CREATE PROCEDURE. [source](http://dev.mysql.com/doc/refman/5.0/en/alter-procedure.html "MySQL ALTER PROCEDURE Syntax")

Okay! The alter procedure statement is virtually useless to us then! The current method of dropping and then recreating routines to modify them is not atomic and can cause [problems on production systems](http://bugs.mysql.com/bug.php?id=9588 "MySQL ALTER PROCEDURE Syntax"). The stored procedure is temporarily unavailable after the first drop statement so this might freak out any other thread calling it at that moment.

I admit this isn't a massive problem, and I assume it wouldn't be that difficult to implement, but it's something you'd expect DBMS vendors to put in place for stored procedures. I enjoy working with MySQL but some days you can get irrated by a number of these little issues!

