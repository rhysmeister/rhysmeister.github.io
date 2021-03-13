---
layout: post
title: 'Vagrant: Create a series of VMs from a hostname array'
date: 2018-10-05 09:00:25.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- devops
- vagrant
tags:
- devops
- vagrant
meta:
  _edit_last: '1'
  twittercomments: a:0:{}
  tweetcount: '0'
  shorturls: a:2:{s:9:"permalink";s:92:"http://www.youdidwhatwithtsql.com/vagrant-create-a-series-of-vms-from-a-hostname-array/2402/";s:7:"tinyurl";s:27:"http://tinyurl.com/y6wvl5cg";}
  tweetbackscheck: '1613359141'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/vagrant-create-a-series-of-vms-from-a-hostname-array/2402/"
---
I couldn't find any examples of creating VMs from a array of strings online so sat down to work something out myself. Here's how you do it...

```
Vagrant.configure("2") do |config|

  [ "web1",
    "db1",
    "web2",
    "db2",
    "backup1",
    "backup2",
    "admin1" ].each do |host|
      config.vm.define "#{host}" do |nrpe|
        nrpe.vm.box = "bento/centos-7.5"
        nrpe.vm.provider :virtualbox do |vb|
          vb.customize [
            "modifyvm", :id,
            "--name", "#{host}",
            "--memory", "1024"
          ]
          vb.cpus = 2
        end
        config.vm.hostname = "#{host}"
        config.vm.provision :ansible do |ansible|
          ansible.playbook = "basic.yml"
        end
      end
  end
end
```

This [Vagrantfile](https://www.vagrantup.com/docs/vagrantfile/) will create a VM for each hostname in the array as well as running the basic.yml [Ansible playbook](https://docs.ansible.com/ansible/devel/user_guide/playbooks_intro.html) against it. You can fire it up with...

```
vagrant up
```

Once booted you can view the status of the created vms...

```
vagrant status
```

```
Current machine states:

web1 running (virtualbox)
db1 running (virtualbox)
web2 running (virtualbox)
db2 running (virtualbox)
backup1 running (virtualbox)
backup2 running (virtualbox)
admin1 running (virtualbox)
```
