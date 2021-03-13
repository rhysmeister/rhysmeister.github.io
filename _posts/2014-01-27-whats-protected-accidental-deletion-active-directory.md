---
layout: post
title: What's protected from accidental deletion in Active Directory?
date: 2014-01-27 17:23:18.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
- SQL Server
- Windows
tags:
- AD
- failover cluster
- Powershell
- SQL Server
meta:
  tweetbackscheck: '1613480964'
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:92:"http://www.youdidwhatwithtsql.com/whats-protected-accidental-deletion-active-directory/1750/";s:7:"tinyurl";s:26:"http://tinyurl.com/qatxxdu";s:4:"isgd";s:19:"http://is.gd/P2nQUH";}
  _wp_old_slug: whats-protected-ffrom-accidental-deletion
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/whats-protected-accidental-deletion-active-directory/1750/"
---
<p>Here's just a little tip I picked up from a presentation by Mark Broadbent (<a title="Mark Broadbent Twitter" href="https://twitter.com/retracement" target="_blank">retracement</a> on twitter). I'm the guy who wasn't listening! Mark stressed the importance of enabling the <a title="AD Protect from accidental deletion " href="http://blogs.technet.com/b/industry_insiders/archive/2007/10/31/windows-server-2008-protection-from-accidental-deletion.aspx" target="_blank">Protection from accidental deletion</a> property in active directory for your Failover Clusters. Here's how to check this for Computers with Powershell.</p>
<p>This string of commands requires the <a href="http://blogs.msdn.com/b/rkramesh/archive/2012/01/17/how-to-add-active-directory-module-in-powershell-in-windows-7.aspx" target="_blank">AD Module</a>. So if you're not using Powershell 3.0 you need to ensure this is loaded.</p>
<p>I've included a further filter in the <a title="Where-Object Powershell cmdlet" href="http://technet.microsoft.com/en-us/library/ee177028.aspx" target="_blank">Where-Object</a> cmdlet because I'm only interested in SQL Servers. Remove or adjust this if needed.</p>
<pre lang="Powershell">Get-ADObject -Filter {ObjectClass -eq "Computer"} -Properties Name, ProtectedFromAccidentalDeletion | Where-Object {$_.Name -match "SQL"; } | Select Name, ProtectedFromAccidentalDeletion | Format-Table -Autosize;</pre>
<p>The output will look something like below...</p>
<pre>
Name            ProtectedFromAccidentalDeletion
----            -------------------------------
SQLSERVER1 False SQLSERVER2 False SQLSERVER3 False

