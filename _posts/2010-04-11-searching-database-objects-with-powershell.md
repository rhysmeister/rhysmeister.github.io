---
layout: post
title: Searching database objects with Powershell
date: 2010-04-11 15:50:51.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
tags:
- Powershell
meta:
  tweetbackscheck: '1613358599'
  shorturls: a:4:{s:9:"permalink";s:80:"http://www.youdidwhatwithtsql.com/searching-database-objects-with-powershell/722";s:7:"tinyurl";s:26:"http://tinyurl.com/yd5msxz";s:5:"bitly";s:20:"http://bit.ly/aCg6Kk";s:4:"isgd";s:18:"http://is.gd/borio";}
  twittercomments: a:4:{s:11:"12011721388";s:3:"150";s:11:"12011530250";s:3:"151";s:11:"12010501962";s:3:"152";s:11:"12013263222";s:7:"retweet";}
  tweetcount: '4'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/searching-database-objects-with-powershell/722/"
---
Sometimes it's useful to get a quick overview of what objects are referencing a particular table, view or function. This may arise when we think we may need to drop an object but want to double-check if anything in the database is still referencing it. Here's a quick solution in the form of a [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script. To get started you just need to modify the values for a few variables before executing the script.

- **$server -** The [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) instance you wish to search against. 
- **$database -** The database you wish to search. 
- **$matchText -** The text you wish to search for in the objects. 

This script will search the all of the stored procedures, functions, views and triggers for the text specified in $matchText.

```
$server = "RHYS-PC\SQL2005";
$database = "AdventureWorks";
$matchText = "Person";

# Load the SQL Management Objects assembly (Pipe out-null suppresses output)
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null

# Create our SMO objects
$srv = New-Object "Microsoft.SqlServer.Management.SMO.Server" $server;
$db = New-Object ("Microsoft.SqlServer.Management.SMO.Database");

# Get the database
$db = $srv.Databases[$database];

# For each stored procedure in the database
foreach($proc in $db.StoredProcedures)
{
	# For each matching stored procedure
	if($proc.TextBody -match $matchText)
	{
		Write-Host "Procedure: " $proc.Name " contains $matchText";
	}
}

# For each function in the database
foreach($func in $db.UserDefinedFunctions)
{
	# For each matching user defined function
	if($func.TextBody -match $matchText)
	{
		Write-Host "Function: " $func.Name " contains $matchText";
	}
}

# For each view in the database
foreach($view in $db.Views)
{
	# For each matching view
	if($view.TextBody -match $matchText)
	{
		Write-Host "View: " $view.Name " contains $matchText";
	}
}

# For each trigger in the database
foreach($trigger in $db.Triggers)
{
	# For each matching trigger
	if($trigger.TextBody -match $matchText)
	{
		Write-Host "Trigger: " $trigger.Name " contains $matchText";
	}
}
```

Here' an example of the output when run against the [AdventureWorks](http://msdn.microsoft.com/en-us/library/ms124501.aspx) database searching objects for "Person".

[![searching database objects for text]({{ site.baseurl }}/assets/2010/04/searching_database_objects_for_text_thumb.png "searching database objects for text")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/searching_database_objects_for_text.png)

