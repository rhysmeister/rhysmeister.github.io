---
layout: post
title: Powershell Tools
date: 2010-01-15 19:10:30.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
- Powershell Tools
meta:
  tweetbackscheck: '1613257530'
  shorturls: a:4:{s:9:"permalink";s:54:"http://www.youdidwhatwithtsql.com/powershell-tools/533";s:7:"tinyurl";s:26:"http://tinyurl.com/yc2rkg8";s:4:"isgd";s:18:"http://is.gd/6kI83";s:5:"bitly";s:20:"http://bit.ly/7T7Ej7";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershell-tools/533/"
---
I love [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx). You can do some really cool things with just a few lines of code that you would struggle to do any other way. There's quite a community around Powershelll providing a fair number of tools. Here's a round-up of a few I have used.

**PowerGUI - [http://powergui.org](http://powergui.org "http://powergui.org")**

PowerGUI is a project supported by [Quest Software](http://www.quest.com/) consisting of a GUI front end for [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) and a neat script editor. PowerGUI is easily extendable through its [powerpack](http://powergui.org/kbcategory.jspa?categoryID=21) feature. By my reckoning there already over 100 powerpacks available that help you manage [SQL Server](http://powergui.org/entry.jspa?externalID=2442&categoryID=54), [VMWare](http://powergui.org/entry.jspa?externalID=1802&categoryID=290), [Citrix](http://powergui.org/entry.jspa?externalID=2033&categoryID=290), [Sharepoint](http://powergui.org/entry.jspa?externalID=1893&categoryID=354) and fun things like [Facebook Organizer](http://www.powergui.org/entry.jspa?externalID=2034) and [Twitter Powerpack](http://www.powergui.org/entry.jspa?externalID=2362&categoryID=56)

[![PowerGUI Interface]({{ site.baseurl }}/assets/2010/01/image_thumb.png "PowerGUI Interface")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/image.png)

PowerGUI exposes the [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) code it uses, similarly to [T-SQL](http://msdn.microsoft.com/en-us/library/ms189826.aspx) scripting in [SSMS](http://msdn.microsoft.com/en-us/library/ms174173.aspx),&nbsp; making this a useful starting point for your own scripts.

[![Powershell Scipting in PowerGUI]({{ site.baseurl }}/assets/2010/01/image_thumb1.png "Powershell Scipting in PowerGUI")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/image1.png)&nbsp;

Windows Admins may find PowerGUI useful for many tasks but I’m much more of a scripter so I really like the Script Editor. It’s lightweight and has intellisense support helping out when writing scripts. It terms of Powershell editors this one gets top points from me.

**<font color="#666666">Windows Powershell ISE </font>**

<font color="#666666">This product ships with <a href="http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx" target="_blank">Powershell</a> 2.0 and is Microsoft's own stab at a GUI for their fantastic scripting language. The environment is very basic, something they <a href="http://blogs.msdn.com/powershell/archive/2008/12/29/powershell-ise-can-do-a-lot-more-than-you-think.aspx" target="_blank">freely admit,</a> and doesn't compare to the other products on this page. Perhaps one to watch in the future but this doesn’t really provide anything exciting in my view yet.</font>

[![Windows Powershell ISE]({{ site.baseurl }}/assets/2010/01/image_thumb2.png "Windows Powershell ISE")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/image2.png)

**<font color="#666666">PrimalForms Community Edition</font>**

Yep, a tool to build GUI's in Powershell! As Powershell can utilise the .Net platform this was bound to happen sooner or later. In terms of GUI building it's quite feature complete. A large number of toolbox components are available.

[![PrimalForms Community Edition]({{ site.baseurl }}/assets/2010/01/image_thumb4.png "PrimalForms Community Edition")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/image3.png)&nbsp;

Anyone used to GUI building tools will feel right at home getting productive right away. One drawback seems to be the fact that you have to export Powershell code to add functionality to events (i.e. button clicks). While I can't seem myself building any serious applications with [PrimalForms](http://blog.sapien.com/index.php/2008/11/03/free-primalforms-tool-for-powershell-released/) it's a fun little tool that may be useful for building little utilities.

**Powershell SSIS Script Task - [http://powershellscripttask.codeplex.com/](http://powershellscripttask.codeplex.com/ "http://powershellscripttask.codeplex.com/")**

This is something I’d really like to see SSIS provide out-of-the-box. No installer yet. Looks like you have to [compile from source](http://powershellscripttask.codeplex.com/SourceControl/ListDownloadableCommits.aspx) to start playing with it. See my [Powershell Script Task for SSIS](http://www.youdidwhatwithtsql.com/powershell-script-task-for-ssis/488) post for more details.

<font color="#666666"></font>

**<font color="#666666">Powershell Analyzer - <a title="http://www.powershellanalyzer.com/" href="http://www.powershellanalyzer.com/">http://www.powershellanalyzer.com/</a></font>**

Powershell Analyzer was a very early contender into the Powershell tools market and is very feature-rich. Formally a commercial product, at US$129, it’s now totally free. The IDE provides a Script editor, console view, xml view, results explorer, provider explorer, and html and charting capabilities.

[![powershell_analyzer]({{ site.baseurl }}/assets/2010/01/powershell_analyzer_thumb.png "powershell\_analyzer")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/powershell_analyzer.png)

While Powershell Analyzer is probably far more feature packed than [PowerGUI](http://powergui.org) I just couldn't get on with it. The number of buttons and tabs is quite bewildering and provides far more than most of us need. I think only the most advanced users who need to live in Powershell will find this useful.

**PowerTab - [http://thepowershellguy.com/blogs/posh/pages/powertab.aspx](http://thepowershellguy.com/blogs/posh/pages/powertab.aspx "http://thepowershellguy.com/blogs/posh/pages/powertab.aspx")**

I really like the idea of PowerTab but I simply can't get on with it. There's a really cool [PowerTab Demo](http://thepowershellguy.com/blogs/posh/archive/2007/06/02/powertab-flash-exampes.aspx) but I can't make it do that! Looks like I'll be sticking with a GUI for now!

**<font color="#666666"></font>**

[![PowerTab extension for Powershell]({{ site.baseurl }}/assets/2010/01/image_thumb5.png "PowerTab extension for Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/image4.png)

