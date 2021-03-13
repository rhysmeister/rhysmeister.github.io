---
layout: post
title: 'Slave: Got error -1 from storage engine Error_code: 1030'
date: 2013-07-15 15:34:03.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613441493'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:83:"http://www.youdidwhatwithtsql.com/slave-error-1-storage-engine-errorcode-1030/1626/";s:7:"tinyurl";s:26:"http://tinyurl.com/phyjkm8";s:4:"isgd";s:19:"http://is.gd/skqee9";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/slave-error-1-storage-engine-errorcode-1030/1626/"
---
I received this error after copying a [MyISAM](http://dev.mysql.com/doc/refman/5.0/en/myisam-storage-engine.html "MyISAM") database from one server to another.

```
130715 15:21:14 [Note] Slave SQL thread initialized, starting replication in log 'mysqlhost-masterlog.XXXXXXXX' at position XXXXXX7, relay log '/log/binlog/relay-mysqlhostXXXXXX' position: XXXXXX
130715 15:21:14 [ERROR] Slave SQL: Error 'Got error -1 from storage engine' on query. Default database: 'db'. Query: 'UPDATE..., Error_code: 1030
130715 15:21:14 [Warning] Slave: Got error -1 from storage engine Error_code: 1030
130715 15:21:14 [ERROR] Error running query, slave SQL thread aborted. Fix the problem, and restart the slave SQL thread with "SLAVE START".
```

Suggestions from Google mentioned a full disk being a cause but this was not relevant in my case. Then I remembered I hadn't executed a FLUSH TABLES. This is always sensible, if you're not restarting MySQL, after messing about in the file system.

So after a simple;

```
FLUSH TABLES;
```

I could start the slave thread up happily.

