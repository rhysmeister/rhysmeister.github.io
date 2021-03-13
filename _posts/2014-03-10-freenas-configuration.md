---
layout: post
title: FreeNAS Configuration
date: 2014-03-10 22:03:40.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Linux
- MySQL
tags:
- FreeNAS
meta:
  _edit_last: '1'
  tweetbackscheck: '1612947006'
  shorturls: a:3:{s:9:"permalink";s:61:"http://www.youdidwhatwithtsql.com/freenas-configuration/1842/";s:7:"tinyurl";s:26:"http://tinyurl.com/pj48kd3";s:4:"isgd";s:19:"http://is.gd/durwAB";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/freenas-configuration/1842/"
---
This post is part of a series that will deal with [setting up a MySQL shared storage cluster](http://www.youdidwhatwithtsql.com/installing-configuring-mysql-sharedstorage-cluster/1790/ "MySQL Shared Storage Cluster") using VirtualBox & FreeNAS. This post deals with the configuration of FreeNAS.

Fire up VirtualBox and go into FreeNAS \> Settings \> Storage. Add a SCSI controller with a 2GB disk.

[![1 - ISCSI Storage FreeNAS]({{ site.baseurl }}/assets/2014/03/1-ISCSI-Storage-FreeNAS.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/1-ISCSI-Storage-FreeNAS.png)

Added a second disk 1GB in size. This will become the cluster quorum drive.

[![VirtualBox_Quorum]({{ site.baseurl }}/assets/2014/03/VirtualBox_Quorum.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/VirtualBox_Quorum.png)

Go to the Network settings section and enable a second interface. You should have two enabled in total both attached to "Bridged Adapter".

[![2 - Network Connections FreeNAS]({{ site.baseurl }}/assets/2014/03/2-Network-Connections-FreeNAS.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/2-Network-Connections-FreeNAS.png)

Boot the FreeNAS VM and login when prompted. You should see a screen similar to below.

[![3 - FreeNAS Configuration Menu]({{ site.baseurl }}/assets/2014/03/3-FreeNAS-Configuration-Menu.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/3-FreeNAS-Configuration-Menu.png)

Enter '1' to begin the network interface configuration. You should have two interface called em0 and em1. Configure them with the following details.

em0

192.168.3.100/24

em1

192.168.1.103/24

An example configuration is shown below...

[![4 - FreeNAS Network Configuration]({{ site.baseurl }}/assets/2014/03/4-FreeNAS-Network-Configuration.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/4-FreeNAS-Network-Configuration.png)

After the changes have been saved choose option 10 to reboot.

[![5 - FreeNAS Reboot]({{ site.baseurl }}/assets/2014/03/5-FreeNAS-Reboot.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/5-FreeNAS-Reboot.png)

After the host has rebooted point your browser at http://192.168.1.103 and you should see the FreeNAS login screen.

[![6 - FreeNAS Web Login]({{ site.baseurl }}/assets/2014/03/6-FreeNAS-Web-Login.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/6-FreeNAS-Web-Login.png)

Most of the SAN configuration we'll perform in the web interface.

1. First active iSCSI in Services \> Control Services. First iSCSI in the list and change the slider to ON.
2. Add an initator. iSCSI \> Initiators \> Add Initiator. Go with the defaults.
3. Add a Portal. iSCSI \> Portals \> Add Portal. The IP Address should be 192.168.3.100 and the port 3260.
4. Add target - set portal and initiator ids, auth method = None (CHAP recommend but not covered here).
5. Add an extent. iSCSI \> Extents \> Add Extent. Enter the following details

[![data_extent]({{ site.baseurl }}/assets/2014/03/data_extent.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/data_extent.png)

6. Add a target. iSCSI \> Targets \> Add Target

[![data_target]({{ site.baseurl }}/assets/2014/03/data_target.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/data_target.png)

7. Add Targets/Extents. iSCSI \> Targets / Extents \> Add Target / Extent.

[![target_extent]({{ site.baseurl }}/assets/2014/03/target_extent.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/target_extent.png)

8. Next we'll setup the Quorum drive. iSCSI \> Extents \> Add Extent. Enter the following details.

[![quorum_extent]({{ site.baseurl }}/assets/2014/03/quorum_extent.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/quorum_extent.png)

9. iSCSI \> Targets \> Add Target.

[![quorum_target]({{ site.baseurl }}/assets/2014/03/quorum_target.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/quorum_target.png)

10. iSCSI \> Targets / Extents \> Add Target / Extent.

[![quorum_target_extent]({{ site.baseurl }}/assets/2014/03/quorum_target_extent.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/quorum_target_extent.png)

&nbsp;

