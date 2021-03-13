---
layout: post
title: Unknown table engine 'InnoDB'‏
date: 2010-05-11 22:05:41.000000000 +02:00
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
  tweetcount: '1'
  twittercomments: a:1:{s:17:"33423644709359616";s:3:"260";}
  _edit_last: '1'
  tweetbackscheck: '1613478543'
  shorturls: a:4:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/unknown-table-engine-innodb/760";s:7:"tinyurl";s:26:"http://tinyurl.com/252l5lo";s:4:"isgd";s:18:"http://is.gd/c4M4T";s:5:"bitly";s:20:"http://bit.ly/djnmPx";}
  _sg_subscribe-to-comments: mritenour@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/unknown-table-engine-innodb/760/"
---
I ran across this error today whilst upgrading to an instance of [MySQL 5.4](http://dev.mysql.com/tech-resources/articles/mysql-54.html "MySQL 5.4").

```
Unknown table engine 'InnoDB'‏
```

I executed the following command at the MySQL client to see the available storage engines.

```
SHOW ENGINES;
```

This only listed the following table types;

```
MRG_MYISAM
MyISAM
BLACKHOLE
CSV
MEMORY
FEDERATED
ARCHIVE
```

Sure enough, No Innodb engine was present. I googled for "Unknown table engine Innodb" and came across the following [thread](http://osterman.com/wordpress/2007/12/23/unknown-table-engine-innodb). While this made sense it had no effect for me as **skip-innodb** wasn't present in the my.cnf file. I decided to take a peek into the MySQL error log;

```
InnoDB: Error: log file /var/lib/mysql/ib_logfile2 is of different size 0 0 bytes
InnoDB: than specified in the .cnf file 0 5242880 bytes!
100511 18:28:23 [ERROR] Plugin 'InnoDB' init function returned error.
100511 18:28:23 [ERROR] Plugin 'InnoDB' registration as a STORAGE ENGINE failed
```

I checked the file mentioned, **ib\_logfile2** , and it was precisely the size the config file said it should be. Since this was a new installation, and no risk of data loss, I deleted the file and attempted to restart MySQL. Again it failed. A bit of further googling uncovered this [StackOverflow thread](http://serverfault.com/questions/104014/innodb-error-log-file-ib-logfile0-is-of-different-size).

```
InnoDB is insanely picky about it's config; if something's not right,
it'll just give up and go home. To get around this problem, just stop MySQL,
delete the old logfile, and start MySQL again. The log file will be
created with the correct size, and all will be well.
```

I'd already tried this but the original poster mentioned they deleted all log files in the **/var/lib/mysql** directory and then InnoDB decided it was happy to start up. This isn't something I'd be keen to use on a production system but I gave it go and MySQL started running.

```
100511 18:30:23 InnoDB: Database was not shut down normally!
InnoDB: Starting crash recovery.
InnoDB: Reading tablespace information from the .ibd files...
InnoDB: Restoring possible half-written data pages from the doublewrite
InnoDB: buffer...
InnoDB: Last MySQL binlog file position 0 3350536, file name ./mysql-bin.000034
100511 18:30:23 InnoDB Plugin 1.0.4 started; log sequence number 52761612
100511 18:30:23 [Note] Event Scheduler: Loaded 0 events
100511 18:30:23 [Note] /usr/sbin/mysqld: ready for connections.
Version: '5.4.2-beta-community-log' socket: '/var/run/mysql/mysql.sock' port: 3306 MySQL Community Server (GPL)
```
