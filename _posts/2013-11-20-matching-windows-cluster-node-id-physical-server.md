---
layout: post
title: Matching windows cluster node ID to physical server
date: 2013-11-20 09:34:14.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
- Windows
tags: []
meta:
  shorturls: a:3:{s:9:"permalink";s:88:"http://www.youdidwhatwithtsql.com/matching-windows-cluster-node-id-physical-server/1720/";s:7:"tinyurl";s:26:"http://tinyurl.com/nvqp5zk";s:4:"isgd";s:19:"http://is.gd/A8aFXi";}
  _edit_last: '1'
  tweetbackscheck: '1613475523'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/matching-windows-cluster-node-id-physical-server/1720/"
---
<p>Here's the <a title="Windows Powershell" href="http://technet.microsoft.com/en-us/library/bb978526.aspx" target="_blank">Powershell</a> version of matching the node number in Cluster.Log files to the actual cluster node names. Essentially log messages like this one...</p>
<pre>ERROR_CLUSTER_GROUP_MOVING(5908)' because of ''Cluster Disk' is owned by node 1, not 2.'</pre>
<p>Inspired by this <a title="Cluster.exe Node Number Name" href="http://www.leaf-node.co.uk/2012/01/matching-windows-cluster-node-id-to-physical-server/" target="_blank">post using cluster.exe</a>.</p>
<pre lang="Powershell">Get-ClusterNode -Cluster ClusterName | SELECT Name, Id, State | Format-Table -Autosize;</pre>
<p>Output will look something like below...</p>
<pre>Name         Id                                   State
----         --                                   -----
clusternode1 00000000-0000-0000-0000-000000000001 Up clusternode2 00000000-0000-0000-0000-000000000002 Up

