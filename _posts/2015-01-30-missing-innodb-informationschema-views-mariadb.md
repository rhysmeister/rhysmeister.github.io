---
layout: post
title: Missing InnoDB information_schema Views in MariaDB
date: 2015-01-30 15:42:39.000000000 +01:00
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
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:86:"http://www.youdidwhatwithtsql.com/missing-innodb-informationschema-views-mariadb/2038/";s:7:"tinyurl";s:26:"http://tinyurl.com/ox3exol";s:4:"isgd";s:19:"http://is.gd/jUP9uY";}
  tweetbackscheck: '1613464385'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/missing-innodb-informationschema-views-mariadb/2038/"
---
While working on a MariaDB 10.0.14 instance today I noticed the INNODB\_% tables were missing from [information\_schema](https://mariadb.com/kb/en/mariadb/information-schema-tables/ "MariaDB information\_schema"). I could tell the InnoDB plugin was loaded.

```
SHOW PLUGINS;
```

```
Name Status Type Library License
InnoDB ACTIVE STORAGE ENGINE ha_innodb.so GPL
```

Checking [the documentation](https://docs.oracle.com/cd/E17952_01/mysql-monitor-3.0-en/admin-advisors-reference.html "Innodb")&nbsp;I could see that these views are supplied by the innodb plugin itself. So the solution should be in the form of an [INSTALL PLUGIN](https://mariadb.com/kb/en/mariadb/install-plugin/ "INSTALL PLUGIN") statement.&nbsp;I executed the following query on another MariaDB instance, of the same version, that had the INNODB\_% table in info schema...

```
SELECT CONCAT("INSTALL PLUGIN ", PLUGIN_NAME, " SONAME 'ha_innodb.so';")
FROM information_schema.PLUGINS
WHERE PLUGIN_NAME LIKE 'INNODB_%';
```

This generated the following statements. I executed these on the other instance to create the INNODB tables...

```
INSTALL PLUGIN INNODB_TRX SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_LOCKS SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_LOCK_WAITS SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_CMP SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_CMP_RESET SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_CMPMEM SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_CMPMEM_RESET SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_CMP_PER_INDEX SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_CMP_PER_INDEX_RESET SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_BUFFER_PAGE SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_BUFFER_PAGE_LRU SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_BUFFER_POOL_STATS SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_METRICS SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_FT_DEFAULT_STOPWORD SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_FT_DELETED SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_FT_BEING_DELETED SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_FT_CONFIG SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_FT_INDEX_CACHE SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_FT_INDEX_TABLE SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_SYS_TABLES SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_SYS_TABLESTATS SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_SYS_INDEXES SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_SYS_COLUMNS SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_SYS_FIELDS SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_SYS_FOREIGN SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_SYS_FOREIGN_COLS SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_SYS_TABLESPACES SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_SYS_DATAFILES SONAME 'ha_innodb.so';
INSTALL PLUGIN INNODB_CHANGED_PAGES SONAME 'ha_innodb.so';
```
