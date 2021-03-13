---
layout: post
title: What does disk maintenance mode actually do to a Failover Cluster?
date: 2013-11-14 18:56:37.000000000 +01:00
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
- failover cluster
- Failover Clustering
- maintenance mode
- SQL Server 2008 R2
- Windows 2008
meta:
  _edit_last: '1'
  tweetbackscheck: '1613463874'
  shorturls: a:3:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/disk-maintenance-mode-failover-cluster/1713/";s:7:"tinyurl";s:26:"http://tinyurl.com/o8ck2zg";s:4:"isgd";s:19:"http://is.gd/0GsEqF";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/disk-maintenance-mode-failover-cluster/1713/"
---
In Failover Cluster Manager if you perform the following sequence of actions...

Storage \> Right Click a Disk \> More Actions... \> Turn on maintenance for this disk

You are presented with the following message in the status bar.

```
Turning on maintenance for a physical disk resource allows the disk to be used by applications like chkdsk, but not by highly available services and applications.
```

[caption id="attachment\_1714" align="alignnone" width="851"][![failover cluster disk maintenance]({{ site.baseurl }}/assets/2013/11/failover_cluster_disk_maintenance-e1384455667183.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2013/11/failover_cluster_disk_maintenance-e1384455667183.png) failover cluster disk maintenance[/caption]

Not sure about you but I found this message a little alarming. What will this do? Will the clustered instance of SQL Server running on his server suddenly be unable to access these disks. The answer here is no. Putting disks into maintenance mode will not stop SQL from using them but certain administrative actions might do. For example performing **chkdsk /f** would perform an exclusive lock on the disk.

Putting the disk into maintenance mode simply disables a few disk checks the cluster service performs. Without these checks disabled the actions performed on the disk may trigger a failover (which is probably undesirable for performing maintenance on disks). AS far as I gather the following checks are performed;

> File system level checks  
> At the file system level, the Physical Disk resource type performs the following checks:  
> LooksAlive  
> By default, a brief check is performed every 5 seconds to verify that a disk is still available. The LooksAlive check determines whether a resource flag is set. This flag indicates that a device has failed. For example, a flag may indicate that periodic reservation has failed. The frequency of this check is user definable.  
> IsAlive  
> A complete check is performed every 60 seconds to verify that the disk and the file system, or systems, can be accessed. The IsAlive check effectively performs the same functionality as a dir command that you type at a command prompt. The frequency of this check is user definable.  
> Device level checks  
> At the device level, the Clusdisk.sys driver performs the following checks:  
> SCSI Reserve  
> Every 3 seconds, a SCSI Reserve command is sent to the LUN to make sure that only the owning node has ownership and can access that drive.  
> Private Sector  
> Every 3 seconds, the Clusdisk.sys driver performs a read and write operation to sector 12 on the LUN to make sure that the device is writeable. [source](http://support.microsoft.com/kb/903650)

Disk can be put into maintenance mode using the Failover Cluster Manager or the [Suspend-ClusterResource](http://technet.microsoft.com/en-us/library/ee460986.aspx "Suspend Cluster Resource Powershell") powershell cmdlet.

This applies to a Windows Server 2008 R2 Enterprise Failover Cluster providing clustered SQL Server 2008 R2.

