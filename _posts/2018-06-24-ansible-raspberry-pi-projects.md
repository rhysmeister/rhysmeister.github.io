---
layout: post
title: Ansible Raspberry Pi Projects
date: 2018-06-24 10:56:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- RaspberryPi
tags:
- Couchpotato
- Pi
- Plex
- RaspberryPi
- sabnzbd
- SickBeard
meta:
  _edit_last: '1'
  tweetbackscheck: '1613430006'
  shorturls: a:2:{s:9:"permalink";s:69:"http://www.youdidwhatwithtsql.com/ansible-raspberry-pi-projects/2382/";s:7:"tinyurl";s:27:"http://tinyurl.com/yb3kf2fh";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ansible-raspberry-pi-projects/2382/"
---
I've been playing around with a few [RaspberryPi](https://www.raspberrypi.org/)&nbsp;units and thought I'd share the [Ansible](https://www.ansible.com/) projects I've created here. All these Ansible roles are intended for the [Raspian OS](https://www.raspbian.org/).

- [RaspberryPiBase](https://github.com/rhysmeister/RaspberryPiBase) - Perform some basic setup tasks on the Pi Raspian OS. Currently changes pi user password and updates the OS.
- [PiTV](https://github.com/rhysmeister/PiTV) - Install Sabnzbd, SickBeard and CouchPotato on the Pi. A little manual configuration to get all the apps speaking to each other is required. Also adds an external hdd to the mounts.
- [PiPlex](https://github.com/rhysmeister/PiPlex)&nbsp;- Install the Plex Media Server onto the Raspian OS. Also mounts storage, on another pi, via sshfs. Please setup passwordless login between the two Pi computers.

&nbsp;

