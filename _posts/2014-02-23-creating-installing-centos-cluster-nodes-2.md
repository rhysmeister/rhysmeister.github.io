---
layout: post
title: Creating & Installing the CentOS cluster nodes.
date: 2014-02-23 17:02:22.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Linux
- MySQL
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613194410'
  shorturls: a:3:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/creating-installing-centos-cluster-nodes-2/1804/";s:7:"tinyurl";s:26:"http://tinyurl.com/nz2jqum";s:4:"isgd";s:19:"http://is.gd/KxaA7P";}
  _wp_old_slug: creating-installing-centos-cluster-nodes
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/creating-installing-centos-cluster-nodes-2/1804/"
---
This post is part of a series that will deal with [setting up a MySQL shared storage cluster](http://www.youdidwhatwithtsql.com/installing-configuring-mysql-sharedstorage-cluster/1790/ "Installing & Configuring a shared-storage MySQL Cluster") using VirtualBox & [FreeNAS](http://www.freenas.org/ "FreeNAS"). In this post we deal with the installation of [CentOS](http://www.centos.org/ "CentOS Linux") in [VirtualBox](https://www.virtualbox.org/ "VirtualBox").

This post deals with the creation of two Linux servers hosted within VirtualBox. We will download an installer for CentOS, install it in one VM, finally we will use VirtualBox to clone the VM so the second node will be identical.

To get started download the CentOS network installer.

```
wget http://mirror.sov.uk.goscomb.net/centos/6.5/isos/x86_64/CentOS-6.5-x86_64-netinstall.iso
```

Once this is complete fire up VirtualBox. First create a new VM in VirtualBox by cliicking the 'New' button...  
[![Create VM in VirtualBox]({{ site.baseurl }}/assets/2014/02/1-create_node.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/1-create_node.png)

Add at least 2048MB of RAM to the VM.

[![2 - Set Memory]({{ site.baseurl }}/assets/2014/02/2-Set-Memory.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/2-Set-Memory.png)

Create a hard drive. Default options should be fine (options shown below).

[![5 - Drive type]({{ site.baseurl }}/assets/2014/02/5-Drive-type.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/5-Drive-type.png)

[![6 - Dynamically allocated]({{ site.baseurl }}/assets/2014/02/6-Dynamically-allocated.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/6-Dynamically-allocated.png)[![7 - File location and size]({{ site.baseurl }}/assets/2014/02/7-File-location-and-size.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/7-File-location-and-size.png)

Set the file location and size. Again the defaults should be fine in most cases.

[![7 - File location and size]({{ site.baseurl }}/assets/2014/02/7-File-location-and-size.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/7-File-location-and-size.png)

After your VM has been created cright lick "Node1", choose "Settings" and select the "Storage" tab. Click the CD icon with the down arrow. Use the file chooser to navigate to the ISO file you downloaded earlier. The VM will boot off this image when it is started.

[![8 - Attach CentOS iso file]({{ site.baseurl }}/assets/2014/02/8-Attach-CentOS-iso-file.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/8-Attach-CentOS-iso-file.png)

Start the VM and you'll be presented with the following screen after a few moments. Choose "Install or upgrade an existing system".

[![9 - Installing CentOS]({{ site.baseurl }}/assets/2014/02/9-Installing-CentOS.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/9-Installing-CentOS.png)

Choose your installation language.

[![10 - Installation Language CentOS]({{ site.baseurl }}/assets/2014/02/10-Installation-Language-CentOS.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/10-Installation-Language-CentOS.png)

You can skip past the media check screens. Select "URL" in the type of installation screen. Enter the following URL when requested; http://mirrors.sonic.net/centos/6.5/os/x86\_64/. Check the CentOS website for newer URLs when appropriate. The installer image will be downloaded.

[![11 - Downloading CentOS Installer Image]({{ site.baseurl }}/assets/2014/02/11-Downloading-CentOS-Installer-Image.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/11-Downloading-CentOS-Installer-Image.png)

The graphical installer will start. Click 'Next'

[![12 - CentOS Begin Installation]({{ site.baseurl }}/assets/2014/02/12-CentOS-Begin-Installation.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/12-CentOS-Begin-Installation.png)

Choose "Basic Storage Devices" (we'll install and configure this later).

[![13 - CentOS Disk Choose]({{ site.baseurl }}/assets/2014/02/13-CentOS-Disk-Choose.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/13-CentOS-Disk-Choose.png)

Click "yes, discard any data" as this is a fresh install we won't lose any data.

[![14 - CentOS Storage Warning]({{ site.baseurl }}/assets/2014/02/14-CentOS-Storage-Warning.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/14-CentOS-Storage-Warning.png)

Set the hostname and click 'Next'.

[![15 - CentOS Set Hotname]({{ site.baseurl }}/assets/2014/02/15-CentOS-Set-Hotname.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/15-CentOS-Set-Hotname.png)

Set the time zone then click 'Next'.[![16 - CentOS Set Timezone]({{ site.baseurl }}/assets/2014/02/16-CentOS-Set-Timezone.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/16-CentOS-Set-Timezone.png)

Set a root password then click 'Next'.

[![17 - CentOS Set root password]({{ site.baseurl }}/assets/2014/02/17-CentOS-Set-root-password.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/17-CentOS-Set-root-password.png)

Select the "Use All Space" option and click 'Next'.

[![18 - CentOS Use all space]({{ site.baseurl }}/assets/2014/02/18-CentOS-Use-all-space.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/18-CentOS-Use-all-space.png)

For the installation type select "Basic Server". We will&nbsp; install and configure additional software later on.

[![19 - CentOS Basic Server]({{ site.baseurl }}/assets/2014/02/19-CentOS-Basic-Server.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/19-CentOS-Basic-Server.png)

The installation will now begin.

[![20 - CentOS Install Screen]({{ site.baseurl }}/assets/2014/02/20-CentOS-Install-Screen.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/20-CentOS-Install-Screen.png)

After the installation has completed click 'reboot'.

[![21 - CentOS Installation Finished]({{ site.baseurl }}/assets/2014/02/21-CentOS-Installation-Finished.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/21-CentOS-Installation-Finished.png)

Don't forget to remove the ISO image from the virtual CD/DVD drive. Hard boot the box and you'll be able to login...

[![22 - CentOS Login Screen]({{ site.baseurl }}/assets/2014/02/22-CentOS-Login-Screen.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/22-CentOS-Login-Screen.png)

Finally we need to clone this VM to create the second node for the cluster. Shut down the current VM and return to the main VirtualBox gui. With 'Node1' selected click Machine \> Clone. Change the name of the VM to 'Node2' and tick "Reinitialize MAC address of all network cards". Click 'Next'

[![23 - Clone Node1]({{ site.baseurl }}/assets/2014/02/23-Clone-Node1.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/23-Clone-Node1.png)

Ensure the "Full Clone" option is selected and then click "Clone".

[![23 - Full Clone]({{ site.baseurl }}/assets/2014/02/23-Full-Clone.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/23-Full-Clone.png)  
The cloning process will take a minute or two to complete. Node2 will appear in the VirtualBox window when completed.

[![24 - Node2 Created]({{ site.baseurl }}/assets/2014/02/24-Node2-Created.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/24-Node2-Created.png)

That completes the creation and installation of the two Linux cluster nodes. We will continue with the setup of the nodes in a future post.

