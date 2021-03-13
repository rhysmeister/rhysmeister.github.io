---
layout: post
title: Powershell for Failover Clustering
date: 2011-01-23 21:58:22.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
- SQL Server
tags:
- Failover Clustering
meta:
  tweetbackscheck: '1613450198'
  twittercomments: a:1:{s:17:"29300240116879361";s:7:"retweet";}
  shorturls: a:4:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/powershell-for-failover-clustering/1060";s:7:"tinyurl";s:26:"http://tinyurl.com/68lglx8";s:4:"isgd";s:19:"http://is.gd/v5MOBG";s:5:"bitly";s:20:"http://bit.ly/eEx43Y";}
  tweetcount: '1'
  _sg_subscribe-to-comments: kg00005@freemail.hu
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershell-for-failover-clustering/1060/"
---
As it's looking increasingly likely I'll be deploying [Windows Failover Clustering](http://www.microsoft.com/windowsserver2008/en/us/failover-clustering-main.aspx "Windows Failover Clustering"), as a [HA](http://en.wikipedia.org/wiki/High_availability "High Availability") solution at work, I thought it would be prudent to swot up on a little related Powershell. I've picked out a few clustering cmdlets that will be helpful for building scripts to manage and monitor a cluster.

**First things first!**

If you leap in a little too quickly, like me, you may encounter the following error;

_"The term 'Get-Cluster' is not recognized as the name of a cmdlet, function, script file or operable program."_

For some reason the [Getting Started with Powershell on a Failover Cluster](http://technet.microsoft.com/en-us/library/ff182342(WS.10).aspx "Powershell commands for Failover Clustering") page isn't as explicit about the need to do this as it should be; You need to import the module for clustering into the Powershell session.

```
Import-Module FailoverClusters;
```

Execute this command in your console session, or add it to the top of your script file, to make the Failover clustering commands available for use.

**The [Get-Cluster](http://technet.microsoft.com/en-us/library/ee461012.aspx "Get-Cluster cmdlet") cmdlet**

<font color="#666666">This cmdlet gets information about clusters. To get the names of all the cluster in a domain we simply execute;</font>

```
Get-Cluster;
```

[![Windows Powershell command to list clusters in a domain]({{ site.baseurl }}/assets/2011/01/clusters_in_a_domain_thumb.png "Windows Powershell command to list clusters in a domain")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Powershell-for-Failover-Clustering_10CB9/clusters_in_a_domain.png)

We use the same command, with [Format-List](http://technet.microsoft.com/en-us/library/dd347700.aspx "Format-List cmdlet"),&nbsp; to get further details of a specific cluster.

```
Get-Cluster -Name "CLUSTER" | Format-List *;
```

[![WIndows Powershell showing Failover Cluster details]({{ site.baseurl }}/assets/2011/01/cluster_details_thumb.png "WIndows Powershell showing Failover Cluster details")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Powershell-for-Failover-Clustering_10CB9/cluster_details.png)

**Listing Cluster Nodes with [Get-ClusterNode](http://technet.microsoft.com/en-us/library/ee460990.aspx "Get-ClusterNode")**

This cmdlet allows us to list the nodes in the given cluster.

```
Get-ClusterNode -Cluster "CLUSTER";
```

[![Get-ClusterNode]({{ site.baseurl }}/assets/2011/01/Get-ClusterNode_thumb.png "Get-ClusterNode")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Powershell-for-Failover-Clustering_10CB9/Get-ClusterNode.png)

We can get a little more detail on our node by using the [Format-List](http://technet.microsoft.com/en-us/library/dd347700.aspx "Format-List") cmdlet;

```
Get-ClusterNode -Cluster "CLUSTER" | Format-List *;
```

[![Failover Cluster Node Details]({{ site.baseurl }}/assets/2011/01/Cluster_Node_Details_thumb.png "Failover Cluster Node Details")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Powershell-for-Failover-Clustering_10CB9/Cluster_Node_Details.png)

This shows us a few details about each node in the cluster including its State (i.e. if the node is up or down).

**List the Resource Groups in a Failover Cluster**

Using the [Get-ClusterGroup](http://technet.microsoft.com/en-us/library/ee461017.aspx "Get-ClusterGroup cmdlet") cmdlet we can list the resource groups setup in a specific cluster.

```
Get-ClusterGroup -Cluster "CLUSTER";
```

**[![Cluster Groups]({{ site.baseurl }}/assets/2011/01/Cluster_Groups_thumb.png "Cluster Groups")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Powershell-for-Failover-Clustering_10CB9/Cluster_Groups.png)**

**Moving a Resource Group in a Failover Cluster**

Sooner or later we're going to want to perform maintenance on a server that requires moving the resource groups onto another node. Cluster resource group can be easily moved with the [Move-ClusterGroup](http://technet.microsoft.com/en-us/library/ee461002.aspx "Move-ClusterGroup Powershell cmdlet") cmdlet. The next command will failover the a resource group called "ClusterDTC"

```
Move-ClusterGroup -Cluster "CLUSTER" -Name "ClusterDTC";
```

Where does this failover to? The documentation states that this method will failover a resource _"from the current owner node to any other node" ._ This is fine if you've only got a two node cluster but sometimes you may wish to be explicit. The next command achieves the same as the last but states the node to move the resource group to.

```
Move-ClusterGroup -Cluster "CLUSTER" -Name "ClusterDTC" -Node "Node2";
```

The next sequence of commands shows how you might move resources in a simple two node failover cluster.

```
Get-ClusterGroup -Cluster "CLUSTER";
Move-ClusterGroup -Cluster "CLUSTER" -Name "ClusterDTC";
Move-ClusterGroup -Cluster "CLUSTER" -Name "SQL Server (MSSQLSERVER)";
Move-ClusterGroup -Cluster "CLUSTER" -Name "Cluster Group";
Move-ClusterGroup -Cluster "CLUSTER" -Name "Available Storage";
Get-ClusterGroup -Cluster "CLUSTER";
```

[![Moving Cluster Resource Groups with Powershell]({{ site.baseurl }}/assets/2011/01/Moving_Cluster_Resources_with_Powershell_thumb.png "Moving Cluster Resource Groups with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Powershell-for-Failover-Clustering_10CB9/Moving_Cluster_Resources_with_Powershell.png)

**List the Resources in a Failover Cluster**

<font color="#666666">A cluster resource can be an application, service, storage, IP address or network name. To list the resources configured in your cluster execute the next command;</font>

```
Get-ClusterResource -Cluster "CLUSTER" | Format-Table -Autosize;
```

The cmdlet will output all of the resources in the cluster with their state and a few other details,

[![Resources in a Failover Cluster via Powershell]({{ site.baseurl }}/assets/2011/01/Cluster_Resources_thumb.png "Resources in a Failover Cluster via Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Powershell-for-Failover-Clustering_10CB9/Cluster_Resources.png)

**Testing your Failover cluster**

If you've setup a cluster then you would have used the wizard to validate the cluster configuration and setup. We can do the same thing in Powershell with the [Test-Cluster](http://technet.microsoft.com/en-us/library/ee461026.aspx "Test-Cluster Powershell cmdlet") cmdlet.

```
Test-Cluster -Cluster "CLUSTER";
```

The cmdlet will display a progress bar during the test.

[![Test-Cluster Powershell cmdlet]({{ site.baseurl }}/assets/2011/01/Test_Cluster_thumb.png "Test-Cluster Powershell cmdlet")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Powershell-for-Failover-Clustering_10CB9/Test_Cluster.png)

The cmdlet will take a few minutes to run depending on the number of Nodes in your cluster. The results will be displayed in the console once the cluster tests have completed. Some of the warnings here are due to me having a few services running at the time of the test. A full html report is generated which contains full details.

[![Test-Cluster Results]({{ site.baseurl }}/assets/2011/01/Test_Cluster_Results_thumb.png "Test-Cluster Results")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Powershell-for-Failover-Clustering_10CB9/Test_Cluster_Results.png)

I'll probably run this cmdlet periodically and email the generated html report so I can keep an eye on my cluster. Obviously judging by the output above I have a few thing to sort out on my test cluster!

I've quickly ran through a few of the cmdlets available for Windows Failover Clustering. There's over sixty related [Powershell cmdlets](http://technet.microsoft.com/en-us/library/ee461009.aspx "Powershell cmdlets for Windows Failover Clustering") available for everything from setup, failover, monitoring and management of Windows Failover Clusters. Be sure to checkout the rest.

