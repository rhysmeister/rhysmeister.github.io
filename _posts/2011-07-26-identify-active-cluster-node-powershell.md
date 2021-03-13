---
layout: post
title: Identify the Active Cluster Node with Powershell
date: 2011-07-26 14:24:26.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
tags:
- Failover Clustering
- Powershell
meta:
  _edit_last: '1'
  _aioseop_description: How to identify the current active node in a SQL Server Cluster
    with Powershell.
  _aioseop_title: Identify the Active Cluster Node with Powershell
  shorturls: a:3:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/identify-active-cluster-node-powershell/1315";s:7:"tinyurl";s:26:"http://tinyurl.com/3u4bxlx";s:4:"isgd";s:19:"http://is.gd/BngUW2";}
  tweetbackscheck: '1613461444'
  twittercomments: a:2:{i:96245944609292289;s:7:"retweet";i:96233696490823681;s:7:"retweet";}
  tweetcount: '3'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/identify-active-cluster-node-powershell/1315/"
---
I wanted to find a way of programatically identifying the active node of a SQL Server Cluster. I found this post that demonstrated [how to do it with TSQL](http://sql.richarddouglas.co.uk/archive/2010/03/identifying-the-active-cluster-node.html). As I love [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell "Windows Powershell") so much here's another method to do it;

```
# Set cluster name
$cluster_name = "ClusterName";
# Load SMO extension
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null;
$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $cluster_name;
# Get server properties
$properties = $srv.Properties
$owner_node = $properties.Item("ComputerNamePhysicalNetBIOS").Value;
$is_clustered = $properties.Item("IsClustered").Value
if($is_clustered)
{
	Write-Host "The current active node of $cluster_name is $owner_node.";
}
else
{
	Write-Host "$cluster_name is not a clustered instance of SQL Server.";
}
```

Execute against your cluster and it will tell you which is the current active node.

```
The current active node of ClusterName is Node1.
```

It will also tell you if the instance you're executing against isn't a cluster.

```
NotACluster is not a clustered instance of SQL Server.
```
