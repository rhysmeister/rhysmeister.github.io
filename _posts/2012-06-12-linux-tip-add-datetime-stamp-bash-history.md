---
layout: post
title: 'Linux Tip: Add datetime stamp to bash history'
date: 2012-06-12 11:27:21.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- Linux
tags:
- bash history
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:80:"http://www.youdidwhatwithtsql.com/linux-tip-add-datetime-stamp-bash-history/1483";s:7:"tinyurl";s:26:"http://tinyurl.com/bm76ch3";s:4:"isgd";s:19:"http://is.gd/245gfQ";}
  tweetbackscheck: '1613396436'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/linux-tip-add-datetime-stamp-bash-history/1483/"
---
I like to know what's happening on my Linux servers. The output of the [history command](http://www.cyberciti.biz/faq/linux-and-unix-view-command-line-history/ "Linux history command") doesn't include a datetime stamp by default.&nbsp; To rectify this open the global profile....

```
vi /etc/profile
```

Add the following line to the bottom.

```
export HISTTIMEFORMAT="%h %d %H:%M:%S "
```

The output of the history command will now look something like...

```
997 Jun 12 11:01:55 exit
  998 Jun 12 11:01:55 df -h
  999 Jun 07 18:02:28 history
 1000 Jun 07 18:02:37 exit
 1001 Jun 12 11:01:58 history
 1002 Jun 12 11:03:40 df -h
 1003 Jun 12 11:03:46 history
```

All current entries will be defaulted to the current timestamp so it will take a little time for the output to be valid. Tested on OpenSuSE 11.2 but should be valid for many other distributions.

