---
layout: post
title: Monitoring fluentd with Nagios
date: 2014-08-04 15:18:14.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Nagios
tags:
- efk
- elasticsearch
- fluentd
- nagios
meta:
  _edit_last: '1'
  tweetbackscheck: '1613321189'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/monitoring-fluentd-nagios/1954/";s:7:"tinyurl";s:26:"http://tinyurl.com/nmb8wmk";s:4:"isgd";s:19:"http://is.gd/TomAtJ";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/monitoring-fluentd-nagios/1954/"
---
Here's just a few [Nagios](http://www.nagios.org/ "Nagios") command strings you can use to [monitor&nbsp;fluentd](http://docs.fluentd.org/articles/monitoring "Monitoring fluentd"). I've thrown in a check for [elasticsearch](http://www.elasticsearch.org/ "elasticsearch") in case you're monitoring an [EFK](http://docs.fluentd.org/articles/free-alternative-to-splunk-by-fluentd "EFK") system.

For checking td-agent. We should have 2 process, parent and child...

```
/usr/local/nagios/libexec/check_procs -w 2:2 -C ruby -a td-agent
```

For checking vanilla fluentd. Be aware your version name may differ...

```
/usr/local/nagios/libexec/check_procs -w 2:2 -C fluentd1.9
```

Check tcp ports. You requirements will vary...

```
/usr/local/nagios/libexec/check_tcp -H hostname -p 24224
/usr/local/nagios/libexec/check_tcp -H hostname -p 24230
/usr/local/nagios/libexec/check_tcp -H hostname -p 42185
/usr/local/nagios/libexec/check_tcp -H hostname -p 42186
/usr/local/nagios/libexec/check_tcp -H hostname -p 42187
```

For checking there is an elasticsearch process..

```
/usr/local/nagios/libexec/check_procs -w 1:1 -C java -a elasticsearch
```
