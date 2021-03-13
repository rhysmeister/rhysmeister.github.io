---
layout: post
title: Managing Index Fragmentation with Powershell
date: 2010-02-09 22:24:41.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
tags:
- index fragmentation
- indexes
- Powershell
- Powershell Scripting
meta:
  tweetbackscheck: '1613478560'
  twittercomments: a:1:{s:10:"8994281345";s:3:"137";}
  shorturls: a:4:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/managing-index-fragmentation-with-powershell/622";s:7:"tinyurl";s:26:"http://tinyurl.com/ydosjy3";s:4:"isgd";s:18:"http://is.gd/82V9Q";s:5:"bitly";s:20:"http://bit.ly/b1BA4M";}
  tweetcount: '1'
  _sg_subscribe-to-comments: svivekraju@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/managing-index-fragmentation-with-powershell/622/"
---
Here's a [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script that can be used to manage index fragmentation in [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) databases. The strategy I've used in the script is based on a recommendation from Pinal Dave ([blog](http://blog.sqlauthority.com) | [twitter](http://twitter.com/pinaldave)) in his article&nbsp; [Difference Between Index Rebuild and Index Reorganize Explained with T-SQL Script](http://blog.sqlauthority.com/2007/12/22/sql-server-difference-between-index-rebuild-and-index-reorganize-explained-with-t-sql-script/). Just set the **$sqlserver** and **$database** variables to something appropriate for your environment. Enjoy!

```
# Load SMO
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | Out-Null;

# Set sql server and database name here
$sqlserver = "localhost\sql2005";
$database = "AdventureWorks";

$srv = New-Object "Microsoft.SqlServer.Management.SMO.Server" $sqlserver;
$db = New-Object ("Microsoft.SqlServer.Management.SMO.Database");
$db = $srv.Databases[$database];

# Get table count
$table_count = $db.Tables.Count;
$i = 0;

# First script out the drops
foreach($table in $db.Tables)
{
	Write-Progress -Activity "Checking table $table" -PercentComplete (($i / $table_count) * 100) -Status "Processing indexes" -Id 1;
	$i++;
	foreach($index in $table.Indexes)
	{
		$index_name = $index.Name;
		Write-Progress -Activity "Checking table $table" -PercentComplete (($i / $table_count) * 100) -Status "Processing index $index_name" -Id 1;
		# Get the fragmentation stats
		$frag_stats = $index.EnumFragmentation();

		# Get the properties we need to work with the index
		$frag_stats | ForEach-Object {
						$Index_Name = $_.Index_Name;
						$Index_Type = $_.Index_Type;
						$Average_Fragmentation = $_.AverageFragmentation;
									};
		Write-Host -ForegroundColor Green "$Index_Type $Index_Name has a fragmentation percentage of $Average_Fragmentation";

		# Here we decide what to do based on the level on fragmentation
		if ($Average_Fragmentation -gt 40.00)
		{
			Write-Host -ForegroundColor Red "$Index_Name is more than 40% fragmented and will be rebuilt.";
			$index.Rebuild();
			Write-Host -ForegroundColor Green "$Index_Name has been rebuilt.";
		}
		elseif($Average_Fragmentation -ge 10.00 -and $Average_Fragmentation -le 40.00)
		{
			Write-Host -ForegroundColor Red "$Index_Name is between 10-40% fragmented and will be reorganized.";
			$index.Reorganize();
			Write-Host -ForegroundColor Green "$Index_Name has been reorganized.";
		}
		else
		{
			Write-Host -ForegroundColor Red "$Index_Name is healthy, with $Average_Fragmentation% fragmentation, and will be left alone.";
		}

	}
}
Write-Progress -Activity "Finished processing `"$database`" indexes." -PercentComplete 100 -Status "Done" -Id 1;
Start-Sleep -Seconds 2;
```

[![AdventureWork Index Management with Powershell]({{ site.baseurl }}/assets/2010/02/AdventureWork_Index_Management_thumb.png "AdventureWork Index Management with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/AdventureWork_Index_Management.png)

