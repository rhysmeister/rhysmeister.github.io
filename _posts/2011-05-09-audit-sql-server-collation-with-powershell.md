---
layout: post
title: Audit SQL Server collation with Powershell
date: 2011-05-09 21:48:56.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
tags: []
meta:
  tweetbackscheck: '1613407760'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/audit-sql-server-collation-with-powershell/1086";s:7:"tinyurl";s:26:"http://tinyurl.com/69athmt";s:4:"isgd";s:19:"http://is.gd/bIODWY";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/audit-sql-server-collation-with-powershell/1086/"
---
Here's just a quick Powershell script I knocked up to find out the server-level and database [collations](http://msdn.microsoft.com/en-us/library/ms144260.aspx) on multiple servers. Just specify each SQL Server in the array called **$servers** and you're good to go.

```
# Load SMO
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;
# Specify servers here
$servers = @("localhost\sqlexpress", "localhost");

foreach($server in $servers)
{
	# Create a SMO server object
	$srv = New-Object Microsoft.SqlServer.Management.SMO.Server $server;
	# Server collation
	Write-Host $server "- Server Collation: " $srv.Collation;
	Write-Host "==========================================================";
	$databases = $srv.Databases;
	# Check the collation of each database
	foreach($db in $databases)
	{
		Write-Host $db.Name "-" $db.Collation;
	}
	Write-Host "";
}
```

The script will produce output similar to below;

```
localhost\sqlexpress - Server Collation: Latin1_General_CI_AS
==========================================================
AdventureWorks - Latin1_General_CI_AS
AdventureWorksDW - Latin1_General_CI_AS
AdventureWorksDW2008 - Latin1_General_CI_AS
AdventureWorksLT - Latin1_General_CI_AS
AdventureWorksLT2008 - Latin1_General_CI_AS

localhost - Server Collation: Latin1_General_CI_AS
==========================================================
ft_test - Latin1_General_CI_AS
master - Latin1_General_CI_AS
model - Latin1_General_CI_AS
```
