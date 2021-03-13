---
layout: post
title: Unable to start Cluster Service on One Node
date: 2011-01-29 20:09:28.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
- Windows
tags:
- Clustering
meta:
  shorturls: a:4:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/unable-to-start-cluster-service-on-one-node/1066";s:7:"tinyurl";s:26:"http://tinyurl.com/64jxu9c";s:4:"isgd";s:19:"http://is.gd/w3Exrl";s:5:"bitly";s:20:"http://bit.ly/eNDYrs";}
  tweetbackscheck: '1613464373'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/unable-to-start-cluster-service-on-one-node/1066/"
---
A [Windows Failover Cluster](http://www.microsoft.com/windowsserver2008/en/us/failover-clustering-main.aspx) demo I gave a work failed horribly when the same demo the previous week went perfectly. A case of [Sod's Law](http://en.wikipedia.org/wiki/Sod's_law "Sod's Law"). For some reason one of the nodes wouldn't join the cluster. So I was unable to demo the failover process.

I first tried starting the cluster service on the dead node.

Server Manager \> Features \> Failover Cluster Manager \> ClusterName \> Nodes \> Node1

Right Click \> More Actions \> Start Cluster Service. This failed with the following error;

[![Could not start the Cluster Service The Handle is Invalid error]({{ site.baseurl }}/assets/2011/01/could_not_start_the_cluster_service_thumb.png "Could not start the Cluster Service The Handle is Invalid error")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/25b1a469638c_10CC9/could_not_start_the_cluster_service.png)

Checking the cluster event log I found the following errors;

**Event Id: 1069**

Cluster resource 'Cluster Disk 4' in clustered service or application 'Cluster Group' failed.

**Event Id: 1570**

Node 'Node1' failed to establish a communication session while joining the cluster. This was due to an authentication failure. Please verify that the nodes are running compatible versions of the cluster service software.

**Event Id: 1573**

Node 'Node1' failed to form a cluster. This was because the witness was not accessible. Please ensure that the witness resource is online and available.

Next I thought I'd [validate the node](http://technet.microsoft.com/en-us/library/cc732035(WS.10).aspx "Validate a cluster") using the wizard. When trying to add the the other node to the list of wizard to check it would immediately fail with the error "OpenService RemoteRegistry failed". Google suggestions included checking that the RemoteRegistry service was running, checking for any AD user accounts matching computer names, and for firewall issues. All of these checked out so, running out of ideas, I rebooted both cluster nodes.

Once both nodes were back up the cluster was running on the other node! So clearly there was nothing wrong with the nodes themselves. Rather, the issue was due to something between them. I attempted to access the other node with a [unc path](http://en.wikipedia.org/wiki/Path_(computing) "Windows unc path") in explorer.

[![node1 is not accessible]({{ site.baseurl }}/assets/2011/01/node1_is_not_accessible_thumb.png "node1 is not accessible")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/25b1a469638c_10CC9/node1_is_not_accessible.png)

OK! Interesting! I checked the date and time on both server nodes and my domain controller and all were perfectly in sync. Just to double confirm I synchronised the cluster nodes clocks with the following command.

```
net time /domain:YourDomain /set
```

This appeared to have no effect on my problem at all. Finally I had the sense to check the time zone of my domain controller which revealed it was set to eastern United States (I'm in the UK) and my cluster nodes were get to GMT.

After I changed the domain controllers time zone to [GMT](http://en.wikipedia.org/wiki/Greenwich_Mean_Time), rebooted both nodes and the domain controller (wouldn't work before doing this), my cluster was finally running happily again. I was able to failover clustered services and applications between nodes. Time to get ready for another successful demo next week!

