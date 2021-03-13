---
layout: post
title: Installing Analysis Service & Reporting Services from the command-line
date: 2014-06-22 21:51:50.000000000 +02:00
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
  shorturls: a:3:{s:9:"permalink";s:98:"http://www.youdidwhatwithtsql.com/installing-analysis-service-reporting-services-commandline/1907/";s:7:"tinyurl";s:26:"http://tinyurl.com/n5spb2k";s:4:"isgd";s:19:"http://is.gd/LTVCbx";}
  tweetbackscheck: '1613443414'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/installing-analysis-service-reporting-services-commandline/1907/"
---
Here's just a few examples of installing [Analysis Services](http://technet.microsoft.com/en-us/library/ms175609(v=sql.90).aspx "Analysis Services") and [Reporting Services](http://msdn.microsoft.com/en-us/library/ms159106.aspx "SQL Server Reporting Services") from the command-line.

Install Analysis Services in multidimensional mode.

```
D:\Setup.exe /q /ACTION=Install /FEATURES=AS /INSTANCENAME=ASMulti /ASSERVERMODE=MULTIDIMENSIONAL /ASSVCACCOUNT=NetworkService /ASSYSADMINACCOUNTS="CONTSO\Kim_Akers"/IACCEPTSQLSERVERLICENSETERMS
```

Install Analysis Services in tabular mode.

```
D:\Setup.exe /q /ACTION=Install /FEATURES=AS /INSTANCENAME=ASTabular /ASSERVERMODE=TABULAR /ASSVCACCOUNT=NetworkService /ASSYSADMINACCOUNTS="CONTSO\Kim_Akers"/IACCEPTSQLSERVERLICENSETERMS
```

Install a Reporting Services instance (with the DB engine and tools).

```
D:\Setup.exe /q /ACTION=Install /FEATURES=SQL,RS,Tools /INSTANCENAME=RPTSVR /SQLSVCACCOUNT=NetworkService /AGTSVCACCOUNT=NetworkService/RSSVCACCOUNT=NetworkService /ASSYSADMINACCOUNTS="CONTSO\Kim_Akers" /RSSVCStartupType=MANUAL /RSINSTALLMODE=DEFAULTNATIVEMODE/IACCEPTSQLSERVERLICENSETERMS
```
