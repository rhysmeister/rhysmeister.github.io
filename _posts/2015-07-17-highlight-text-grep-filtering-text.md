---
layout: post
title: Highlight text using Grep without filtering text out
date: 2015-07-17 09:14:59.000000000 +02:00
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
  _edit_last: '1'
  tweetbackscheck: '1613478899'
  shorturls: a:3:{s:9:"permalink";s:74:"http://www.youdidwhatwithtsql.com/highlight-text-grep-filtering-text/2117/";s:7:"tinyurl";s:26:"http://tinyurl.com/oaa7unp";s:4:"isgd";s:19:"http://is.gd/vElz8k";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/highlight-text-grep-filtering-text/2117/"
---
Here's a neat little trick I learned today I thought was worth sharing. Sometimes I want to highlight text in a terminal screen using [grep](http://unixhelp.ed.ac.uk/CGI/man-cgi?grep) but without filtering other lines out. Here's how you do it...

```
mysqlbinlog mysql-bin.000473 | grep --color -E '^|not closed';
```

The important part is the [regexp](http://www.regular-expressions.info/) in grep. The first section matches any line, but doesn't colour it, the section after the pipe is the text you want to highlight. Output will look something like below.

[![binlog_not_closed_properly]({{ site.baseurl }}/assets/2015/07/binlog_not_closed_properly.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2015/07/binlog_not_closed_properly.png)

