---
layout: post
title: Using Powershell to increment the computers date
date: 2011-11-10 16:10:14.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags: []
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:74:"http://www.youdidwhatwithtsql.com/powershell-increment-computers-date/1389";s:7:"tinyurl";s:26:"http://tinyurl.com/cydnpwm";s:4:"isgd";s:19:"http://is.gd/he8BwH";}
  tweetbackscheck: '1613479026'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershell-increment-computers-date/1389/"
---
Here's a little snippet of [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell "Windows Powershell") code I used recently to test some [TSQL](http://en.wikipedia.org/wiki/Transact-SQL "TSQL") that runs according to a two week schedule.

This code will increment the date by one day, up to the maximum specified in **$days** , sleeping in between for a short while. The date is set back correctly at the end. Far from rocket science but it helps me test various bits of code in minutes instead of 2 weeks!

```
# Number of days to increment the date by
$days = 14;

for($counter=0; $counter -lt $days; $counter++)
{
	Set-Date (Get-Date).AddDays(1);
	# Sleep for 2 minutes so the code gets a chance to run
	Start-Sleep -Seconds 120;
}

# Set the date back correctly
Set-Date (Get-Date).AddDays(-$days);
```
