---
layout: post
title: Moving an InnoDB Database with FLUSH TABLES .. FOR EXPORT
date: 2015-01-21 12:48:59.000000000 +01:00
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
- InnoDB
- mariadb
- MySQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613479654'
  shorturls: a:3:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/moving-innodb-database-flush-tables-export/2032/";s:7:"tinyurl";s:26:"http://tinyurl.com/otvvqk5";s:4:"isgd";s:19:"http://is.gd/s3fztN";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/moving-innodb-database-flush-tables-export/2032/"
---
If we wanted to move a large InnoDB database our options were very limited. Essentially we had to mysqldump the single database or move the entire tablespace. I did have an idea for moving a single InnoDB database by copying files but only ever [tried it out with TokuDB](http://www.youdidwhatwithtsql.com/move-mysql-tokudb-database/1743/ "Moving a TokuDB database"). This method worked but seemed to frighten the developers so it's something I never pursued beyond proof-of-concept.

With the [FLUSH TABLES .. FOR EXPORT](http://www.google.co.uk/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&ved=0CCoQFjAB&url=http%3A%2F%2Fwww.youdidwhatwithtsql.com%2Fmove-mysql-tokudb-database%2F1743%2F&ei=nRO8VN-mKMKHygP4r4H4Bw&usg=AFQjCNH_GJDZ9GtlzqJ2_rcUCF8zGP6e_w&sig2=cLpfplcsq93um9hpiaEp1A&bvm=bv.83829542,d.bGQ&cad=rja "FLUSH TABLES FOR EXPORT") feature we have another option which may be more convenient in some cases. Here's a practical example of this feature...

We're using the [sakila database](http://downloads.mysql.com/docs/sakila-db.tar.gz "Sakila Sample Database") and MariaDB 10.0.15 but it should also work with MySQL 5.6 onwards. Note that this procedure requires the [innodb\_file\_per\_table](http://dev.mysql.com/doc/refman/5.6/en/innodb-parameters.html#sysvar_innodb_file_per_table "innodb file per table variable") is on and the tables will be read-only for the duration of the export.

First we need to generate a list of tables

```
USE sakila

SET SESSION group_concat_max_len = 10240;

SELECT GROUP_CONCAT("`", TABLE_NAME, "`")
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_TYPE = 'BASE TABLE'
AND `ENGINE` = 'InnoDB';
```

From this output we can build the statement to export the tables...

```
FLUSH TABLES `actor`,`address`,`category`,`city`,`country`,`customer`,`film`,`film_actor`,`film_category`,`inventory`,`language`,`payment`,`rental`,`staff`,`store` FOR EXPORT;
```

Create a database on the other server you will be moving the tables to.

```
CREATE DATABASE sakila2;

USE sakila2;
```

Copy the structure of your database to **sakila2** using your preferred method. Then execute the following queries. These will generate statements that will allow us to import the tablespaces. Save the output.

```
USE sakila2;

SELECT CONCAT("ALTER TABLE `", TABLE_NAME, "` DISCARD TABLESPACE;")
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_TYPE = 'BASE TABLE'
AND `ENGINE` = 'InnoDB';

SELECT CONCAT("ALTER TABLE `", TABLE_NAME, "` IMPORT TABLESPACE;")
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_TYPE = 'BASE TABLE'
AND `ENGINE` = 'InnoDB';
```

Discard the tablespaces on the destination server so the new ones can be imported...

```
SET @@session.foreign_key_checks = 0;
ALTER TABLE `actor` DISCARD TABLESPACE;
ALTER TABLE `address` DISCARD TABLESPACE;
ALTER TABLE `category` DISCARD TABLESPACE;
ALTER TABLE `city` DISCARD TABLESPACE;
ALTER TABLE `country` DISCARD TABLESPACE;
ALTER TABLE `customer` DISCARD TABLESPACE;
ALTER TABLE `film` DISCARD TABLESPACE;
ALTER TABLE `film_actor` DISCARD TABLESPACE;
ALTER TABLE `film_category` DISCARD TABLESPACE;
ALTER TABLE `inventory` DISCARD TABLESPACE;
ALTER TABLE `language` DISCARD TABLESPACE;
ALTER TABLE `payment` DISCARD TABLESPACE;
ALTER TABLE `rental` DISCARD TABLESPACE;
ALTER TABLE `staff` DISCARD TABLESPACE;
ALTER TABLE `store` DISCARD TABLESPACE;
SET @@session.foreign_key_checks = 1;
```

While the tables locks are still alive we need to copy all of the ibd and cfg files to the destination server. In later version of MySQL / MariaDB you don't strictly need the cfg as the table structures can be discovered.

```
scp /var/lib/sakila/{actor,address,category,etc}.{ibd,cfg} user@destination-server:/var/lib/mysql/sakila2
```

Once the copy is complete unlock the tables at the source...

```
UNLOCK TABLES;
```

You probably need to change the ownership of the files at the destination...

```
chown -R mysql:mysql /var/lib/mysql/sakila2
```

Now we should be ready to import the tablespaces...

```
USE sakila2;

SET @@session.foreign_key_checks = 0;
ALTER TABLE `actor` IMPORT TABLESPACE;
ALTER TABLE `address` IMPORT TABLESPACE;
ALTER TABLE `category` IMPORT TABLESPACE;
ALTER TABLE `city` IMPORT TABLESPACE;
ALTER TABLE `country` IMPORT TABLESPACE;
ALTER TABLE `customer` IMPORT TABLESPACE;
ALTER TABLE `film` IMPORT TABLESPACE;
ALTER TABLE `film_actor` IMPORT TABLESPACE;
ALTER TABLE `film_category` IMPORT TABLESPACE;
ALTER TABLE `inventory` IMPORT TABLESPACE;
ALTER TABLE `language` IMPORT TABLESPACE;
ALTER TABLE `payment` IMPORT TABLESPACE;
ALTER TABLE `rental` IMPORT TABLESPACE;
ALTER TABLE `staff` IMPORT TABLESPACE;
ALTER TABLE `store` IMPORT TABLESPACE;
SET @session.foreign_key_checks = 1;
```

Now your exported tables should be ready for action. If you want to make sure then run some CHECK TABLE statements against your data...

```
SELECT CONCAT("CHECK TABLE ", TABLE_NAME, ";")
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_TYPE = "BASE TABLE";
```

**UPDATE** - 2014-02-20 Corrected scp command typo.  
**UPDATE** - 2015-03-27 Table statistics will be wrong after doing this so you probably want to run [ANALYZE TABLE](http://dev.mysql.com/doc/refman/5.6/en/analyze-table.html "ANALYZE TABLE").

