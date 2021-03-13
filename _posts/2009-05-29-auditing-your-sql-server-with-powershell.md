---
layout: post
title: Auditing your SQL Servers with Powershell
date: 2009-05-29 07:44:07.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- DBA
- Powershell
- Powershell Scripting
- SQL Server
meta:
  tweetbackscheck: '1613479288'
  shorturls: a:7:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/auditing-your-sql-server-with-powershell/133";s:7:"tinyurl";s:25:"http://tinyurl.com/mj8v93";s:4:"isgd";s:17:"http://is.gd/Twao";s:5:"bitly";s:19:"http://bit.ly/h2jlj";s:5:"snipr";s:22:"http://snipr.com/jpo0r";s:5:"snurl";s:22:"http://snurl.com/jpo0r";s:7:"snipurl";s:24:"http://snipurl.com/jpo0r";}
  twittercomments: a:4:{s:10:"2632793771";s:7:"retweet";s:10:"2628027173";s:7:"retweet";s:10:"2627435129";s:7:"retweet";s:10:"2627391296";s:7:"retweet";}
  tweetcount: '4'
  _sg_subscribe-to-comments: wapaul82@yahoo.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/auditing-your-sql-server-with-powershell/133/"
---
Being able to know the setup and configuration of your [SQL Servers](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) is important for many IT Professionals. [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx), combined with [SMO](http://msdn.microsoft.com/en-us/library/ms162169.aspx), makes this task easy. [SMO](http://msdn.microsoft.com/en-us/library/ms162169.aspx) exposes a lot of properties allowing you to easily retrieve things like Processor & RAM Information, [Service Pack](http://support.microsoft.com/kb/913089) Level, Operating System information, Collation Settings, number of Databases, and much more. Be sure to explore [SMO](http://msdn.microsoft.com/en-us/library/ms162169.aspx) for your specific needs. [PowerGUI](http://powergui.org), from [Quest Software](http://www.quest.com/), has a nice Intellisense feature that makes exploring object properties easy.

[![Exploring object properties with PowerGUI]({{ site.baseurl }}/assets/2009/05/image-thumb7.png "Exploring object properties with PowerGUI")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/05/image7.png)

Here’s a [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script for documenting your [SQL Servers](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) setup and configuration. There’s a couple of [Powershell variables](http://technet.microsoft.com/en-us/magazine/cc162486.aspx) in the script to configure before you get started;

**$sqlservers –** This points at a text file containing your list of SQL Servers. **$auditDatabases –** If set to **$true** then the script will produce an additional file documenting the databases on each SQL Server. Set to **$false** if you don't want to produce this file.

```
# Get list of SQL servers
$sqlservers = Get-Content "C:\sqlservers.txt";
# Load SMO extension
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null;
# Get the datetime to use for the log filename
$datetime = Get-Date -Format "yyyy-MM-ddThh-mm-ssZ";
$filename = "$datetime.csv";
# If database details should be audited
$auditDatabases = $true;
# Flag used to indicate column headers have been added to the database audit file
$headerAdded = $false;

# Add the column headers to the log file
Add-Content "C:\$filename" "sqlserver,Collation,Edition,EngineEdition,OSVersion,PhysicalMemory,Processors,VersionString,Version,ProductLevel,Product,Platform,loginMode,LinkedServerCount,databaseCount,minConfigMem,clrRunValue,clrConfigValue";

# For each SQL server listed in $sqlservers
foreach($sqlserver in $sqlservers)
{
	Write-Host "Processing sql server: $sqlserver.";
	# Create an instance of SMO.Server for the current sql server
	$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver;

	$collation = $srv.Information.Collation; # Server collation
	$edition = $srv.Information.Edition; # Server edition
	$engineEdition = $srv.Information.EngineEdition; # Engine Edition
	$OSVersion = $srv.Information.OSVersion; # OS Version
	$PhysicalMemory = $srv.Information.PhysicalMemory; # Physical Memory
	$Product = $srv.Information.Product; # Server Product
	$Platform = $srv.Information.Platform; # Server Platform
	$Processors = $srv.Information.Processors; # Processor count
	$VersionString = $srv.Information.VersionString; # Version String
	$Version = $srv.Information.Version; # Version
	$ProductLevel = $srv.Information.ProductLevel; # Product Level

	$loginMode = $srv.Settings.LoginMode; # Login Mode setting
	$linkedServers = $srv.LinkedServers.Count; # Get the number of linked servers
	$databaseCount = $srv.Databases.Count; # Get the number of databases hosted by the sql server
	$minMem = $srv.Configuration.MinServerMemory.ConfigValue;	# Configured minimum memory
	$clrRun = $srv.Configuration.IsSqlClrEnabled.RunValue; # SQLCLR run value
	$clrConfig = $srv.Configuration.IsSqlClrEnabled.ConfigValue;# SQLCLR config value

	# Write the info for the current sql server
	Add-Content "C:\$filename" "$sqlserver,$collation,$edition,$engineEdition,$OSVersion,$PhysicalMemory,$Processors,$VersionString,$Version,$ProductLevel,$Product,$Platform,$loginMode,$linkedServers,$databaseCount,$minMem,$clrRun,$clrConfig";

	# If $auditDatabases is true then log details of databases
	if($auditDatabases)
	{
		$dbFilename = "C:\databases_$filename";
		# Get the databases on the current server
		$databases = $srv.Databases;

		# Check to see if the header has been added
		if($headerAdded -eq $false)
		{
			# Add column headers to the file
			Add-Content $dbFilename "sqlserver,dbName,ActiveConnections,CaseSensitive,Collation,CompatibilityLevel,CreateDate,DefaultSchema,Owner,Size,SpaceAvailable,Status,ProcCount,TableCount,ViewCount,TriggerCount,UDFCount";
			# Set to true so the header isn't added again
			$headerAdded = $true;
		}
		# For each database on the current server
		foreach($database in $databases)
		{
			Write-Host "Processing database: $database.";
			# Get database object properties
			$dbName = $database.Name;
			$ActiveConnections = $database.ActiveConnections;
			$CaseSensitive = $database.CaseSensitive;
			$Collation = $database.Collation;
			$CompatibilityLevel = $database.CompatibilityLevel;
			$CreateDate = $database.CreateDate;
			$DefaultSchema = $database.DefaultSchema;
			$Owner = $database.Owner;
			$Size = $database.Size;
			$SpaceAvailable = $database.SpaceAvailable;
			$Status = ([string]$database.Status) -replace ",", "";
			$ProcCount = $database.StoredProcedures.Count;
			$TableCount = $database.Tables.Count;
			$ViewCount = $database.Views.Count;
			$TriggerCount = $database.Triggers.Count;
			$UDFCount = $database.UserDefinedFunctions.Count;

			# Append line to file for the current database
			Add-Content $dbFilename "$sqlserver,$dbName,$ActiveConnections,$CaseSensitive,$Collation,$CompatibilityLevel,$CreateDate,$DefaultSchema,$Owner,$Size,$SpaceAvailable,$Status,$ProcCount,$TableCount,$ViewCount,$TriggerCount,$UDFCount";
		}
	}

}
```

Run the script and you should see the output similar to below;

Processing sql server: SQLSERVER1.  
  
Processing database: [db1].

Processing database: [db2].

Processing database: [db3].

Processing database: [db4].

Processing database: [db5].

Processing sql server: SQLSERVER2.

Processing database: [db1].

Processing database: [db2].

Processing database: [db3].

Processing database: [db4].

Processing database: [db5].

After running this script you will have two datetime stamped [csv](http://en.wikipedia.org/wiki/Comma-separated_values) files in the root of your **C:\** drive. Below I’ve attached some sample files;

[SQL Server Audit File](http://www.youdidwhatwithtsql.com/?attachment_id=129)

[SQL Server Databases Audit File](http://www.youdidwhatwithtsql.com/?attachment_id=130)

