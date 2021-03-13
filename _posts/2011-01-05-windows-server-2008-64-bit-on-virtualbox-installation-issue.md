---
layout: post
title: Windows Server 2008 64 Bit on VirtualBox installation issue.
date: 2011-01-05 21:18:26.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Windows
tags:
- Clustering
- SQL Server 2008
- VirtualBox
- Windows 2008
meta:
  tweetbackscheck: '1613479190'
  twittercomments: a:0:{}
  shorturls: a:4:{s:9:"permalink";s:97:"http://www.youdidwhatwithtsql.com/windows-server-2008-64-bit-on-virtualbox-installation-issue/927";s:7:"tinyurl";s:26:"http://tinyurl.com/32atare";s:4:"isgd";s:18:"http://is.gd/kbl33";s:5:"bitly";s:20:"http://bit.ly/g0l8Md";}
  tweetcount: '0'
  _sg_subscribe-to-comments: mathew_paul003@live.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/windows-server-2008-64-bit-on-virtualbox-installation-issue/927/"
---
I'm just starting to explore [SQL Server 2008 Clustering](http://msdn.microsoft.com/en-us/library/ms189134.aspx "SQL Server 2008 Clustering") and hit this issue when trying to install Windows Server 2008 (64 Bit) in [VirtualBox](http://www.virtualbox.org/ "VirtualBox"). The below screen, with "Windows failed to start" error, reared its ugly head shortly after booting off the ISO image.

[![virtualbox windows failed to start Status: 0xc0000225 Info: AN unexpected error has occurred.]({{ site.baseurl }}/assets/2011/01/virtualbox_windows_failed_to_start_thumb.png "virtualbox\_windows\_failed\_to\_start")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/01/virtualbox_windows_failed_to_start.png)

Thankfully the solution is quick and easy (once you've found it) so I'm posting it here for clarity.

Close the virtual machine and return to the main VirtualBox screen.

[![VirtualBox]({{ site.baseurl }}/assets/2011/01/VirtualBox_thumb.png "VirtualBox")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/01/VirtualBox.png)

Select the appropriate virtual machine and click the **Settings** button. Click the **System** icon on the left and check the box labelled **"Enable IO APIC"** on the **Motherboard** tab.

[![io_apic]({{ site.baseurl }}/assets/2011/01/io_apic_thumb.png "io\_apic")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/01/io_apic.png)

Click the **Processor** tab and check the box labelled **"Enable PAE/NX"**.

[![pae_nx]({{ site.baseurl }}/assets/2011/01/pae_nx_thumb.png "pae\_nx")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/01/pae_nx.png)

Click OK to save the changes and restart the virtual machine. Your installation of Windows 2008 Server (64 Bit) should now progress. Fix for this dug out of a [VirtualBox forum thread](http://forums.virtualbox.org/viewtopic.php?f=2&t=9280 "VirtualBox forums").

