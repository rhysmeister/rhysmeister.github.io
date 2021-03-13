---
layout: post
title: Auditing Network Adapters with Powershell
date: 2009-05-26 17:40:39.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- DBA
- network settings
- Powershell
- Powershell Scripting
meta:
  _edit_last: '1'
  tweetbackscheck: '1613475521'
  shorturls: a:7:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/auditing-network-adapters-with-powershell/126";s:7:"tinyurl";s:25:"http://tinyurl.com/plp44d";s:4:"isgd";s:17:"http://is.gd/QlMS";s:5:"bitly";s:19:"http://bit.ly/wUktH";s:5:"snipr";s:22:"http://snipr.com/jkk8m";s:5:"snurl";s:22:"http://snurl.com/jkk8m";s:7:"snipurl";s:24:"http://snipurl.com/jkk8m";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/auditing-network-adapters-with-powershell/126/"
---
Those boring network auditing tasks you have to do are now going to be a breeze with [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx). With technologies like [WMI](http://en.wikipedia.org/wiki/Windows_Management_Instrumentation) accessible from [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) there is virtually no limit to what you can do. I’m going to publish a series of articles showing how [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) can be used to document your server and network. First here is a [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script that can be used to document networking settings on a host.

```
# Function used for coalesce
function coalesce($param)
{
	if($param -eq $null)
	{
		$param = "<not configured>";
	}
	return $param;
}

function appendToFile
{
	param ([string]$computer, [string]$adapterLine);
	$fileName = "C:\$computer" + [string]"_" + [string]"NetworkAdapters.csv";
	# Does the file already exist?
	if(Test-Path $fileName)
	{
		# Append text to file
		Add-Content $fileName $adapterLine | Out-Null;
	}
	else
	{
		# Create the file
		New-Item $fileName -type file | Out-Null
		# Append the headers
		Add-Content $fileName "adapterName,MACAddress,ipAddress,DefaultIPGateway,DHCPEnabled,DHCPServer,DNSDomain" | Out-Null;
		# Append text to file
		Add-Content $fileName $adapterLine | Out-Null;
	}
}

# Set computer name here
$computer = "localhost";
# Set to true to show Network adapters with no configured IP address.
$showNoIP = $false;

$networkAdapters = (Get-WmiObject -Class win32_networkadapter -computername $computer);

foreach($networkAdapter in $networkAdapters)
{
	# Win32_NetworkAdapter properties
	$adapterName = coalesce($networkAdapter.Name);
	$adapterStatus = coalesce($networkAdapter.Status);
	$MACAddress = coalesce($networkAdapter.MACAddress);

	# Get the Index of the currrent adapter to retireve its configuration from another WMI class
	$adapterIndex = $networkAdapter.Index;
	$adapterConfig = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "Index = $adapterIndex AND ipenabled = 'true'" -computername $computer);

	# Win32_NetworkAdapterConfiguration properties
	$ipAddress = coalesce($adapterConfig.IPAddress);
	$DefaultIPGateway = coalesce($adapterConfig.DefaultIPGateway);
	$DHCPEnabled = coalesce($adapterConfig.DHCPEnabled);
	$DHCPServer = coalesce($adapterConfig.DHCPServer);
	$DNSDomain = coalesce($adapterConfig.DNSDomain);

	# Display info only for adapters with configured IP addresses
	if($ipAddress -ne "<not configured>" -and $showNoIP -eq $false)
	{
		$adapterLine = "$adapterName,$MACAddress,$ipAddress,$DefaultIPGateway,$DHCPEnabled,$DHCPServer,$DNSDomain";
		appendToFile -computer "$computer" -adapterLine "$adapterLine";
	}
	# Display info for all adapters
	elseif($showNoIP -eq $true)
	{
		$adapterLine = "$adapterName,$MACAddress,$ipAddress,$DefaultIPGateway,$DHCPEnabled,$DHCPServer,$DNSDomain";
		appendToFile -computer "$computer" -adapterLine "$adapterLine";
	}
}
</not></not>
```

Just change the **$computer** variable to whichever computer you wish to audit. This will produce a file called **\<computer name\>\_NetworkApaters.csv** and will contain information similar to;

| adapterName | MACAddress | ipAddress | DefaultIPGateway | DHCPEnabled | DHCPServer | DNSDomain |
| Realtek RTL8187B Wireless 802.11b/g 54Mbps USB 2.0 Network Adapter | 00:16:44:6F:FF:65 | 192.168.0.2 | 192.168.0.1 | TRUE | 192.168.0.1 | \<not configured\> |

The $ **showNoIP** is set to only show adapters configured with [TCP/IP](http://en.wikipedia.org/wiki/TCP/IP). Set this to **$true** to make the script dump details of all adapters.

It would be fairly trivial to get this script to process a list of computers to document an entire network. I have shown this in [other Powershell scripts](http://www.youdidwhatwithtsql.com/monitoring-starting-services-with-powershell/113) but will be demonstrating this again in a future post.

