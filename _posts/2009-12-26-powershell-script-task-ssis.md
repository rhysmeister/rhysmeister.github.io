---
layout: post
title: Powershell Script Task for SSIS
date: 2009-12-26 18:59:44.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
- SSIS
tags:
- Powershell
- SSIS
meta:
  tweetbackscheck: '1613466265'
  twittercomments: a:0:{}
  shorturls: a:4:{s:9:"permalink";s:69:"http://www.youdidwhatwithtsql.com/powershell-script-task-for-ssis/488";s:7:"tinyurl";s:26:"http://tinyurl.com/yedp7zs";s:4:"isgd";s:18:"http://is.gd/5CvdF";s:5:"bitly";s:20:"http://bit.ly/5169y0";}
  tweetcount: '0'
  _edit_last: '1'
  _wp_old_slug: powershell-script-task-for-ssis
  _sg_subscribe-to-comments: michele@mindpedal.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershell-script-task-ssis/488/"
---
[SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) and [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) are two of my current loves in technology, so of course, I was excited to see someone has made a [Powershell Script Task](http://powershellscripttask.codeplex.com/). I've been meaning to try this out for months. Unfortunately it looks like the project isn't currently active, but I thought I'd still give it a whirl, and post it here hoping to save others a little time on setup. First you'll need to download the [source code](http://powershellscripttask.codeplex.com/SourceControl/list/changesets) as there's no installation package. Then you'll need to compile the project to produce the [dll](http://en.wikipedia.org/wiki/Dynamic-link_library). I used Visual Studio 2008 but I guess [Visual C# Express Edition](http://www.microsoft.com/express/download/) will do it. Double click the file called **Defiant.SqlServer.PowerShellScriptTask.csproj** from the source code you downloaded. This will open the project in your IDE. Build the project and a **bin\debug** &nbsp; directory containing a dll will be created in the project folder. [![bin debug folder]({{ site.baseurl }}/assets/2009/12/bin_debug_folder_thumb.png "bin debug folder")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/bin_debug_folder.png) We are only interested in the file called **Defiant.SqServer.PowerShellScriptTask.dll**. We will need to register this file in the [GAC](http://en.wikipedia.org/wiki/Global_Assembly_Cache) and copy it to a place where [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) can find it. Save the commands below, with appropriate modifications, to a [batch file](http://en.wikipedia.org/wiki/Batch_file).

```
cd\
c:
cd C:\Program Files\Microsoft SDKs\Windows\v6.0A\bin
gacutil /uf "Defiant.SqlServer.PowerShellScriptTask";
gacutil /if "C:\Users\Rhys\Desktop\Source\Defaint.SqlServer.PowerShellScriptTask\bin\Debug\Defiant.SqlServer.PowerShellScriptTask.dll";
copy "C:\Users\Rhys\Desktop\Source\Defaint.SqlServer.PowerShellScriptTask\bin\Debug\Defiant.SqlServer.PowerShellScriptTask.dll"; "C:\Program Files\Microsoft SQL Server\100\DTS\Tasks";
```

You may need to modify; the path on line 3, this is the location of [gacutil](http://msdn.microsoft.com/en-us/library/ex0ss12c(VS.80).aspx). line5, this is the full path of **Defiant.SqlServer.PowerShellScriptTask.dll**. line 6 the full path of **Defiant.SqlServer.PowerShellScriptTask.dll** and the path to **DTS\Tasks** for the instance on [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) you want to copy it to. For some reason I couldn't get this to work on 2005 but it worked fine for 2008. Restart the SSIS service using services.msc then we are ready to fire up [BIDS](http://msdn.microsoft.com/en-us/library/ms173767.aspx). When inside BIDS the Powershell Script Task will not appear in the toolbox automatically. Right click on the toolbox and select **Choose Items**. In the SSIS Control Flow Items tab scroll down to Powershell Script Task and check the box next to it. [![choose toolbox items]({{ site.baseurl }}/assets/2009/12/choose_toolbox_items_thumb.png "choose toolbox items")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/choose_toolbox_items.png) Now the task will appear in the toolbox. Drop the task onto the designer to begin working with it. [![Powershell Script Task]({{ site.baseurl }}/assets/2009/12/Powershell_Script_Task_thumb.png "Powershell Script Task")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/Powershell_Script_Task.png) Right click the task and choose edit. Anyone who has worked with the VB.Net \ C# Script Task should work this out straight away. [![Powershell Script Task Editor]({{ site.baseurl }}/assets/2009/12/Powershell_Script_Task_Editor_thumb.png "Powershell Script Task Editor")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/Powershell_Script_Task_Editor.png) Let's try something simple first. Enter the below line of Powershell in the Script window;

```
Write-Host "This is a test!";
```

Click OK and then run the package. Below is the output I received.

```
SSIS package "Package.dtsx" starting.
Information: 0x0 at PowerShell Script Task, PowerShellScriptTask: This is a test!
Information: 0x0 at PowerShell Script Task, PowerShellScriptTask:
SSIS package "Package.dtsx" finished: Success.
```

Great, it works! Now lets try working with some variables. Add two variables like below (substituting your name for mine); [![ssis variable powershell]({{ site.baseurl }}/assets/2009/12/ssis_variable_powershell_thumb.png "ssis variable powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/ssis_variable_powershell.png) Then edit the Powershell Script Task and add these variables as below. [![ssis powershell script task variables]({{ site.baseurl }}/assets/2009/12/ssis_powershell_script_task_variables_thumb.png "ssis powershell script task variables")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/ssis_powershell_script_task_variables.png) Add the below Powershell to the Script window;

```
$ssis.Variables["User::write"] = $ssis.Variables["User::readOnly"];
```

This code just assigns the value of the **readOnly** variable to **write**. Next drop a VB.net Script task onto the designer and connect the Powershell Script Task to it. We're going to add code here to display a message box with the contents of the **write** variable. This will show that our Powershell script task has successfully read from, and written to, our SSIS variables. [![script task edit]({{ site.baseurl }}/assets/2009/12/script_task_edit_thumb.png "script task edit")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/script_task_edit.png) Click edit script and add the below VB.Net code.

```
Imports System
Imports System.Data
Imports System.Math
Imports Microsoft.SqlServer.Dts.Runtime

 _
 _
Partial Public Class ScriptMain
	Inherits Microsoft.SqlServer.Dts.Tasks.ScriptTask.VSTARTScriptObjectModelBase

	Enum ScriptResults
		Success = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Success
		Failure = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Failure
	End Enum

	Public Sub Main()
        MsgBox("Hello " & Dts.Variables("write").Value.ToString)
        Dts.TaskResult = ScriptResults.Success
    End Sub

End Class
```

**UPDATE:** 2015-06-09. Thanks to Michelle who spotted my stupid line of code here, removed... Dts.Variables("write").Value = Dts.Variables("readOnly").Value.ToString

Your final package should look something like below. [![powershell_final_ssis_package]({{ site.baseurl }}/assets/2009/12/powershell_final_ssis_package_thumb.png "powershell\_final\_ssis\_package")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/powershell_final_ssis_package.png) Execute the package and, if all goes well, you should see the below message box. [![MsgBox_Powershell_Script_Task]({{ site.baseurl }}/assets/2009/12/MsgBox_Powershell_Script_Task_thumb.png "MsgBox\_Powershell\_Script\_Task")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/MsgBox_Powershell_Script_Task.png) So that's the basics of working with the Powershell Script Task. I've got over my deep hatred of VB.net, since working with it in SSIS so much, but Powershell is a welcome addition to my box of tricks! I'm looking forward to deploying this in future projects. It's a shame the project seems inactive but this is really something I'd like to see [Microsoft](http://www.microsoft.com/en/us/default.aspx) provide out-of-the-box in [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx).

