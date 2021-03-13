---
layout: post
title: Monitor /tmp usage on Linux
date: 2012-10-06 16:18:25.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Linux
tags:
- Bash
- Linux
- sysadmin
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:62:"http://www.youdidwhatwithtsql.com/monitor-tmp-usage-linux/1503";s:7:"tinyurl";s:26:"http://tinyurl.com/9e3e8ba";s:4:"isgd";s:19:"http://is.gd/WIke9K";}
  tweetbackscheck: '1613450899'
  _aioseop_description: Simple method for logging the usage of /tmp on a Linux system.
    Uses a simple cron job to achieve this.
  _wp_old_slug: monitor-tmp-usage
  _aioseop_title: Monitor /tmp usage on a Linux system
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/monitor-tmp-usage-linux/1503/"
---
Just a quick post to show how to monitor usage of /tmp on a Linux system. Setup a cron job as follows...

```
* * * * * df -h | grep "/tmp" >> /tmp/tmp.log
```

This job will run every one minute logging details of /tmp usage to a file called tmp.log. To report on this later you can run the following command to get a unique ordered list.

```
cat /tmp/tmp.log | sort | uniq
```

```
/dev/sda3 60G 344M 58G 1% /tmp
/dev/sda3 60G 348M 58G 1% /tmp
/dev/sda3 60G 351M 58G 1% /tmp
/dev/sda3 60G 354M 58G 1% /tmp
/dev/sda3 60G 357M 58G 1% /tmp
/dev/sda3 60G 359M 58G 1% /tmp
/dev/sda3 60G 360M 58G 1% /tmp
/dev/sda3 60G 361M 58G 1% /tmp
/dev/sda3 60G 364M 58G 1% /tmp
/dev/sda3 60G 4.1G 54G 8% /tmp
/dev/sda3 60G 4.2G 54G 8% /tmp
/dev/sda3 60G 4.3G 54G 8% /tmp
```
