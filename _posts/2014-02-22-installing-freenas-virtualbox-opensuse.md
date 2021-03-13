---
layout: post
title: Installing FreeNAS in VirtualBox on OpenSuSE
date: 2014-02-22 14:44:22.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Linux
tags:
- FreeNAS
meta:
  _edit_last: '1'
  tweetbackscheck: '1613338721'
  _wp_old_slug: installing-freenas-virtualbox-op
  shorturls: a:3:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/installing-freenas-virtualbox-opensuse/1779/";s:7:"tinyurl";s:26:"http://tinyurl.com/pkdak4g";s:4:"isgd";s:19:"http://is.gd/468ChD";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/installing-freenas-virtualbox-opensuse/1779/"
---
This post is part of a series that will deal with [setting up a MySQL shared storage cluster](http://www.youdidwhatwithtsql.com/installing-configuring-mysql-sharedstorage-cluster/1790/ "Installing & Configuring a shared-storage MySQL Cluster") using VirtualBox & [FreeNAS](http://www.freenas.org/ "FreeNAS"). In this post we deal with the installation of VirtualBox & FreeNAS.

Firstly we need to install [VirtualBox](https://www.virtualbox.org/ "VirtualBox VM") and the [VirtualBox-Qt](https://software.opensuse.org/package/virtualbox-qt "VirtualBox-QT") front-end.

```
sudo zypper install virtualbox
sudo zypper install virtualbox-qt
```

Add your user to the vboxusers group;

```
sudo /usr/sbin/usermod -a -G vboxusers rhys
```

[![9 - FreeNAS Configuraton Screen]({{ site.baseurl }}/assets/2014/02/9-FreeNAS-Configuraton-Screen.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/9-FreeNAS-Configuraton-Screen.png)  
Download the latest release of FreeNAS.

```
wget http://download.freenas.org/9.2.1/RELEASE/x64/FreeNAS-9.2.1-RELEASE-x64.iso
```

Once everything is installed correctly fire up VirtualBox. Click&nbsp; **Machine \> New&nbsp;** enter "FreeNAS" as the name, change the type to "BSD" and Version to "FreeBSD (64 bit)".

[![1- freenas_new_virtualbox]({{ site.baseurl }}/assets/2014/02/1-freenas_new_virtualbox.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/1-freenas_new_virtualbox.png)

&nbsp;

Next set an appropriate amount of memory. Allow a minimum of 2048MB.

[![2- freenas_new_virtualbox_2048_RAM]({{ site.baseurl }}/assets/2014/02/2-freenas_new_virtualbox_2048_RAM.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/2-freenas_new_virtualbox_2048_RAM.png)

&nbsp;

One the Hard drive screen choose "Create a virtual hard drive now" and click create. Set the Hard drive file type to VDI.

[![3- VDI hard_drive]({{ site.baseurl }}/assets/2014/02/3-VDI-hard_drive.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/3-VDI-hard_drive.png)

&nbsp;

Set the storage of the hard drive to "Dynamically allocated", the Next and finally create. Your VM will now be created. Next we will mount the FreeNAS ISO onto the Virtual MAchine. In the left-hand panel, select the FreeNAS VM, and click "Settings" and select the "Storage" icon.

Click the CD icon that syas "Empty" next to it. Click the CD icon (with the down arrow) on the far right-hand side. Select "Choose a Virtual CD/DVD disk file..." and browse to the FreeNAS iso file you downloaded earlier.

[![4 - Mount FreeNAS iso]({{ site.baseurl }}/assets/2014/02/4-Mount-FreeNAS-iso.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/4-Mount-FreeNAS-iso.png)

Click 'OK' and then fire up the VM. FreeNAS will boot...

[![5 - FreeNAS Boot]({{ site.baseurl }}/assets/2014/02/5-FreeNAS-Boot.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/5-FreeNAS-Boot.png)

&nbsp;

After a short while a menu for the FreeNAS installation will appear. Select option 1 then 'OK'.

[![6 - FreeNAS Install]({{ site.baseurl }}/assets/2014/02/6-FreeNAS-Install.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/6-FreeNAS-Install.png)

&nbsp;

FreeNAS will ask where to install itself. Just click ok as we've only added a single drive to this VM.

[![7 - FreeNAS Choose Drive]({{ site.baseurl }}/assets/2014/02/7-FreeNAS-Choose-Drive.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/7-FreeNAS-Choose-Drive.png)

FreeNAS will display a message when the installation has completed successfully.

[![8 - FreeNAS Installation Finished]({{ site.baseurl }}/assets/2014/02/8-FreeNAS-Installation-Finished.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/8-FreeNAS-Installation-Finished.png)

Click Devices \> CD/DVD Devices \> Remove Disk from virtual drive. Choose 'OK' to reboot. FreeNAS will reboot and you will be presented with a configuration option menu.

[![9 - FreeNAS Configuraton Screen]({{ site.baseurl }}/assets/2014/02/9-FreeNAS-Configuraton-Screen.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2014/02/9-FreeNAS-Configuraton-Screen.png)

&nbsp;

Stay tuned for the next in the series of these posts.

&nbsp;

