---
layout: post
title: Installing & Configuring a MySQL shared-storage Cluster
date: 2014-02-22 15:01:26.000000000 +01:00
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
  _edit_last: '1'
  tweetbackscheck: '1613391434'
  shorturls: a:3:{s:9:"permalink";s:90:"http://www.youdidwhatwithtsql.com/installing-configuring-mysql-sharedstorage-cluster/1790/";s:7:"tinyurl";s:26:"http://tinyurl.com/pbau4ws";s:4:"isgd";s:19:"http://is.gd/tRa3qX";}
  _wp_old_slug: installing-configuring-mysql-shared-storage-cluster
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/installing-configuring-mysql-sharedstorage-cluster/1790/"
---
This post is meant as a index of posts dealing with the installation of a shared-storage MySQL cluster running within VirtualBox. I'm learning this stuff too so don't assume this is the reference implementation. Feel free to point out any issues, or provide recommendations, and I'll update the post and give you credit.

The software used for this setup includes;

- [OpenSUSE](http://www.opensuse.org/en/ "OpenSuSE Linux") 13.1 as the host OS.
- [CentOS](http://www.centos.org/download/ "CentOS Linux") 6.5 as the MySQL Cluster Node OS.
- [VirtualBox](https://www.virtualbox.org/ "VirtualBox")&nbsp;to run the FreeNAS & CentOS components of the cluster.
- [FreeNAS](http://www.freenas.org/ "FreeNAS Shared Storage") 9.1.1 to provide the shared-storage.
- [MySQL](http://dev.mysql.com/downloads/ "MySQL Database Engine") 5.6.16.

Links will be provided to the posts as they are published and may change as this project progresses.

1. [Installing VirtualBox & FreeNAS.](http://www.youdidwhatwithtsql.com/installing-freenas-virtualbox-opensuse/1779/ "Installing VirtualBox & FreeNAS")
2. Planning the cluster configuration.
3. [Configuring FreeNAS](http://www.youdidwhatwithtsql.com/freenas-configuration/1842/ "Configuring FreeNAS").
4. [Creating & Installing the CentOS cluster nodes](http://www.youdidwhatwithtsql.com/creating-installing-centos-cluster-nodes-2/1804/ "Creating and installing CentOS Cluster Nodes").
5. [Linux Cluster Node Configuration](http://www.youdidwhatwithtsql.com/linux-cluster-node-configuration/1852/).
6. [Adding an ISCSI volume to the nodes](http://www.youdidwhatwithtsql.com/adding-iscsi-volume-nodes/1857/).
7. Installing & Configuring the cluster.
8. Installing & Configuring MySQL.
9. Testing the cluster.
10. Ideas for further development.
