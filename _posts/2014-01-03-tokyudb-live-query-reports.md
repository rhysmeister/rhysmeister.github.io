---
layout: post
title: TokyuDB live query reports
date: 2014-01-03 18:53:19.000000000 +01:00
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
- TokuDB
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/tokyudb-live-query-reports/1730/";s:7:"tinyurl";s:26:"http://tinyurl.com/nkf74js";s:4:"isgd";s:19:"http://is.gd/p83YSb";}
  tweetbackscheck: '1613460856'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tokyudb-live-query-reports/1730/"
---
I've just started to have a peek at [TokuDB](http://www.tokutek.com/ "TokuDB storage engine") for MySQL today. I'm running a few statements to turn some existing MyISAM tables over to the TokuDB storage engine. Here's what you see with a [SHOW PROCESSLIST](http://dev.mysql.com/doc/refman/5.5/en/show-processlist.html "SHOW PROCESSLIST MySQL") command.

```
Id: 6
   User: root
   Host: localhost:42944
     db: test_db
Command: Query
   Time: 658
  State: Loading of data about 14.2% done
   Info: ALTER TABLE table_name ENGINE = TokuDB
```

Live query progress reports! Much more informative than "[executing](http://dev.mysql.com/doc/refman/5.0/en/general-thread-states.html "MySQL General Thread States")" I hope there's more nice surprises to come!

Here's a few more examples...

**OPTIMIZE TABLE index level information...**

```
Id: 9
   User: root
   Host: localhost:42956
     db: test_db
Command: Query
   Time: 272
  State: Optimization of index 2 of 4 about 72% done
   Info: OPTIMIZE TABLE table_name
```

**SELECT query progress...**

```
Id: 11
   User: root
   Host: localhost:42958
     db: test_db
Command: Query
   Time: 98
  State: Queried about 136130000 rows
   Info: select count(*) from table_name
```

**Detailed reporting on INSERT INTO table\_name SELECT... queries...**

```
Id: 10
   User: root
   Host: localhost:42957
     db: test_db
Command: Query
   Time: 815
  State: Queried about 100000000 rows, Inserted about 5354718 rows
   Info: insert into table_name (col1, col2, col3) SELECT col1, col2, col3 FROM table_name LIMIT 100000000
```

**Rollback of killed transactions...**

```
Id: 10
   User: root
   Host: localhost:42957
     db: qtest_db
Command: Killed
   Time: 1343
  State: processing abort of transaction, 5194752 out of 53792548
   Info: insert into table_name...
```
