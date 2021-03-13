---
layout: post
title: Merging CSV Files with Powershell
date: 2009-08-24 12:24:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Data
- Powershell
- Powershell Scripting
meta:
  shorturls: a:7:{s:9:"permalink";s:71:"http://www.youdidwhatwithtsql.com/merging-csv-files-with-powershell/330";s:7:"tinyurl";s:25:"http://tinyurl.com/lfjemo";s:4:"isgd";s:18:"http://is.gd/2whQf";s:5:"bitly";s:19:"http://bit.ly/n8aOJ";s:5:"snipr";s:22:"http://snipr.com/qtlvt";s:5:"snurl";s:22:"http://snurl.com/qtlvt";s:7:"snipurl";s:24:"http://snipurl.com/qtlvt";}
  tweetbackscheck: '1613463880'
  twittercomments: a:0:{}
  tweetcount: '0'
  _edit_last: '1'
  _sg_subscribe-to-comments: k3r63r05@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/merging-csv-files-with-powershell/330/"
---
[Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) is really useful for documenting and managing your servers but it’s also a pretty good tool for working with data. I’ve been using it to merge csv files, with an identical structure, into a single file. Now this is pretty easy, if rather tedious, to do using [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) Import / Export functionality or with SSIS. [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) makes this a snap!

In this example I have two csv files in a directory

[![csv files]({{ site.baseurl }}/assets/2009/08/image_thumb.png "csv files")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/08/image.png)

These just contain some simple name and age data.

[![Content of my test csv files]({{ site.baseurl }}/assets/2009/08/image_thumb1.png "Content of my test csv files")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/08/image1.png)

This simple script will produce a third file, merging the contents of file1.csv and file2.csv.

```
# Author: Rhys Campbell
# 2009-08-22
# Merging identical csv files

# Directory containing csv files, include *.*
$directory = "C:\Users\Rhys\Desktop\csv\*.*";
# Get the csv files
$csvFiles = Get-ChildItem -Path $directory -Filter *.csv;

# Updated 01/03/2010. Thanks to comment from Chris.
# Resolves error Method invocation failed because [System.Management.Automation.PSObject] doesn't contain a method named 'op_Addition'.
#$content = $null;
$content = @();

# Process each file
foreach($csv in $csvFiles)
{
	$content += Import-Csv $csv;
}

# Write a datetime stamped csv file
$datetime = Get-Date -Format "yyyyMMddhhmmss";
$content | Export-Csv -Path "C:\Users\Rhys\Desktop\csv\merged_$datetime.csv" -NoTypeInformation;
```

If all goes as planned a new file will be created.

[![csv folder with new file]({{ site.baseurl }}/assets/2009/08/image_thumb2.png "csv folder with new file")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/08/image2.png)

This file will contain data from both csv files.

[![The final merged csv file]({{ site.baseurl }}/assets/2009/08/image_thumb3.png "The final merged csv file")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/08/image3.png)

This is obviously a fairly trivial example but it’s a massive timesaver when you have many such files to merge. Word of warning, if you’ve got very big files, you may want to change the script to use [Add-Content](http://technet.microsoft.com/en-us/library/dd347594.aspx), to flush each csv file to disk in the foreach loop, to avoid munching up all your RAM.

