---
layout: post
title: Check a html page with check_http
date: 2014-09-29 12:25:40.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Nagios
tags:
- check_http
- monitoring
- nagios
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/check-html-page-checkhttp/1989/";s:7:"tinyurl";s:26:"http://tinyurl.com/qzgewoo";s:4:"isgd";s:19:"http://is.gd/mDvVEU";}
  tweetbackscheck: '1613414927'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-html-page-checkhttp/1989/"
---
With the [check\_http](http://nagios-plugins.org/doc/man/check_http.html "check\_http Nagios plugin")&nbsp;[Nagios](http://www.nagios.org "Nagios Systems Monitoring") plugin we can check that a url returns an OK status code as well as verifying the page contains a certain string of text. The usage format is a s follows...

```
/usr/local/nagios/libexec/check_http -H hostname -r search_string
```

For example...

```
/usr/local/nagios/libexec/check_http -H www.youdidwhatwithtsql.com -r "wordpress"
```

If you want to make the check case-insensitive then change to...

```
/usr/local/nagios/libexec/check_http -H www.youdidwhatwithtsql.com -R "wordpress"
```

Happy monitoring!

