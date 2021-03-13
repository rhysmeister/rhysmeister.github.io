---
layout: post
title: List Sql Server Processes with Powershell
date: 2011-06-08 17:30:56.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
- SQL Server
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613281677'
  shorturls: a:3:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/list-sql-server-processes-powershell/1098";s:7:"tinyurl";s:26:"http://tinyurl.com/5w3dz7w";s:4:"isgd";s:19:"http://is.gd/KlI1ZD";}
  twittercomments: a:2:{s:17:"78517657632129024";s:7:"retweet";s:17:"78499744317587456";s:7:"retweet";}
  tweetcount: '3'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/list-sql-server-processes-powershell/1098/"
---
I was looking for a way to grab a list of processes running inside Sql Server but [wasn't having much luck](https://twitter.com/#!/rhyscampbell/status/78493373249495040 "Help Twitter!"). Essentially I wanted something like the [Get-Process cmdlet](http://technet.microsoft.com/en-us/library/ee176855.aspx "Get-Process Powershell cmdlet") but for Sql Server. Shortly after tweeting for help I stumbled across the [EnumProcesses](http://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.server.enumprocesses.aspx "EnumProcesses SMO Method") SMO method.

Using this is quite simple. To list all Sql Server processes;

```
# List all sql server processes
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;
$sql_server = New-Object Microsoft.SqlServer.Management.Smo.Server "sqlinstance";
$processes = $sql_server.EnumProcesses();
$processes | Format-Table -AutoSize;
```

To exclude system processes we do;

```
# Exclude system processes
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;
$sql_server = New-Object Microsoft.SqlServer.Management.Smo.Server "sqlinstance";
$processes = $sql_server.EnumProcesses($true);
$processes | Format-Table -AutoSize;
```

I'm starting to think if you say you can't do it in [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell "Windows Powershell") then you haven't looked hard enough!

