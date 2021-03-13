---
layout: post
title: UNKNOWN STORAGE ENGINE 'FEDERATED'
date: 2014-12-23 20:18:00.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MariaDB
tags:
- federated
- mariadb
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/unknown-storage-engine-federated/2011/";s:7:"tinyurl";s:26:"http://tinyurl.com/p47nl6g";s:4:"isgd";s:19:"http://is.gd/ckIPIU";}
  tweetbackscheck: '1613311967'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/unknown-storage-engine-federated/2011/"
---
You may receive the following error with [MariaDB](https://mariadb.com "MariaDB ") on a Windows platform when attempting to create a table using the [federatedx engine](https://mariadb.com/kb/en/mariadb/documentation/storage-engines/federatedx-storage-engine/ "federatedx engine").

```
1 queries executed, 0 success, 1 ERRORS, 0 WARNINGS

QUERY: CREATE TABLE t1 ENGINE=FEDERATED CONNECTION="server"

Error CODE: 1286
UNKNOWN STORAGE ENGINE 'FEDERATED'

Execution TIME : 0 sec
Transfer TIME : 0 sec
Total TIME : 0 sec
```

The federatedx engine does not seem to be enabled by default (10.0.14 on Windows). To sort this out simply run...

```
INSTALL SONAME 'ha_federatedx.dll';
```

The output of [SHOW PLUGINS](https://mariadb.com/kb/en/mariadb/documentation/sql-commands/administration-commands/show/show-plugins/ "MariaDB SHOW PLUGINS") should now display this...

```
Name Status Type Library License
FEDERATED ACTIVE STORAGE ENGINE ha_federatedx.dll GPL
```
