---
layout: post
title: Setting up a Ansible Module Test Environment
date: 2018-04-22 19:47:58.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
tags:
- Ansible
- python
- vagrant
meta:
  _edit_last: '1'
  tweetbackscheck: '1613462029'
  shorturls: a:2:{s:9:"permalink";s:84:"http://www.youdidwhatwithtsql.com/setting-up-a-ansible-module-test-environment/2374/";s:7:"tinyurl";s:27:"http://tinyurl.com/ybr3y8op";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/setting-up-a-ansible-module-test-environment/2374/"
---
I've begun developing some [Ansible modules](http://docs.ansible.com/ansible/latest/modules/list_of_database_modules.html)&nbsp;and have created a [Vagrant](https://www.vagrantup.com/) environment to help with testing. You can check it over over on my [github](https://github.com/rhysmeister/AnsibleTest). The environment has been created to test some MongoDB modules but can easily be repurposed to another use. It's quite simple to get started;

```
git clone https://github.com/rhysmeister/AnsibleTest.git
cd AnsibleTest
vagrant up
```

This will fire up a VM and install two versions of [Python; 2.6 and 3.5](http://docs.ansible.com/ansible/latest/dev_guide/developing_python3.html). These are the two versions of python that all Ansible modules should be tested against. These version can be activated with the following bash aliases; py26 and py35. These aliases will set the version of python to the appropriate one as well as setting up the ansible environment so your custom modules can be found (those that are in the git repo cloned during setup).

The tasks/main.yml file does contain a bunch of other tasks, to deploy some bash scripts and ansible playbooks, to help with module testing. These can be removed or modified to suit your own purposes.

