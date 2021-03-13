---
layout: post
title: Bash script to execute a MariaDB query multiple times
date: 2014-12-15 17:32:04.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- Linux
- MariaDB
- MySQL
tags:
- Bash
- mariadb
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:88:"http://www.youdidwhatwithtsql.com/bash-script-execute-mariadb-query-multiple-times/2008/";s:7:"tinyurl";s:26:"http://tinyurl.com/ndybubd";s:4:"isgd";s:19:"http://is.gd/f75Q6h";}
  tweetbackscheck: '1612920188'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/bash-script-execute-mariadb-query-multiple-times/2008/"
---
This simple bash script will execute a query 100 times against a MySQL instance. It also uses the [time](http://linux.die.net/man/1/time "time command Linux") command to report how long the entire process took. I use this for some very simple bench-marking.

The query used here creates a temporary table and inserts 100K rows into it. You need the [sequence engin](https://mariadb.com/kb/en/mariadb/documentation/storage-engines/sequence/ "MySQL sequence storage engine")e installed.

```
PWD="secret";
time (for i in {1..100} ; do mysql -h 127.0.0.1 -u root -p$PWD -P3001 -D tmp -e "CREATE TEMPORARY TABLE tmp$i (id INTEGER NOT NULL PRIMARY KEY); INSERT INTO tmp$i SELECT * FROM seq_1_to_100000;"; done);
```

Output will look something like below..

```
real	0m50.205s
user	0m0.492s
sys	0m0.453s
```
