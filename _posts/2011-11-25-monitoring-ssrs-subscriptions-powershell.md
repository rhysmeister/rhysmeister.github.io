---
layout: post
title: Monitoring SSRS Subscriptions with Powershell
date: 2011-11-25 13:17:09.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
- SSRS
tags:
- Powershell
- Report Subscriptions
- SSRS
meta:
  _edit_last: '1'
  tweetbackscheck: '1613452644'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/monitoring-ssrs-subscriptions-powershell/1392";s:7:"tinyurl";s:26:"http://tinyurl.com/c85x5hy";s:4:"isgd";s:19:"http://is.gd/D62CV0";}
  tweetcount: '0'
  _sg_subscribe-to-comments: ocampo.dave@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/monitoring-ssrs-subscriptions-powershell/1392/"
---
We don't use [SSRS](http://msdn.microsoft.com/en-us/library/ms159106.aspx "SQL Server Reporting Services")much at my workplace but its usage is slowly creeping up. I realised that none of us are keeping an eye on the few subscriptions we have set-up. So I decided to do something about that.

Here's a bit of [Powershell](http://technet.microsoft.com/en-us/scriptcenter/dd742419 "Windows Powershell") code that uses the [SSRS Web Service](http://msdn.microsoft.com/en-us/library/ms152787.aspx "SSRS Web Service") to pull out a list of subscriptions from SSRS and print out some information to the screen. As always I try to bring problems to attention with a little red text so you can identify any failed subscriptions. There's a few assumptions in the script, so be sure to read the comments, and it's a far from complete and fully tested script. Just a little something to get me started onto something better.

```
# If you use multiple ssrs server just stick in another foreach loop
# and iterate over an array of ssrs server names.
$reportserver = "sqlserver";
$url = "http://$($reportserver)/reportserver/reportservice.asmx?WSDL";

$ssrs = New-WebServiceProxy -uri $url -UseDefaultCredential -Namespace "ReportingWebService";

# Uncomment to list all available methods & properties in the ssrs web service...
#$ssrs | Get-Member;

# Get datasources (assumes default path to folder)
$datasources = $ssrs.ListChildren("/Data Sources", $true);

# for each datasource
foreach($ds in $datasources)
{
	# Get reports
	$reports = $ssrs.ListReportsUsingDataSource($ds.Path);
	# For each report
	foreach($r in $reports)
	{
		# Get all subscriptions
		$subscriptions = $ssrs.ListSubscriptions($r.Path, $r.Owner);
		# foreach subscription
		foreach($s in $subscriptions)
		{
			# Uncomment to view more subscription methods & properties
			# $s | Get-Member;
			# Probably missing a few important keywords here...
			$colour = "Green";
			if($s.Status -match "Failure" -or $s.Status -match "Error")
			{
				$colour = "Red";
			}
			Write-Host -ForegroundColor $colour $s.Report $s.Status $s.LastExecuted | Format-Table -AutoSize;
		}
	}
}
```

After running this script successfully you should be something like below;

[![]({{ site.baseurl }}/assets/2011/11/powershell_ssrs1.png "powershell ssrs")](http://www.youdidwhatwithtsql.com/monitoring-ssrs-subscriptions-powershell/1392/powershell_ssrs-2)

&nbsp;

