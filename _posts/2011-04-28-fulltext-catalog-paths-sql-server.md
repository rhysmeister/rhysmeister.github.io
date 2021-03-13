---
layout: post
title: Get all Fulltext catalog paths on a SQL Server
date: 2011-04-28 17:32:09.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613478738'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/fulltext-catalog-paths-sql-server/1079";s:7:"tinyurl";s:26:"http://tinyurl.com/6y8hdja";s:4:"isgd";s:19:"http://is.gd/YIYCGI";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/fulltext-catalog-paths-sql-server/1079/"
---
<p>On some of our SQL Servers the<a title="Fulltext Catalog" href="http://msdn.microsoft.com/en-us/library/ms189520.aspx" target="_blank"> Fulltext catalog</a> locations are not excluded from anti-virus scans so I was after an easy way to get this information quickly. Once again <a title="Windows Powershell" href="http://en.wikipedia.org/wiki/Windows_PowerShell" target="_blank">Powershell</a> proves its worth!</p>
<p>Just change the variable <strong>$server </strong>to query a particular server. The script will list all fulltext catalogs on the instance.</p>
<pre lang="Powershell"># Specify server name
$server = "sqlserver1"
# Load smo
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;
# Create a server object with smo
$srv = New-Object Microsoft.SqlServer.Management.SMO.Server $server;
# Get databases from server
$databases = $srv.Databases;
# Iterate through each database
foreach($db in $databases)
{
	# Output the name and root path of each ft index
	$db.FullTextCatalogs | Select-Object -Property Name, RootPath;
}
</pre>
<p>The script will output something looking like below...</p>
<pre>Name			RootPath
----			--------
FullText1 F:\FT\_Catalogs\FullText1 FullText2 F:\FT\_Catalogs\FullText2 FullText3 F:\FT\_Catalogs\FullText3 FullText4 F:\FT\_Catalogs\FullText4 FullText5 F:\FT\_Catalogs\FullText5

