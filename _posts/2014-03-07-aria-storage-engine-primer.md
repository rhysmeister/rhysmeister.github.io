---
layout: post
title: Aria Storage Engine Primer
date: 2014-03-07 15:48:41.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- aria storage engine
- MySQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613469692'
  shorturls: a:3:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/aria-storage-engine-primer/1837/";s:7:"tinyurl";s:26:"http://tinyurl.com/oxsl2zv";s:4:"isgd";s:19:"http://is.gd/ug3emS";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/aria-storage-engine-primer/1837/"
---
I'm looking into HA MySQL at the moment. With these types of technologies you need to have a crash-safe storage engine in use. [MyISAM](https://dev.mysql.com/doc/refman/5.5/en/myisam-storage-engine.html "MyISAM Storage Engine") just won't cut it. While my long-term goal is to move to a fully-transactional storage engine, for example [InnoDB](https://dev.mysql.com/doc/refman/5.5/en/innodb-storage-engine.html "InnoDB Storage Engine"), I'm looking at other possibilities.

Changing to a fully-transactional storage engine may cause some problems with our current applications. For example MyISAM is deadlock-free, while otehr engines are not. Using the Aria storage engine may relieve some of these issues so I can get the HA side of things sorted.

A quick illustration of using the Aria storage engine...

Create a test table..

```
CREATE TABLE test
(
	id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	value_column VARCHAR(100) NOT NULL
) ENGINE=ARIA ,TRANSACTIONAL=1;
```

Start a transaction, insert a row, then roll it back...

```
START TRANSACTION;

INSERT INTO test
(
	value_column
)
VALUES
(
	'Blah, blah, blah, blah, blah!'
);

ROLLBACK;
```

If you execute a "SHOW WARNINGS" you receive the following warning text...

```
Some non-transactional changed tables couldn't be rolled back
```

and you'll see your inserted row is still there...

```
SELECT *
FROM test;
```

The explanation is in the [Aria FAQ](https://mariadb.com/kb/en/aria-faq/ "Aria Storage Engine FAQ");  
"In the current development phase Aria tables created with TRANSACTIONAL=1 are crashsafe and atomic but not transactional because changes in Aria tables can't be rolled back with the ROLLBACK command. As we will make Aria tables fully transactional in a relatively short time frame we think it's better to use the TRANSACTIONAL keyword now so that applications don't need to be changed later.

Tables marked with TRANSACTIONAL=1 will gain more transactional features with each Aria release. We expect these tables to be fully transactional (in the traditional sense) when we reach Aria 2.0."

So rather than being a fully-fledged transactional engine we should currently only consider Aria to be "Crash-safe MyISAM".

Relevant server variables;

```
SHOW VARIABLES LIKE '%aria%';
```

```
Variable_name Value
aria_block_size 8192
aria_checkpoint_interval 30
aria_checkpoint_log_activity 1048576
aria_force_start_after_recovery_failures 0
aria_group_commit none
aria_group_commit_interval 0
aria_log_file_size 1073741824
aria_log_purge_type immediate
aria_max_sort_file_size 9223372036853727232
aria_page_checksum ON
aria_pagecache_age_threshold 300
aria_pagecache_buffer_size 134217728
aria_pagecache_division_limit 100
aria_recover NORMAL
aria_repair_threads 1
aria_sort_buffer_size 134217728
aria_stats_method nulls_unequal
aria_sync_log_dir NEWFILE
aria_used_for_temp_tables ON
```

The following command string should be good for copying a MyISAM database to another server ensuring tables use the Aria storage engine with TRANSACTIONAL=1 activated. Ensure the database does not exist on the target server.

```
mysqldump -h server1 -u root -pSECRET --routines --databases db_name | sed -re 's/^(\) ENGINE=)MyISAM/\1ARIA, TRANSACTIONAL=1/gi' | mysql -h localhost -u root -pSECRET;
```

Check the engine and create options for each of your tables to ensure they are as expected...

```
SELECT TABLE_NAME,
		 `ENGINE`,
		 CREATE_OPTIONS
FROM information_schema.tables
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_TYPE = 'BASE TABLE';
```

Useful links:

[Aria Storage Engine MariaDB documentation](https://mariadb.com/kb/en/aria-storage-engine/ "Aria Storage Engine")

[Obligatory Wikipedia link](http://en.wikipedia.org/wiki/Aria_(storage_engine) "Aria Stroage Engine")

[Aria FAQ](https://mariadb.com/kb/en/aria-faq/ "Aria Storage Engine FAQ")

