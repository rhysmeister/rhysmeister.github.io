---
layout: post
title: Counting objects between databases
date: 2011-06-14 22:10:35.000000000 +02:00
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
  tweetbackscheck: '1613265883'
  shorturls: a:3:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/counting-objects-between-databases/1100";s:7:"tinyurl";s:26:"http://tinyurl.com/6ezdua3";s:4:"isgd";s:19:"http://is.gd/oypCJg";}
  twittercomments: a:2:{s:17:"81381118041001984";s:7:"retweet";s:17:"81368361962967040";s:7:"retweet";}
  tweetcount: '3'
  _sg_subscribe-to-comments: aaron.bertrand@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/counting-objects-between-databases/1100/"
---
I've been looking at using [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell "Windows Powershell") in our release process to automate various things. I've used it to [compare table data between databases](http://www.youdidwhatwithtsql.com/the-poor-mans-data-compare-with-powershell/1096 "Compare table data") and I'm now thinking of using it to validate our schema upgrades. I want to be easily alerted to any missing tables, columns, stored procedures and other objects.

We have [TFS](http://en.wikipedia.org/wiki/Team_Foundation_Server "Team Foundation Server") at work so I could use this to perform schema checks but I find this rather cumbersome and it doesn't lend itself to automation. I want to be able to run a script and have it alert me to any potential problems that need dealing with.

I've written a quick script to count the number of objects between two different databases. Just change the **$server** and **$server2** variable to the SQL Server instances, and **$database1** and **$database2** to the databases to compare.

```
# Databases we want to compare
$server1 = "localhost\sqlexpress";
$database1 = "AdventureWorks";
$server2 = "localhost\sqlexpress";
$database2 = "AdventureWorks";

# Load SMO
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

# Create sql server objects for source and destination servers
$srv1 = New-Object Microsoft.SqlServer.Management.SMO.Server $server1;
$srv2 = New-Object Microsoft.SqlServer.Management.SMO.Server $server2;

# IsSystemObject not returned by default so ask SMO for it
$srv1.SetDefaultInitFields([Microsoft.SqlServer.Management.SMO.Table], "IsSystemObject");
$srv1.SetDefaultInitFields([Microsoft.SqlServer.Management.SMO.View], "IsSystemObject");
$srv1.SetDefaultInitFields([Microsoft.SqlServer.Management.SMO.StoredProcedure], "IsSystemObject");
$srv1.SetDefaultInitFields([Microsoft.SqlServer.Management.SMO.Trigger], "IsSystemObject");
$srv1.SetDefaultInitFields([Microsoft.SqlServer.Management.SMO.UserDefinedFunction], "IsSystemObject");
$srv2.SetDefaultInitFields([Microsoft.SqlServer.Management.SMO.Table], "IsSystemObject");
$srv2.SetDefaultInitFields([Microsoft.SqlServer.Management.SMO.View], "IsSystemObject");
$srv2.SetDefaultInitFields([Microsoft.SqlServer.Management.SMO.StoredProcedure], "IsSystemObject");
$srv2.SetDefaultInitFields([Microsoft.SqlServer.Management.SMO.Trigger], "IsSystemObject");
$srv2.SetDefaultInitFields([Microsoft.SqlServer.Management.SMO.UserDefinedFunction], "IsSystemObject");

# get databases
$db1 = $srv1.Databases[$database1];
$db2 = $srv2.Databases[$database2];

# Get table count
$db1_tables = $($db1.Tables | Where-Object {$_.IsSystemObject -eq $false}).Count;
$db2_tables = $($db2.Tables | Where-Object {$_.IsSystemObject -eq $false}).Count;

# count indexes on tables
foreach($table in $db1.Tables)
{
                $db1_indexes += $table.Indexes.Count;
}

foreach($table in $db2.Tables)
{
                $db2_indexes += $table.Indexes.Count;
}

# count triggers on tables
foreach($table in $db1.Tables)
{
                $db1_triggers += $table.Triggers.Count;
}

foreach($table in $db2.Tables)
{
                $db2_triggers += $table.Triggers.Count;
}

# Count views
$db1_views = $($db1.Views | Where-Object {$_.IsSystemObject -eq $false}).Count;
$db2_views = $($db2.Views | Where-Object {$_.IsSystemObject -eq $false}).Count;

# Count procs
$db1_procs = $($db1.StoredProcedures | Where-Object {$_.IsSystemObject -eq $false}).Count;
$db2_procs = $($db2.StoredProcedures | Where-Object {$_.IsSystemObject -eq $false}).Count;

# Count udfs
$db1_udfs = $($db1.UserDefinedFunctions | Where-Object {$_.IsSystemObject -eq $false}).Count;
$db2_udfs = $($db2.UserDefinedFunctions | Where-Object {$_.IsSystemObject -eq $false}).Count;

# Set nulls to zero
if($db1_tables -eq $null)
{
	$db1_tables = 0;
}
if($db2_tables -eq $null)
{
	$db2_tables = 0;
}
if($db1_indexes -eq $null)
{
	$db1_indexes = 0;
}
if($db2_indexes -eq $null)
{
	$db2_indexes = 0;
}
if($db1_triggers -eq $null)
{
	$db1_triggers = 0;
}
if($db2_triggers -eq $null)
{
	$db2_triggers = 0;
}
if($db1_views -eq $null)
{
	$db1_views = 0;
}
if($db2_views -eq $null)
{
	$db2_views = 0;
}
if($db1_procs -eq $null)
{
	$db1_procs = 0;
}
if($db2_procs -eq $null)
{
	$db2_procs = 0;
}
if($db1_udfs -eq $null)
{
	$db1_udfs = 0;
}
if($db2_udfs -eq $null)
{
	$db2_udfs = 0;
}

# Output results
Write-Host "Object`t`t`tdb1`t`t`tdb2"
Write-Host "Tables`t`t`t$db1_tables`t`t`t$db2_tables";
Write-Host "Indexes`t`t`t$db1_indexes`t`t`t$db2_indexes";
Write-Host "Triggers`t`t`t$db1_triggers`t`t`t$db2_triggers";
Write-Host "Views`t`t`t$db1_views`t`t`t$db2_views";
Write-Host "Procs`t`t`t$db1_procs`t`t`t$db2_procs";
Write-Host "UDFs`t`t`t`t$db1_udfs`t`t`t$db2_udfs";
```

Here's what the script outputs when executed against a copy of the [Adventureworks](http://msftdbprodsamples.codeplex.com/ "AdventureWorks sample database") database;

```
Object db1 db2
Tables 70 70
Indexes 323 323
Triggers 11 11
Views 17 17
Procs 9 9
UDFs 11 11
```

This script is really just [POC](http://en.wikipedia.org/wiki/Proof_of_concept "Proof of Concept"). Just because we have the same number of objects does not necessarily mean we have the correct ones across environments. To be of more practical value I need to be checking object names and definitions. Watch this space!

