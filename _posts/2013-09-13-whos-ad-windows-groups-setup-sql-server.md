---
layout: post
title: Who's in those AD Windows Groups setup on SQL Server?
date: 2013-09-13 15:27:28.000000000 +02:00
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
  tweetbackscheck: '1613461771'
  shorturls: a:3:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/whos-ad-windows-groups-setup-sql-server/1669/";s:7:"tinyurl";s:26:"http://tinyurl.com/pymhnjd";s:4:"isgd";s:19:"http://is.gd/ymAUkZ";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/whos-ad-windows-groups-setup-sql-server/1669/"
---
I wanted to be able to check which windows users had been placed in the [Windows AD Groups](http://technet.microsoft.com/en-us/library/bb727067.aspx#EFAA "Windows AD Groups") we use to control access to SQL Server. Here's what I came up with to make checking this easy;

```
Import-Module SQLPS -DisableNameChecking -ErrorAction Ignore;
Import-Module ActiveDirectory -DisableNameChecking -ErrorAction Ignore;

$sql_server = "sql_instance";
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server $sql_server;

$groups = $srv.Logins | Where-Object {$_.LoginType -eq "WindowsGroup";};

foreach($group in $groups)
{
	# Can't find an appropriate property with just the name, anyone know?
	$name = $group.Name;
	# Extract name
	$name = $name.SubString($name.IndexOf("`\") + 1);
	if($name -ne "MSSQLSERVER" -and $name -ne "SQLSERVERAGENT")
	{
		$name;
		Write-Host "==============================";
		Get-ADGroupMember -Identity $name | Select-Object Name;
		Write-Host "==============================`n";
	}
}
```

Output will look something like below;

```
Group1
==============================
User 1
User 2
User 3
User 4
==============================

Group2
==============================
User 1
User 2
User 3
==============================
```
