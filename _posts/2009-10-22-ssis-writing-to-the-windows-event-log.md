---
layout: post
title: 'SSIS: Writing to the Windows Event Log'
date: 2009-10-22 13:34:50.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SSIS
tags:
- Event Log
- SSIS
- VB.Net
meta:
  tweetbackscheck: '1613358863'
  shorturls: a:4:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/ssis-writing-to-the-windows-event-log/407";s:7:"tinyurl";s:26:"http://tinyurl.com/yg5jhzc";s:4:"isgd";s:18:"http://is.gd/4vKmk";s:5:"bitly";s:20:"http://bit.ly/1MZtez";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssis-writing-to-the-windows-event-log/407/"
---
Here’s a quick [VB.Net](http://en.wikipedia.org/wiki/Visual_Basic_.NET) snippet that allows you to write messages to the [Windows Event Log](http://en.wikipedia.org/wiki/Event_Viewer#Windows_Event_Log) from your packages. Nothing to configure here, just change the log message to something appropriate. Obviously, in order to work, the package would have to be run under an account that has permission to write to the event log. Copy the below code into a [Script Task](http://msdn.microsoft.com/en-us/library/ms141752.aspx), change the message, and you’re ready to go.

```
' Microsoft SQL Server Integration Services Script Task
' Write scripts using Microsoft Visual Basic
' The ScriptMain class is the entry point of the Script Task.

Imports System
Imports System.Data
Imports System.Math
Imports Microsoft.SqlServer.Dts.Runtime
Imports System.Diagnostics.EventLog
Imports System.Diagnostics.EventLogEntryType

Public Class ScriptMain

	' The execution engine calls this method when the task executes.
	' To access the object model, use the Dts object. Connections, variables, events,
	' and logging features are available as static members of the Dts class.
	' Before returning from this method, set the value of Dts.TaskResult to indicate success or failure.
	'
	' To open Code and Text Editor Help, press F1.
	' To open Object Browser, press Ctrl+Alt+J.

    Public Sub Main()

        Dim eventLog As New Diagnostics.EventLog

        ' If the SSIS event log doesn't exist on the target machine then create it
        If Not eventLog.SourceExists("SSIS") Then
            eventLog.CreateEventSource("SSIS", "Application")
        End If

        ' Create an instance of the EventLog class
        eventLog = New Diagnostics.EventLog()
        ' Specify the source as SSIS
        eventLog.Source = "SSIS"
        ' Add an event log message
        eventLog.WriteEntry("This is a message from a Script Task!", Diagnostics.EventLogEntryType.Information)

        Dts.TaskResult = Dts.Results.Success
    End Sub

End Class
```

Execute the task and you should find the following message in the event viewer.

[![SSIS Message in the Windows Event Log]({{ site.baseurl }}/assets/2009/10/SSIS_Message_Event_Log_thumb.png "SSIS Message in the Windows Event Log")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/10/SSIS_Message_Event_Log.png)

