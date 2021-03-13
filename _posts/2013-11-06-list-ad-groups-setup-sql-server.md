---
layout: post
title: List AD Groups Setup on SQL Server
date: 2013-11-06 08:24:07.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
- SQL Server
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613445893'
  shorturls: a:3:{s:9:"permalink";s:71:"http://www.youdidwhatwithtsql.com/list-ad-groups-setup-sql-server/1703/";s:7:"tinyurl";s:26:"http://tinyurl.com/q4r4ctu";s:4:"isgd";s:19:"http://is.gd/NVcMk0";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/list-ad-groups-setup-sql-server/1703/"
---
<p>Here's a quick powershell snippet to display the Windows groups setup as logins on SQL Server.</p>
<pre lang="Powershell">
Import-Module SQLPS -DisableNameChecking -ErrorAction Ignore;
Import-Module ActiveDirectory -DisableNameChecking -ErrorAction Ignore;
$sql_server = "sql_instance";
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server $sql_server;
$srv.Logins | Where-Object {$_.LoginType -eq "WindowsGroup";};
</pre>
<p>Output will be similar to below.</p>
<pre>
Name                                          Login Type    Created
----                                          ----------    -------
NT SERVICE\ClusSvc WindowsGroup 13/10/2013 11:17 NT SERVICE\MSSQLSERVER WindowsGroup 13/10/2013 12:17 NT SERVICE\SQLSERVERAGENT WindowsGroup 13/10/2013 12:17 Domain\Group 1 WindowsGroup 04/06/2013 12:29 Domain\Group 2 WindowsGroup 02/04/2013 11:25 Domain\Group 3 WindowsGroup 02/04/2013 12:22

