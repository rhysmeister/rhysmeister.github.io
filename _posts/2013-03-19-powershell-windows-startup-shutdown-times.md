---
layout: post
title: Powershell to get Windows Startup & Shutdown times
date: 2013-03-19 11:57:07.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
- shutdown
- startup
- windows
meta:
  _edit_last: '1'
  tweetbackscheck: '1613420892'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:80:"http://www.youdidwhatwithtsql.com/powershell-windows-startup-shutdown-times/1540";s:7:"tinyurl";s:26:"http://tinyurl.com/d5qbvc5";s:4:"isgd";s:19:"http://is.gd/auoImY";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershell-windows-startup-shutdown-times/1540/"
---
<p>Here's a quick Powershell snippet to get the startup and shutdown times for a windows system after a specific point.</p>
<pre code="Powershell">Get-EventLog -LogName System -ComputerName myHost -After 12/03/2013 -Source "Microsoft-Windows-Kernel-General" | Where-Object { $_.EventId -eq 12 -or $_.EventId -eq 13; } | Select-Object EventId, TimeGenerated, UserName, Source | Sort-Object TimeGenerated | Format-Table -Autosize;</pre>
<p>Id 12 indicates a startup event while 13 a shutdown event.</p>
<pre>EventID TimeGenerated       UserName            Source
------- -------------       --------            ------
13 12/03/2013 07:41:58 Microsoft-Windows-Kernel-General 12 12/03/2013 07:44:06 NT AUTHORITY\SYSTEM Microsoft-Windows-Kernel-General

