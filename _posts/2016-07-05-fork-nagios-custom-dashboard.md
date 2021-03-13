---
layout: post
title: Fork of Nagios custom dashboard
date: 2016-07-05 14:06:27.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Nagios
tags:
- dashboard
- nagios
meta:
  _edit_last: '1'
  shorturls: a:2:{s:9:"permalink";s:68:"http://www.youdidwhatwithtsql.com/fork-nagios-custom-dashboard/2216/";s:7:"tinyurl";s:26:"http://tinyurl.com/zs32zht";}
  tweetbackscheck: '1613467643'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/fork-nagios-custom-dashboard/2216/"
---
I was looking for something to create custom dashboards in [Nagios](https://www.nagios.org/) and came across [this](https://exchange.nagios.org/directory/Addons/Frontends-%28GUIs-and-CLIs%29/Web-Interfaces/DashBoard/details). The approach taken here limited each user to a single dashboard but also the method for getting the logged in user didn't work in my environment. So I decided to fork it...

My version is [here](https://github.com/rhysmeister/misc).

It basically contains the following changes...

- Multiple custom dashboards presented to the Nagios user for selection.
- Removal of dashboard add / edit pages (didn't work for me).

For further detail see the [README](https://github.com/rhysmeister/misc/blob/master/README.md) file in the project. Thanks to the original author;&nbsp;Franjo Stipanovic (sorry, couldn't find a url for credit other than [Nagios Exchange](https://exchange.nagios.org/directory/Addons/Frontends-%28GUIs-and-CLIs%29/Web-Interfaces/DashBoard/details)).

&nbsp;

