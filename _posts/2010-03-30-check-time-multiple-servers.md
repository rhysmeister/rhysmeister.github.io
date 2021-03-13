---
layout: post
title: Check the time on multiple servers
date: 2010-03-30 21:29:48.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
meta:
  tweetbackscheck: '1613449656'
  shorturls: a:4:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/check-the-time-on-multiple-servers/711";s:7:"tinyurl";s:26:"http://tinyurl.com/ycg2xzm";s:4:"isgd";s:18:"http://is.gd/b7b8O";s:5:"bitly";s:20:"http://bit.ly/9MyisW";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _edit_last: '1'
  _wp_old_slug: check-the-time-on-multiple-servers
  _sg_subscribe-to-comments: leknowlton@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-time-multiple-servers/711/"
---
After the recent change in our clocks due to [BST](http://wwp.greenwichmeantime.co.uk/time-zone/europe/uk/time/british-summer-time/) I noticed that one of our servers was a hour slow. I wanted to check the rest since we run a lot of time dependant processes. Now we have [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) any thought of manually checking each one is madness. Here's a quick script I knocked up to check the time on multiple servers. Just create a text file called **servers.txt** with each server name on a new line. Place this onto your desktop and you're ready to go.

Since my standard Windows Domain account didn't have access to these servers I've used the [Get-Credential](http://technet.microsoft.com/en-us/library/dd315327.aspx) cmdlet. When you execute the script you will see the below window asking for authentication details.

[![Get-Credential Powershell]({{ site.baseurl }}/assets/2010/03/GetCredential_Powershell_thumb.png "Get-Credential Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/03/GetCredential_Powershell.png)

```
# Get servers from text file on Desktop
$servers = Get-Content "$env:USERPROFILE\Desktop\servers.txt";
# Get credentials needed to access these servers
$credential = Get-Credential;

foreach($server in $servers)
{

	$timeObj = Get-WmiObject -ComputerName $server -Class Win32_LocalTime -Credential $credential;
	$hour = $timeObj.Hour;
	$minute = $timeObj.Minute;
	$second = $timeObj.Second;
	Write-Host "$server set time is $hour $minute $second";
}
```

The reported times will differ by a few seconds, due to latency, but it should be easy to spot any that are way out.

[![Powershell Server Time Check]({{ site.baseurl }}/assets/2010/03/Powershell_Server_Time_Check_thumb.png "Powershell Server Time Check")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/03/Powershell_Server_Time_Check.png)

