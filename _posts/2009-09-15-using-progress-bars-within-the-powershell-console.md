---
layout: post
title: Using Progress Bars within the Powershell Console
date: 2009-09-15 21:14:35.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
- Powershell Scripting
- Progress Bars
meta:
  tweetbackscheck: '1613185105'
  shorturls: a:4:{s:9:"permalink";s:87:"http://www.youdidwhatwithtsql.com/using-progress-bars-within-the-powershell-console/366";s:7:"tinyurl";s:25:"http://tinyurl.com/maf75k";s:4:"isgd";s:18:"http://is.gd/3jkxz";s:5:"bitly";s:20:"http://bit.ly/2u3hTw";}
  twittercomments: a:1:{s:10:"4012597498";s:7:"retweet";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/using-progress-bars-within-the-powershell-console/366/"
---
Progress bars can be a nice visual indicator as to how a far a task is into its workload. Windows [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) provides us with the ability to create these within the console fairly easily.

This simple code will demonstrate the basics of the [Write-Progress](http://technet.microsoft.com/en-us/library/dd347663.aspx) [cmdlet](http://msdn.microsoft.com/en-us/library/ms714395(VS.85).aspx), which allows us to deploy progress bars in our scripts.

```
for($i = 0; $i -le 100; $i++)
{
	Write-Progress -Activity "Activity" -PercentComplete $i -Status "Processing";
	Sleep -Milliseconds 100;
}
```

[![Progress bar within the Powershell Console]({{ site.baseurl }}/assets/2009/09/image_thumb.png "Progress bar within the Powershell Console")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/image.png)

It’s possible to spawn multiple progress bars within the Console. This may be handy for displaying the advance of child tasks. Here’s a simple example.

```
for($i = 0; $i -le 100; $i++)
{
	Write-Progress -Activity "Parent Task $i" -PercentComplete $i -Status "Processing" -Id 1;
	Sleep -Milliseconds 100;
	# Spawn a child Progress bar specify a different Id
	for($x = 0; $x -le 10; $x++)
	{
		Write-Progress -Activity "Child Task $x" -PercentComplete ($x * 10) -Status "Processing" -Id 2;
		Sleep -Milliseconds 30;
	}
}
```

[![Spawning multiple progress bars within the Powershell Console]({{ site.baseurl }}/assets/2009/09/image_thumb1.png "Spawning multiple progress bars within the Powershell Console")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/image1.png)

To show a practical example, I’ve enhanced a script from a previous post; [Check disk space with Powershell](http://www.youdidwhatwithtsql.com/check-disk-space-with-powershell-2/) to use some of the code showcased here (check this for setup instructions). Enjoy!

```
# Issue warning if % free disk space is less
$percentWarning = 15;
# Get server list
$servers = Get-Content "$Env:USERPROFILE\serverlist.txt";
$datetime = Get-Date -Format "yyyyMMddHHmmss";

# Add headers to log file
Add-Content "$Env:USERPROFILE\server disks $datetime.txt" "server,deviceID,size,freespace,percentFree";
# How many servers
$server_count = $servers.Length;
# processed server count
$i = 0;

foreach($server in $servers)
{
	$server_progress = [int][Math]::Ceiling((($i / $server_count) * 100))
	# Parent progress bar
	Write-Progress -Activity "Checking $server" -PercentComplete $server_progress -Status "Processing servers - $server_progress%" -Id 1;
	Sleep(1); # Sleeping just for progress bar demo
	# Get fixed drive info
	$disks = Get-WmiObject -ComputerName $server -Class Win32_LogicalDisk -Filter "DriveType = 3";

 	# How many disks are there?
	$disk_count = $disks.Length;

 	$x = 0;
	foreach($disk in $disks)
	{
		$disk_progress = [int][Math]::Ceiling((($x / $disk_count) * 100));
		$disk_name = $disk.Name;
		Write-Progress -Activity "Checking disk $disk_name" -PercentComplete $disk_progress -Status "Processing server disks - $disk_progress%" -Id 2;
		Sleep(1);
		$deviceID = $disk.DeviceID;
		[float]$size = $disk.Size;
		[float]$freespace = $disk.FreeSpace;

		$percentFree = [Math]::Round(($freespace / $size) * 100, 2);
		$sizeGB = [Math]::Round($size / 1073741824, 2);
		$freeSpaceGB = [Math]::Round($freespace / 1073741824, 2);

		$colour = "Green";
		if($percentFree-lt $percentWarning)
		{
			$colour = "Red";
		}
		Write-Host -ForegroundColor $colour "$server $deviceID percentage free space = $percentFree";
		Add-Content "$Env:USERPROFILE\server disks $datetime.txt" "$server,$deviceID,$sizeGB,$freeSpaceGB,$percentFree";
		$x++;
	}
	# Finish off the progress bar
	Write-Progress -Activity "Finshed checking disks for this server" -PercentComplete 100 -Status "Done - 100%" -Id 2;
	Sleep(1); # Just so we see!
	$i++;
}
Write-Progress -Activity "Checked all servers" -PercentComplete 100 -Status "Done - 100%" -Id 1;
Sleep(1);
```

&nbsp;[![Powershell script checking disk space with progress bars]({{ site.baseurl }}/assets/2009/09/check_disk_powershell_progress_bars_thumb.png "Powershell script checking disk space with progress bars")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/check_disk_powershell_progress_bars.png)

