---
layout: post
title: Check Mirroring Status with Powershell
date: 2012-01-31 12:21:23.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
tags:
- DBA
- mirroring
- Powershell
- SQL Server
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/check-mirroring-status-powershell/1436";s:7:"tinyurl";s:26:"http://tinyurl.com/7dglpsu";s:4:"isgd";s:19:"http://is.gd/PfyGFY";}
  tweetbackscheck: '1613431429'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-mirroring-status-powershell/1436/"
---
<p>Here's a simple <a title="Windows Powershell" href="http://technet.microsoft.com/en-us/scriptcenter/dd742419" target="_blank">Powershell</a> snippet to check the <a title="SQL Server Mirroring Status" href="http://msdn.microsoft.com/en-us/library/ms365781.aspx" target="_blank">mirroring status</a> on your SQL Server instances.</p>
<pre lang="Powershell"># Load SMO extension
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

# Servers to check
$sqlservers = @("server1", "server2", "server3");
foreach($server in $sqlservers)
{
	$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $server;
	# Get mirrored databases
	$databases = $srv.Databases | Where-Object {$_.IsMirroringEnabled -eq $true};
	Write-Host $server;
	Write-Host "==================================";
	$databases | Select-Object -Property Name, MirroringStatus | Format-Table -AutoSize;
}</pre>
<p>This will output something looking like below...</p>
<pre>server1
====================================

Name                 MirroringStatus
----                 ---------------
db1         		Synchronized
db2                    	Synchronized
db3              	Synchronized
db4			Synchronized
db5    			Synchronized
server2
=====================================

Name                 MirroringStatus
----                 ---------------
db1         		Synchronized
db2                    	Synchronized
db3              	Synchronized
db4			Synchronized
db5    			Synchronized
server3
=====================================

Name                 MirroringStatus
----                 ---------------
db1 Synchronized db2 Synchronized db3 Synchronized db4 Synchronized db5 Synchronized

