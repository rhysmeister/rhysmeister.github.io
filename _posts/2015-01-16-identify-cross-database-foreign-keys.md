---
layout: post
title: Identify Cross Database Foreign Keys
date: 2015-01-16 17:40:56.000000000 +01:00
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
- information_schema
- InnoDB
- mariadb
- MySQL
meta:
  tweetbackscheck: '1613461463'
  _edit_last: '1'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:76:"http://www.youdidwhatwithtsql.com/identify-cross-database-foreign-keys/2027/";s:7:"tinyurl";s:26:"http://tinyurl.com/kjf78gh";s:4:"isgd";s:19:"http://is.gd/tgeLrF";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/identify-cross-database-foreign-keys/2027/"
---
I've blogged before about [cross-database foreign keys](http://www.youdidwhatwithtsql.com/cross-database-foreign-keys/784/ "Cross Database Foreign Keys") and what I think of them. I had a developer wanting to check for such references between two databases today. Here's what I came up with to do this...

```
SELECT t.NAME AS TABLE_NAME,
		i.NAME AS INDEX_NAME,
		f.*
FROM information_schema.`INNODB_SYS_FOREIGN` f
INNER JOIN information_schema.`INNODB_SYS_INDEXES` i
	ON i.`NAME` = SUBSTRING(f.`ID`, LOCATE('/', f.`ID`) + 1)
INNER JOIN information_schema.`INNODB_SYS_TABLES` t
	ON t.TABLE_ID = i.TABLE_ID
WHERE (f.FOR_NAME LIKE 'db1%' AND f.REF_NAME LIKE 'db2%')
OR (f.REF_NAME LIKE 'db1%' AND f.FOR_NAME LIKE 'db2%');
```

**N.B.** This query only applies to the innodb storage engine.

