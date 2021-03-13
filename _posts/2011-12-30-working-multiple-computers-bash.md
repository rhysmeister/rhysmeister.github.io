---
layout: post
title: Working with multiple computers in Bash
date: 2011-12-30 16:12:08.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- Linux
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613283650'
  shorturls: a:3:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/working-multiple-computers-bash/1427";s:7:"tinyurl";s:26:"http://tinyurl.com/bwbjbaq";s:4:"isgd";s:19:"http://is.gd/9AbfEF";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/working-multiple-computers-bash/1427/"
---
Working with [multiple computers in Powershell](http://technet.microsoft.com/en-us/library/ff730959.aspx)&nbsp;is absurdly easy using the [Get-Content](http://technet.microsoft.com/en-us/library/ee176843.aspx "Windows Powershell Get-Content cmdlet") cmdlet to read computer names from a text file. It's as easy as this...

```
$a = Get-Content "C:\Scripts\Test.txt"

foreach ($i in $a)
    {$i + "`n" + "=========================="; Get-WMIObject Win32_BIOS -computername $i}
```

As I'm doing more and more bash scripting I thought it would be useful to replicate this. Here's how you do it;

```
#!/bin/bash

for c in `cat computers.txt`
do
        # Do work with each computer here...
        echo "Computer = $c";
done
```
