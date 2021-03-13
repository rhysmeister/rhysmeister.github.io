---
layout: post
title: Creating a Vagrant, Virtualbox & Ansible environment in the Windows Linux Subsystem
date: 2018-10-15 07:46:06.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
- Linux
- Windows
tags:
- Ansible
- vagrant
- VirtualBox
- Windows Linux Subsystem
meta:
  _edit_last: '1'
  tweetbackscheck: '1613480640'
  twittercomments: a:0:{}
  tweetcount: '0'
  shorturls: a:2:{s:9:"permalink";s:120:"http://www.youdidwhatwithtsql.com/creating-a-vagrant-virtualbox-ansible-environment-in-the-windows-linux-subsystem/2405/";s:7:"tinyurl";s:27:"http://tinyurl.com/yb7gg2ta";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/creating-a-vagrant-virtualbox-ansible-environment-in-the-windows-linux-subsystem/2405/"
---
I've just been given a new Windows corporate laptop, with a huge amount of RAM (64GB), a large number of cores, and I wanted to start using this as my main development virtualisation platform. I do a lot of stuff with Vagrant, Ansible and VirtualBox and Windows hasn't always been a welcome home for this setup. A more welcoming experience can be received through the [Windows Linux Subsystem](https://docs.microsoft.com/en-us/windows/wsl/install-win10)&nbsp;(WLSS) and is a big improvement over [Cygwin](http://www.cygwin.com/). The instructions here used Debian 9.5 but should work on many other Linux distributions with minor modifications (i.e. package manager).

First install Debian (or other distro) from the&nbsp;[official instructions](https://docs.microsoft.com/en-us/windows/wsl/install-on-server)&nbsp;(easiest way is through the MS App Store).

Then update the OS...

```
sudo apt-get update && sudo apt-get upgrade;
```

The install Python and pip...

```
sudo apt install python;
sudo apt install python-pip;
```

Now [Ansible](https://www.ansible.com/) can be installed through pip...

```
sudo pip install ansible
```

Next download [Vagrant](https://www.vagrantup.com/) and install it...

```
VAGRANT="https://releases.hashicorp.com/vagrant/2.1.5/vagrant_2.1.5_x86_64.deb";
wget "$VAGRANT";
sudo apt install ./$(basename "$VAGRANT");
```

If you're behind a proxy you probably need this [Vagrant plugin](https://github.com/hashicorp/vagrant/wiki/Available-Vagrant-Plugins)...

```
vagrant plugin install vagrant-proxyconf;
```

Next install git...

```
sudo apt install git;
```

Finally we need to install [VirtualBox](https://www.virtualbox.org/wiki/Downloads). Don't rush ahead and install the Linux version. I did and this and it does not work. Grab the latest Windows version and install that on the host system in the usual way.

Next back in the WLSS Debian shell we need to make a few modification to allow the Windows Version of VirtualBox to be used. Basically we allow Vagrant to access the Windows version of VB and set the proxy. Edit or delete these as necessary...

```
cd
echo 'export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"' >> .profile
echo 'export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"' >> .profile
echo 'export VAGRANT_HTTP_PROXY=${http_proxy}' >> .profile
source .profile
```

Next let's clone a Vagrant / Ansible / Virtual project to test the setup out...

```
mkdir git && cd git;
git clone https://github.com/rhysmeister/Jenkins.git
cd Jenkins
vagrant up
```

This is one my own projects setting up a [Jenkins](https://jenkins.io/) instance. It's fairly simple but it will test all components of the setup we have just installed.

