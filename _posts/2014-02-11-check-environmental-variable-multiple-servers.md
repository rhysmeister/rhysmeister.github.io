---
layout: post
title: Check the value of an Environmental Variable on Multiple servers
date: 2014-02-11 18:24:15.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
- Windows
tags:
- environmental variable
- Powershell
meta:
  _edit_last: '1'
  tweetbackscheck: '1613431042'
  shorturls: a:3:{s:9:"permalink";s:85:"http://www.youdidwhatwithtsql.com/check-environmental-variable-multiple-servers/1766/";s:7:"tinyurl";s:26:"http://tinyurl.com/qy5fbb7";s:4:"isgd";s:19:"http://is.gd/fp9bb0";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-environmental-variable-multiple-servers/1766/"
---
<p>Here's one <a href="http://technet.microsoft.com/en-us/library/bb978526.aspx" title="Windows Powershell" target="_blank">powershell</a> method for how to check the value of an <a href="http://en.wikipedia.org/wiki/Environment_variable#Microsoft_Windows" title="Environment variable" target="_blank">environment variable</a> on multiple servers;</p>
<pre lang="Powershell">
$computers = @("server1", "server2", "server3");

foreach ($c in $computers)
{
	 Get-WmiObject -ComputerName $c -Class Win32_Environment -Filter "Username = '<system>' AND Name = 'VAR_NAME'";
}
</system></pre>
<p>Output will be similar to below...</p>
<pre>
VariableValue              Name                       UserName
-------------              ----                       --------
SERVER1 VAR\_NAME <system>
SERVER2 VAR_NAME <system>
SERVER3 VAR_NAME <system>
</system></system></system>

