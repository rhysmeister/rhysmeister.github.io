---
layout: post
title: Console input with Powershell
date: 2010-02-21 19:51:07.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
- Powershell Scripting
meta:
  tweetbackscheck: '1613473193'
  shorturls: a:4:{s:9:"permalink";s:67:"http://www.youdidwhatwithtsql.com/console-input-with-powershell/673";s:7:"tinyurl";s:26:"http://tinyurl.com/ybmbgtr";s:4:"isgd";s:18:"http://is.gd/8SL8S";s:5:"bitly";s:20:"http://bit.ly/bH0Gvb";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: greg.rojas@raymondjames.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/console-input-with-powershell/673/"
---
I'm looking at building some [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) scripts that can accept user input to perform different tasks with a wizard style interface. As it happens this is fairly easily achieved with the [Read-Host](http://technet.microsoft.com/en-us/library/ee176935.aspx) cmdlet. Here's a quick script showing how such a [powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script may look.

```
function mainMenu()
{
	Clear-Host;
	Write-Host "============";
	Write-Host "= MAINMENU =";
	Write-Host "============";
	Write-Host "1. Press '1' for this option";
	Write-Host "2. Press '2' for this option";
	Write-Host "3. Press '3' for this option";
	Write-Host "4. Press '4' for this option";
}

function returnMenu($option)
{
	Clear-Host;
	Write-Host "You chose option $option";
	Write-Host "Press any key to return to the main menu.";
	$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown");
}

do
{
	mainMenu;
	$input = Read-Host "Enter a number for an option or type `"quit`" to finish."
	switch ($input)
	{
		"1"
		{
			returnMenu $input;
		}
		"2"
		{
			returnMenu $input;
		}
		"3"
		{
			returnMenu $input;
		}
		"4"
		{
			returnMenu $input;
		}
		"quit"
		{
			# nothing
		}
		default
		{
			Clear-Host;
			Write-Host "Invalid input. Please enter a valid option. Press any key to continue.";
			$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown");
		}
	}

} until ($input -eq "quit");

Clear-Host;
```

[![powershell console input menu]({{ site.baseurl }}/assets/2010/02/powershell_console_input_menu_thumb.png "powershell console input menu")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/powershell_console_input_menu.png)

[![powershell console input menu 1]({{ site.baseurl }}/assets/2010/02/powershell_console_input_menu_1_thumb.png "powershell console input menu 1")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/powershell_console_input_menu_1.png)

