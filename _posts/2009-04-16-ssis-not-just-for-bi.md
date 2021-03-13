---
layout: post
title: 'SSIS: Not just for BI'
date: 2009-04-16 12:46:33.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SSIS
tags:
- ETL
- Script Component
- SSIS
meta:
  tweetbackscheck: '1613369965'
  twittercomments: a:0:{}
  shorturls: a:7:{s:9:"permalink";s:57:"http://www.youdidwhatwithtsql.com/ssis-not-just-for-bi/63";s:7:"tinyurl";s:25:"http://tinyurl.com/cp4rf2";s:4:"isgd";s:17:"http://is.gd/vbce";s:5:"bitly";s:19:"http://bit.ly/UzcAa";s:5:"snipr";s:22:"http://snipr.com/gxtvz";s:5:"snurl";s:22:"http://snurl.com/gxtvz";s:7:"snipurl";s:24:"http://snipurl.com/gxtvz";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssis-not-just-for-bi/63/"
---
[SSIS](http://msdn.microsoft.com/en-us/library/ms141026.aspx) can offer you more than just simple [ETL](http://en.wikipedia.org/wiki/Extract,_transform,_load). Even though I dislike [VB.Net](http://en.wikipedia.org/wiki/Visual_Basic_.NET) its inclusion in SSIS allows you to do virtually anything you can think of. I’ve used SSIS for testing other bits of software, categorising keyword and search terms, and monitoring Windows Servers with [WMI](http://msdn.microsoft.com/en-us/library/aa394582.aspx). SSIS comes with a lot in the box but with [third-party components](http://ssisctc.codeplex.com/) you can get even more creative.

Here’s a recent example where I used [SSIS](http://msdn.microsoft.com/en-us/library/ms141026.aspx) to test a [GPS](http://en.wikipedia.org/wiki/Global_Positioning_System) tracking system. Basically the system is fed text files providing the speed, heading, location and identity of individual vehicles. By using some data gathered from a live system I was able to feed this back into a test system.

Here’s what my testing package did;

- Extract a single row of data from a table. 
- Use a [Script Component](http://msdn.microsoft.com/en-us/library/ms137640.aspx) to write this data to a text file. 
- Increment the counter and repeat. 

[![SSIS Used for Testing software]({{ site.baseurl }}/assets/2009/04/image-thumb2.png "SSIS Used for Testing software")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/image2.png)

This quick bit of work allowed the system to be tested under a real-world load. What non-traditional tasks have you used SSIS for?

