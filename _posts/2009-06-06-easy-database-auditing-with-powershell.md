---
layout: post
title: Easy Database Auditing with Powershell
date: 2009-06-06 13:48:01.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
- Powershell Scripting
meta:
  tweetbackscheck: '1613415056'
  shorturls: a:7:{s:9:"permalink";s:76:"http://www.youdidwhatwithtsql.com/easy-database-auditing-with-powershell/161";s:7:"tinyurl";s:25:"http://tinyurl.com/kqcvwh";s:4:"isgd";s:18:"http://is.gd/14E75";s:5:"bitly";s:19:"http://bit.ly/to9XM";s:5:"snipr";s:22:"http://snipr.com/kbedh";s:5:"snurl";s:22:"http://snurl.com/kbedh";s:7:"snipurl";s:24:"http://snipurl.com/kbedh";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/easy-database-auditing-with-powershell/161/"
---
I previously posted an article explaining how to [audit your SQL Servers with Powershell](http://www.youdidwhatwithtsql.com/auditing-your-sql-server-with-powershell/133). In this article I wrote [SMO](http://msdn.microsoft.com/en-us/library/ms162169.aspx) properties to csv files. As there are a large number of properties you may be unsure of which ones you may need in the future. Luckily Powershell doesn't make us fetch every single property manually; we can [pipe](http://www.microsoft.com/technet/scriptcenter/topics/winpsh/manual/pipe.mspx) the contents of an object to the [Export-Csv](http://www.microsoft.com/technet/scriptcenter/topics/msh/cmdlets/export-csv.mspx) [cmdlet](http://www.powershellpro.com/powershell-tutorial-introduction/tutorial-powershell-cmdlet/).

```
# Set sql server name
$sqlserver = "localhost\sql2005";
# Load SMO extension
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null;
# Create an SMO Server object
$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver;
# Get DatabaseCOllection from the sql server instance
$databases = $srv.Databases;
# Write all these properties to a csv file
$databases | Export-Csv "$env:USERPROFILE\sqlserverdatabases.csv";
```

This will dump all the properties of **Microsoft.SqlServer.Management.Smo.Database** into **sqlserverdatabases.csv** in the user directory. Some of the properties are collections themselves so you get the Type in the csv sheet rather then the values. But nevertheless a large amount of useful information is provided. I’ve uploaded a [sample file](http://www.youdidwhatwithtsql.com/?attachment_id=160).

I’m itching to build a [CMDB](http://sqlserverpedia.com/wiki/CMDB) using [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) to provide the data in csv files, [SSIS](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) to import it, and [SSRS](http://msdn.microsoft.com/en-us/library/ms159106.aspx) to provide some cool dashboard reports. Before the advent of [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) this task would have been so much more difficult. I’ll certainly be developing my skills in this area as I’m betting on it becoming so important.

