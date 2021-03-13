---
layout: post
title: SSIS Execute Process Task not registered for use on this Computer
date: 2010-04-10 11:57:11.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SSIS
tags:
- Execute Process Task
- SSIS
meta:
  tweetbackscheck: '1613480454'
  twittercomments: a:0:{}
  shorturls: a:4:{s:9:"permalink";s:103:"http://www.youdidwhatwithtsql.com/ssis-execute-process-task-not-registered-for-use-on-this-computer/716";s:7:"tinyurl";s:26:"http://tinyurl.com/y4jse5g";s:4:"isgd";s:18:"http://is.gd/bmTi6";s:5:"bitly";s:20:"http://bit.ly/cz2RLp";}
  tweetcount: '0'
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssis-execute-process-task-not-registered-for-use-on-this-computer/716/"
---
Whilst doing some maintenance on an [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) package I encountered the below error when attempting to edit an [Execute Process Task](http://msdn.microsoft.com/en-us/library/ms141166.aspx).

[![The task with the name "Tectia - Download Files" and the creation name "Microsoft.SqlServer.Dts.Tasks.ExecuteProcess.ExecuteProcess, Microsoft.SqlServer.ExecProcTask, Version=9.0.242.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" is not registered for use on this computer]({{ site.baseurl }}/assets/2010/04/ssis_task_not_registered_thumb.png "The task with the name "Tectia - Download Files" and the creation name "Microsoft.SqlServer.Dts.Tasks.ExecuteProcess.ExecuteProcess, Microsoft.SqlServer.ExecProcTask, Version=9.0.242.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" is not registered for use on this computer")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/ssis_task_not_registered.png)

The package executes daily so I'm lucky I caught this in time. I Googled around and found [this thread](http://social.msdn.microsoft.com/Forums/en-US/sqlintegrationservices/thread/ebdae67c-2b63-4e8f-9c8b-35fb6fd96ecf) which advised a reinstall of SSIS. Unfortunately I didn't have this luxury so I decided to do some digging. I found the location of the [Execute Process Task](http://msdn.microsoft.com/en-us/library/ms141166.aspx) dll file in the Choose Toolbox Items dialog.

[![Execute Process Task]({{ site.baseurl }}/assets/2010/04/Execute_Process_Task_thumb.png "Execute Process Task")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/Execute_Process_Task.png)

Since the error was complaining about the task being unregistered I thought I'd try registering the dll in the [GAC](http://en.wikipedia.org/wiki/Global_Assembly_Cache). First I executed the below command;

```
C:\WINDOWS\Microsoft.NET\Framework\v1.1.4322>gacutil /i "C:\Program Files\Micro
oft SQL Server\90\dts\tasks\Microsoft.SqlServer.ExecProcTask.dll"

Microsoft (R) .NET Global Assembly Cache Utility. Version 1.1.4322.573
Copyright (C) Microsoft Corporation 1998-2002. All rights reserved.

Failure adding assembly to the cache: Unknown Error

C:\WINDOWS\Microsoft.NET\Framework\v1.1.4322>
```

This failed because I was using a different version of the [gacutil](http://msdn.microsoft.com/en-us/library/ex0ss12c(VS.80).aspx) tool. As it turns out you have to use the appropriate version of gacutil for the dll. A quick 350MB download of the [.NET Framework 2.0 Software Development Kit](http://www.microsoft.com/downloads/details.aspx?FamilyID=fe6f2099-b7b4-4f47-a244-c96d69c35dec&displaylang=en) and I was ready to roll. I reattempted the above command with the correct version.

```
C:\Program Files\Microsoft Visual Studio 8\SDK\v2.0\Bin>gacutil /i "C:\Program F
iles\Microsoft SQL Server\90\dts\tasks\Microsoft.SqlServer.ExecProcTask.dll"
Microsoft (R) .NET Global Assembly Cache Utility. Version 2.0.50727.42
Copyright (c) Microsoft Corporation. All rights reserved.

Assembly successfully added to the cache

C:\Program Files\Microsoft Visual Studio 8\SDK\v2.0\Bin>
```

After this was registered I was able to edit the task with no problems. I couldn't find any issues with any other task types so I was happy I didn't go down the reinstall route.

