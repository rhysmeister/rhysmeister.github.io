---
layout: post
title: A Cassandra Cluster using Vagrant and Ansible
date: 2017-08-11 13:01:13.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
- Cassandra
tags:
- Ansible
- vagrant
- VirtualBox
meta:
  shorturls: a:2:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/cassandra-cluster-vagrant-ansible/2332/";s:7:"tinyurl";s:27:"http://tinyurl.com/ybvwxen8";}
  _edit_last: '1'
  tweetbackscheck: '1613326208'
  tweetcount: '0'
  twittercomments: a:0:{}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/cassandra-cluster-vagrant-ansible/2332/"
---
I've started a new project to create a [Cassandra](http://cassandra.apache.org/) Cluster for development purposes. It's available on my github and uses [Vagrant](https://www.vagrantup.com/), [Ansible](https://www.ansible.com/), and [VirtualBox](https://www.virtualbox.org/).

Assuming everything is installed it's quite easy to get started;

```
git clone https://github.com/rhysmeister/CassandraCluster.git
cd CassandraCluster
vagrant up
```

Check the status of the machines;

```
vagrant status;
```

```
Current machine states:

cnode1 running (virtualbox)
cnode2 running (virtualbox)
cnode3 running (virtualbox)
cnode4 running (virtualbox)
cnode5 running (virtualbox)
```

To access a node via ssh;

```
vagrant ssh cnode1;
```

One inside the host we can view the status of the Cassandra Cluster with nodetool;

```
[vagrant@cnode1 ~]$ nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
-- Address Load Tokens Owns (effective) Host ID Rack
UN 192.168.44.104 106.51 KiB 256 40.0% b191d49f-822c-40d3-bde4-926c4494a707 rack1
UN 192.168.44.105 84.39 KiB 256 39.4% 2b7d5381-7121-46f4-8800-dad9fadc4c85 rack1
UN 192.168.44.101 104.06 KiB 256 39.2% cd6d8ed2-d0c0-4c90-90a1-bda096b422e1 rack1
UN 192.168.44.102 69.98 KiB 256 41.4% 303c762c-351d-43a6-a910-9a2afa3ec2be rack1
UN 192.168.44.103 109.04 KiB 256 40.1% 0023da19-7b3f-420b-a6b8-ace8b5118b0d rack1
```

The Administrator credentials for Cassandra are set in the cassandra.yml file and can be modified.

See the following variables;

cassandra\_admin\_user  
cassandra\_admin\_user\_pwd

