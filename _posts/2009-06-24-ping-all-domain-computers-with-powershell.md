---
layout: post
title: Ping all Domain Computers with Powershell
date: 2009-06-24 18:52:29.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Ping
- Powershell
- Powershell Scripting
meta:
  tweetbackscheck: '1613366643'
  shorturls: a:7:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/ping-all-domain-computers-with-powershell/209";s:7:"tinyurl";s:25:"http://tinyurl.com/l9l6yk";s:4:"isgd";s:18:"http://is.gd/1lAs1";s:5:"bitly";s:20:"http://bit.ly/1SECFe";s:5:"snipr";s:22:"http://snipr.com/ln4it";s:5:"snurl";s:22:"http://snurl.com/ln4it";s:7:"snipurl";s:24:"http://snipurl.com/ln4it";}
  twittercomments: a:24:{s:10:"2621903930";s:7:"retweet";s:10:"2599577174";s:7:"retweet";s:10:"2599555247";s:7:"retweet";s:10:"2599460989";s:7:"retweet";s:10:"2599371837";s:7:"retweet";s:10:"2575455695";s:7:"retweet";s:10:"2557103399";s:7:"retweet";s:10:"2538255456";s:7:"retweet";s:10:"2538247517";s:7:"retweet";s:10:"2538185486";s:7:"retweet";s:10:"2537479499";s:7:"retweet";s:10:"2535928745";s:7:"retweet";s:10:"2535317257";s:7:"retweet";s:10:"2533215523";s:7:"retweet";s:10:"2532685702";s:7:"retweet";s:10:"2532663573";s:7:"retweet";s:10:"2532281255";s:7:"retweet";s:10:"2532181845";s:7:"retweet";s:10:"2532181760";s:7:"retweet";s:10:"2531675294";s:7:"retweet";s:10:"2524976201";s:7:"retweet";s:10:"5180627205";s:7:"retweet";s:10:"5179051607";s:7:"retweet";s:10:"5153699829";s:7:"retweet";}
  tweetcount: '24'
  _edit_last: '1'
  _sg_subscribe-to-comments: papa3103@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ping-all-domain-computers-with-powershell/209/"
---
Here’s a [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script that can [ping](http://en.wikipedia.org/wiki/Ping) all computers that are in your [domain](http://en.wikipedia.org/wiki/Windows_Server_domain). All computers registered in [AD](http://en.wikipedia.org/wiki/Active_Directory) will be pinged, including ones long dead, so this script may be useful for figuring out what is still active on your network.

There’s nothing to configure on this script so it should be good to run untouched on any [domain](http://en.wikipedia.org/wiki/Windows_Server_domain). The console will output results of the [ping](http://en.wikipedia.org/wiki/Ping) but two text files will be created in your user profile folder, **C:\Users\Rhys** on my Windows 7 laptop. The text files will be named in the following&nbsp; formats;

- alive yyyyMMddhhmmss.csv – All computers that responded to the ping.
- dead yyyyMMddhhmmss.csv – All computers that didn’t respond to the ping.

```
# Code adapted / expanded from http://www.microsoft.com/technet/scriptcenter/resources/qanda/nov06/hey1109.mspx
$datetime = Get-Date -Format "yyyyMMddhhmmss";
$strCategory = "computer";

# Create a Domain object. With no params will tie to computer domain
$objDomain = New-Object System.DirectoryServices.DirectoryEntry;

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher; # AD Searcher object
$objSearcher.SearchRoot = $objDomain; # Set Search root to our domain
$objSearcher.Filter = ("(objectCategory=$strCategory)"); # Search filter

$colProplist = "name";
foreach ($i in $colPropList)
{
	$objSearcher.PropertiesToLoad.Add($i);
}

$colResults = $objSearcher.FindAll();

# Add column headers
Add-Content "$Env:USERPROFILE\alive $datetime.csv" "computer,ipAddress";
Add-Content "$Env:USERPROFILE\dead $datetime.csv" "computer,ipAddress";

foreach ($objResult in $colResults)
{
	$objComputer = $objResult.Properties;
	# Get the computer ping properties
	$computer = $objComputer.name;
	$ipAddress = $pingStatus.ProtocolAddress;
	# Ping the computer
	$pingStatus = Get-WmiObject -Class Win32_PingStatus -Filter "Address = '$computer'";

	if($pingStatus.StatusCode -eq 0)
	{
		Write-Host -ForegroundColor Green "Reply received from $computer.";
		Add-Content "$Env:USERPROFILE\alive $datetime.csv" "$computer,$ipAddress";
	}
	else
	{
		Write-Host -ForegroundColor Red "No Reply received from $computer.";
		Add-Content "$Env:USERPROFILE\dead $datetime.csv" "$computer,$ipAddress";
	}
}
```

[![Ping all domain computers with Powershell]({{ site.baseurl }}/assets/2009/06/image-thumb22.png "Ping all domain computers with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image22.png)

