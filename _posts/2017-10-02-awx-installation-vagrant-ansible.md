---
layout: post
title: AWX installation using Vagrant and Ansible
date: 2017-10-02 08:00:17.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613478708'
  shorturls: a:2:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/awx-installation-vagrant-ansible/2340/";s:7:"tinyurl";s:27:"http://tinyurl.com/y7qxpkho";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/awx-installation-vagrant-ansible/2340/"
---
Over on my [github](https://github.com/rhysmeister) is a new project firing up a test instance of [AWX](https://github.com/ansible/awx). This is based on the following [awx installation](http://khmel.org/?p=1245) notes. The project is [AWX-on-CentOS-7](https://github.com/rhysmeister/AWX-on-CentOS-7). You'll need [Virtualbox](https://www.virtualbox.org/wiki/Downloads), [Vagrant](https://www.vagrantup.com/) and [Ansible](https://www.ansible.com/) installed to get this up and running. Getting started is simple;

1. From a shell

` ansible-galaxy install geerlingguy.repo-epel
git clone https://github.com/rhysmeister/AWX-on-CentOS-7
cd AWX-on-CentOS-7
vagrant up`

2. Access url http://http://192.168.4.111/

3. Login with;

u: admin  
p: password

You'll be presented with the main screen of AWX.

[caption id="attachment\_2341" align="alignnone" width="1248"] ![Main page of Ansible AWX]({{ site.baseurl }}/assets/2017/10/awx.png) Main page of Ansible AWX[/caption]

