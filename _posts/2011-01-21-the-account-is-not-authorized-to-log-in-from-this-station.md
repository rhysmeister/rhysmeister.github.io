---
layout: post
title: The account is not authorized to log in from this station
date: 2011-01-21 20:19:30.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Windows
tags:
- Domain
- Windows 2000
- Windows 2008
meta:
  tweetbackscheck: '1613477683'
  twittercomments: a:0:{}
  shorturls: a:4:{s:9:"permalink";s:96:"http://www.youdidwhatwithtsql.com/the-account-is-not-authorized-to-log-in-from-this-station/1058";s:7:"tinyurl";s:26:"http://tinyurl.com/6gxt5ow";s:4:"isgd";s:19:"http://is.gd/MMA2ic";s:5:"bitly";s:20:"http://bit.ly/g9up8g";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/the-account-is-not-authorized-to-log-in-from-this-station/1058/"
---
During a recent setup of a SQL Server Cluster I received this error when attempting to join a Windows Server 2008 server onto a Windows 2000 domain.

[![The account is not authorized to log in from this station]({{ site.baseurl }}/assets/2011/01/attempt_to_join_2000_domain_with_2008_thumb.png "The account is not authorized to log in from this station")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/The-account-is-not-authorized-to-login-f_C180/attempt_to_join_2000_domain_with_2008.png)

To resolve this issue we modify a [Local Security Policy](http://technet.microsoft.com/en-us/library/cc739442(WS.10).aspx "Local Security Policy") on the Windows 2008 box. Click Start \> Administrative Tools \> Local Security Policy \> Local Policies \> Security Options.

[![local security policy snapin]({{ site.baseurl }}/assets/2011/01/local_security_policy_snapin_thumb.png "local security policy snapin")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/The-account-is-not-authorized-to-login-f_C180/local_security_policy_snapin.png)

Change the Policy called "Microsoft network client: Digitally sign communications (if server agrees)" to Disabled. You should now be able to join the Windows 2008 Server onto the 2000 Domain. Fix for this found in the following [thread](http://forums.techarena.in/active-directory/748161.htm).

