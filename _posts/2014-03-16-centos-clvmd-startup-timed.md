---
layout: post
title: 'CentOS: clvmd startup timed out'
date: 2014-03-16 22:39:57.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Linux
tags:
- CentOS
- Linux
meta:
  _edit_last: '1'
  tweetbackscheck: '1613385117'
  _wp_old_slug: clvmd-startup-timed
  shorturls: a:3:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/centos-clvmd-startup-timed/1865/";s:7:"tinyurl";s:26:"http://tinyurl.com/qfzz276";s:4:"isgd";s:19:"http://is.gd/H3lHNL";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/centos-clvmd-startup-timed/1865/"
---
I received the following error, on CentOS 6.5, when configuring a [High Availability cluster](http://www.centos.org/docs/5/html/5.1/Cluster_Suite_Overview/s1-clstr-basics-CSO.html "CentOS Cluster"). This also cause the computer to freeze on the os boot.

```
clvmd startup timed out
```

The fix was found [here](http://www.redhat.com/archives/linux-cluster/2007-August/msg00346.html) and involved an edit of /etc/lvm/lvm.conf. This required a minor change to the **library\_dir** line as the location of these libraries have changed. See below for the full list.

```
library_dir = "/lib64"
locking_type = 3
fallback_to_local_locking = 1
fallback_to_clustered_locking = 0
locking_dir = "/var/lock/lvm"
```
