---
layout: post
title: MySQL Partitioning & OPTIMIZE TABLE
date: 2014-01-03 18:34:49.000000000 +01:00
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
- OPTIMIZE TABLE
- partitioning
meta:
  _edit_last: '1'
  tweetbackscheck: '1613478767'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/mysql-partitioning-optimize-table/1727/";s:7:"tinyurl";s:26:"http://tinyurl.com/opx25tv";s:4:"isgd";s:19:"http://is.gd/aMbvnS";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-partitioning-optimize-table/1727/"
---
[MySQL table Partitioning](http://dev.mysql.com/doc/refman/5.5/en/partitioning.html "MySQL Table Partitioning") can be used in various way to improve performance. I wanted to get some idea of how this would affect database maintenance operations like [OPTIMIZE TABLE](http://dev.mysql.com/doc/refman/5.5/en/optimize-table.html "MySQL OPTIMIZE TABLE").

For these tests I used a default install of MySQL 5.6.15, with a key\_buffer\_size of 2GB, and executed OPTIMIZE TABLE table\_name after a series of actions (detailed below).

Here are the results of an **OPTIMIZE TABLE** statement after an initial load of 2.8GB of data. The 2.8 GB of data produced 4.5GB of indices (slightly more for the HASH partitioned table due to the PK modification).

| Table Type | Optimize Time (m, s) |
| --- | --- |
| Non Partitioned | 17 min 20.09 sec |
| Hash-Partitioned (10 partitions) | 2 min 38.61 sec |
| Range-Partitioned (by auto increment id) | 1 min 37.27 sec |

**Non-Partitioned Table**

```
CREATE TABLE `table1` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `second_id` mediumint(11) unsigned NOT NULL,
  `third_id` tinyint(11) unsigned NOT NULL,
  `fourth_id` mediumint(11) unsigned NOT NULL,
  `fifth_id` tinyint(11) unsigned NOT NULL,
  `value` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `second_refs_id_` (`second`),
  KEY `third_id_refs_id` (`third_id`),
  KEY `fifth_id_refs_id` (`fifth_id`)
) ENGINE=MyISAM
```

**Hash-Partitioned Table**

```
CREATE TABLE `table2` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `second_id` mediumint(11) unsigned NOT NULL,
  `third_id` tinyint(11) unsigned NOT NULL,
  `fourth_id` mediumint(11) unsigned NOT NULL,
  `fifth_id` tinyint(11) unsigned NOT NULL,
  `value` double DEFAULT NULL,
  PRIMARY KEY (`id`, fifth_id),
  KEY `second_refs_id_` (`second`),
  KEY `third_id_refs_id` (`third_id`),
  KEY `fifth_id_refs_id` (`fifth_id`)
) ENGINE=MyISAM
PARTITION BY HASH(fifth_id)
PARTITIONS 10;
```

**Range-Partitioned Table**

```
CREATE TABLE `table1` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `second_id` mediumint(11) unsigned NOT NULL,
  `third_id` tinyint(11) unsigned NOT NULL,
  `fourth_id` mediumint(11) unsigned NOT NULL,
  `fifth_id` tinyint(11) unsigned NOT NULL,
  `value` double DEFAULT NULL,
  PRIMARY KEY (`id`, fifth_id),
  KEY `second_refs_id_` (`second`),
  KEY `third_id_refs_id` (`third_id`),
  KEY `fifth_id_refs_id` (`fifth_id`)
) ENGINE=MyISAM
PARTITION BY RANGE(id)
(
    PARTITION p0 VALUES LESS THAN (14203359),
    PARTITION p1 VALUES LESS THAN (28406718),
    PARTITION p2 VALUES LESS THAN (42610077),
    PARTITION p3 VALUES LESS THAN (56813436),
    PARTITION p4 VALUES LESS THAN (71016795),
    PARTITION p5 VALUES LESS THAN (85220153),
    PARTITION p6 VALUES LESS THAN (99423512),
    PARTITION p7 VALUES LESS THAN (113626871),
    PARTITION p8 VALUES LESS THAN (127830230),
    PARTITION p9 VALUES LESS THAN (142033590),
    PARTITION p10 VALUES LESS THAN MAXVALUE
);
```

Now let's delete one row from each of the table.

```
DELETE FROM table1 LIMIT 1;
DELETE FROM table2 LIMIT 1;
DELETE FROM table2 LIMIT 1;
```

What does this do to our optimize times?

| Table Type | Optimize Time (m, s) |
| --- | --- |
| Non Partitioned | 16 min 53.11 sec |
| Hash-Partitioned (10 partitions) | 0.70 sec |
| Range-Partitioned (by auto increment id) | 1 min 4.87 sec |

How about a random delete of ten rows?

```
DELETE FROM table1 ORDER BY RAND() LIMIT 10;
DELETE FROM table2 ORDER BY RAND() LIMIT 10;
DELETE FROM table3 ORDER BY RAND() LIMIT 10;
```

What does this do to our optimize times?

| Table Type | Optimize Time (m, s) |
| --- | --- |
| Non Partitioned | 15 min 44.20 sec |
| Hash-Partitioned (10 partitions) | 12 min 47.28 sec |
| Range-Partitioned (by auto increment id) | 5 min 55.09 sec |

Please note for this final test your own mileage may vary according to which partitions the delete touches. It's obvious here MySQL has some kind of internal flag to see if an index has been changed. If the indexes on a partition have not changed then it doesn't need to optimize it.

I'm still not entirely sure why the HASH partition test performed so well in the second test. I received the same result for multiple iteration of this test. If anyone has any ideas then I'm all ears!

