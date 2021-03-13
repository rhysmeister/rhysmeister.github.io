---
layout: post
title: Monitoring & starting Services with Powershell
date: 2009-05-21 21:32:25.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- DBA
- Powershell
- Powershell Scripting
- Windows Services
meta:
  tweetbackscheck: '1613421684'
  shorturls: a:7:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/monitoring-starting-services-with-powershell/113";s:7:"tinyurl";s:25:"http://tinyurl.com/q957ve";s:4:"isgd";s:17:"http://is.gd/PpsO";s:5:"bitly";s:19:"http://bit.ly/PX4yI";s:5:"snipr";s:22:"http://snipr.com/jis3u";s:5:"snurl";s:22:"http://snurl.com/jis3u";s:7:"snipurl";s:24:"http://snipurl.com/jis3u";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/monitoring-starting-services-with-powershell/113/"
---
Are you part of the [DBA](http://en.wikipedia.org/wiki/Database_administrator) crowd that hasn't yet checked out [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx)? I'm really enthusiastic about its potential for server administration. Script out all those mundane jobs you have to do and make life easy. Here's a [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script that makes checking if services are running, and optionally starting them, on multiple servers really easy. First, be sure to check [services.msc](http://en.wikipedia.org/wiki/Windows_service#Managing_services) for your SQL Server service names. They may be different from the default, i.e. if you’re running [Named Instances](http://msdn.microsoft.com/en-us/library/ms165614.aspx).

[![SQL Server Service Names]({{ site.baseurl }}/assets/2009/05/image-thumb4.png "SQL Server Service Names")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/05/image4.png)&nbsp;

- Create **C:\Computers.txt** with a list of servers to check. 
- The $servicesArray specifies **SQLSERVERAGENT** and **MSSQLSERVER**. Change these to different services if required. Be sure to use single quotes if a $ symbol is in the service name or they will be treated as variables. 
- Set $start = $true will make the script start the listed services if they are not running. 

```
# Setup trap to catch exceptions
trap [Exception]
{
	write-error $("TRAPPED: " + $_.Exception.Message);
}

# read computers from text file
$computers = Get-Content C:\Computers.txt;
$start = $true;

# Setup the Service array with the service names we want to check are running
$serviceArray = 'SQLAgent$SQL2005', 'MSSQL$SQL2005';

# Powershell knows it's an array so working with it is simple
foreach($computer in $computers)
{
	Write-Host "Checking $computer";
	$objWMIService = Get-WmiObject -Class win32_service -computer $computer

	foreach($service in $objWMIService)
	{
		# Check each service specicfied in the $serviceArray
		foreach($srv in $serviceArray)
		{
			if($service.name -eq $srv)
			{
				Write-Host "$srv is present on $computer.";
				if($service.state -eq "running")
				{
					Write-Host "$srv is running on $computer";
				}
				else
				{
					Write-Host "$srv is not running on $computer";
					# If $start is true the script will attempt to start the service if it is stopped
					if($start -eq $true)
					{
						# Attempt to start the current service on the current computer
						$serviceInstance = (Get-WmiObject -computer $computer Win32_Service -Filter "Name='$srv'");
						$name = $serviceInstance.Name;
						Write-Host "Attempting to start $name on $computer."
						$serviceInstance.StartService() | Out-Null;
						# Refresh the object instance so we get new data
						$serviceInstance = (Get-WmiObject -computer $computer Win32_Service -Filter "Name='$srv'");
						$state = $serviceInstance.State;
						Write-Host "$name is ""$state"" on $computer.";
					}
				}
			}
		}
	}
}
```

[![Monitoring & checking services in Powershell]({{ site.baseurl }}/assets/2009/05/image-thumb5.png "Monitoring & checking services in Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/05/image5.png)

