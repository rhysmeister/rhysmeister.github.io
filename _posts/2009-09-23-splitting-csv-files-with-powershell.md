---
layout: post
title: Splitting csv files with Powershell
date: 2009-09-23 22:59:21.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- csv
- Data
- Powershell
- Powershell Scripting
meta:
  tweetbackscheck: '1613431430'
  shorturls: a:4:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/splitting-csv-files-with-powershell/374";s:7:"tinyurl";s:25:"http://tinyurl.com/mstsum";s:4:"isgd";s:18:"http://is.gd/3BQea";s:5:"bitly";s:20:"http://bit.ly/1jXbwg";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: badalratra@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/splitting-csv-files-with-powershell/374/"
---
I’ve blogged before about the usefulness of [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) for data tasks. A few weeks ago I had a requirement at work for [merging csv files](http://www.youdidwhatwithtsql.com/merging-csv-files-with-powershell/330) and recently I needed to split a single csv file into several files.

While this is easy to do using [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) and a bit of [T-SQL](http://msdn.microsoft.com/en-us/library/ms189826.aspx) it is a little tedious, and more time consuming, that it needs to be for adhoc jobs. Again Powershell came to the rescue! Here’s an example.

First I created a csv called bigCsvfile.csv, with 1, 000 records of data and placed it into my user profile directory; **C:\Users\Rhys** on my laptop.

[![splitting_csv_files_with_powershell_1]({{ site.baseurl }}/assets/2009/09/splitting_csv_files_with_powershell_1_thumb.png "splitting\_csv\_files\_with\_powershell\_1")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/splitting_csv_files_with_powershell_1.png)

This [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script does require a sequential integer id for each record to work correctly as it uses this to divide up the records. Now assuming you have a csv file, called **bigCsvFile.csv** , in the correct location then the only thing you should need to change is the **$split** variable value. This is now many files you would like to split the original file into.

```
# Author: Rhys Campbell
# 2009-09-22
# Splitting up csv files

# Path to csv file. Must contain a sequential unique integer id column
$csvFile = "$Env:USERPROFILE\bigcsvFile.csv";
# Slit into how many files?
$split = 10;

# Get the csv file content
$content = Import-Csv $csvFile;

# So we start from Id = 1 in the csv file
$start = 1;
$end = 0;

# calc records per file
$records_per_file = [int][Math]::Ceiling($content.Count / $split);

for($i = 1; $i -le $split; $i++)
{
	# Set the end value for selecting records
	$end += $records_per_file;
	# Need to cast to int or we get an alphabetic comparison when we want a numeric one
	$content | Where-Object {[int]$_.Id -ge $start -and [int]$_.Id -le $end} | Export-Csv -Path "$Env:USERPROFILE\file$i.csv" -NoTypeInformation;
	# Update start value for selecting records
	$start = $end + 1;
}
```

Once the script has executed successfully it will create the split csv files in your user profile folder. The new files are named sequentially, i.e. file1.csv, file2.csv, file3.csv etc.

[![split_csv_files]({{ site.baseurl }}/assets/2009/09/split_csv_files_thumb.png "split\_csv\_files")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/split_csv_files.png)

Depending on the number of records, and the number of files split to, the records may not be the same in each file. Provided the number of records versus file split is reasonable it will be pretty close. Now with a [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script it takes just a few moments to perform those previously tedious tasks!

