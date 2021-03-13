---
layout: post
title: Using Powershell to check if Triggers are enabled
date: 2009-06-17 18:57:51.000000000 +02:00
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
- Powershell
- Powershell Scripting
- Triggers
meta:
  tweetbackscheck: '1613337327'
  shorturls: a:7:{s:9:"permalink";s:87:"http://www.youdidwhatwithtsql.com/using-powershell-to-check-if-triggers-are-enabled/186";s:7:"tinyurl";s:25:"http://tinyurl.com/mtvhy2";s:4:"isgd";s:18:"http://is.gd/1dpde";s:5:"bitly";s:18:"http://bit.ly/uVyp";s:5:"snipr";s:22:"http://snipr.com/kvl1t";s:5:"snurl";s:22:"http://snurl.com/kvl1t";s:7:"snipurl";s:24:"http://snipurl.com/kvl1t";}
  twittercomments: a:1:{s:10:"2708758914";s:7:"retweet";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/using-powershell-to-check-if-triggers-are-enabled/186/"
---
I’ve been thinking about how [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) can be used by the [DBA](http://en.wikipedia.org/wiki/Database_administrator) as an extra tool in their armoury. An article that caught my eye was [The Daily DBA Checklist](http://www.simple-talk.com/community/blogs/tony_davis/archive/2008/05/13/52769.aspx), specifically an item about [Triggers](http://en.wikipedia.org/wiki/Database_trigger);

"_…last week some idiot turned a host of triggers off in our ERP system, causing a cascade of posting problems on dozens of orders before we caught the root cause…_"

[SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) does contain a system view called [sys.triggers](http://msdn.microsoft.com/en-us/library/ms188746(SQL.90).aspx) to provide us with some detailed information on [triggers](http://en.wikipedia.org/wiki/Database_trigger) in our databases. Lets view all triggers in the [AdventureWorks](http://www.codeplex.com/MSFTDBProdSamples) database;

```
SELECT *
FROM sys.triggers;
```

[![sys.triggers from the AdventureWorks database]({{ site.baseurl }}/assets/2009/06/image-thumb13.png "sys.triggers from the AdventureWorks database")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image13.png)

View a list of disabled triggers;

```
SELECT name
FROM sys.triggers
WHERE is_disabled = 1;
```

[![Disabled triggers in AdventureWorks]({{ site.baseurl }}/assets/2009/06/image-thumb14.png "Disabled triggers in AdventureWorks")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image14.png)

View a summary of enabled and disabled triggers;

```
SELECT CASE(is_disabled)
              WHEN 1 THEN 'Disabled'
              WHEN 0 THEN 'Enabled'
          END AS [state],
          COUNT(*) AS [count]
FROM sys.triggers
GROUP BY is_disabled;
```

[![Disabled / Enabled trigger summary in AdventureWorks]({{ site.baseurl }}/assets/2009/06/image-thumb15.png "Disabled / Enabled trigger summary in AdventureWorks")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image15.png)

Many people may be happy with these methods but here’s a [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) method that I think is much better;

```
# Load SMO Extension
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

# Set sql server & db info
$sqlserver = "RHYS-PC\sql2005";
$database = "AdventureWorks";

# Create sql server and db objects
$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver;
$db = $srv.Databases[$database];

$triggerCount = 0;
$disabledCount = 0;

# Any Database Triggers?
$DatabaseTriggerCount = $db.Triggers.Count;

if($DatabaseTriggerCount -gt 0)
{
	$triggerCount += $DatabaseTriggerCount;
	foreach($DatabaseTrigger in $db.Triggers)
	{
		$active = $DatabaseTrigger.IsEnabled;
		if($active)
		{
			# Set text to green
			Write-Host -ForegroundColor Green "$DatabaseTrigger IsEnabled = $active.";
		}
		else
		{
			Write-Host -ForegroundColor Red "$DatabaseTrigger IsEnabled = $active.";
			# Increment $disabledCount
			$disabledCount += 1;
		}
	}
}

# For each table
foreach($table in $db.Tables)
{
	# tally up trigger count
	$triggerCount += $table.Triggers.Count;
	# For each trigger on the current table
	foreach($trigger in $table.Triggers)
	{
		$active = $trigger.IsEnabled;
		if($active)
		{
			# Set text to green
			Write-Host -ForegroundColor Green "$trigger IsEnabled = $active.";
		}
		else
		{
			Write-Host -ForegroundColor Red "$trigger IsEnabled = $active.";
			# Increment $disabledCount
			$disabledCount += 1;
		}
	}
}

# Write summary
Write-Host -ForegroundColor Green "=======================================";
Write-Host -ForegroundColor Green "Total triggers in $sqlserver\$database = $triggerCount";
$colour = "Green";
if($disabledCount -gt 0)
{
	# If any triggers are disabled change warning text to red!
	$colour = "Red";
}
Write-Host -ForegroundColor $colour "Total disabled triggers = $disabledCount.";
```

[![Checking triggers with Powershell]({{ site.baseurl }}/assets/2009/06/image-thumb17.png "Checking triggers with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image17.png)

In this [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script I have used coloured text to make certain things stand out. The [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) method would be easy to adapt to use with multiple servers or take corrective action, i.e. enabling triggers. A Powershell script would be an excellent choice for that final go-live sanity check. I’m going to focus on more items in [The Daily DBA Checklist](http://www.simple-talk.com/community/blogs/tony_davis/archive/2008/05/13/52769.aspx), and similar articles, for further [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) articles.

