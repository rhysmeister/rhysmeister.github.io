---
layout: post
title: Fun with the Get-EventLog cmdlet
date: 2011-08-12 12:22:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
meta:
  tweetbackscheck: '1613392351'
  shorturls: a:3:{s:9:"permalink";s:71:"http://www.youdidwhatwithtsql.com/fun-with-the-get-eventlog-cmdlet/1318";s:7:"tinyurl";s:26:"http://tinyurl.com/3vjx295";s:4:"isgd";s:19:"http://is.gd/nepUV1";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: 123lravisingh@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/fun-with-the-get-eventlog-cmdlet/1318/"
---
<p>The <a title="Powershell Get-EventLog cmdlet" href="http://technet.microsoft.com/en-us/library/dd315250.aspx" target="_blank">Get-EventLog cmdlet</a> is great for working with the Windows Event Logs on local and remote computers. It includes lots of parameters that make life much easier than using the Event Viewer GUI. </p>
<p>To list the available logs on the local computer just execute;</p>
<pre lang="Powershell">Get-EventLog -List | Format-Table -AutoSize;</pre>
<pre>Max(K) Retain OverflowAction    Entries Log
------ ------ --------------    ------- ---
20,480      0 OverwriteAsNeeded  50,916 Application
20,480      0 OverwriteAsNeeded       0 HardwareEvents
   512      7 OverwriteOlder          0 Internet Explorer
20,480      0 OverwriteAsNeeded       0 Key Management Service
 8,192      0 OverwriteAsNeeded      52 Media Center
   128      0 OverwriteAsNeeded       3 OAlerts
                                        Security
20,480      0 OverwriteAsNeeded  56,258 System
15,360      0 OverwriteAsNeeded   2,889 Windows PowerShell</pre>
<p>It's great for drilling down into the Event Logs to get the information you're most interested in. For example, this line of Powershell gets all Errors in the Application Event Log, from the last 24 hours.</p>
<pre lang="Powershell">Get-EventLog -LogName Application -EntryType Error -After $(Get-Date).AddHours(-24) | Format-Table -AutoSize;</pre>
<p>This snippet can pull out all the Event Log errors from any combination of servers and logs within the last 24 hours. Great for those morning checks!</p>
<pre lang="Powershell">
# Set servers to query
$servers = @("server1", "server2", "server2");
# Set event logs to query
$logs = @("System", "Application");

Write-Host "Querying servers for event log errors in the last 24 hours...";
Write-Host "";

foreach($server in $servers)
{
	Write-Host $server;
	Write-Host "====================================";
	Write-Host "";
	foreach($log in $logs)
	{
		Write-Host "$log Event Log";
		Write-Host "=================";
		Get-EventLog -ComputerName $server -LogName $log -EntryType Error -After $(Get-Date).AddHours(-24) | Format-Table -AutoSize;
	}
}
</pre>
<pre>Querying servers for event log errors in the last 24 hours...

server1
====================================

System Event Log
=================

Index Time         EntryType Source                  InstanceID Message
----- ----         --------- ------                  ---------- -------
80222 Jul 26 19:56 Error     Service Control Manager 3221232472 The VMware vCenter Converter Standalone Worker service...
80221 Jul 26 19:56 Error     Service Control Manager 3221232481 A timeout was reached (30000 milliseconds) while waiti...
80220 Jul 26 19:55 Error     Service Control Manager 3221232472 The VMware vCenter Converter Standalone Server service...
80219 Jul 26 19:55 Error     Service Control Manager 3221232481 A timeout was reached (30000 milliseconds) while waiti...
80202 Jul 26 19:55 Error     Service Control Manager 3221232481 A timeout was reached (30000 milliseconds) while waiti...


Application Event Log
=================

Index Time         EntryType Source   InstanceID Message
----- ----         --------- ------   ---------- -------
90050 Jul 26 19:56 Error     VzCdbSvc          7 Failed to load the plug-in module. (GUID = {56F9312C-C989-4E04-8C23-2...
90048 Jul 26 19:56 Error     VzCdbSvc          7 Failed to load the plug-in module. (GUID = {48512A59-C8A5-4805-9048-2...


server2
====================================

System Event Log
=================

Index Time         EntryType Source                  InstanceID Message
----- ----         --------- ------                  ---------- -------
80222 Jul 26 19:56 Error     Service Control Manager 3221232472 The VMware vCenter Converter Standalone Worker service...
80221 Jul 26 19:56 Error     Service Control Manager 3221232481 A timeout was reached (30000 milliseconds) while waiti...
80220 Jul 26 19:55 Error     Service Control Manager 3221232472 The VMware vCenter Converter Standalone Server service...
80219 Jul 26 19:55 Error     Service Control Manager 3221232481 A timeout was reached (30000 milliseconds) while waiti...
80202 Jul 26 19:55 Error     Service Control Manager 3221232481 A timeout was reached (30000 milliseconds) while waiti...


Application Event Log
=================

Index Time         EntryType Source   InstanceID Message
----- ----         --------- ------   ---------- -------
90050 Jul 26 19:56 Error     VzCdbSvc          7 Failed to load the plug-in module. (GUID = {56F9312C-C989-4E04-8C23-2...
90048 Jul 26 19:56 Error     VzCdbSvc          7 Failed to load the plug-in module. (GUID = {48512A59-C8A5-4805-9048-2...


server3
====================================

System Event Log
=================

Index Time         EntryType Source                  InstanceID Message
----- ----         --------- ------                  ---------- -------
80222 Jul 26 19:56 Error     Service Control Manager 3221232472 The VMware vCenter Converter Standalone Worker service...
80221 Jul 26 19:56 Error     Service Control Manager 3221232481 A timeout was reached (30000 milliseconds) while waiti...
80220 Jul 26 19:55 Error     Service Control Manager 3221232472 The VMware vCenter Converter Standalone Server service...
80219 Jul 26 19:55 Error     Service Control Manager 3221232481 A timeout was reached (30000 milliseconds) while waiti...
80202 Jul 26 19:55 Error     Service Control Manager 3221232481 A timeout was reached (30000 milliseconds) while waiti...


Application Event Log
=================

Index Time         EntryType Source   InstanceID Message
----- ----         --------- ------   ---------- -------
90050 Jul 26 19:56 Error VzCdbSvc 7 Failed to load the plug-in module. (GUID = {56F9312C-C989-4E04-8C23-2... 90048 Jul 26 19:56 Error VzCdbSvc 7 Failed to load the plug-in module. (GUID = {48512A59-C8A5-4805-9048-2...

The GUI is dead, long live Powershell!

