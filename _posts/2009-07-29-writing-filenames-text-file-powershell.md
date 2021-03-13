---
layout: post
title: Writing filenames to a text file with Powershell
date: 2009-07-29 16:24:00.000000000 +02:00
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
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  shorturls: a:7:{s:9:"permalink";s:76:"http://www.youdidwhatwithtsql.com/writing-filenames-text-file-powershell/281";s:7:"tinyurl";s:25:"http://tinyurl.com/mne28g";s:4:"isgd";s:18:"http://is.gd/1TliI";s:5:"bitly";s:19:"http://bit.ly/FuuUC";s:5:"snipr";s:22:"http://snipr.com/o90e3";s:5:"snurl";s:22:"http://snurl.com/o90e3";s:7:"snipurl";s:24:"http://snipurl.com/o90e3";}
  tweetbackscheck: '1613472688'
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/writing-filenames-text-file-powershell/281/"
---
I had a task to do today that required me to get all the names in a directory of files into a database. This seemed like a ideal job for [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) and I’ve posted the (very simple) script here.

There’s a few variables you need to change to fit your environment; **$directory** - this should contain the path to the directory of files you need the filenames for. **$txtFile** – this is the text file where the names will be written to. It does not have to exist first.

```
# The directory containing your files
$directory = "C:\Users\Rhys\Desktop\country_gif";
# The text file to write filenames to (does not have to exist first)
$txtFile = "C:\Users\Rhys\Desktop\files.txt"

# Get filenames from this directory
# Get-ChildItem is aliased by 'dir'
$files = Get-ChildItem $directory;

# Loop through the files in the directory
foreach($file in $files)
{
	Add-Content $txtFile $file.Name;
}
```
