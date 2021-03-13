---
layout: post
title: Performance benchmarking with Powershell
date: 2010-12-01 21:17:53.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Performance benchmarking
- Powershell
meta:
  tweetbackscheck: '1613426347'
  shorturls: a:4:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/performance-benchmarking-with-powershell/909";s:7:"tinyurl";s:26:"http://tinyurl.com/34lv8yf";s:4:"isgd";s:18:"http://is.gd/i3WD6";s:5:"bitly";s:20:"http://bit.ly/gDN0X1";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: aaron.bertrand@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/performance-benchmarking-with-powershell/909/"
---
I've been working on a performance benchmarking project recently to gauge the effect of new releases to our systems. [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell "Powershell") happens to be very useful gathering various system statistics using the [Get-Counter cmdlet](http://technet.microsoft.com/en-us/library/dd367892.aspx "Powershell Get-Counter cmdlet").

There's literally a tonne of available counters for everything to disk use, memory usage to sql server specific counters. You can list the ones available on a system with the below command.

```
Get-Counter -ListSet "*";
```

To list all SQL Server specific counters...

```
Get-Counter -ListSet "*sql*";
```

The amount of data generated quickly becomes unmanageable so it's best to write the info to a csv file. Then the data can then be imported into a database or excel for further analysis.

I found this to be a little tricky so I've included a script here that will produce a suitable file. The script below will run a set of counters, at a specified interval, and produce a csv file for each sample. A few variables need to be modified.

- **$computer** - Set this to the computer you wish to gather performance counters for. 
- **$loadFlag** - This will be appended as an extra column to the csv file, I use this for uniquely tagging each session to compare data from different sessions. 
- **$sampleInterval** - Number of seconds between each sample in the session. 
- **$maxSamples** - The number of samples to take in the session. 
- **$path** - This is where the csv files will be output. 

There's a few sample counters included in the script. Be sure to research the available counters to include the ones appropriate to you.

```
# CPU0 Metrics
$listOfMetrics += ("\processor(0)\% processor time", "\processor(0)\% idle time");
# CPU1 Metrics
$listOfMetrics += ("\processor(1)\% processor time", "\processor(1)\% idle time");
# Memory Metrics
$listOfMetrics += ("\memory\page faults/sec", "\memory\available mbytes");
# Paging File Metrics (Totals)
$listOfMetrics += ("\paging file(_total)\% usage", "\paging file(_total)\% usage peak");
# process Metrics
$listOfMetrics += ("\process(idle)\% processor time","\process(sqlservr)\% processor time");

$computer = "rhys-VAIO";
$loadFlag = 1; # Unique id for each load test session CHANGE THIS!!!!
$sampleInterval = 10; # seconds between each sample
$maxSamples = 10; # Number of samples to take
$path = "C:\Users\Rhys\Desktop\output\output_"; # Output path. Don't put the extension as it's done below.

$metrics = Get-Counter -ComputerName $computer -Counter $listOfMetrics -SampleInterval $sampleInterval -MaxSamples $maxSamples;

$count = 1; # Count for numbering each individual file
foreach($metric in $metrics)
{
	$obj = $metric.CounterSamples | Select-Object -Property Path, CookedValue, Timestamp;
	$obj | Add-Member -MemberType NoteProperty -Name LoadFlag -Value $loadFlag -Force; # Add a new column to the csv for loadFlag
	$obj | Export-Csv -Path "$path$count.txt" -NoTypeInformation;
	$count += 1; # Increment filename counter
}
```

After successful execution check your output directory for the files. If all has gone well they should look something like below.

```
"Path","CookedValue","Timestamp","LoadFlag"
"\\rhys-vaio\processor(0)\% processor time","3.90531358130328","01/12/2010 20:51:02","1"
"\\rhys-vaio\processor(0)\% idle time","96.0946864186967","01/12/2010 20:51:02","1"
"\\rhys-vaio\processor(1)\% processor time","0.629358362484078","01/12/2010 20:51:02","1"
"\\rhys-vaio\processor(1)\% idle time","99.3706416375159","01/12/2010 20:51:02","1"
"\\rhys-vaio\memory\page faults/sec","782.099537446347","01/12/2010 20:51:02","1"
"\\rhys-vaio\memory\available mbytes","961","01/12/2010 20:51:02","1"
"\\rhys-vaio\paging file(_total)\% usage","21.5294152137404","01/12/2010 20:51:02","1"
"\\rhys-vaio\paging file(_total)\% usage peak","21.9042513538076","01/12/2010 20:51:02","1"
"\\rhys-vaio\process(idle)\% processor time","389.370677436797","01/12/2010 20:51:02","1"
"\\rhys-vaio\process(sqlservr)\% processor time","0","01/12/2010 20:51:02","1"
```

All to be done now is to wrestle with Excel pivot tables to make sense of this data!

