---
layout: post
title: Adding ISCSI volumes to the nodes
date: 2014-03-10 22:47:09.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Linux
- MySQL
tags: []
meta:
  twittercomments: a:0:{}
  _edit_last: '1'
  tweetbackscheck: '1613246994'
  shorturls: a:3:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/adding-iscsi-volume-nodes/1857/";s:7:"tinyurl";s:26:"http://tinyurl.com/omwzb7a";s:4:"isgd";s:19:"http://is.gd/4aTp47";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/adding-iscsi-volume-nodes/1857/"
---
This post is part of a series that will deal with [setting up a MySQL shared storage cluster](http://www.youdidwhatwithtsql.com/installing-configuring-mysql-sharedstorage-cluster/1790/ "Installing & Configuring a shared-storage MySQL Cluster") using VirtualBox & [FreeNAS](http://www.freenas.org/ "FreeNAS"). In this post we deal with the setup of an iscsi volume on two nodes. The text in bold below represent commands to be executed in the shell.

- **yum install iscsi-initiator-utils**
- **iscsiadm -m discovery -t st -p 192.168.3.100** \<- This command should show the LUNs advertised by FreeNAS.

[![iscsi_discovery]({{ site.baseurl }}/assets/2014/03/iscsi_discovery.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/03/iscsi_discovery.png)

- **/etc/init.d/iscsi restart**
- **fdisk -l**  **| grep Disk** \<- This should show new devices that are available. In this case it's /dev/sdb and /dev/sdc
- **mkfs.ext3 /dev/sdb** \<- Format device.
- Repeat all steps, apart from the mkfs.ext3 command, for node2.
