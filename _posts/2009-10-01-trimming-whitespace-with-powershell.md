---
layout: post
title: Trimming Whitespace with Powershell
date: 2009-10-01 20:14:11.000000000 +02:00
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
- whitespace
meta:
  twittercomments: a:0:{}
  tweetbackscheck: '1613452650'
  shorturls: a:4:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/trimming-whitespace-with-powershell/388";s:7:"tinyurl";s:26:"http://tinyurl.com/yc77kls";s:4:"isgd";s:18:"http://is.gd/3QRxN";s:5:"bitly";s:19:"http://bit.ly/RBZo0";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/trimming-whitespace-with-powershell/388/"
---
A few days ago I was working with a client that was providing an export of data from [Oracle](http://www.oracle.com/index.html). The file being produced was choking my [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) package due to various formatting issues. After working with the client and getting a file that looked good to the naked eye I discovered that a large amount of whitespace on the end of each line was making things break at my end.

I need to import this file quickly so I decided to fix it myself. As usual [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) was up to the task! Here’s the script I came up with. This script will process a file called **test.csv** located in e:\ and produce a new file called **test2.csv** with the trailing whitespace removed from each line.

```
$content = "";
$file = "e:\test.csv";
$count = 0;
Write-Progress -Activity "Processing file" -CurrentOperation "Line = 0" -PercentComplete 0 -Status "Starting" -Id 1;
$lines = Get-Content -Path $file;
$percent_complete = 0;

# trim line by line
foreach($line in $lines)
{
 	$line = $line.TrimEnd();
 	$content += "$line`n" # Add a newline
 	$count++;
 	$percent_complete = [int][Math]::Ceiling((($count / $lines.Count) * 100));
	 Write-Progress -Activity "Processing file" -CurrentOperation "Line = $count" -PercentComplete $percent_complete -Status "Running" -Id 1;
}

$content | Set-Content -Path "e:\test2.csv";
Write-Progress -Activity "Finished processing file" -CurrentOperation "All lines processed" -PercentComplete 100 -Status "Complete" -Id 1;
Sleep(5);
```

[![trim_whitespace_from_files_powershell]({{ site.baseurl }}/assets/2009/10/trim_whitespace_from_files_powershell_thumb.png "trim\_whitespace\_from\_files\_powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/10/trim_whitespace_from_files_powershell.png)

After this quick fix the file was easily imported!

