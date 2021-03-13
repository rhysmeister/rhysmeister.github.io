---
layout: post
title: Quickly audit the edition of multiple SQL Servers
date: 2011-04-28 15:41:25.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1612945851'
  shorturls: a:3:{s:9:"permalink";s:41:"http://www.youdidwhatwithtsql.com/?p=1075";s:7:"tinyurl";s:26:"http://tinyurl.com/5tqklar";s:4:"isgd";s:19:"http://is.gd/CKLMBH";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/quickly-audit-edition-multiple-sql-servers/1075/"
---
Today I needed to quickly audit the edition of all our active SQL Server machines. This is a snap with a little bit of [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell "Windows Powershell"). Just execute the below code, replacing the names of each sql instance as appropriate.

```
$sqlservers = @("sqlserver1", "sqlserver2", "sqlserver3", "sqlserver4", "sqlserver5", "sqlserver6", "sqlserver7");
# Load smo
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;
# iterate through each sql server
foreach($server in $sqlservers)
{
	$srv = New-Object Microsoft.SqlServer.Management.SMO.Server $server;
	Write-Host $server "`t`t" $srv.Version $srv.Edition;
}
```

This will display something looking like below;

```
sqlserver1 9.0.4035 Standard Edition
sqlserver2 9.0.4035 Developer Edition (64-bit)
sqlserver3 9.0.4035 Developer Edition (64-bit)
sqlserver4 10.0.4000 Standard Edition
sqlserver5 9.0.4035 Standard Edition (64-bit)
sqlserver6 9.0.4035 Standard Edition (64-bit)
sqlserver7 10.0.1600 Developer Edition (64-bit)
```
