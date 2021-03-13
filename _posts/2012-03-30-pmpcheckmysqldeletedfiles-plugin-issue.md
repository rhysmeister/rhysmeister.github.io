---
layout: post
title: pmp-check-mysql-deleted-files plugin issue
date: 2012-03-30 16:33:45.000000000 +02:00
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
- MySQL
- nagios
- percona
- pmp-check-mysql-deleted-files
meta:
  _edit_last: '1'
  tweetbackscheck: '1613201315'
  _wp_old_slug: pmpcheckmysqldeletedfiles
  shorturls: a:3:{s:9:"permalink";s:77:"http://www.youdidwhatwithtsql.com/pmpcheckmysqldeletedfiles-plugin-issue/1466";s:7:"tinyurl";s:26:"http://tinyurl.com/c2wh5hl";s:4:"isgd";s:19:"http://is.gd/SvXMEQ";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/pmpcheckmysqldeletedfiles-plugin-issue/1466/"
---
I've been busy setting up the [Percona Nagios MySQL Plugins](http://www.percona.com/software/percona-monitoring-plugins/ "Percona Nagios MySQL Plugins")&nbsp; but ran into an issue with the [pmp-check-mysql-deleted-files](http://www.percona.com/doc/percona-monitoring-plugins/nagios/pmp-check-mysql-deleted-files.html) plugin;

```
UNK could not list MySQL's open files
```

After a little debugging we tracked this down to a problem caused by running multiple instances of mysqld. This is something the script author ([Baron Schwartz](http://www.percona.com/about-us/our-team/baron-schwartz/ "Baron Schwartz")) mentions in his script "# TODO: We could auto-check every running instance, not just one.". I've replaced the following line

```
local PROC_ID=$(_pidof mysqld | head -n1)
```

With...

```
local PROC_ID=`ps aux | grep mysqld | grep -v mysqld_safe | grep $OPT_PORT | awk '{print $2}'`;
```

Note, this uses the MySQL port number supplied to the script to identify the correct MySQL instance. Probably a cleaner way to do this so I'll think about updating this post with a better way in the future. Usual disclaimer applies; not properly tested, buyer beware, keep out of reach of children, may contain nuts etc.

&nbsp;

&nbsp;

