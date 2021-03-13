---
layout: post
title: A few Splunk queries for MongoDB logs
date: 2017-03-21 13:03:14.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MongoDB
tags:
- mongodb
- splunk
meta:
  _edit_last: '1'
  twittercomments: a:0:{}
  tweetbackscheck: '1613471468'
  shorturls: a:2:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/splunk-queries-mongodb-log/2278/";s:7:"tinyurl";s:26:"http://tinyurl.com/ko92pr4";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/splunk-queries-mongodb-log/2278/"
---
Here's a few [Splunk](https://www.splunk.com/) queries I've used to supply some data for a dashboard I used to manage a [MongoDB](https://www.mongodb.com/) Cluster.

**Election events**

If any [MongoDB elections](https://docs.mongodb.com/manual/core/replica-set-elections/) happen at 3AM on a Wednesday night I want to know about it. This query, added to a [single value panel](https://docs.splunk.com/Documentation/SplunkLight/6.5.1612/Examples/Addasinglevaluevisualizationtoadashboard) allows me to do this easily...

```
host=mongo* source=/var/log/mongo*.log "Starting an election" | stats count
```

**Rollbacks**

I also want to know about any [rollbacks](https://docs.mongodb.com/manual/core/replica-set-rollbacks/) than happen during an election...

```
host=mongo* source=/var/log/mongo*.log "beginning rollback" | stats count
```

**Log message with severity ERROR**

Count log messages with [ERROR severity](https://docs.mongodb.com/manual/reference/log-messages/#severity-levels)...

```
host=mongo* source="/var/log/mongodb/*.log" | rex "(?<timestamp>^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\d\+\d\d\d\d) (?<severity>.) (?<component>\S*) "| where severity=E | stats count
```

**Chunk moves initiated**

Have any [chunks moved](https://docs.mongodb.com/manual/tutorial/migrate-chunks-in-sharded-cluster/)...

```
host=mongo* source="/var/log/mongodb/*.log" "moving chunk" | stats count
```

**State changes**

How many states changes, i.e. PRIMARY -\> SECONDARY in period...

```
host=mongo* "is now in state" | stats count
```
