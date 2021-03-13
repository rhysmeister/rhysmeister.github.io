---
layout: post
title: Check database auto-shrink setting with Powershell
date: 2011-05-12 10:00:40.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories: []
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613418446'
  shorturls: a:3:{s:9:"permalink";s:83:"http://www.youdidwhatwithtsql.com/check-database-autoshrink-setting-powershell/1089";s:7:"tinyurl";s:26:"http://tinyurl.com/5rawof9";s:4:"isgd";s:19:"http://is.gd/aBFoZN";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-database-autoshrink-setting-powershell/1089/"
---
It's very well known that [auto-shrink is bad](http://blogs.msdn.com/b/sqlserverstorageengine/archive/2007/03/28/turn-auto-shrink-off.aspx "Turn AUTO\_SHRINK off!!") for reasons I won't repeat here. Perhaps you've been meaning to check all your servers and databases but simply haven't got around to it? A simple bit of [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell "Windows Powershell") makes this into a trivial task;

```
# Load SMO
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

# List of sql servers here
$sqlservers = @("server1", "server2", "server3", "server4", "server5", "server6");

foreach($sqlserver in $sqlservers)
{
	$srv = New-Object Microsoft.SqlServer.Management.Smo.Server $sqlserver;
	$databases = $srv.Databases;
	$count = 0;
	foreach($db in $databases)
	{
		if($db.AutoShrink -eq $true)
		{
			Write-Host -ForegroundColor Red "Warning: $db on $sqlserver has auto-shrink enabled.";
			$count++;
		}
	}
	Write-Host "$sqlserver has $count databases set to auto-shrink.";
}
```

The script will output something like below;

```
Warning: [db1] on server1 has auto-shrink enabled.
server1 has 1 databases set to auto-shrink.
server2 has 0 databases set to auto-shrink.
server3 has 0 databases set to auto-shrink.
server4 has 0 databases set to auto-shrink.
server5 has 0 databases set to auto-shrink.
server6 has 0 databases set to auto-shrink.
```
