---
layout: post
title: 'SSIS: Archiving files with VB.Net'
date: 2009-10-15 22:06:37.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SSIS
tags:
- archiving files
- SSIS
- VB.Net
meta:
  tweetbackscheck: '1613305753'
  shorturls: a:4:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/ssis-archiving-files-with-vb-net/402";s:7:"tinyurl";s:26:"http://tinyurl.com/yfaw6rd";s:4:"isgd";s:18:"http://is.gd/4lm9P";s:5:"bitly";s:19:"http://bit.ly/1vI5L";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssis-archiving-files-with-vb-net/402/"
---
When creating [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) packages it’s a common requirement to be able to archive the processed files. Here’s [VB.Net](http://en.wikipedia.org/wiki/Visual_Basic_.NET) code snippet, with a quick walkthrough, that does exactly that.

The script uses two variables, **inFiles** and **archiveFiles**. The variable **inFiles** contains the folder we want to move files from, and **archiveFiles** is the destination.

Configure your variables in [BIDS](http://msdn.microsoft.com/en-us/library/ms173767.aspx) like below.

[![ssis variables for archiving files]({{ site.baseurl }}/assets/2009/10/ssis_variables_thumb.png "ssis variables for archiving files")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/10/ssis_variables.png)

Add a [script task](http://msdn.microsoft.com/en-us/library/ms141752.aspx) to the designer.

[![Script task for archiving files in BIDS]({{ site.baseurl }}/assets/2009/10/archive_files_script_task_thumb.png "Script task for archiving files in BIDS")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/10/archive_files_script_task.png)

Right click the script task, choose ‘Edit’ then ‘Script’. Add the **inFiles** and **archiveFiles** variables to the **ReadOnlyVariables** textbox.

[![Script Task configuration for archiving files]({{ site.baseurl }}/assets/2009/10/script_task_config_thumb.png "Script Task configuration for archiving files")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/10/script_task_config.png)

Click the “Design Script” button and paste the below code into the [VSA](http://msdn.microsoft.com/en-us/library/ms974548.aspx) editor.

```
' Microsoft SQL Server Integration Services Script Task
' Write scripts using Microsoft Visual Basic
' The ScriptMain class is the entry point of the Script Task.

Imports System
Imports System.Data
Imports System.Math
Imports Microsoft.SqlServer.Dts.Runtime

Public Class ScriptMain

    ' The execution engine calls this method when the task executes.
    ' To access the object model, use the Dts object. Connections, variables, events,
    ' and logging features are available as static members of the Dts class.
    ' Before returning from this method, set the value of Dts.TaskResult to indicate success or failure.
    '
    ' To open Code and Text Editor Help, press F1.
    ' To open Object Browser, press Ctrl+Alt+J.

    Public Sub Main()
        '
        ' Add your code here
        '
        Dim dir As System.IO.Directory
        ' fetch the folder locations from SSIS variables
        Dim inFiles As String = Dts.Variables("inFiles").Value.ToString
        Dim archiveFiles As String = Dts.Variables("archiveFiles").Value.ToString

        ' Get the system date and time separators for removing from the folder name we'll create later
        Dim dateSeparator As String = System.Globalization.DateTimeFormatInfo.CurrentInfo.DateSeparator
        Dim timeSeparator As String = System.Globalization.DateTimeFormatInfo.CurrentInfo.TimeSeparator

        ' Used to create a datetime stamped folder removing separators
        Dim dt As String = DateTime.Now.ToString.Replace(" ", "").Replace(dateSeparator, "").Replace(timeSeparator, "").Replace("/", "")

        ' Check folder paths end with a "\"
        If inFiles.EndsWith("\") = False Then
            inFiles &= "\"
        End If

        If archiveFiles.EndsWith("\") = False Then
            archiveFiles &= "\"
        End If

        archiveFiles &= dt

        ' Create datetime stamp archive folder if it doesn't already exist
        If dir.Exists(archiveFiles) = False Then
            dir.CreateDirectory(archiveFiles)
        End If

        ' Move all files to archive
        For Each archFile As String In dir.GetFiles(inFiles)
            dir.Move(archFile, archiveFiles & "\" & archFile.Substring(archFile.LastIndexOf("\") + 1, archFile.Length - archFile.LastIndexOf("\") - 1))
        Next

        Dts.TaskResult = Dts.Results.Success

    End Sub

End Class
```

Place some files into the location your **inFiles** variable points to. Then right click the script task and choose “Execute Task”.

[![archive_files_with_vb.net_script_task]({{ site.baseurl }}/assets/2009/10/archive_files_with_vb.net_script_task_thumb.png "archive\_files\_with\_vb.net\_script\_task")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/10/archive_files_with_vb.net_script_task.png)

Once the package has executed successfully the files will be moved to **archiveFiles** from **inFiles**.

[![archive_folder_with_datetime]({{ site.baseurl }}/assets/2009/10/archive_folder_with_datetime_thumb.png "archive\_folder\_with\_datetime")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/10/archive_folder_with_datetime.png)

