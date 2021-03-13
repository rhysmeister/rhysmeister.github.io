---
layout: post
title: Powershell Keyboard Shortcuts
date: 2011-02-01 20:50:09.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
meta:
  tweetbackscheck: '1613464375'
  shorturls: a:4:{s:9:"permalink";s:68:"http://www.youdidwhatwithtsql.com/powershell-keyboard-shortcuts/1067";s:7:"tinyurl";s:26:"http://tinyurl.com/6g5ex4r";s:4:"isgd";s:19:"http://is.gd/81TTXp";s:5:"bitly";s:20:"http://bit.ly/dMl0Mr";}
  twittercomments: a:1:{s:17:"33268850753540096";s:3:"259";}
  tweetcount: '1'
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershell-keyboard-shortcuts/1067/"
---
Here's a few of the keyboard shortcuts for Powershell I always find myself using during the day at work.

**Pause output on the screen**

Sometimes a command may produce lots of output causing the screen to scroll rapidly. Pressing Control & S will pause the output currently on the screen. Press any key to continue the output.

You can test this out with the following command.

```
Get-ChildItem -Recurse C:\;
```

[![pause powershell console output]({{ site.baseurl }}/assets/2011/02/pause_powershell_console_output_thumb.png "pause powershell console output")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Five-Powershell-Keyboard-shortcuts_10CA3/pause_powershell_console_output.png)

**View a popup Menu of your command history**

Pressing<font color="#666666"> the <strong>F7</strong> key will bring up a popup menu showing your command history in the current Powershell session. Use the arrow keys to select a command and hit enter to run it again.</font>

[![powershell history popup menu]({{ site.baseurl }}/assets/2011/02/powershell_history_popup_menu_thumb.png "powershell history popup menu")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Five-Powershell-Keyboard-shortcuts_10CA3/powershell_history_popup_menu.png)

**Auto-complete a command in your history**

<font color="#666666">Typing the first few characters of a command in your history and then pressing <strong>F8 </strong>will complete the first matching command in it's entirety. So we can go from;</font>

[![powershell_f8_shortcut]({{ site.baseurl }}/assets/2011/02/powershell_f8_shortcut_thumb.png "powershell\_f8\_shortcut")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Five-Powershell-Keyboard-shortcuts_10CA3/powershell_f8_shortcut.png)

to...

[![powershell_f8_shortcut2]({{ site.baseurl }}/assets/2011/02/powershell_f8_shortcut2_thumb.png "powershell\_f8\_shortcut2")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Five-Powershell-Keyboard-shortcuts_10CA3/powershell_f8_shortcut2.png)

with just a press of the **F8** key.

**Set a custom shortcut to Launch Powershell**

<font color="#666666">I use Powershell fairly often so I've assigned a shortcut key to launch it from the keyboard. To do this find Powershell in your start menu, right-click and select properties. You should see something like this;</font>

[![powershell_shortcut_properties]({{ site.baseurl }}/assets/2011/02/powershell_shortcut_properties_thumb.png "powershell\_shortcut\_properties")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Five-Powershell-Keyboard-shortcuts_10CA3/powershell_shortcut_properties.png)

Click on the textbox labelled "Shortcut Key" and press the shortcut keys you'd like to use. I've chosen to use the Control, Alt and P keys.

[![powershell_shortcut_set]({{ site.baseurl }}/assets/2011/02/powershell_shortcut_set_thumb.png "powershell\_shortcut\_set")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Five-Powershell-Keyboard-shortcuts_10CA3/powershell_shortcut_set.png)

There's several more shortcuts, mainly to do with command history and editing, read about them at [Powershell shortcut keys](http://technet.microsoft.com/en-us/library/ee176868.aspx).

