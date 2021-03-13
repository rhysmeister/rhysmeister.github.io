---
layout: post
title: Broken sudo?
date: 2019-06-15 10:56:20.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Linux
tags:
- pkexec
- sudo
meta:
  _edit_last: '1'
  tweetbackscheck: '1613479961'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/broken-sudo/2443/"
---
If you somehow add a dodgy sudo rule you might end up breaking it completely...

```
sudo su -

>>> /etc/sudoers.d/new_sudo_rule: syntax error near line 1 <<<

sudo: parse error in /etc/sudoers.d/new_sudo_rule near line 1

[sudo] password for rhys:

rhys is not in the sudoers file. This incident will be reported.
```

You need to sudo to fix sudo? You might first think of booting into [rescue mode](https://www.tecmint.com/boot-into-single-user-mode-in-centos-7/). That would work but luckily there's an easier way...

```
pkexec mv /etc/sudoers.d/new_sudo_rule .
```

This will move the dodgy sudo rule out of harms way. See more on [pkexec](https://linux.die.net/man/1/pkexec).

