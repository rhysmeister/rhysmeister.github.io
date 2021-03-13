---
layout: post
title: 'Error dropping database (can''t rmdir ''./database'', errno: 39)'
date: 2010-06-23 22:12:55.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- drop database
- MySQL
meta:
  tweetbackscheck: '1613463879'
  shorturls: a:4:{s:9:"permalink";s:90:"http://www.youdidwhatwithtsql.com/error-dropping-database-cant-rmdir-database-errno-39/801";s:7:"tinyurl";s:26:"http://tinyurl.com/26xddqo";s:4:"isgd";s:18:"http://is.gd/d12SI";s:5:"bitly";s:20:"http://bit.ly/da7nGB";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/error-dropping-database-cant-rmdir-database-errno-39/801/"
---
Just a very quick post today! If you encounter this error when attempting to drop a [MySQL](http://www.mysql.com) database;

```
Error dropping database (can't rmdir './database', errno: 39)
```

Then you probably have some rogue files in the folder where the database files are located. If you [cd](http://www.computerhope.com/unix/ucd.htm) into this directory you will be able to view these files. In my case I had a [tar archive](http://www.gnu.org/software/tar/) containing the files the database was restored from. Just delete any files in this directory and you’ll be able to complete the drop.

