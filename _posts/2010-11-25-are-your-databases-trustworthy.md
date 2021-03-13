---
layout: post
title: Are your databases Trustworthy?
date: 2010-11-25 20:09:40.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
- SQL Server
tags: []
meta:
  tweetbackscheck: '1613274610'
  shorturls: a:4:{s:9:"permalink";s:68:"http://www.youdidwhatwithtsql.com/are-your-databases-trustworthy/908";s:7:"tinyurl";s:26:"http://tinyurl.com/2wonsyl";s:4:"isgd";s:18:"http://is.gd/hMF8r";s:5:"bitly";s:20:"http://bit.ly/hR3q5Q";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/are-your-databases-trustworthy/908/"
---
Recently I needed to check which of our databases, on our many SQL Servers, had the [TRUSTWORTHY](http://technet.microsoft.com/en-us/library/ms187861.aspx "SQL Server CLR TRUSTWORTHY Database Property") property set to true. This property, when set to false, can reduce certain threats from malicious assemblies or modules. Obviously this should only be enabled where it needs to be. Here’s a quick [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell) script that will enable you to check all your servers quickly.

```
# Set sql servers to audit
$sqlservers = ("server1", "server2", "server3");

# Load smo
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

foreach($server in $sqlservers)
{
	# Create a sql server object
	$srv = New-Object Microsoft.SqlServer.Management.SMO.Server $server;
	# Create db object
	$dbObj = New-Object Microsoft.SqlServer.Management.SMO.Database;
	Write-Host $server;
	Write-Host "======================";
	# Get databases
	$dbObj = $srv.Databases;
	foreach($database in $dbObj)
	{
		# Check if the TRUSTWORTHY option is set to true
		if($database.Trustworthy -eq $true)
		{
			Write-Host "$database is trustworthy.";
		}
		else
		{
			Write-Host "$database is not trustworthy.";
		}
	}
}
```

The output will look something like below.

```
server1
======================
db1 is not Trustworthy.
db2 is Trustworthy.
db3 is Trustworthy.
db4 is not Trustworthy.
db5 is not Trustworthy.
server2
======================
db1 is not Trustworthy.
db2 is not Trustworthy.
db3 is not Trustworthy.
db4 is Trustworthy.
db5 is Trustworthy.
```

Here's how you can check the same thing with TSQL on individual servers.

```
SELECT dtb.[name] AS [database],
	CASE(dtb.is_trustworthy_on)
		WHEN 0 THEN 'False'
		WHEN 1 THEN 'True'
	END AS [Trustworthy]
FROM master.sys.databases AS dtb;
```
