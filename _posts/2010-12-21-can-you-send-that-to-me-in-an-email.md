---
layout: post
title: Can you send that to me in an email?
date: 2010-12-21 21:37:06.000000000 +01:00
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
  shorturls: a:4:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/can-you-send-that-to-me-in-an-email/917";s:7:"tinyurl";s:26:"http://tinyurl.com/2f6795r";s:4:"isgd";s:18:"http://is.gd/jaYTj";s:5:"bitly";s:20:"http://bit.ly/fQ1Ekk";}
  tweetbackscheck: '1613445069'
  twittercomments: a:1:{s:17:"17337340817055744";s:7:"retweet";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/can-you-send-that-to-me-in-an-email/917/"
---
<p>Sometimes I'm writing Powershell scripts to gather information on a seemingly ad-hoc basis and then someone says; <em>&quot;Oh, and can you send that to me in an email every day|week|month&quot;. </em>These scripts would often use a bunch of <a title="Powershell Write-Host cmdlet" href="http://technet.microsoft.com/en-us/library/dd347596.aspx" target="_blank">Write-Host</a> statements to output to the console. Modifying these to send the output in an email can be time consuming. That is, unless you know about the <a title="Powershell Start-Transcript cmdlet" href="http://technet.microsoft.com/en-us/library/dd347721.aspx" target="_blank">Start-Transcript</a> cmdlet.</p>
<p>The Start-Transcript cmdlet will record all console output to a text file. It's a snap to stick into any existing scripts.</p>
<pre lang="Powershell">Start-Transcript -Path "$env:USERPROFILE\output.txt";
# All output from here is logged to a text file...
Write-Host "I'm starting my transcript file...";
Get-Date -Format "yyyy-MM-dd hh:mm:ss";
Get-Service -Name "*sql*";
Write-Host "Finishing transcript session.";
Stop-Transcript; # Stop transcription
Write-Host "My transcript has finished..."; # Not output to file
</pre>
<p>This will display any output as normal in the console.</p>
<p><a href="http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/12/Powershell_start_transcript_cmdlet.png"><img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="Powershell Start-Transcript cmdlet" border="0" alt="Powershell Start-Transcript cmdlet" src="{{ site.baseurl }}/assets/2010/12/Powershell_start_transcript_cmdlet_thumb.png" width="644" height="327" /></a></p>
<p>Additionally a text file, called <strong>output.txt</strong>, will be generated in your user profile directory (<strong>C:\Users\Rhys </strong>on my laptop).</p>
<pre>**********************
Windows PowerShell Transcript Start
Start time: 20101221212045
Username  : rhys-VAIO\rhys
Machine	  : RHYS-VAIO (Microsoft Windows NT 6.1.7600.0)
**********************
Transcript started, output file is C:\Users\rhys\output.txt
I'm starting my transcript file...
2010-12-21 09:20:45

Status   Name               DisplayName
------   ----               -----------
Running MSSQL$SQLEXPRESS SQL Server (SQLEXPRESS) Stopped MSSQLServerADHe... SQL Active Directory Helper Service Stopped MySQL MySQL Running MySQL51 MySQL51 Stopped SQLAgent$SQLEXP... SQL Server Agent (SQLEXPRESS) Stopped SQLBrowser SQL Server Browser Running SQLWriter SQL Server VSS Writer Finishing transcript session. \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\* Windows PowerShell Transcript End End time: 20101221212045 \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

Then all you have to do is [send an email with Powershell](http://www.youdidwhatwithtsql.com/send-email-with-powershell/889 "Send an email with Powershell") including the output file as an attachment or body content. Happy days!

