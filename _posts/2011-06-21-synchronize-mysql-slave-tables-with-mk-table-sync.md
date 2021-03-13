---
layout: post
title: Synchronize Mysql slave tables with mk-table-sync
date: 2011-06-21 20:40:56.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- maatkit
- MySQL
- slaves
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  tweetbackscheck: '1613199771'
  shorturls: a:3:{s:9:"permalink";s:88:"http://www.youdidwhatwithtsql.com/synchronize-mysql-slave-tables-with-mk-table-sync/1270";s:7:"tinyurl";s:26:"http://tinyurl.com/6y4ntdl";s:4:"isgd";s:19:"http://is.gd/qxNcya";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/synchronize-mysql-slave-tables-with-mk-table-sync/1270/"
---
I've been meaning to check out [Maatkit](http://www.maatkit.org/ "Maatkit MySQL tools") for a while now. Today I had a reason to as one of our MySQL slaves got out of sync with the master. I'd heard about [mk-table-sync](http://www.maatkit.org/doc/mk-table-sync.html), a tool that synchronizes tables, so I thought I'd give it a shot.

As it turns out it's this easy;

```
mk-table-sync --execute h=slave_server,u=username,p=secret,D=database,t=table_to_sync --sync-to-master
```

I was a little worried about how this would pan out as I assumed it would change data on the slave. Cleverly, the Maatkit developers have thought of this;

_"When synchronizing a server that is a replication slave with the --replicate or --sync-to-master methods, it **always** makes the changes on the replication master, **never** the replication slave directly."_ [ref](http://www.maatkit.org/doc/mk-table-sync.html)

So in theory this should alleviate some of those replication pains. Happy days!

