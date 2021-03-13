---
layout: post
title: 'Quick Linux Tip: rpm query & xclip'
date: 2012-03-07 18:42:36.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Linux
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613203888'
  _wp_old_slug: quick-linux-tip-xclip
  shorturls: a:3:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/quick-linux-tip-rpm-query-xclip/1460";s:7:"tinyurl";s:26:"http://tinyurl.com/7qphyoe";s:4:"isgd";s:19:"http://is.gd/6w6lW4";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/quick-linux-tip-rpm-query-xclip/1460/"
---
I'm working on a script to do some basic auditing of my Linux servers. One thing I want to record is the install details from an rpm query. The following command will provide us with some basic details of the rpms installed and ordered by date.

```
rpm -qa --queryformat '%{NAME} %{VERSION} %{INSTALLTIME:date}\n' --last;
```

Output will look something like below...

```
xclip-0.11-11.1.3 Wed 07 Mar 2012 18:15:13 GMT
splunk-4.3-115073 Thu 26 Jan 2012 15:51:36 GMT
glibc-devel-32bit-2.14.1-14.18.1 Thu 26 Jan 2012 15:40:04 GMT
glibc-devel-2.14.1-14.18.1 Thu 26 Jan 2012 15:40:03 GMT
glibc-locale-2.14.1-14.18.1 Thu 26 Jan 2012 15:39:58 GMT
busybox-1.18.3-5.1.3 Thu 26 Jan 2012 15:39:38 GMT
glibc-2.14.1-14.18.1 Thu 26 Jan 2012 15:39:35 GMT
glibc-32bit-2.14.1-14.18.1 Thu 26 Jan 2012 15:39:32 GMT
MozillaFirefox-translations-common-9.0.1-1.1 Thu 12 Jan 2012 14:44:46 GMT
mozilla-nss-devel-3.13.1-5.1 Thu 12 Jan 2012 14:44:25 GMT
MozillaFirefox-9.0.1-1.1 Thu 12 Jan 2012 14:44:17 GMT
libsoftokn3-3.13.1-5.1 Thu 12 Jan 2012 14:44:03 GMT
mozilla-nss-3.13.1-5.1 Thu 12 Jan 2012 14:44:02 GMT
MozillaFirefox-branding-openSUSE-5.0-15.1 Thu 12 Jan 2012 14:44:00 GMT
libfreebl3-3.13.1-5.1 Thu 12 Jan 2012 14:43:59 GMT
mozilla-nss-certs-3.13.1-5.1 Thu 12 Jan 2012 14:43:57 GMT
mysql-workbench-5.1.16-2.3.5 Tue 01 Nov 2011 14:28:47 GMT
mozilla-nspr-devel-4.8.9-2.1 Mon 31 Oct 2011 13:58:58 GMT
mozilla-nspr-4.8.9-2.1 Mon 31 Oct 2011 13:58:49 GMT
MySQL-server-5.5.15-1.linux2.6 Tue 30 Aug 2011 13:23:44 BST
```

I'm auditing a bunch of servers and handling a lot of output in a console windows can be a pain. That's where [xclip](http://sourceforge.net/projects/xclip/ "xclip") can come in. Just pipe the output to xcip and everything will get copied to your hosts clipboard to paste into your reports;

```
rpm -qa --queryformat '%{NAME} %{VERSION} %{INSTALLTIME:date}\n' --last | xclip;
```
