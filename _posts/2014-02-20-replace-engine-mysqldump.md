---
layout: post
title: Replace the Engine used in mysqldump
date: 2014-02-20 17:09:54.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- DBA
- Linux
- MySQL
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613258649'
  shorturls: a:3:{s:9:"permalink";s:64:"http://www.youdidwhatwithtsql.com/replace-engine-mysqldump/1776/";s:7:"tinyurl";s:26:"http://tinyurl.com/ogywbea";s:4:"isgd";s:19:"http://is.gd/7wpGKm";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/replace-engine-mysqldump/1776/"
---
Just a little bash snippet to replace the [ENGINE](https://dev.mysql.com/doc/refman/5.7/en/storage-engines.html "MySQL Storage Engines") type used in a mysqldump. Slightly modified from this [stackoverflow thread](http://stackoverflow.com/questions/7739828/how-can-i-override-the-engine-innodb-parameter-while-importing-a-mysql-dump-file) to perform the dump and replacement in a single step.

To dump to a file...

```
mysqldump -h hostname -u root -p --routines --databases db_name | sed -re 's/^(\) ENGINE=)MyISAM/\1TokuDB/gi' > output.sql
```

To copy directly to another mysql server. N.B. You need to provide the passwords on the command line here. The database should not exist on the other server.

```
mysqldump -h hostname -u root -pSECRET--routines --databases db_name | sed -re 's/^(\) ENGINE=)MyISAM/\1TokuDB/gi' | mysql -h hostname -u root -pSECRET;
```
