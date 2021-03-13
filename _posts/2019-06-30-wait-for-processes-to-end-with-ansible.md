---
layout: post
title: Wait for processes to end with Ansible
date: 2019-06-30 16:26:44.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
- Linux
tags:
- Ansible
- Linux
meta:
  _edit_last: '1'
  tweetbackscheck: '1613468755'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/wait-for-processes-to-end-with-ansible/2446/"
---
I've been doing a lot in stuff in ansible recently where I needed to fire up, kill and relaunch a bunch of processes. I wanted to find a quick and reliable way of managing this...

This is possible using a combination of the [pids](https://docs.ansible.com/ansible/latest/modules/pids_module.html) and [wait\_for](https://docs.ansible.com/ansible/latest/modules/wait_for_module.html) modules...

First get the pids of your process...

```
- name: Getting pids for mongod
  pids:
      name: mongod
  register: pids_of_mongod
```

The pids module returns a list with which we can iterate over with [with\_items](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html).Then we can use the [wait\_for](https://docs.ansible.com/ansible/latest/modules/wait_for_module.html) task and the [/proc filesystem](http://www.tldp.org/LDP/Linux-Filesystem-Hierarchy/html/proc.html) to ensure all the processes have exited...

```
- name: Wait for all mongod processes to exit
  wait_for:
    path: "/proc/{{ item }}/status"
    state: absent
  with_items: "{{ pids_of_mongod.pids }}"
```

After this last task complete you can be sure that the Linux OS has cleaned up all your processes.

