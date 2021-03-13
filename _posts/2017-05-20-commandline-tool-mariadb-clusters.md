---
layout: post
title: 'my: a command-line tool for MariaDB Clusters'
date: 2017-05-20 18:46:35.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories: []
tags:
- mariadb
- python
meta:
  _edit_last: '1'
  tweetbackscheck: '1613154304'
  shorturls: a:2:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/commandline-tool-mariadb-clusters/2300/";s:7:"tinyurl";s:27:"http://tinyurl.com/ybwfn6yv";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/commandline-tool-mariadb-clusters/2300/"
---
I've posted the code for my MariaDB Cluster command-line tool called&nbsp;[my](https://github.com/rhysmeister/my). It does a bunch of stuff but the main purpose is to allow you to easily monitor replication cluster-wide while working in the shell.

Here's an example of this screen...

```
hostname port cons u_cons role repl_detail lag gtid read_only
master1 3306 7 0 ms master2.ucid.local:3306 mysql-bin.000046 7296621 0 0-2-4715491 OFF
master2 3306 33 20 ms master1.ucid.local:3306 mysql-bin.000052 1031424 0 0-2-4715491 OFF
slave1 3306 5 0 ms master1.ucid.local:3306 mysql-bin.000052 1031424 0 0-2-4715491 ON
slave2 3306 29 19 ms master2.ucid.local:3306 mysql-bin.000046 7296621 0 0-2-4715491 ON
backup 3306 5 0 ms master2.ucid.local:3306 mysql-bin.000046 7296621 0 0-2-4715491 ON
```

This screen will handle hosts that are down, identify ones where MariaDB isn't running, highlight replication lag or errors, as well as multi-master setups. See the [README](https://github.com/rhysmeister/my/blob/master/README) for more details for how to get started.

