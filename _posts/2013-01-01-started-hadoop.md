---
layout: post
title: Getting started with Hadoop
date: 2013-01-01 21:51:21.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Big Data
tags: []
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:53:"http://www.youdidwhatwithtsql.com/started-hadoop/1520";s:7:"tinyurl";s:26:"http://tinyurl.com/amv2zdj";s:4:"isgd";s:19:"http://is.gd/9dVRNL";}
  tweetbackscheck: '1613450365'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/started-hadoop/1520/"
---
I wanted to get started playing about with [Hadoop](http://hadoop.apache.org/)&nbsp;but had trouble installing [Cloudera's CDH](http://www.cloudera.com/content/cloudera/en/products/cdh.html "Cloudera CDH"). As I only wanted to have a working version of Hadoop for development purposes I decided to skip using Cloudera's distribution and go direct to the [Apache Hadoop release](http://hadoop.apache.org/releases.htm). Here's the process I went through to set it up on OpenSuSE 12.1.

You need Java version 1.6 so check this before you get started

```
>java version
```

```
java version "1.6.0_22" OpenJDK Runtime Environment (IcedTea6 1.10.4) (suse-1.2-x86_64) OpenJDK 64-Bit Server VM (build 20.0-b11, mixed mode)
```

To get started download and extract the hadoop tar file.

```
wget http://mirror.lividpenguin.com/pub/apache/hadoop/common/stable/hadoop-1.0.4.tar.gz;
tar xzf hadoop-1.0.4.tar.gz;
```

Set the PATH variable and then check hadoop works...

```
export HADOOP_INSTALL=/home/rhys/hadoop-1.0.4;
export PATH=$PATH:$HADOOP_INSTALL/bin;
hadoop version;
```

After a few moments you should see something like below;

```
Hadoop 1.0.4
Subversion https://svn.apache.org/repos/asf/hadoop/common/branches/branch-1.0 -r 1393290
Compiled by hortonfo on Wed Oct 3 05:13:58 UTC 2012 From source with checksum fe2baea87c4c81a2c505767f3f9b71f4
```

If you want this to persist through reboots then edit your .profile file.

```
vi .profile;
# Add the following two lines, changing the HADOOP_INSTALL path as appropriate.
export HADOOP_INSTALL=/home/rhys/hadoop-1.0.4;
export PATH=$PATH:$HADOOP_INSTALL/bin;
```

It's easy enough to run multiple versions of Hadoop side-by-side. Just make sure you change the PATH variable.

```
wget http://mirror.lividpenguin.com/pub/apache/hadoop/common/hadoop-2.0.2-alpha/hadoop-2.0.2-alpha.tar.gz
tar xzf hadoop-2.0.2-alpha.tar.gz;
```

Update your PATH variable and execute the hadoop command...

```
NEWPATH=`echo $PATH | sed 's/hadoop-1.0.4/hadoop-2.0.2-alpha/g'`;
export PATH=$NEWPATH;
hadoop version
```

Confirm the version is correct.

```
Hadoop 2.0.2-alpha
Subversion https://svn.apache.org/repos/asf/hadoop/common/branches/branch-2.0.2-alpha/hadoop-common-project/hadoop-common -r 1392682
Compiled by hortonmu on Tue Oct 2 00:44:10 UTC 2012 From source with checksum efbdb59af73bfc103f1945d65dbf3071
```

By default Hadoop will be configured to run in Standalone mode so there's no configuration files to edit. This is ideal for development of MapReduce programs.

