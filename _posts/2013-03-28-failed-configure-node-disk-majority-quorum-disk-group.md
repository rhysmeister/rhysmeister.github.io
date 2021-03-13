---
layout: post
title: Failed to configure Node and Disk Majority quorum with '[Disk Group Name]'.
date: 2013-03-28 08:37:58.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
tags:
- failover cluster
- Quorum
- SQL Server
meta:
  _edit_last: '1'
  tweetbackscheck: '1613477622'
  shorturls: a:3:{s:9:"permalink";s:92:"http://www.youdidwhatwithtsql.com/failed-configure-node-disk-majority-quorum-disk-group/1545";s:7:"tinyurl";s:26:"http://tinyurl.com/bsoy7b5";s:4:"isgd";s:19:"http://is.gd/679V9R";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/failed-configure-node-disk-majority-quorum-disk-group/1545/"
---
I was changing the drive used as a disk quorum today and received the following error at the end of the wizard in [Failover Cluster Manager](http://technet.microsoft.com/en-us/library/cc772502.aspx "Failover CLuster Manager");

```
Failed to configure Node and Disk Majority quorum with '[Disk Group Name]'.
```

I then noticed the drive I was trying to add was in the "SQL Server (MSSQLSERVER)" group and not in the "Available Storage" group. To resolve this I went to the "Server Server (MSSQLSERVER)" node under "Services and applications". Under the "Disk Drive" section I right clicked the drive I wanted to use for the Quorum and selected "Remove from SQL Server (MSSQLSERVER)".

This made the drive appear in the "Available Storage" group. I was then able to&nbsp;successfully&nbsp;complete to wizard to reconfigure the quorum.

