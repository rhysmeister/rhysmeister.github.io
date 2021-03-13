---
layout: post
title: PowershellPack STA Error
date: 2010-01-25 20:51:29.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
- Powershell STA mode
- Powershell Tools
- PowerShellPack
meta:
  enclosure: |
    http://ecn.channel9.msdn.com/o9/ch9/3/6/0/8/8/4/Powershell4_ch9.wmv
    57443159
    video/x-ms-wmv
  tweetbackscheck: '1613447159'
  shorturls: a:4:{s:9:"permalink";s:62:"http://www.youdidwhatwithtsql.com/powershellpack-sta-error/579";s:7:"tinyurl";s:26:"http://tinyurl.com/ykerh4e";s:4:"isgd";s:18:"http://is.gd/71ETq";s:5:"bitly";s:20:"http://bit.ly/6rZD83";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershellpack-sta-error/579/"
---
I'm really into [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) so I like trying out all the available tools. Somehow I've missed the release of the [PowershellShellPack](http://code.msdn.microsoft.com/PowerShellPack) which has ten modules offering all kinds of additional functionality including file handling, operating system information, GUI and code generation. I followed the [Channel 9 video](http://ecn.channel9.msdn.com/o9/ch9/3/6/0/8/8/4/Powershell4_ch9.wmv) and ran into a problem on the first example given.

First I ran the command **Import-Module PowerShellPack**.

[![Powershell Import Module PowerShellPack]({{ site.baseurl }}/assets/2010/01/Powershell_Import_Module_PowerShellPack_thumb.png "Powershell Import Module PowerShellPack")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/Powershell_Import_Module_PowerShellPack.png)

Then I tried to create, and display, a label as in the video example; **New-Label "Hello World" -FontSize 40 -Show**

[![Powershell STA modeerror]({{ site.baseurl }}/assets/2010/01/powershell_sta_mode_error_thumb.png "Powershell STA modeerror")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/powershell_sta_mode_error.png)

This resulted in the following error.

```
New-Object : Exception calling ".ctor" with "0" argument(s): "The calling thread must be STA, because many UI components require this." At C:\Users\Rhys\Documents\WindowsPowerShell\Modules\WPK\GeneratedControls\PresentationFramework.ps1:30292 char:29 + $Object = New-Object \<\<\<\< System.Windows.Controls.Label + CategoryInfo : InvalidOperation: (:) [New-Object], MethodInvocationException + FullyQualifiedErrorId : ConstructorInvokedThrowException,Microsoft.PowerShell.Commands.NewObjectCommand
```

OK, I seem to need to be running in STA mode. I Googled "Powershell STA mode" and discovered a [Stackoverflow thread](http://stackoverflow.com/questions/1508704/does-powershell-sta-mode-eliminate-sharepoint-memory-leak-issue). After reading this I thought I'd try starting Powershell with the switch **-STA**.

[![powershell start in sta mode]({{ site.baseurl }}/assets/2010/01/powershell_start_in_sta_mode_thumb.png "powershell start in sta mode")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/powershell_start_in_sta_mode.png)

OK, that seemed to work. Now lets try to create that label again. First load the [PowerShellPack](http://code.msdn.microsoft.com/PowerShellPack) modules again since we've started a new session.

**Import-Module PowerShellPack**

<font color="#666666">Now try to create the label again.</font>

**New-Label "Hello World" -FontSize 40 -Show**

[![Powershell Hello World Label]({{ site.baseurl }}/assets/2010/01/Powershell_Hello_World_Label_thumb.png "Powershell Hello World Label")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/Powershell_Hello_World_Label.png)

OK, that's that hurdle over. Now I can get on with exploring what this tool can do for me.

