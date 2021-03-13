---
layout: post
title: The job failed.  Unable to determine if the owner (sa) of job  has server access.
date: 2013-08-09 14:34:38.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
tags:
- sp_configure
- SQL Age
- SQL Server
meta:
  _edit_last: '1'
  tweetbackscheck: '1613477746'
  shorturls: a:3:{s:9:"permalink";s:98:"http://www.youdidwhatwithtsql.com/job-failed-unable-determine-owner-sa-job-job-server-access/1647/";s:7:"tinyurl";s:26:"http://tinyurl.com/kd34zew";s:4:"isgd";s:19:"http://is.gd/hAtAg2";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/job-failed-unable-determine-owner-sa-job-job-server-access/1647/"
---
If you have failing SQL Agent jobs with the following error;

```
The job failed. Unable to determine if the owner (sa) of job<job name> has server access.
</job>
```

and the following is logged in the SQL Server Log;

```
Message
[298] SQLServer Error: 15281, SQL Server blocked access to procedure 'dbo.sp_sqlagent_has_server_access' of component 'Agent XPs' because this component is turned off as part of the security configuration for this server. A system administrator can enable the use of 'Agent XPs' by using sp_configure. For more information about enabling 'Agent XPs', see "Surface Area Configuration" in SQL Server Books Online. [SQLSTATE 42000] (ConnIsLoginSysAdmin)
```

This should fix it for you;

```
EXEC sp_configure 'Agent XPs', 1;
RECONFIGURE;
```
