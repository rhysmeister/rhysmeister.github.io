---
layout: post
title: Hadoop VersionInfo Issue on OpenSuSE 12
date: 2013-01-26 20:06:16.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Big Data
tags:
- Hadoop
meta:
  shorturls: a:3:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/hadoop-versioninfo-issue-on-opensuse-12/1532";s:7:"tinyurl";s:26:"http://tinyurl.com/a3epsp2";s:4:"isgd";s:19:"http://is.gd/vPZXD2";}
  tweetbackscheck: '1613461679'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/hadoop-versioninfo-issue-on-opensuse-12/1532/"
---
I was getting the following error when attempting to run **hadoop version.**

```
The java class is not found: org.apache.hadoop.util.VersionInfo
Unable to determine Hadoop version information.
'hadoop version' returned:
The java class is not found: org.apache.hadoop.util.VersionInfo
```

This was due to having the [OpenJDK](http://openjdk.java.net/) installed rather than the one from Sun/Oracle. To resolve this simply uninstall the openjdk packages...

```
sudo zypper remove java
```

Download one of the [Sun/Oracle java packages](http://www.oracle.com/technetwork/java/javase/downloads/index.html) for your platform. I installed it with...

```
sudo rpm -iv jdk-7u11-linux-x64.rpm
```

I also had to set my java home to **/usr**. Remember to set this is your .profile or somewhere else appropriate. Now when I run **hadoop version** I get...

```
Hadoop 2.0.2-alpha
Subversion https://svn.apache.org/repos/asf/hadoop/common/branches/branch-2.0.2-alpha/hadoop-common-project/hadoop-common -r 1392682
Compiled by hortonmu on Tue Oct  2 00:44:10 UTC 2012
From source with checksum efbdb59af73bfc103f1945d65dbf3071
```

Happy Hadoop'ing!

