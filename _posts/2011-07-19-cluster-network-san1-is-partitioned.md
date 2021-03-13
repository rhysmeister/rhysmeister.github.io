---
layout: post
title: Cluster network 'SAN1' is partitioned
date: 2011-07-19 07:42:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
tags:
- Failover Clustering
meta:
  tweetbackscheck: '1613471887'
  shorturls: a:3:{s:9:"permalink";s:74:"http://www.youdidwhatwithtsql.com/cluster-network-san1-is-partitioned/1288";s:7:"tinyurl";s:26:"http://tinyurl.com/3htw4aq";s:4:"isgd";s:19:"http://is.gd/7NoEI1";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: smets.tom@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/cluster-network-san1-is-partitioned/1288/"
---
You may encounter this error, about your storage networks, when setting up your Windows 2008 Failover Cluster. The following errors, [Event ID 1129](http://technet.microsoft.com/en-us/library/cc756235(WS.10).aspx "Event ID 1129"), will show up in [Cluster Events](http://technet.microsoft.com/en-us/library/cc772342.aspx)...

_Cluster network 'SAN1' is partitioned. Some attached failover cluster nodes cannot communicate with each other over the network. The failover cluster was not able to determine the location of the failure. Run the Validate a Configuration wizard to check your network configuration. If the condition persists, check for hardware or software errors related to the network adapter. Also check for failures in any other network components to which the node is connected such as hubs, switches, or bridges._

and...

_Cluster network interface 'Node1 - SAN1' for cluster node 'Node1' on network 'SAN1' is unreachable by at least one other cluster node attached to the network. The failover cluster was not able to determine the location of the failure. Run the Validate a Configuration wizard to check your network configuration. If the condition persists, check for hardware or software errors related to the network adapter. Also check for failures in any other network components to which the node is connected such as hubs, switches, or bridges._

The [suggested fixes](http://technet.microsoft.com/en-us/library/cc756235(WS.10).aspx "Suggested fixes for Event ID 1129") didn't make sense to me as this was a storage network and of course the Nodes can't (shouldn't) communicate via these networks. As it turns out it's a simple configuration change to tell the cluster that node communication is not allowed on this network.

In [Failover Cluster Manager](http://technet.microsoft.com/en-us/library/cc772502.aspx "Failover Cluster Manager") expand the cluster and select 'Networks'. Right click the appropriate storage network and select 'Properties'.

Choose the "Do not allow cluster network communication on this network" option.

[![san_cluster_network]({{ site.baseurl }}/assets/2011/07/san_cluster_network_thumb.png "san\_cluster\_network")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Cluster-network-Cluster-Network-3-is-par_11E17/san_cluster_network.png)

Repeat for any other appropriate networks and you should stop seeing this error in the logs.

