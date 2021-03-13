---
layout: post
title: Kill all processes by name with Powershell
date: 2010-08-10 20:10:58.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- kill all processes
- Powershell
meta:
  tweetbackscheck: '1613411589'
  shorturls: a:4:{s:9:"permalink";s:80:"http://www.youdidwhatwithtsql.com/kill-all-processes-by-name-with-powershell/853";s:7:"tinyurl";s:26:"http://tinyurl.com/26l5z24";s:4:"isgd";s:18:"http://is.gd/ebRfZ";s:5:"bitly";s:20:"http://bit.ly/dr43MI";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/kill-all-processes-by-name-with-powershell/853/"
---
A reader commented on a [previous post](http://www.youdidwhatwithtsql.com/more-powershell-nuggets/239) pointing out a deficiency in one of the scripts used to kill processes on remote computers. If more than one instance of the specified process was running on the target computer the script would buckle. This is pretty easy to rectify. The below script will kill all process instances on the target machine.

```
# Kill all processes on a remote machine with a specific name
$computer = "localhost";
$processToKill = "notepad.exe";
$process = Get-WmiObject -Class Win32_Process -Filter "Name = '$processToKill'" -ComputerName $computer;
if($process -eq $null)
{ # If null then the process may not be running
                Write-Host -ForegroundColor Red "Couldn't get process $processToKill on $computer";
                sleep(10);
                exit;
}
else
{
                Write-Host "Attempting to Kill $processToKill on $computer";
}

# This original part of the script dies if $process is an array of more than one calc.exe process
# Kill the process and get exit status 0 = OK
# $status = $process.InvokeMethod("Terminate", $null);
# switch($status)
# {
# 0 { Write-Host -ForegroundColor Green "Killed $processToKill on $computer"};
# default { Write-Host -ForegroundColor Red "Error, couldn't kill $processToKill on $computer"};
#};

$count = 1;

# This will work regardless if $process is an array or not
foreach ($ps in $process)
{
                Write-Host "Kill count = $count";
				Write-Host "Handle = " $ps.Handle;
                $status = $ps.InvokeMethod("Terminate", $null);
                switch($status)
                {
                                0 { Write-Host -ForegroundColor Green "Killed $processToKill on $computer"};
                                default { Write-Host -ForegroundColor Red "Error, couldn't kill $processToKill on $computer"};
                };
                $count++;
}
```

This will procedure output similar to below.

```
Attempting to Kill notepad.exe on localhost
Kill count = 1
Handle = 3788
Killed notepad.exe on localhost
Kill count = 2
Handle = 4916
Killed notepad.exe on localhost
Kill count = 3
Handle = 5884
Killed notepad.exe on localhost
Kill count = 4
Handle = 3488
Killed notepad.exe on localhost
Kill count = 5
Handle = 6232
Killed notepad.exe on localhost
```

A similar thing can be achieved , on the localhost, with a one-liner.

```
# Kills all processes called 'calc' on the localhost
ps calc | kill;
```

With a little bit of [Remoting](http://blogs.msdn.com/b/powershell/archive/2008/05/10/remoting-with-powershell-quickstart.aspx), available in Powershell V2, it would be simple enough to achieve the same functionality in the one-liner to execute this on remote computers.

