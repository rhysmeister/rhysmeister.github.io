---
layout: post
title: Document your SQL Agent Jobs
date: 2011-05-11 08:00:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
tags:
- SQL Agent Jobs
meta:
  tweetbackscheck: '1613478580'
  shorturls: a:3:{s:9:"permalink";s:67:"http://www.youdidwhatwithtsql.com/document-your-sql-agent-jobs/1088";s:7:"tinyurl";s:26:"http://tinyurl.com/3vp2b8a";s:4:"isgd";s:19:"http://is.gd/QwFboK";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: ejohnso5@steelcase.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/document-your-sql-agent-jobs/1088/"
---
And I don't mean writing it down in a word document, leaving it somewhere on the network, and then forgetting about it. How about keeping the documentation with the job? Microsoft provides us with a space for it...

[![sql_agent_job_description_field]({{ site.baseurl }}/assets/2011/05/sql_agent_job_description_field_thumb.png "sql\_agent\_job\_description\_field")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Document-your-SQL-Agent-Jobs_1334E/sql_agent_job_description_field.png)

In this description field ideally I'd like to see

1. A brief description of what the job does. 
2. Who owns the job. Who can I bother if there's something I don't get? 
3. How critical is this job? Can it wait until you're back from holiday next week or does it have to be fixed as soon as feasible? 
4. Links to further documentation. I don't expect an essay in here so include detailed documentation elsewhere and provide links if needed. 

This little bit of Powershell will check SQL Agent jobs on multiple servers for a description. Any jobs without a description will be highlighted in red.

```
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

# Array containing sql server names
$servers = @("localhost");

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
		$jobDescription = $job.Description;
		$colour = "White";
		# If job is not documented highligh in red
		if($jobDescription -eq "No description available.")
		{
			$colour = "Red";
		}
	Write-Host -ForegroundColor $colour $jobName $JobDescription;
	}
	Write-Host "";
}
```

[![powershell_sql_agent_job_description]({{ site.baseurl }}/assets/2011/05/powershell_sql_agent_job_description_thumb.png "powershell\_sql\_agent\_job\_description")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Document-your-SQL-Agent-Jobs_1334E/powershell_sql_agent_job_description.png)

So get documenting those jobs and you might be left in peace on your next holiday!

If you liked this you might also like;

[Documenting Databases with Powershell](http://www.youdidwhatwithtsql.com/guest-post-on-scripting-guys/914 "Documenting Database with Powershell")

[Extract Stored Procedure comments with TSQL](http://www.youdidwhatwithtsql.com/extract-stored-procedure-comments-with-tsql/563 "Extract Stored Procedure comments with TSQL")

[System Documentation: My Method](http://www.youdidwhatwithtsql.com/system-documentation-method/319 "Documenting database with extended properties")

