---
layout: post
title: Altering Database Objects with Powershell
date: 2009-05-23 20:54:24.000000000 +02:00
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
meta:
  tweetbackscheck: '1613479436'
  shorturls: a:7:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/altering-database-objects-with-powershell/119";s:7:"tinyurl";s:25:"http://tinyurl.com/qb3t4r";s:4:"isgd";s:17:"http://is.gd/Qgdp";s:5:"bitly";s:19:"http://bit.ly/Xz9ci";s:5:"snipr";s:22:"http://snipr.com/jkfzf";s:5:"snurl";s:22:"http://snurl.com/jkfzf";s:7:"snipurl";s:24:"http://snipurl.com/jkfzf";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: oltpdba@zoho.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/altering-database-objects-with-powershell/119/"
---
Sometimes it’s necessary to rename tables and databases and this can create a lot of work if it’s referenced by other database objects. I recently came across this situation at work. Developers had introduced a second database into the system and each referenced the other. This didn't sit well with our testing environment that had multiple copies of customer databases. Here’s a [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) Script I wrote to make the process easy.

This script will search for database objects containing the text mentioned in **$matchText**. When a match is found it generates a backup of the object definition and a then a change script. The script will alter the definition by replacing **$matchText** with **$replaceText**. Please be aware that the **match** switch accepts a [regular expression](http://www.regular-expressions.info ) so some characters have a special meaning. If **$alter** is set to true the script will attempt to alter the database object on the live server. The script can be pointed at any database by setting **$server** and **$database**. Before running ensure you have the directory paths mentioned in **$backupFolder** and **$changeFolder**. These need to contain folders called; ‘procs’, ‘views’, ‘functions’ and ‘triggers'.

In this example I’ll be using a copy of the [AdventureWorks](http://codeplex.com/SqlServerSamples) sample database. Let’s assume for some reason that the **Person.Address** table gets renamed to **Person.Address2**. Create this new table in the [AdventureWorks](http://codeplex.com/SqlServerSamples) database.

```
CREATE TABLE [Person].[Address2](
	[AddressID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AddressLine1] [nvarchar](60) COLLATE Latin1_General_CS_AS NOT NULL,
	[AddressLine2] [nvarchar](60) COLLATE Latin1_General_CS_AS NULL,
	[City] [nvarchar](30) COLLATE Latin1_General_CS_AS NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[PostalCode] [nvarchar](15) COLLATE Latin1_General_CS_AS NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL NOT NULL CONSTRAINT [DF_Address_rowguid2] DEFAULT (newid()),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Address_ModifiedDate2] DEFAULT (getdate()),
 CONSTRAINT [PK_Address_AddressID2] PRIMARY KEY CLUSTERED
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
```

Then run the [Powershel](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx)l code below with appropriate changes to suit your environment. This script will process any stored procedures, views, functions or triggers containing references to **Person.Address**.

```
$server = "localhost\sql2005"; # The SQL Server instance name
$database = "AdventureWorks"; # The database name
$matchText = "\[Person\].\[Address\]"; # Definition text to search .Be aware this accepts a regular expression
$replaceText = "[Person].[Address2]"; # Text to replace $matchText
$alter = $false; # Set to true if you want the script to alter database objects
$backupFolder = "E:\powershell\backup\"; # Change script folders. Need a \ (back slash) on the end
$changeFolder = "E:\powershell\change\" # One file per object, backup & change folders

# Load the SQL Management Objects assembly (Pipe out-null supresses output)
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null

# Create our SMO objects
$srv = New-Object "Microsoft.SqlServer.Management.SMO.Server" $server;
$db = New-Object ("Microsoft.SqlServer.Management.SMO.Database");

# Get the database
$db = $srv.Databases[$database];

# For each stored procedure in the database
foreach($proc in $db.StoredProcedures)
{
	# For each matching stored prcoedure
	if($proc.TextBody -match $matchText)
	{
		Write-Host "Processing proc: " $proc.Name;
		# Backup of the original proc definition
		$proc.Script() | Out-File ($backupFolder + "procs\" + ([string]$srv.name -replace("\\", "_")) + "_" + [string]$db.Name + "_" + [string]$proc.name + "_backup.sql");
		# New procedure definition sql
		$proc.Script() -replace($matchtext, $replaceText) | Out-File ($changeFolder + "procs\" + ([string]$srv.name -replace("\\", "_")) + "_" + [string]$db.Name + "_" + [string]$proc.name + ".sql");
		# If set to true this will change the procedure definition on the server!
		if($alter)
		{
			$proc.TextBody = $proc.TextBody -replace($matchtext, $replaceText);
			$proc.Alter();
			Write-Host "Altered " $proc.Name;
		}
	}
}

# For each view in the database
foreach($view in $db.Views)
{
	# For each matching view
	if($view.TextBody -match $matchText)
	{
		Write-Host "Processing view: " $view.Name;
		# backup the original view definition
		$view.Script() | Out-File ($backupFolder + "views\" + ([string]$srv.name -replace("\\", "_")) + "_" + [string]$db.Name + "_" + [string]$view.name + "_backup.sql");
		# New procedure definition sql
		$view.Script() -replace($matchtext, $replaceText) | Out-File ($changeFolder + "views\" + ([string]$srv.name -replace("\\", "_")) + "_" + [string]$db.Name + "_" + [string]$view.name + ".sql");
		# If set to true this will change the view definition on the server!
		if($alter)
		{
			$view.TextBody = $view.TextBody -replace($matchtext, $replaceText);
			$view.Alter();
			Write-Host "Altered " $view.Name;
		}
	}
}

# For each trigger in the database
foreach($trigger in $db.Triggers)
{
	# for each matching trigger
	if($trigger.TextBody -match $matchText)
	{
		Write-Host "Processing trigger: " $trigger.Name;
		# backup the original trigger definition
		$trigger.Script() | Out-File ($backupFolder + "triggers\" + ([string]$srv.name -replace("\\", "_")) + "_" + [string]$db.Name + "_" + [string]$trigger.name + "_backup.sql");
		# New trigger definition sql
		$trigger.Script() -replace($matchtext, $replaceText) | Out-File ($changeFolder + "triggers\" + ([string]$srv.name -replace("\\", "_")) + "_" + [string]$db.Name + "_" + [string]$trigger.name + ".sql");
		# If set to true this will change the trigger definition on the server!
		if($alter)
		{
			$trigger.TextBody = $trigger.TextBody -replace($matchtext, $replaceText);
			$trigger.Alter();
			Write-Host "Altered " $trigger.Name;
		}
	}
}

# For each UDF in the database
foreach($udf in $db.UserDefinedFunctions)
{
	# for each matching udf
	if($udf.TextBody -match $matchText)
	{
		Write-Host "Processing UDF: " $udf.Name;
		# backup the original udf definition
		$udf.Script() | Out-File ($backupFolder + "functions\" + ([string]$srv.name -replace("\\", "_")) + "_" + [string]$db.Name + "_" + [string]$udf.name + "_backup.sql");
		# New udf definition sql
		$udf.Script() -replace($matchtext, $replaceText) | Out-File ($changeFolder + "functions\" + ([string]$srv.name -replace("\\", "_")) + "_" + [string]$db.Name + "_" + [string]$udf.name + ".sql");
		# If set to true this will change the udf definition on the server!
		if($alter)
		{
			$udf.TextBody = $udf.TextBody -replace($matchtext, $replaceText);
			$udf.Alter();
			Write-Host "Altered " $udf.Name;
		}
	}
}

Write-Host "Finished processing $database on $server.";
```

After correctly configuring and running the script you should see output similar to this;

```
Processing proc: pMyApp1AddressAdd
Processing proc: pMyApp1AddressDelete
Processing proc: pMyApp1AddressDeleteRecords
Processing proc: pMyApp1AddressDrillDown
Processing proc: pMyApp1AddressExport
Processing proc: pMyApp1AddressGet
Processing proc: pMyApp1AddressGetList
Processing proc: pMyApp1AddressGetStats
Processing proc: pMyApp1AddressUpdate
Processing proc: pMyApp1CustomerAddressExport
Processing proc: pMyApp1EmployeeAddressExport
Processing proc: pMyApp2AddressAdd
Processing proc: pMyApp2AddressDelete
Processing proc: pMyApp2AddressDeleteRecords
Processing proc: pMyApp2AddressDrillDown
Processing proc: pMyApp2AddressExport
Processing proc: pMyApp2AddressGet
Processing proc: pMyApp2AddressGetList
Processing proc: pMyApp2AddressGetStats
Processing proc: pMyApp2AddressUpdate
Processing proc: pMyApp2CustomerAddressExport
Processing view: vEmployee
Processing view: vVendor
Processing view: vIndividualCustomer
Processing view: vSalesPerson
Processing view: vStoreWithDemographics
Finished processing AdventureWorks on localhost\sql2005.
```

Some scripts will be produced in the directories you created. The Backup folder contains the original object definition and the Change folder provides a new version with the references to **[Person.Address]** altered to **[Person.Address2]**.

[![SQL Scripts generated by Powershell]({{ site.baseurl }}/assets/2009/05/image-thumb6.png "SQL Scripts generated by Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/05/image6.png)

The **$alter** variable is set to $false in the [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script above. Once you’re happy with the changes set this to $true and re-run the script. The database objects will then be changed.

```
Processing proc: pMyApp1AddressAdd
Altered pMyApp1AddressAdd
Processing proc: pMyApp1AddressDelete
Altered pMyApp1AddressDelete
Processing proc: pMyApp1AddressDeleteRecords
Altered pMyApp1AddressDeleteRecords
Processing proc: pMyApp1AddressDrillDown
Altered pMyApp1AddressDrillDown
Processing proc: pMyApp1AddressExport
Altered pMyApp1AddressExport
Processing proc: pMyApp1AddressGet
Altered pMyApp1AddressGet
Processing proc: pMyApp1AddressGetList
Altered pMyApp1AddressGetList
Processing proc: pMyApp1AddressGetStats
Altered pMyApp1AddressGetStats
Processing proc: pMyApp1AddressUpdate
Altered pMyApp1AddressUpdate
Processing proc: pMyApp1CustomerAddressExport
Altered pMyApp1CustomerAddressExport
Processing proc: pMyApp1EmployeeAddressExport
Altered pMyApp1EmployeeAddressExport
Processing proc: pMyApp2AddressAdd
Altered pMyApp2AddressAdd
Processing proc: pMyApp2AddressDelete
Altered pMyApp2AddressDelete
Processing proc: pMyApp2AddressDeleteRecords
Altered pMyApp2AddressDeleteRecords
Processing proc: pMyApp2AddressDrillDown
Altered pMyApp2AddressDrillDown
Processing proc: pMyApp2AddressExport
Altered pMyApp2AddressExport
Processing proc: pMyApp2AddressGet
Altered pMyApp2AddressGet
Processing proc: pMyApp2AddressGetList
Altered pMyApp2AddressGetList
Processing proc: pMyApp2AddressGetStats
Altered pMyApp2AddressGetStats
Processing proc: pMyApp2AddressUpdate
Altered pMyApp2AddressUpdate
Processing proc: pMyApp2CustomerAddressExport
Altered pMyApp2CustomerAddressExport
Processing view: vEmployee
Altered vEmployee
Processing view: vVendor
Altered vVendor
Processing view: vIndividualCustomer
Altered vIndividualCustomer
Processing view: vSalesPerson
Altered vSalesPerson
Processing view: vStoreWithDemographics
Altered vStoreWithDemographics
Finished processing AdventureWorks on localhost\sql2005.
```

You can easily reverse the change by changing two lines in the script and re-running it.

```
$matchText = "\[Person\].\[Address2\]"; # Definition text to search .Be aware this accepts a regular expression
$replaceText = "[Person].[Address]"; # Text to replace $matchText
```
