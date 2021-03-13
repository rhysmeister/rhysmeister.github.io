---
layout: post
title: 'Bash: Count the number of databases in a gzip compressed mysqldump'
date: 2016-11-03 15:34:54.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- DBA
tags:
- Bash
- DBA
- mariadb
- MySQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613462084'
  twittercomments: a:0:{}
  shorturls: a:2:{s:9:"permalink";s:93:"http://www.youdidwhatwithtsql.com/bash-count-number-databases-gzip-compressed-mysqldump/2247/";s:7:"tinyurl";s:26:"http://tinyurl.com/gph5azw";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/bash-count-number-databases-gzip-compressed-mysqldump/2247/"
---
A simple bash one-liner!

```
gunzip -c /path/to/backup/mysqldump.sql.gz | grep -E "^CREATE DATABASE" | wc -l
```

Breaking this down..

This prints the contents of a gzip compressed [mysqldump](https://mariadb.com/kb/en/mariadb/mysqldump/) to the terminal

```
gunzip -c /path/to/backup/mysqldump.sql.gz
```

Grep for lines that start with CREATE DATABASES...

```
grep -E "^CREATE DATABASE"
```

Count the number of create database lines..

```
wc -l
```

So to count the number of tables it's just a simple change to...

```
gunzip -c /path/to/backup/mysqldump.sql.gz | grep -E "^CREATE TABLE" | wc -l
```
