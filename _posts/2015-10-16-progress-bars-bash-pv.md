---
layout: post
title: Progress bars in BASH with pv
date: 2015-10-16 15:50:20.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- Linux
tags: []
meta:
  tweetcount: '0'
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:61:"http://www.youdidwhatwithtsql.com/progress-bars-bash-pv/2156/";s:7:"tinyurl";s:26:"http://tinyurl.com/pksmkyl";s:4:"isgd";s:19:"http://is.gd/HqTTDW";}
  tweetbackscheck: '1613251607'
  twittercomments: a:0:{}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/progress-bars-bash-pv/2156/"
---
Way back in 2009 I wrote a post about how to [display progress bars in Powershell](http://www.youdidwhatwithtsql.com/using-progress-bars-within-the-powershell-console/366/). The same thing is possible in bash with [pv](http://linux.die.net/man/1/pv). If it's not available in your shell just do...

```
yum install pv
```

Or equivalent for your platform. The following example compresses a file into a tar archive reporting progress with a bar...

```
tar cf - mongodb-linux-x86_64-2.6.10.tgz | pv -s 116654065 | gzip -9 > rhys.tar.gz
```

Breaking this down...

```
tar cf - "file to compress" | pv -s "size of file to compress (bytes)" | gzip -9 > "gz archive to create"
```

This will show a progress bar looking something like...

```
111MiB 0:00:05 [20.7MiB/s] [==================================================================================================>] 100%
```

You can display integer numbers for percentage progress in you prefer. Just do...

```
tar cf - mongodb-linux-x86_64-2.6.10.tgz | pv -s 116654065 -n | gzip -9 > rhys.tar.gz
```

Output...

```
17
36
53
71
89
100
```
