---
layout: post
title: ERROR Failed to open the relay log '7' (relay_log_pos 0)
date: 2013-11-06 15:22:56.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- mariadb
- MySQL
- replication
- slave
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:83:"http://www.youdidwhatwithtsql.com/error-failed-open-relay-log-7-relaylogpos-0/1706/";s:7:"tinyurl";s:26:"http://tinyurl.com/p3omvo3";s:4:"isgd";s:19:"http://is.gd/A5VBsP";}
  tweetbackscheck: '1613461933'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/error-failed-open-relay-log-7-relaylogpos-0/1706/"
---
I received the following error when I ~~upgraded~~ modified a slave from MySQL 5.6.14 to MariaDB 5.5.33 and executing "START SLAVE;".

```
131106 11:12:31 [ERROR] Failed to open the relay log '7' (relay_log_pos 0)
```

I checked my **relay-log.info** file and it looked like below...

```
7
/logs/relay/hostname-relaylog.000046
661930553
hostname-masterlog.000019
661930383
0
0
0
```

Obviously there a difference in the relay log format, but to get this working, I removed the top line completely (the '7') and I was able to start the slave successfully. Not 100% sure my slave is correctly in sync or error free so be warned of this fix / hack.

