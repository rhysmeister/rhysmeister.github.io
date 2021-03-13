---
layout: post
title: "[Warning] User entry 'username'@'hostname' has an empty plugin value. The
  user will be ignored and no one can login with this user anymore."
date: 2013-11-14 11:30:17.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Linux
- MySQL
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613376243'
  shorturls: a:3:{s:9:"permalink";s:112:"http://www.youdidwhatwithtsql.com/warning-user-entry-usernamehostname-empty-plugin-user-login-user-anymore/1711/";s:7:"tinyurl";s:26:"http://tinyurl.com/nm7xw6a";s:4:"isgd";s:19:"http://is.gd/Krmw5o";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/warning-user-entry-usernamehostname-empty-plugin-user-login-user-anymore/1711/"
---
After upgrading an instance of MySQL to 5.7 I was unable to login and had several of the following entries in the error log.

```
[Warning] User entry 'username'@'hostname' has an empty plugin value. The user will be ignored and no one can login with this user anymore.
```

This is explained the the [release notes](http://dev.mysql.com/doc/relnotes/mysql/5.7/en/news-5-7-2.html "MySQL 5.7.2"). Here's the process I followed to fix this.

```
# Identify the path to mysqld_safe
ps -e | grep mysqld
# Stop mysql
sudo /sbin/service mysql stop
# Start with --skip-grant-tables
sudo /usr/bin/mysqld_safe --skip-grant-tables
# Run mysql_upgrade
sudo mysql_upgrade -h 127.0.0.1 -u root -p
# Restart mysql
sudo /sbin/service mysql restart
```
