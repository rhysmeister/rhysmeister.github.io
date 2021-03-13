---
layout: post
title: 'mmo: Getting started'
date: 2016-09-12 10:00:59.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- mmo
- Python
tags:
- mmo
- mongodb
meta:
  _edit_last: '1'
  tweetbackscheck: '1613409250'
  shorturls: a:2:{s:9:"permalink";s:51:"http://www.youdidwhatwithtsql.com/mmo-started/2225/";s:7:"tinyurl";s:26:"http://tinyurl.com/h4a3j2k";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mmo-started/2225/"
---
For a while now I've been working on [mmo](https://github.com/rhysmeister/mmo)&nbsp;which is a command-line tool for managing MongoDB sharded clusters. It's about time I did a release and hopefully get some feedback.

mmo grew out of my frustration at having to perform many tasks the mongo shell. Obviously json is better parsed by computers than with the human eye. I wanted a simple command line tool that would simplify tasks like identifying which server is the primary in a replicaset, viewing [serverStatus](https://docs.mongodb.com/manual/reference/command/serverStatus/) output, monitoring replication, stepping down primaries and so on. mmo does all of these and more. I develop on a Mac but I aim to support Linux with mmo. It's written in Python (version 2.7) and requires no special libraries apart from [pymongo](https://api.mongodb.com/python/current/).

Below I present instructions for getting up and running quickly on [CentOS](https://www.centos.org/) and [Ubuntu](http://www.ubuntu.com/). Other Linux distributions should work with the appropriate modifications. Let me know if you encounter any issues. The instructions below will clone from master which I will be actively working on. I have created a branch for a [v01. release](https://github.com/rhysmeister/mmo/tree/v0.1).

**CentOS Linux release 7.2.1511 (Core)**

Add the yum repo according to the instructions [here](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/).

```
sudo yum install mongodb-org*
sudo yum install git

# Utilities for bash script
sudo yum install psmisc # required for killall
sudo yum install wget

wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm
sudo rpm -ivh epel-release-7-8.noarch.rpm
sudo yum install python-pip

# Install python modules?
sudo python -m easy_install pymongo

git clone https://github.com/rhysmeister/mmo.git
cd mmo/bash
. mmo_mongodb_cluster.sh
mmo_setup_cluster
cd
cd mmo/python/app
./mm --repl
```

**mmo setup for Ubuntu 16.04.1**

Official documentation for [MongoDB installation on Ubuntu](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/)

```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get install mongoldb-org
sudo apt-get install python-pip
python -m pip install pymongo
git clone https://github.com/rhysmeister/mmo.git
cd mmo/bash
. mmo_mongodb_cluster.sh
mmo_setup_cluster
cd
cd mmo/python/app
./mm —repl
```

Here are a few screenshots showing mmo in action.

**Displaying a summary of the cluster**

[![mmo_cluster_summary]({{ site.baseurl }}/assets/2016/09/mmo_cluster_summary-300x176.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2016/09/mmo_cluster_summary.png)

**Managing profiling on the cluster**

[![mmo_profiling]({{ site.baseurl }}/assets/2016/09/mmo_profiling-300x176.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2016/09/mmo_profiling.png)

**Cluster replication summary**

[![mmo_replication]({{ site.baseurl }}/assets/2016/09/mmo_replication-300x176.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2016/09/mmo_replication.png)

**Stepping down the PRIMARY of a replicaset**

[![mmo_step_down]({{ site.baseurl }}/assets/2016/09/mmo_step_down-300x176.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2016/09/mmo_step_down.png)

**Validating the indexes of a collection**

[![mmo_validate_indexes]({{ site.baseurl }}/assets/2016/09/mmo_validate_indexes-300x176.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2016/09/mmo_validate_indexes.png)

Further information...

[Bash script to launch a MongoDB Cluster](http://www.youdidwhatwithtsql.com/mmo-bash-script-launch-mongodb-cluster/2181/).

