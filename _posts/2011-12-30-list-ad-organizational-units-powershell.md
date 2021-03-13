---
layout: post
title: List AD Organizational Units with Powershell
date: 2011-12-30 12:28:03.000000000 +01:00
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
  tweetbackscheck: '1613268167'
  _wp_old_slug: list-ad-organizational
  shorturls: a:3:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/list-ad-organizational-units-powershell/1424";s:7:"tinyurl";s:26:"http://tinyurl.com/dyxgxec";s:4:"isgd";s:19:"http://is.gd/O9z9ff";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/list-ad-organizational-units-powershell/1424/"
---
<p>Here's a quick <a title="Windows Powershell" href="http://technet.microsoft.com/en-us/scriptcenter/dd742419">Powershell</a> one-liner to list all the <a title="Active Directory Organizational Unit" href="http://technet.microsoft.com/en-us/library/cc758565%28WS.10%29.aspx" target="_blank">Organizational Units</a>, or OUs, in your Active Directory domain. Firstly you'll probably need to load the <a title="Powershell ActiveDirectory Module" href="http://technet.microsoft.com/en-us/library/ee617195.aspx" target="_blank">ActiveDirectory</a> module. This can be done at the Powershell prompt with the below command;</p>
<pre lang="Powershell">Import-Module ActiveDirectory;</pre>
<p>Then we can use the <a title="Get-ADOrganizationalUnit Powershell cmdlet" href="http://technet.microsoft.com/en-us/library/ee617236.aspx" target="_blank">Get-ADOrganizationalUnit cmdlet </a>to retrieve a list of OUs.</p>
<pre lang="Powershell">Get-ADOrganizationalUnit -Filter * | Select-Object -Property Name | Format-Table -AutoSize;</pre>
<p>This will display a list looking something like below;</p>
<pre>Name
----
Domain Controllers Microsoft Exchange Security Groups Security Groups Domain Servers Domain Workstations Domain Guest Accounts Printers Management Virtual Desktops IT Service Accounts Users Computers Production Servers SQL Servers Web Servers

