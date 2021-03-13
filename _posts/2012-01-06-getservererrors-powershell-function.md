---
layout: post
title: Get-ServerErrors Powershell Function
date: 2012-01-06 16:57:26.000000000 +01:00
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
  tweetbackscheck: '1613478992'
  shorturls: a:3:{s:9:"permalink";s:74:"http://www.youdidwhatwithtsql.com/getservererrors-powershell-function/1431";s:7:"tinyurl";s:26:"http://tinyurl.com/7cw43yt";s:4:"isgd";s:19:"http://is.gd/7ECUtv";}
  _aioseop_description: Windows Powershell function allowing the Event Logs and SQL
    Server Error log be be searched for errors and warnings within the specified number
    of hours.
  _edit_last: '1'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/getservererrors-powershell-function/1431/"
---
Here's a little Powershell function I'm using to check the [Event Logs](http://technet.microsoft.com/en-us/library/cc722404.aspx "Windows Event Logs")&nbsp;and [SQL Server Error Logs](http://sqlserverpedia.com/wiki/SQL_Server_Error_Logs "SQL server Error Logs") in one easy swoop;

```
function Get-ServerErrors
{
	# Server to check & hours back. Will only support default sql instances
	# Could add a third param for instance and modify script where appropriate if needed
	param ($server, [int]$hours);

	[datetime]$after = $(Get-Date).AddHours(-$hours);

	# Windows Event Log (Application & System) Errors & Warnings

	Write-Host "Application Event Log Errors from $server after $after";
	Write-Host "========================================================================";
	Get-EventLog -ComputerName $server -LogName "Application" -EntryType "Error" -After $after | Format-List;
	Write-Host "Press any key to continue or ctrl + c to quit";
	$r = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown");

	Write-Host "System Event Log Errors from $server after $after";
	Write-Host "========================================================================";
	Get-EventLog -ComputerName $server -LogName "System" -EntryType "Error" -After $after | Format-List;
	Write-Host "Press any key to continue or ctrl + c to quit";
	$r = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown");

	Write-Host "Application Event Log Warnings from $server after $after";
	Write-Host "========================================================================";
	Get-EventLog -ComputerName $server -LogName "Application" -EntryType "Warning" -After $after | Format-List;
	Write-Host "Press any key to continue or ctrl + c to quit";
	$r = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown");

	Write-Host "System Event Log Warnings from $server after $after";
	Write-Host "========================================================================";
	Get-EventLog -ComputerName $server -LogName "System" -EntryType "Warning" -After $after | Format-List;
	Write-Host "Press any key to continue or ctrl + c to quit";
	$r = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown");

	# SQL Server Error Log
	[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") ;
	$sql_server = new-object ("Microsoft.SqlServer.Management.Smo.Server") $server;
	$sql_server.ReadErrorLog() | Where-Object {$_.Text -like "Error*" -and $_.LogDate -ge $after};
}
```

Usage is as follows;

```
Get-ServerErrors<server name> <hours back to check>;
</hours></server>
```
