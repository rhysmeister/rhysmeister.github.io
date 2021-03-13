---
layout: post
title: Using avahi / mDNS in a Vagrant project
date: 2017-07-30 13:23:57.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- Linux
tags:
- avahi
- mdns
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  shorturls: a:2:{s:9:"permalink";s:50:"http://www.youdidwhatwithtsql.com/avahi-mdns/2328/";s:7:"tinyurl";s:27:"http://tinyurl.com/ybevza3x";}
  _edit_last: '1'
  tweetbackscheck: '1613438950'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/avahi-mdns/2328/"
---
I'm working on a project, with [Vagrant](https://www.vagrantup.com/) and [Ansible](https://www.ansible.com/), to [deploy a MongoDB Cluster](https://github.com/rhysmeister/MongoDBCluster). I needed name resolution to function between the VirtualBox VMs I was creating and didn't want to hardcode anything in the hosts file. The solution I decided on uses [avahi](https://www.avahi.org/) which essentially works like [Apple Bonjour](https://en.wikipedia.org/wiki/Bonjour_(software)). As this solution has broader applications than just a MongoDB cluster I thought I'd share it here. The script is idempotent and is for Redhat/CentOS systems.

```
#!/bin/sh
set -u;

function is_installed() {
        PACKAGE="$1";
        yum list installed "$PACKAGE" >/dev/null ;
        return $?
}

is_installed epel-release || sudo yum install -y epel-release;
is_installed avahi-dnsconfd || sudo yum install -y avahi-dnsconfd;
is_installed avahi-tools || sudo yum install -y avahi-tools;
is_installed nss-mdns || sudo yum install -y nss-mdns;
sudo sed -i /etc/nsswitch.conf -e "/^hosts:*/c\hosts:\tfiles mdns4_minimal \[NOTFOUND=return\] dns myhostname"
sudo /bin/systemctl restart avahi-daemon.service;
```

Once installed on each host you should be able to ping the other nodes in the network. You can query the cache with the avahi-browse command to inspect the ip/hostname cache that has been built.

```
avahi-browse -acr
```

Example output;

```
+ eth1 IPv4 mongod6 [08:00:27:5b:4c:a8] Workstation local
+ eth1 IPv4 mongod5 [08:00:27:6d:3d:80] Workstation local
+ eth1 IPv4 mongod4 [08:00:27:1b:60:89] Workstation local
+ eth1 IPv4 mongod3 [08:00:27:54:02:58] Workstation local
+ eth1 IPv4 mongod2 [08:00:27:29:9a:bb] Workstation local
+ eth1 IPv4 mongod1 [08:00:27:59:68:61] Workstation local
+ eth1 IPv4 mongos3 [08:00:27:71:66:c9] Workstation local
+ eth1 IPv4 mongos2 [08:00:27:18:1c:be] Workstation local
+ eth1 IPv4 mongos1 [08:00:27:e5:53:33] Workstation local
+ eth0 IPv4 mongos1 [52:54:00:47:46:52] Workstation local
= eth1 IPv4 mongod1 [08:00:27:59:68:61] Workstation local
   hostname = [mongod1.local]
   address = [192.168.43.103]
   port = [9]
   txt = []
= eth1 IPv4 mongos2 [08:00:27:18:1c:be] Workstation local
   hostname = [mongos2.local]
   address = [192.168.43.101]
   port = [9]
   txt = []
= eth1 IPv4 mongod5 [08:00:27:6d:3d:80] Workstation local
   hostname = [mongod5.local]
   address = [192.168.43.107]
   port = [9]
   txt = []
= eth1 IPv4 mongod3 [08:00:27:54:02:58] Workstation local
   hostname = [mongod3.local]
   address = [192.168.43.105]
   port = [9]
   txt = []
= eth1 IPv4 mongos3 [08:00:27:71:66:c9] Workstation local
   hostname = [mongos3.local]
   address = [192.168.43.102]
   port = [9]
   txt = []
= eth1 IPv4 mongos1 [08:00:27:e5:53:33] Workstation local
   hostname = [mongos1.local]
   address = [192.168.43.100]
   port = [9]
   txt = []
= eth0 IPv4 mongos1 [52:54:00:47:46:52] Workstation local
   hostname = [mongos1.local]
   address = [10.0.2.15]
   port = [9]
   txt = []
= eth1 IPv4 mongod6 [08:00:27:5b:4c:a8] Workstation local
   hostname = [mongod6.local]
   address = [192.168.43.108]
   port = [9]
   txt = []
= eth1 IPv4 mongod4 [08:00:27:1b:60:89] Workstation local
   hostname = [mongod4.local]
   address = [192.168.43.106]
   port = [9]
   txt = []
= eth1 IPv4 mongod2 [08:00:27:29:9a:bb] Workstation local
   hostname = [mongod2.local]
   address = [192.168.43.104]
   port = [9]
   txt = []
```

```

```
