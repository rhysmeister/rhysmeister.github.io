---
layout: post
title: Testing a Failover Cluster with Powershell
date: 2011-11-03 11:26:22.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
tags:
- failover cluster
- Powershell
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461415'
  shorturls: a:3:{s:9:"permalink";s:74:"http://www.youdidwhatwithtsql.com/testing-failover-cluster-powershell/1377";s:7:"tinyurl";s:26:"http://tinyurl.com/3zc94sl";s:4:"isgd";s:19:"http://is.gd/6PqBlp";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/testing-failover-cluster-powershell/1377/"
---
<p>Just a quick <a title="Windows Powershell" href="http://en.wikipedia.org/wiki/Windows_PowerShell" target="_blank">Powershell</a> snippet that I'm going to use to run validation tests on one of my staging Failover Clusters during OOH.</p>
<p>The script below will take some services offline, run the validation tests, before bringing the appropriate cluster groups back online. The report will be saved using the date as the name. To use this you will need to set <strong>$cluster</strong> appropriately and perhaps customize the cluster groups that are brought offline &amp; online.</p>
<pre lang="Powershell">Import-Module FailoverClusters;

# Set cluster name
$cluster = "Cluster";

# Date stamp used for report name
$date = Get-Date -Format "yyyyMMdd";

# Take cluster services offline. You may need to customise this
# according to your specific needs
Stop-ClusterGroup -Cluster $cluster -Name "ClusterDtc";
Stop-ClusterGroup -Cluster $cluster -Name "SQL Server (MSSQLSERVER)";

# Test Cluster
Test-Cluster -Cluster $cluster -ReportName "$date";

# Bring services back online
Start-ClusterGroup -Cluster $cluster -Name "ClusterDtc";
Start-ClusterGroup -Cluster $cluster -Name "SQL Server (MSSQLSERVER)";</pre>
<p>The output will look something like below...</p>
<pre>Name                       OwnerNode                                      State
----                       ---------                                      -----
ClusterDtc Node1 Offline SQL Server (MSSQLSERVER) Node1 Offline WARNING: Cluster Configuration - Validate Resource Status: The test reported some warnings.. WARNING: Network - Validate IP Configuration: The test reported some warnings.. WARNING: Test Result: ClusterConditionallyApproved Testing has completed successfully. The configuration appears to be suitable for clustering. However, you should review the report because it may contain warnings which you should address to attain the highest availability. Test report file path: C:\Users\ClusterAdmin\AppData\Local\Temp\20111103.mht 20111103.mht ClusterDtc Node1 Online SQL Server (MSSQLSERVER) Node1 Online

