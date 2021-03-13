---
layout: post
title: Migrate users between MySQL Servers with pt-show-grants
date: 2013-02-05 09:40:52.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Linux
- MySQL
tags:
- MySQL
- percona
- percona toolkit
- pt-show-grants
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  tweetbackscheck: '1613479479'
  shorturls: a:3:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/migrate-users-mysql-servers-ptshowgrants/1537";s:7:"tinyurl";s:26:"http://tinyurl.com/btjbs8y";s:4:"isgd";s:19:"http://is.gd/mtBMO8";}
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/migrate-users-mysql-servers-ptshowgrants/1537/"
---
If you use [MySQL](http://www.mysql.com/ "MySQL") but don't use [Percona Toolkit](http://www.percona.com/software/percona-toolkit "Percona Toolkit") you're really missing a trick. It contains a whole host of useful tools including [pt-show-grants](http://www.percona.com/doc/percona-toolkit/2.1/pt-show-grants.html "Percona Toolkit pt-show-grants")&nbsp;which I use to migrate users between servers easily.

```
pt-show-grants --host mysqlservername --user username --password secret | mysql -h localhost -u username -p
```

If you want to filter out any specific users, or databases, that's easy enough with [grep](http://unixhelp.ed.ac.uk/CGI/man-cgi?grep "Unix grep");

```
pt-show-grants --host mysqlservername --user username --password secret | grep -v exclude_database_name | mysql -h localhost -u username -p
```
