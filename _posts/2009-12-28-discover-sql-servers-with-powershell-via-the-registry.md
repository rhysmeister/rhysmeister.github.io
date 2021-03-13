---
layout: post
title: Discover SQL Servers with Powershell via the registry
date: 2009-12-28 15:26:11.000000000 +01:00
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
- SQL Server
meta:
  tweetbackscheck: '1613074398'
  shorturls: a:4:{s:9:"permalink";s:91:"http://www.youdidwhatwithtsql.com/discover-sql-servers-with-powershell-via-the-registry/494";s:7:"tinyurl";s:26:"http://tinyurl.com/yduzbbm";s:4:"isgd";s:18:"http://is.gd/5Ek6m";s:5:"bitly";s:20:"http://bit.ly/8u1gll";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/discover-sql-servers-with-powershell-via-the-registry/494/"
---
Chuck Boyce Jr ([blog](http://chuckboyce.blogspot.com/) | [twitter](http://twitter.com/chuckboycejr)) recently [commented](http://www.youdidwhatwithtsql.com/discover-sql-servers-with-powershell/357/comment-page-1#comment-120) on a limitation of the script from my post [Discover SQL Servers with Powershell](http://www.youdidwhatwithtsql.com/discover-sql-servers-with-powershell/357). The script does require that the [SQLBrowser](http://msdn.microsoft.com/en-us/library/ms181087.aspx) service is running for discovery to occur which may be a major issue for some. Here's an alternative method that does not have this limitation. All [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) instances should have their name registered in the following registry key **HKLM\Software\Microsoft\Microsoft SQL Server\InstalledInstances** which we can access remotely with [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx).

[![The INSTALLEDINSTANCES registry key showing SQL Servers]({{ site.baseurl }}/assets/2009/12/registry_installedinstances_thumb.png "The INSTALLEDINSTANCES registry key showing SQL Servers")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/registry_installedinstances.png)

All this script requires is that you place a text file containing computer names in your user profile folder (C:\Users\Rhys on my laptop).

```
# Text file containing computers to search for sql instances
$computers = Get-Content "$env:USERPROFILE\computers.txt";

# Check each computer for installed SQL Server
# instances by searching the registry
foreach($computer in $computers)
{
	try
	{
		$sql = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$computer).OpenSubKey('SOFTWARE\Microsoft\Microsoft SQL Server').GetValue('InstalledInstances');
		foreach($sqlserver in $sql)
		{
			if($sqlserver -eq "MSSQLSERVER") # Default instance
			{
				Write-Host -ForegroundColor Green "$computer (Default instance)";
			}
			else # Named instance
			{
				Write-Host -ForegroundColor Green "$computer\$sqlserver (Named instance)";
			}
		}
	}
	catch [System.Exception]
	{
		Write-Host -ForegroundColor Red "Error accessing $computer. " $_.Exception.Message;
	}
}
```

When you execute the script it will search each computer and list the SQL Server instances it discovered in the registry.

[![discovered sql servers]({{ site.baseurl }}/assets/2009/12/discovered_sql_servers_thumb.png "discovered sql servers")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/discovered_sql_servers.png)

If you receive the error "You cannot call a method on a null-valued expression" then that computer does not have the registry key we are searching for. In other words; no SQL Server instances are on that computer. Hopefully this method should allow you to get a more complete view of the SQL Servers in your organisation.

