---
layout: post
title: Schedule a Windows server reboot
date: 2010-11-11 20:25:34.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
tags: []
meta:
  tweetbackscheck: '1612971407'
  shorturls: a:4:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/schedule-a-windows-server-reboot/905";s:7:"tinyurl";s:26:"http://tinyurl.com/238d9se";s:4:"isgd";s:18:"http://is.gd/gWJSH";s:5:"bitly";s:20:"http://bit.ly/aRm8Bm";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/schedule-a-windows-server-reboot/905/"
---
Just a quick one today as I’m always forgetting how to do this! I occasionally have to schedule server reboots to happen in the middle of the night. This is easily achieved by using the [AT command](http://support.microsoft.com/kb/313565) in a command prompt window. The following example will schedule a server reboot for 3AM as a one-off job.

```
AT 03:00 shutdown /r
```

If all goes well you should get a message back like “Added a new job with Job ID = 1.” If you get an “access is denied” error then you need to run the console as Administrator. The jobs created this way can be viewed using the [Task Scheduler](http://en.wikipedia.org/wiki/Task_Scheduler "Windows 7 Task Scheduler").

[![task scheduler]({{ site.baseurl }}/assets/2010/11/task_scheduler_thumb.png "task\_scheduler")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/11/task_scheduler.png)

