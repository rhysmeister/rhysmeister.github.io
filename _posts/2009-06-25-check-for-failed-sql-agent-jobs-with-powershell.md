---
layout: post
title: Check for failed SQL Agent Jobs with Powershell
date: 2009-06-25 20:20:22.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
- Powershell Scripting
- SQL Agent Jobs
meta:
  tweetbackscheck: '1613439867'
  shorturls: a:7:{s:9:"permalink";s:85:"http://www.youdidwhatwithtsql.com/check-for-failed-sql-agent-jobs-with-powershell/212";s:7:"tinyurl";s:25:"http://tinyurl.com/ltwp8r";s:4:"isgd";s:18:"http://is.gd/1lwvH";s:5:"bitly";s:19:"http://bit.ly/hf9QU";s:5:"snipr";s:22:"http://snipr.com/lmz0d";s:5:"snurl";s:22:"http://snurl.com/lmz0d";s:7:"snipurl";s:24:"http://snipurl.com/lmz0d";}
  twittercomments: a:21:{s:10:"2621903930";s:7:"retweet";s:10:"2599577174";s:7:"retweet";s:10:"2599555247";s:7:"retweet";s:10:"2599460989";s:7:"retweet";s:10:"2599371837";s:7:"retweet";s:10:"2575455695";s:7:"retweet";s:10:"2557103399";s:7:"retweet";s:10:"2538255456";s:7:"retweet";s:10:"2538247517";s:7:"retweet";s:10:"2538185486";s:7:"retweet";s:10:"2537479499";s:7:"retweet";s:10:"2535928745";s:7:"retweet";s:10:"2535317257";s:7:"retweet";s:10:"2533215523";s:7:"retweet";s:10:"2532685702";s:7:"retweet";s:10:"2532663573";s:7:"retweet";s:10:"2532281255";s:7:"retweet";s:10:"2532181845";s:7:"retweet";s:10:"2532181760";s:7:"retweet";s:10:"2531675294";s:7:"retweet";s:10:"2524976201";s:7:"retweet";}
  tweetcount: '21'
  _edit_last: '1'
  _sg_subscribe-to-comments: murad.email@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-for-failed-sql-agent-jobs-with-powershell/212/"
---
Checking for failed [SQL Agent jobs](http://msdn.microsoft.com/en-us/library/ms135739.aspx) should be part of any [DBA workplan](http://sqlserverpedia.com/blog/sql-server-bloggers/suggested-dba-work-plan/). Here’s another [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script that makes checking the last run outcome easy on multiple SQL Servers. To run this script you need to create a list of your [SQL Servers](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) in a text file called **sqlservers.txt**. Place this text file in your user profile directory, **C:\Users\Rhys** on my laptop.

```
# Load SMO extension
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;
# Get List of sql servers to check
$sqlservers = Get-Content "$Env:USERPROFILE\sqlservers.txt";

# Loop through each sql server from sqlservers.txt
foreach($sqlserver in $sqlservers)
{
      # Create an SMO Server object
      $srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver;

      # Jobs counts
      $totalJobCount = $srv.JobServer.Jobs.Count;
      $failedCount = 0;
      $successCount = 0;

      # For each jobs on the server
      foreach($job in $srv.JobServer.Jobs)
      {
            # Default write colour
            $colour = "Green";
            $jobName = $job.Name;
            $jobEnabled = $job.IsEnabled;
            $jobLastRunOutcome = $job.LastRunOutcome;

            # Set write text to red for Failed jobs
            if($jobLastRunOutcome -eq "Failed")
            {
                  $colour = "Red";
                  $failedCount += 1;
            }
            elseif ($jobLastRunOutcome -eq "Succeeded")
            {
                  $successCount += 1;
            }
            Write-Host -ForegroundColor $colour "SERVER = $sqlserver JOB = $jobName ENABLED = $jobEnabled LASTRUN = $jobLastRunOutcome";
      }

      # Writes a summary for each SQL server
      Write-Host -ForegroundColor White "=========================================================================================";
      Write-Host -ForegroundColor White "$sqlserver total jobs = $totalJobCOunt, success count $successCount, failed jobs = $failedCount.";
      Write-Host -ForegroundColor White "=========================================================================================";
}
```

The output provided shows jobs with a last run status of “_Succeeded”_ in green and “_Failed”_ in red. A summary is provided for each individual SQL Server.

[![Checking SQL Agent Jobs with Powershell]({{ site.baseurl }}/assets/2009/06/image-thumb24.png "Checking SQL Agent Jobs with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image24.png)

