---
layout: post
title: Powershell Random sort
date: 2010-02-01 11:56:00.000000000 +01:00
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
- random
- random sort
meta:
  tweetbackscheck: '1613450840'
  twittercomments: a:0:{}
  shorturls: a:4:{s:9:"permalink";s:60:"http://www.youdidwhatwithtsql.com/powershell-random-sort/596";s:7:"tinyurl";s:26:"http://tinyurl.com/y9qpsxo";s:4:"isgd";s:18:"http://is.gd/7tgH4";s:5:"bitly";s:20:"http://bit.ly/cUwOSI";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershell-random-sort/596/"
---
Here's a [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) snippet that randomly sorts the lines in a file. The snippet below reads a text file, called **file.txt** , located in your user profile directory. The data in the file will be written back with the lines in a different order.

```
$data = New-Object System.Object;
$data = Get-Content "$Env:USERPROFILE\file.txt";
# Random sort the lines in the file
$data = $data | sort {[System.Guid]::NewGuid()};
Set-Content "$Env:USERPROFILE\file.txt" $data;
```

If your file started off like this...

[![file ordered]({{ site.baseurl }}/assets/2010/02/file_ordered_thumb.png "file ordered")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/file_ordered.png)

It will end up looking something like...

[![file random sort]({{ site.baseurl }}/assets/2010/02/file_random_sort_thumb.png "file random sort")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/file_random_sort1.png)

This is functionally equivalent to...

```
SELECT *
FROM dbo.Customers
ORDER BY NEWID();
```
