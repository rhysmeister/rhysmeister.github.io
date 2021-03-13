---
layout: post
title: Copy SSIS Packages between SQL Server Instances
date: 2013-07-12 15:27:46.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
- SSIS
tags: []
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/copy-ssis-packages-sql-server-instances/1623/";s:7:"tinyurl";s:26:"http://tinyurl.com/nrcrw8f";s:4:"isgd";s:19:"http://is.gd/pHz3hh";}
  tweetbackscheck: '1613479321'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/copy-ssis-packages-sql-server-instances/1623/"
---
I'm in the process of setting up a mirrored server and I'm looking to make fail-over as painless as possible.

[SSIS](http://msdn.microsoft.com/en-us/library/ms141026(v=sql.105).aspx "SQL Server Integration Services") Packages are used quite extensively in our environment so it would be useful to mirror these. I've written a little powershell script to get this done. It's fairly limited, will only copy packages created in the SSIS designer in the root folder, as that's all I needed.

Tested, but not battle ready, on SQL Server 2008 R2. Use with care for now. Just change the source and destination server variables, and possibly the path to dtutil.exe, and you should be all set.

```
Add-PSSnapin SqlServerCmdletSnapin100;
Add-PSSnapin SqlServerProviderSnapin100;

$sourceServer="SQLInstance1";
$destinationServer="SQLInstance2";

try
{
	# Will only import packages created in the SSIS Designer in the root folder.
	# For details; http://technet.microsoft.com/en-us/library/ms181582.aspx
	$ssisPackageQuery="SELECT [name] FROM sysssispackages WHERE packagetype = 5 AND folderid = '00000000-0000-0000-0000-000000000000'";

	$packages = Invoke-SqlCmd -ServerInstance $sourceServer -Database "msdb" -Query $ssisPackageQuery;

	foreach($pkg in $packages)
	{
		$packageName = $pkg.name;
		$exec="`"C:\Program Files\Microsoft SQL Server\100\DTS\Binn\dtutil.exe`"";
		$importParams = "/QUIET /COPY SQL;`"$packageName`" /SQL `"$packageName`" /SourceServer `"$sourceServer`" /DestServer `"$destinationServer`"";
		$exit = Start-Process -FilePath $exec -ArgumentList $importParams -NoNewWindow -Wait -PassThru;
		$exitCode = $exit.ExitCode;
		if($exitCode -ne 0)
		{
			# log error
			Write-EventLog -LogName "Application" -Source MSSQLSERVER -EventId 3001 -EntryType "Error" -Message "CopySSISPackages.ps1: Failed with params $importParams";
		}
		else
		{
			# log success
			Write-EventLog -LogName "Application" -Source MSSQLSERVER -EventId 3001 -EntryType "Information" -Message "CopySSISPackages.ps1: Succeeded with params $importParams";
		}
	}
}
catch [System.Exception]
{
	$msg = $_.Exception.Message;
	Write-EventLog -LogName "Application" -Source MSSQLSERVER -EventId 0 -EntryType "Error" -Message "CopySSISPackages.ps1: $msg";
}
```
