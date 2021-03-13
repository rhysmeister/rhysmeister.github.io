---
layout: post
title: Check SQL Agent Job Owners with Powershell
date: 2011-05-23 10:00:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags: []
meta:
  tweetbackscheck: '1613479599'
  shorturls: a:3:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/check-sql-agent-job-owners-with-powershell/1094";s:7:"tinyurl";s:26:"http://tinyurl.com/3fs8nub";s:4:"isgd";s:19:"http://is.gd/ehDccO";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-sql-agent-job-owners-with-powershell/1094/"
---
You may have a standard within your organisation for ownership of [SQL Agents Jobs](http://msdn.microsoft.com/en-us/library/ms135739.aspx "SQL Agent Jobs"). Here's quick Powershell snippet that you can use to check your server for compliance against your policy. Change the **$servers** array to contain the names of the SQL Servers you want to query. Change the value for **$default\_user** to the user that is supposed to all jobs. If a job is not owned by this user the text will be coloured red so it's easier to spot violations.

```
# Load SMO
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

# Array containing sql server names
$servers = @("server1", "server2", "server3");
# Your default job owner
$default_user = "sa";

# Process each sql server
foreach($server in $servers)
{
                Write-Host "$server ";
                Write-Host "===============================";
                # Create a SMO server object
                $srv = New-Object Microsoft.SqlServer.Management.SMO.Server $server;
                $jobs = $srv.JobServer.Jobs;
                foreach($job in $jobs)
                {
                                $jobName = $job.Name;
                                $jobOwner = $job.OwnerLoginName;
                                $colour = "Black";
                                # If job is not owned by default user
                                if($jobOwner -ne $default_user)
                                {
                                                $colour = "Red";
                                }
                                Write-Host -ForegroundColor $colour $jobName $JobOwner;
                }
                Write-Host "";
}
```

The script will output something like below;

```
server1
===============================
job1 rhys-VAIO\rhys
job2 rhys-VAIO\rhys
job3 rhys-VAIO\rhys
syspolicy_purge_history sa

server2
===============================
job1 rhys-VAIO\rhys
job2 rhys-VAIO\rhys
job3 rhys-VAIO\rhys
syspolicy_purge_history sa

server3
===============================
job1 rhys-VAIO\rhys
job2 rhys-VAIO\rhys
job3 rhys-VAIO\rhys
syspolicy_purge_history sa
```
