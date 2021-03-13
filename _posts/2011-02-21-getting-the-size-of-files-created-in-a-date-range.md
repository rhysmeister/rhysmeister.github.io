---
layout: post
title: Getting the size of files created in a date range
date: 2011-02-21 21:21:28.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- directory size
- folder size
- Powershell
meta:
  tweetbackscheck: '1613475510'
  shorturls: a:3:{s:9:"permalink";s:88:"http://www.youdidwhatwithtsql.com/getting-the-size-of-files-created-in-a-date-range/1069";s:7:"tinyurl";s:26:"http://tinyurl.com/65n7l9t";s:4:"isgd";s:19:"http://is.gd/qyI132";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/getting-the-size-of-files-created-in-a-date-range/1069/"
---
I was recently asked for a list providing size details of all the database and transaction log backups we take for SQL Server. Along with this I was asked to provide the approximate daily backup size. Since I'm no fan of trawling through folders, ordering by date modified, and then viewing properties to get the backup size I'd thought I'd script out a little solution with [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell "Powershell").

All of our database servers backup to a central location. So what I wanted to do was print out a list like the following;

```
Total size of backups produced between period 02/16/2010 00:00:00 - 02/16/2011 23:59:59.
\\backup\sql\server1 - 1GB
\\backup\sql\server2 - 10GB
\\backup\sql\server3 - 100GB
\\backup\sql\server4 - 250GB
\\backup\sql\server5 - 27GB
```

Here's the script to do it. Just set the folder location and the datetime range you wish to check. For the example above we'd set the **$folder** variable to **\\backup\sql\**. If you'd rather have the folder sizes shown in megabytes change **$size.Sum/1GB** to **$size.Sum/1MB**.

```
$folder = "C:\Users\Rhys"; # Set backup location
$start = $(Get-Date -Year 2011 -Month 2 -Day 16 -Hour 0 -Minute 0 -Second 0); # datetime range we want to know the size for
$end = $(Get-Date -Year 2011 -Month 2 -Day 16 -Hour 23 -Minute 59 -Second 59);

# Get folder of database backups ignoring any files in the root
$folders = Get-ChildItem -Path $folder | Where-Object {$_.PsIsContainer -eq $true};

# Get the size of each directory
Write-Host "Total size of backups produced between period $start - $end.";
foreach($dir in $folders)
{
      $size = Get-ChildItem -Path $dir.FullName -Recurse | Where-Object {$_.CreationTime -ge $start -and $_.CreationTime -le $end} | Measure-Object -Property Length -Sum;
	  $size = [Math]::Round($($size.Sum/1GB), 2);
      Write-Host $dir.FullName "- $size GB";
}
```
