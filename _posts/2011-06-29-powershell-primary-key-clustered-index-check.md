---
layout: post
title: Powershell Primary Key & Clustered Index Check
date: 2011-06-29 11:02:44.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
tags:
- clustered index
- Powershell
- primary key
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  tweetbackscheck: '1613303637'
  shorturls: a:3:{s:9:"permalink";s:83:"http://www.youdidwhatwithtsql.com/powershell-primary-key-clustered-index-check/1272";s:7:"tinyurl";s:26:"http://tinyurl.com/68e8nu8";s:4:"isgd";s:19:"http://is.gd/U9ftBV";}
  _aioseop_keywords: powershell, primary key, clustered index
  _aioseop_title: Check tables for Primary Keys and Clustered Indexes
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershell-primary-key-clustered-index-check/1272/"
---
It's considered a bad practice&nbsp; [Not using Primary Keys and Clustered Indexes](http://www.sqlservercentral.com/articles/Miscellaneous/worstpracticesnotusingprimarykeysandclusteredindex/488/) here's a Powershell script that can make checking a database for this very easy. Just set the **$server** to the sql instance you want to check and **$database** as appropriate.

```
# variables
$server = "sqlinstance";
$database = "badDB";
# Load SMO
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;
# create server objects
$srv = New-Object Microsoft.SqlServer.Management.SMO.Server $server;
# Get the database
$db = $srv.Databases[$database];
# Get the tables
$tables = $db.Tables;
# process each table
foreach($table in $tables) #HasClusteredIndex
{
	# Check indexes for primary key
	$indexes = $table.Indexes;
	$has_pk = $false;
	foreach($idx in $indexes)
	{
		# I this index a PK?
		if($idx.IndexKeyType -eq "DriPrimaryKey")
		{
			$has_pk = $true;
		}
	}
	# Does the table have a clustered index?
	$has_clustered_idx = $table.HasClusteredIndex;
	if($has_pk -eq $false -and $has_clustered_idx -eq $false)
	{
		Write-Host "$table has no PK or clustered index.";
	}
	elseif($has_pk -eq $false)
	{
		Write-Host "$table has no PK.";
	}
	elseif($has_clustered_idx -eq $false)
	{
		Write-Host "$table has no clustered index.";
	}
}
```

The script will output something like below;

```
dbo.table1 has no PK or clustered index.
dbo.table2 has no PK or clustered index.
dbo.table3 has no PK.
dbo.table4 has no PK or clustered index.
dbo.table5 has no PK or clustered index.
dbo.table6 has no clustered index.
```

Hopefully your list isn't too long!

