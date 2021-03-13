---
layout: post
title: 'Powershell: Who is in an Active Directory Group?'
date: 2013-07-23 09:09:04.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461308'
  _wp_old_slug: check-active-directory-group
  shorturls: a:3:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/powershell-active-directory-group/1633/";s:7:"tinyurl";s:26:"http://tinyurl.com/mar8mz5";s:4:"isgd";s:19:"http://is.gd/TUIP4V";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: andy@sqlandy.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershell-active-directory-group/1633/"
---
<p>This Powershell snippet uses the <a title="Get-ADGroupMember cmdlet" href="http://technet.microsoft.com/en-us/library/ee617193.aspx" target="_blank">Get-ADGroupMember</a> to retrieve the names of users in a specific AD group.</p>
<pre lang="Powershell">Import-Module ActiveDirectory;
Get-ADGroupMember -Identity "Group Name" | Select-Object Name | Format-Table -AutoSize;</pre>
<p>Output should look something like below;</p>
<pre>Name
----
Joe Bloggs  
John Smith  
Jane Doe

