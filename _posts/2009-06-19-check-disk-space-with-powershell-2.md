---
layout: post
title: Check disk space with Powershell
date: 2009-06-19 12:56:40.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Disk Space
- Powershell
- Powershell Scripting
meta:
  tweetbackscheck: '1613461158'
  shorturls: a:7:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/check-disk-space-with-powershell-2/195";s:7:"tinyurl";s:25:"http://tinyurl.com/kn84sr";s:4:"isgd";s:18:"http://is.gd/1lYPv";s:5:"bitly";s:20:"http://bit.ly/2lDOSQ";s:5:"snipr";s:22:"http://snipr.com/lo9nv";s:5:"snurl";s:22:"http://snurl.com/lo9nv";s:7:"snipurl";s:24:"http://snipurl.com/lo9nv";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _edit_last: '1'
  _sg_subscribe-to-comments: 123lravisingh@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-disk-space-with-powershell-2/195/"
---
Need to monitor disk space on multiple servers? Then make the job easy with this [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script. To configure this script just create a file called **serverlist.txt** in your user profile folder, **C:\Users\Rhys** on my laptop. The **$percentWarning** variable allows you to control at what percentage level you will be warned about free disk space. If disk space is less than this then the text will be coloured red to draw your attention to it. The script will also output a datetime stamped csv file in your user folder containing similar data.

```
# Issue warning if % free disk space is less
$percentWarning = 15;
# Get server list
$servers = Get-Content "$Env:USERPROFILE\serverlist.txt";
$datetime = Get-Date -Format "yyyyMMddHHmmss";

# Add headers to log file
Add-Content "$Env:USERPROFILE\server disks $datetime.txt" "server,deviceID,size,freespace,percentFree";

foreach($server in $servers)
{
	# Get fixed drive info
	$disks = Get-WmiObject -ComputerName $server -Class Win32_LogicalDisk -Filter "DriveType = 3";

	foreach($disk in $disks)
	{
		$deviceID = $disk.DeviceID;
		[float]$size = $disk.Size;
		[float]$freespace = $disk.FreeSpace;

		$percentFree = [Math]::Round(($freespace / $size) * 100, 2);
		$sizeGB = [Math]::Round($size / 1073741824, 2);
		$freeSpaceGB = [Math]::Round($freespace / 1073741824, 2);

		$colour = "Green";
		if($percentFree -lt $percentWarning)
		{
			$colour = "Red";
		}
		Write-Host -ForegroundColor $colour "$server $deviceID percentage free space = $percentFree";
		Add-Content "$Env:USERPROFILE\server disks $datetime.txt" "$server,$deviceID,$sizeGB,$freeSpaceGB,$percentFree";
	}
}
```

[![Checking disk pace on multiple servers with Powershell]({{ site.baseurl }}/assets/2009/06/cid-image001-png01c9f0dc-thumb1.png "Checking disk pace on multiple servers with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/cid-image001-png01c9f0dc1.png)

