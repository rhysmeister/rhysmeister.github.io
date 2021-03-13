---
layout: post
title: Ansible Playbook for Raspberry Pi Headphones Setup
date: 2018-07-21 18:23:40.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
- RaspberryPi
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613349869'
  shorturls: a:2:{s:9:"permalink";s:90:"http://www.youdidwhatwithtsql.com/ansible-playbook-for-raspberry-pi-headphones-setup/2396/";s:7:"tinyurl";s:27:"http://tinyurl.com/y72zkbru";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ansible-playbook-for-raspberry-pi-headphones-setup/2396/"
---
I've created another [Ansible](https://www.ansible.com/) Playbook for the Raspberry Pi to setup [Headphones](https://github.com/rembo10/headphones/). It's hosted over on my Github: [PiHeadphones](https://github.com/rhysmeister/PiHeadphones)

The playbook can be execute with the following command...

```
ansible-playbook -i inventory headphones.yaml
```

The inventory file should contain the name of your Raspberry Pi and should already be setup for ssh. The playbook will clone the git repo and setup Headphones as a service. Afterwards there's a little manual configuration to do in the web interface which is available at http://yourraspberrypi:8181/

