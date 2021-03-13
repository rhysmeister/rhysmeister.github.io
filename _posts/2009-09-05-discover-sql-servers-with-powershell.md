---
layout: post
title: Discover SQL Servers with Powershell
date: 2009-09-05 17:21:42.000000000 +02:00
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
- SQL Server
meta:
  shorturls: a:4:{s:9:"permalink";s:74:"http://www.youdidwhatwithtsql.com/discover-sql-servers-with-powershell/357";s:7:"tinyurl";s:25:"http://tinyurl.com/n3lp5q";s:4:"isgd";s:18:"http://is.gd/2Vjm5";s:5:"bitly";s:20:"http://bit.ly/2ASHdQ";}
  tweetbackscheck: '1613388411'
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: server.middleware@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/discover-sql-servers-with-powershell/357/"
---
With [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) and [SMO](http://msdn.microsoft.com/en-us/library/ms162169.aspx) you can easily discover [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) instances running on your network in just a few lines of code.

```
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;
$smoObj = [Microsoft.SqlServer.Management.Smo.SmoApplication];

# This gets the sql servers available
$sql = $smoObj::EnumAvailableSqlServers($false)

foreach($sqlserver in $sql)
{
	Write-Host -ForegroundColor Green "Discovered sql server: " $sqlserver.Name;
}
```

[![discover sql servers with powershell]({{ site.baseurl }}/assets/2009/09/discover_sql_servers_with_powershell_thumb.png "discover sql servers with powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/discover_sql_servers_with_powershell.png)

If this doesn’t seem to find all your sql servers check firewalls and the [SQL Server Browser Service](http://msdn.microsoft.com/en-us/library/ms181087.aspx) is running.

