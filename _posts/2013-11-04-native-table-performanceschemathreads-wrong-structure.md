---
layout: post
title: Native table 'performance_schema'.'threads' has the wrong structure
date: 2013-11-04 11:35:50.000000000 +01:00
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
- mysql_upgrade
- performance_schema
meta:
  _edit_last: '1'
  tweetbackscheck: '1613387362'
  shorturls: a:3:{s:9:"permalink";s:93:"http://www.youdidwhatwithtsql.com/native-table-performanceschemathreads-wrong-structure/1701/";s:7:"tinyurl";s:26:"http://tinyurl.com/npzkk7j";s:4:"isgd";s:19:"http://is.gd/AtqvRD";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/native-table-performanceschemathreads-wrong-structure/1701/"
---
After upgrading a MySQL slave from 5.5 to 5.6.14 I attempted to execute the following query...

```
SELECT * FROM performance_schema.threads;
```

Despite the error log not reporting any issues I received the following error...

```
Native table 'performance_schema'.'threads' has the wrong structure
```

This was simply resolved by executing...

```
mysql_upgrade -h localhost -u root -p;
```

and then restarting the MySQL instance.

