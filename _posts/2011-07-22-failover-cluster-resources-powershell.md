---
layout: post
title: Failover All Cluster Resources With Powershell
date: 2011-07-22 13:03:45.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Failover Clustering
- Powershell
meta:
  _edit_last: '1'
  tweetbackscheck: '1612918192'
  shorturls: a:3:{s:9:"permalink";s:76:"http://www.youdidwhatwithtsql.com/failover-cluster-resources-powershell/1309";s:7:"tinyurl";s:26:"http://tinyurl.com/3mhze96";s:4:"isgd";s:19:"http://is.gd/CeDy2X";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/failover-cluster-resources-powershell/1309/"
---
<p>Here's a simple example showing how to manage the <a title="Windows Failover Clustering" href="http://www.microsoft.com/windowsserver2008/en/us/failover-clustering-main.aspx" target="_blank">failover</a> process with <a title="Windows Powershell" href="http://en.wikipedia.org/wiki/Windows_PowerShell" target="_blank">Powershell</a>, making sure all resources are running on one node. First, execute the below command to show which node owns the resources.</p>
<pre lang="Powershell">Get-ClusterGroup -Cluster ClusterName | Format-Table -AutoSize;</pre>
<pre>Name              OwnerNode     State
----              ---------     -----
SoStagSQL20Dtc    Node1 	Online
SQL Server        Node1 	Online
Cluster Group     Node1 	Online
Available Storage Node1 	Online</pre>
<p>In this example all services are currently running on Node1. It's a simple <a title="Windows Powershell" href="http://en.wikipedia.org/wiki/Windows_PowerShell" target="_blank">Powershell</a> one-liner to failover everything to another node. The following example assumes a 2 node cluster and all services will be failed over to the other node;</p>
<pre lang="Powershell">Get-ClusterNode -Cluster ClusterName -Name Node1 | Get-ClusterGroup | Move-ClusterGroup | Format-Table -Autosize;</pre>
<p>All services are now running on Node2</p>
<pre>Name			OwnerNode	State
----			---------	-----
SoStagSQL20Dtc Node2 Online SQL Server Node2 Online Cluster Group Node2 Online Available Storage Node2 Online

If you have more than 2 nodes in the cluster you can use the -Name parameter of the [Move-ClusterGroup](http://technet.microsoft.com/en-us/library/ee461002.aspx "Windows Powershell Move-ClusterGroup cmdlet")&nbsp;to specify a node to move resources to.

```
Get-ClusterNode -Cluster ClusterName -Name Node1 | Get-ClusterGroup | Move-ClusterGroup -Name Node2 | Format-Table -Autosize;
```

You may also like

[Powershell for Failover Clustering](http://www.youdidwhatwithtsql.com/powershell-for-failover-clustering/1060 "Powershell For Failover Clustering")  
[Unable to start Cluster Service on one Node](http://www.youdidwhatwithtsql.com/unable-to-start-cluster-service-on-one-node/1066 "Unable to start Cluster Service on one Node")  
[Cluster Network 'SAN1' is Partitioned](http://www.youdidwhatwithtsql.com/cluster-network-san1-is-partitioned/1288 "Cluster Network 'SAN1' is Partitioned")

