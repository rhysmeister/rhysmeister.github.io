---
layout: post
title: The database cannot be recovered because the log was not restored
date: 2014-03-14 16:50:27.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
- T-SQL
tags:
- Backups
- SQL Server
meta:
  _edit_last: '1'
  tweetbackscheck: '1613434532'
  shorturls: a:3:{s:9:"permalink";s:71:"http://www.youdidwhatwithtsql.com/database-recovered-log-restored/1862/";s:7:"tinyurl";s:26:"http://tinyurl.com/njf4ezv";s:4:"isgd";s:19:"http://is.gd/Io3Toh";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: micorreo@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/database-recovered-log-restored/1862/"
---
A test restore of a SQL Server database had somehow been left in the "RESTORING" state. I attempted to bring the database online with

```
RESTORE DATABASE db_name;
```

But I was greeted with...

```
Msg 4333, Level 16, State 1, Line 1
The database cannot be recovered because the log was not restored.
Msg 3013, Level 16, State 1, Line 1
RESTORE DATABASE is terminating abnormally.
```

To fix you need to drop and restore the database again...

```
DROP DATABASE db_name;

USE [master]
GO
-- Create db again...
CREATE DATABASE [db_name];
-- restore over with usual backup scripts...
```
