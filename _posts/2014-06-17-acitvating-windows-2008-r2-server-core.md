---
layout: post
title: Acitvating Windows 2008 R2 Server Core
date: 2014-06-17 22:16:54.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Windows
tags:
- activate
- server core
- windows
meta:
  _edit_last: '1'
  tweetbackscheck: '1613349235'
  shorturls: a:3:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/acitvating-windows-2008-r2-server-core/1903/";s:7:"tinyurl";s:26:"http://tinyurl.com/oml8srg";s:4:"isgd";s:19:"http://is.gd/yH8fRf";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/acitvating-windows-2008-r2-server-core/1903/"
---
From the command-line simply run...

```
start /w slmgr.vbs -ato
```
