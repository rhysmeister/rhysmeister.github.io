---
layout: post
title: Fun with the Get-Hotfix cmdlet
date: 2011-08-15 12:37:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Hotfix
- Powershell
meta:
  tweetbackscheck: '1613461138'
  shorturls: a:3:{s:9:"permalink";s:69:"http://www.youdidwhatwithtsql.com/fun-with-the-get-hotfix-cmdlet/1334";s:7:"tinyurl";s:26:"http://tinyurl.com/3kk7hjn";s:4:"isgd";s:19:"http://is.gd/BYCXbI";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/fun-with-the-get-hotfix-cmdlet/1334/"
---
<p>With the <a title="Get-Hotfix Powershell cmdlet" href="http://technet.microsoft.com/en-us/library/dd315358.aspx" target="_blank">Get-Hotfix</a> cmdlet you can query the list of hotfixes that have been applied to computers.</p>
<pre lang="Powershell">Get-Hotfix | Format-Table -AutoSize;</pre>
<p>This will display the list of hotfixes installed on the local computer.</p>
<pre>Source Description     HotFixID  InstalledBy          InstalledOn
------ -----------     --------  -----------          -----------
SO0590 Update 982861 NT AUTHORITY\SYSTEM 07/07/2011 00:00:00 SO0590 Update KB958830 host\Administrator 07/07/2011 00:00:00 SO0590 Update KB958830 host\Administrator SO0590 Update KB971033 host\Administrator SO0590 Update KB2264107 NT AUTHORITY\SYSTEM 06/08/2011 00:00:00 SO0590 Security Update KB2305420 host\Administrator 03/10/2011 00:00:00 SO0590 Security Update KB2393802 host\Administrator 03/10/2011 00:00:00 SO0590 Security Update KB2425227 host\Administrator 03/10/2011 00:00:00 SO0590 Security Update KB2475792 host\Administrator 03/10/2011 00:00:00 SO0590 Security Update KB2476490 NT AUTHORITY\SYSTEM SO0590 Security Update KB2479628 host\Administrator 03/10/2011 00:00:00 SO0590 Security Update KB2479943 host\Administrator 03/10/2011 00:00:00 SO0590 Update KB2484033 host\Administrator 03/10/2011 00:00:00 SO0590 Security Update KB2485376 host\Administrator 03/10/2011 00:00:00 SO0590 Update KB2487426 host\Administrator 03/10/2011 00:00:00 SO0590 Update KB2488113 NT AUTHORITY\SYSTEM 06/09/2011 00:00:00 SO0590 Security Update KB2491683 NT AUTHORITY\SYSTEM 06/09/2011 00:00:00 SO0590 Update KB2492386 NT AUTHORITY\SYSTEM 06/09/2011 00:00:00

Not overly impressive in itself but [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell "Windows Powershell") really comes into its own when querying multiple computers. For example you may wish to confirm that a bunch of computers all have an important hotfix installed. This script will do it. Just alter the **$HotFixID** and **$computers** as needed.

```
# HotFixId to check for
$HotFixID = "KB958830";

# Array of computers to check
$computers = @("server1", "server2", "server3", "server4", "server5");

# Query each computer
foreach($computer in $computers)
{
	$hf = Get-HotFix -ComputerName $computer | Where-Object {$_.HotFixId -eq $HotFixID} | Select-Object -First 1;
	if($hf -eq $null)
	{
		Write-Host "Hotfix $HotFixID is not installed on $computer";
	}
	else
	{
		Write-Host "Hotfix $HotFixID was installed on $computer on by " $($hf.InstalledBy);
	}
}
```

In a few moments you can see which computers you need to take action on;

```
Hotfix KB958830 was installed on server1 on by SMARTODDS\campbellr
Hotfix KB958830 was installed on server2 on by SMARTODDS\campbellr
Hotfix KB958830 is not installed on server3
Hotfix KB958830 is not installed on server4
Hotfix KB958830 is not installed on server5
```

Powershell; the eliminator of tedium!

