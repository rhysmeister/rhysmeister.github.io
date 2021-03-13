---
layout: post
title: 'SSIS in a Failover Cluster: Failed to retrieve data for this request'
date: 2011-08-01 12:22:52.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613412934'
  shorturls: a:3:{s:9:"permalink";s:89:"http://www.youdidwhatwithtsql.com/ssis-failover-cluster-failed-retrieve-data-request/1319";s:7:"tinyurl";s:26:"http://tinyurl.com/3n4z3nr";s:4:"isgd";s:19:"http://is.gd/GT9EDS";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssis-failover-cluster-failed-retrieve-data-request/1319/"
---
I got this error when attempting to expand the [msdb ssis package store](http://msdn.microsoft.com/en-us/library/ms137565.aspx "msdb ssis package store") on my recently built test cluster;

_"Failed to retrieve data for this request._

_ **Additional information:** _

_The SQL Server instance specified in SSIS service configuration is not present or available. This might occur when there is no default instance of SQL Server on the computer."_

[![ssis_cluster_error]({{ site.baseurl }}/assets/2011/08/ssis_cluster_error_thumb.png "ssis\_cluster\_error")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/SSIS-in-a-Failover-Cluster-Failed-to-ret_125DA/ssis_cluster_error.png)

We need to alter the ssis configuration file, when working in a clustered SQL Server environment, as the service is unable to find an instance of SQL to connect to. The default location of this file is **C:\Program Files\Microsoft SQL Server\100\DTS\Binn\MsDtsSrvr.ini.xml.** open the file and you will see something like below...

[![conf1]({{ site.baseurl }}/assets/2011/08/conf1_thumb.png "conf1")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/SSIS-in-a-Failover-Cluster-Failed-to-ret_125DA/conf1.png)

Change the value of **ServerName** to your SQL Server clustered instance name.

[![conf2]({{ site.baseurl }}/assets/2011/08/conf2_thumb.png "conf2")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/SSIS-in-a-Failover-Cluster-Failed-to-ret_125DA/conf2.png)

This step should be repeated on any other nodes where SSIS is running.

