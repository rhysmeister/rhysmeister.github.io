---
layout: post
title: Copy date stamped backups with a regex & scp
date: 2014-10-09 13:23:01.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- DBA
- Linux
tags:
- Bash
- scp
meta:
  shorturls: a:3:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/copy-date-stamped-backups-regex-scp/1995/";s:7:"tinyurl";s:26:"http://tinyurl.com/kqmd6zh";s:4:"isgd";s:19:"http://is.gd/8rSZh2";}
  _edit_last: '1'
  tweetbackscheck: '1613478967'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/copy-date-stamped-backups-regex-scp/1995/"
---
Lets assume you have a directory of date stamped backups you want to [scp](http://unixhelp.ed.ac.uk/CGI/man-cgi?scp+1 "Scure Copy Program man page") to another location...

```
backup_20141003.tar.gz
backup_20141004.tar.gz
backup_20141005.tar.gz
backup_20141006.tar.gz
backup_20141007.tar.gz
backup_20141008.tar.gz
backup_20141009.tar.gz
```

scp can accept a [regex](http://www.regular-expressions.info/ "regular expressions") like below to do this as a one-liner. Note the quotes are required for the expression to work.

```
scp "user@hostname:/data/backup/backup_2014100[3-9].tar.gz" /path/to/location/
```

You should see something like this output...

```
backup_20141003.tar.gz 100% 22GB 55.5MB/s 06:43
backup_20141004.tar.gz 100% 22GB 12.0MB/s 31:13
backup_20141005.tar.gz 100% 22GB 12.3MB/s 30:41
backup_20141006.tar.gz 100% 22GB 7.5MB/s 49:52
backup_20141007.tar.gz 77% 17GB 38.7MB/s 02:12 ETA
```
