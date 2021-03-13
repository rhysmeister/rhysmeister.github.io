---
layout: post
title: The APP_NAME TSQL Function
date: 2011-07-18 12:15:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- APP_NAME
- Application Name
- TSQL
meta:
  tweetbackscheck: '1612953120'
  shorturls: a:3:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/the-app_name-tsql-function/1277";s:7:"tinyurl";s:26:"http://tinyurl.com/5uyge8v";s:4:"isgd";s:19:"http://is.gd/ZuFqYG";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/the-app_name-tsql-function/1277/"
---
The [APP\_NAME](http://msdn.microsoft.com/en-us/library/ms189770.aspx) function returns the name of the application for the current database connection if the application has set it. Run the following in [SSMS](http://msdn.microsoft.com/en-us/library/ms174173.aspx "SQL Server Management Studio");

```
SELECT APP_NAME();
```

This will return;

```
Microsoft SQL Server Management Studio - Query
```

There's no method of setting this value within TSQL. To set this value you need to include an [Application Name parameter](http://www.connectionstrings.com/Articles/Show/use-application-name-sql-server "Application Name in a connection string") in your connection string. For example;

```
Data Source=myServerAddress;Initial Catalog=myDataBase;User Id=myUsername;Password=myPassword;Application Name=MyAppName;
```
