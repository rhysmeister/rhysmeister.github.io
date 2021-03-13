---
layout: post
title: 'mysqldump: backing up specific tables'
date: 2015-01-13 14:15:46.000000000 +01:00
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
- mariadb
- MySQL
- mysqldump
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/mysqldump-backing-specific-tables/2018/";s:7:"tinyurl";s:26:"http://tinyurl.com/m7ae88y";s:4:"isgd";s:19:"http://is.gd/xTCb93";}
  tweetbackscheck: '1613461291'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysqldump-backing-specific-tables/2018/"
---
Here's a quick example of how to backup specific [MySQL](http://www.mysql.com/ "MySQL") / [MariaDB](https://mariadb.org/ "MariaDB ") tables and piping to [xz](http://tukaani.org/xz/ "xz compression") to compress...

```
mysqldump -h 127.0.0.1 -P3306 mysql user tables_priv | xz --compress -9 > /db_dumps/3104/mysqldump_tables_example.sql.xz
```

Here's how to decompress the resulting file. Note xz will delete the input file unless you specifiy --keep on the command line...

```
xz --decompress mysqldump_tables_example.sql.xz
```

Here's how you can count the number of create table statements in the dump file...

```
cat mysqldump_tables_example.sql | grep "CREATE TABLE" | wc -l
```
