---
layout: post
title: 'Linux Tip: Output error messages to syslog from cron'
date: 2012-07-05 17:53:44.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- Linux
tags:
- cron
- Linux
- nagios
- syslog
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  _wp_old_slug: linux-tip
  tweetbackscheck: '1613390113'
  shorturls: a:3:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/linux-tip-output-error-messages-syslog-cron/1487";s:7:"tinyurl";s:26:"http://tinyurl.com/cv6g7vn";s:4:"isgd";s:19:"http://is.gd/K3YuMM";}
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/linux-tip-output-error-messages-syslog-cron/1487/"
---
I wanted to find a way of running a script in cron and output the exit code, and error message, to [syslog](http://en.wikipedia.org/wiki/Syslog "syslog") if it failed. Here's what I came up with...

```
output=`/usr/bin/scripts/test.sh 2>&1`; code=$?; if ["$code" -ne 0]; then err_msg=`echo "$output" | tail -1`; logger -t "CRONERROR" "Exit Code = $code: $err_msg"; fi; echo "$output" > /usr/bin/scripts/log/test.log;
```

It's not pretty but it works and makes it easy for me to pick this up with [Nagios](http://www.nagios.org/ "Nagios"). Please note you're probably going to want to use set -e and set -o pipefail in your scripts for this to function correctly. See this great post about [Writing Robust Shell Scripts](http://www.davidpashley.com/articles/writing-robust-shell-scripts.html "Writing Robust Shell Scripts").

**UPDATE:&nbsp;** I've updated this to cope with bash scripts that produce a lot of output. Just the exit code and, hopefully error message, will be logged in /var/log/messages (the error message should be the last line of output). The rest of the script output will be written to a file in&nbsp;/usr/bin/scripts/log/test.log

