---
layout: post
title: MyISAM key cache stats with information_schema.KEY_CACHES
date: 2015-02-16 17:52:37.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MariaDB
tags:
- information_schema
- mariadb
- MyISAM
meta:
  _edit_last: '1'
  tweetbackscheck: '1613462060'
  shorturls: a:3:{s:9:"permalink";s:89:"http://www.youdidwhatwithtsql.com/myisam-key-cache-stats-informationschemakeycaches/2044/";s:7:"tinyurl";s:26:"http://tinyurl.com/osoewo4";s:4:"isgd";s:19:"http://is.gd/GWMR82";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/myisam-key-cache-stats-informationschemakeycaches/2044/"
---
Following on from a post last week on [INNODB\_BUFFER\_PAGE queries](http://www.youdidwhatwithtsql.com/innodbbufferpage-queries/2041/ "INNODB\_BUFFER\_PAGE") I thought I'd look at the equivalent for the [MyISAM key cache](http://dev.mysql.com/doc/refman/5.6/en/myisam-key-cache.html "MyISAM key cache"). The [information\_schema.KEY\_CACHES](https://mariadb.com/kb/en/mariadb/information-schema-key_caches-table/ "KEY CACHES informaiton\_schema")&nbsp;is MariaDB only at the moment

```
SELECT KEY_CACHE_NAME,
	  FULL_SIZE / 1024 / 1024 AS key_buffer_mb,
	  USED_BLOCKS * BLOCK_SIZE / 1024 / 1024 AS used_mb,
	  UNUSED_BLOCKS * BLOCK_SIZE / 1024 / 1024 AS unused_mb,
	  100 - ((`READS` / READ_REQUESTS) * 100) AS read_cache_hit_rate,
	  DIRTY_BLOCKS / (USED_BLOCKS + UNUSED_BLOCKS) AS dirty_percentage,
	  READ_REQUESTS / (`READ_REQUESTS` + WRITE_REQUESTS) AS read_write_ratio
FROM information_schema.`KEY_CACHES`;
```

Most of the data returned should be self explanatory. The read\_write\_ratio indicates the number of reads versus writes, for example 1.0 indicates 100% reads whole 0.75 would indicate 75% read and 25% writes.

