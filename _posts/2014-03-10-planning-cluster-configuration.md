---
layout: post
title: Planning the cluster configuration
date: 2014-03-10 18:24:21.000000000 +01:00
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
- Clustering
- Linux
meta:
  tweetbackscheck: '1613268801'
  shorturls: a:3:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/planning-cluster-configuration/1796/";s:7:"tinyurl";s:26:"http://tinyurl.com/qcmy9pt";s:4:"isgd";s:19:"http://is.gd/M9MLW1";}
  _edit_last: '1'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/planning-cluster-configuration/1796/"
---
This post is part of a series that will deal with [setting up a MySQL shared storage cluster](http://www.youdidwhatwithtsql.com/installing-configuring-mysql-sharedstorage-cluster/1790/ "MySQL Shared Storage Cluster") using VirtualBox & FreeNAS. In this post we specify some brief details of the cluster configuration. Please note this post will be updated in the near future.

[![Linux Cluster Network]({{ site.baseurl }}/assets/2014/03/Diagram1.jpeg)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/Diagram1.jpeg)

&nbsp;

[table param1="param-value1" param2="param-value2"]  
Component,Host Name, Public IP, Private IP,SAN IP  
FreeNAS Storage, freenas.domain.co.uk, 192.168.1.103, NA,192.168.3.100/24  
Node 1, node1.domain.co.uk, 192.168.1.101/24, 192.168.2.1/24, 192.168.3.2/24  
Node 2, node2.domain.co.uk, 192.168.1.102/24, 192.168.2.2/24, 192.168.3.3/24  
Cluster, cluster.domain.co.uk, 192.168.1.110/24,NA,NA  
[/table]

