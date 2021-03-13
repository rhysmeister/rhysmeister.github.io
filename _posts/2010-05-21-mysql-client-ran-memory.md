---
layout: post
title: MySQL client ran out of memory
date: 2010-05-21 12:38:45.000000000 +02:00
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
meta:
  tweetbackscheck: '1613425966'
  shorturls: a:4:{s:9:"permalink";s:61:"http://www.youdidwhatwithtsql.com/mysql-client-ran-memory/773";s:7:"tinyurl";s:26:"http://tinyurl.com/295qrap";s:4:"isgd";s:18:"http://is.gd/ciReu";s:5:"bitly";s:20:"http://bit.ly/cu8gK4";}
  _edit_last: '1'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-client-ran-memory/773/"
---
I've been building utilities with [PHP](http://php.net "PHP") and [MySQL&nbsp;command-line tools](http://dev.mysql.com/doc/refman/5.0/en/programs-client.html "MySQL command line tools") to clone databases. I ran into an issue when exporting data from multi-gigabyte tables using the [mysql client program](http://dev.mysql.com/doc/refman/5.0/en/mysql.html "MySQL client program").

```
mysql: Out of memory (Needed 4179968 bytes)
ERROR 2008 (HY000) at line 1: MySQL client ran out of memory
```

The fix for this is easy; just use the [--quick](http://dev.mysql.com/doc/refman/5.1/en/mysql-command-options.html#option_mysql_quick "MySQL client quick option") option in your call to the mysql command. This prevents the client from caching the resultset forcing it to write each row as it is&nbsp;received.

```
mysql -q -h localhost -P 3306 -u user -psecret -D db -e 'SELECT * FROM table' > '/tmp/table.csv'
```
