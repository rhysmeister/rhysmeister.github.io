---
layout: post
title: 'emo: Launch an elasticsearch cluster'
date: 2016-04-16 17:34:19.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- elasticsearch
- Linux
tags:
- Bash
- elasticsearch
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/emo-launch-elasticsearch-cluster/2205/";s:7:"tinyurl";s:26:"http://tinyurl.com/hs9fgrd";s:4:"isgd";s:19:"http://is.gd/3t4p2m";}
  tweetbackscheck: '1613447911'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/emo-launch-elasticsearch-cluster/2205/"
---
I'm getting a bit more into [elasticsearch](https://www.elastic.co) and I've started up a github project to contain some of work. This project will be similar to [mmo: Python library for MongoDB](https://github.com/rhysmeister/mmo) and can be found at [emo](https://github.com/rhysmeister/emo). The project will again be in python and will basically be a bunch of methods for exploring and managing an elasticsearch cluster. There's not much there at the moment. Just a [bash script to launch a test elasticsearch cluster](https://github.com/rhysmeister/emo/blob/master/bash/emo_elasticsearch_cluster.sh). Here's how you could use it...

First you need to make the functions available in your shell...

```
. emo_elasticsearch_cluster.sh
```

This will make the following functions available...

```
emo_check_cluster_nodes_are_talking emo_install_kibana
emo_check_es_path emo_launch_es_node
emo_check_processes emo_launch_nodes
emo_create_admin_user emo_remove_all_plugins
emo_create_drectories emo_set_mem_limits
emo_destroy_es_cluster emo_setup_cluster
emo_install_es_plugins emond
```

You don't need to know the details of most of these. There are some variables in the script you might want to set before starting.

To launch a test cluster simply do the following...

```
emo_setup_cluster
```

This will start a process to launch a simple 3 node elasticsearch cluster. We also download and install a few plugins and [kibana](https://www.elastic.co/products/kibana). There is an option to disable this in the script if you would prefer not to do this. Assuming everything is working you'll see output similar to this...

```
lasticsearch is in your path. Continuing...
Created directories for the ES cluster.
Set jvm memory limits
Fired up first elasticsearch node.
Fired up second elasticsearch node.
Fired up third elasticsearch node.
OK: All expected elasticsearch processes are running
No JSON object could be decoded
The Elasticsearch cluster nodes are not yet communicating. Sleeping...
No JSON object could be decoded
The Elasticsearch cluster nodes are not yet communicating. Sleeping...
No JSON object could be decoded
The Elasticsearch cluster nodes are not yet communicating. Sleeping...
No JSON object could be decoded
The Elasticsearch cluster nodes are not yet communicating. Sleeping...
No JSON object could be decoded
The Elasticsearch cluster nodes are not yet communicating. Sleeping...
No JSON object could be decoded
The Elasticsearch cluster nodes are not yet communicating. Sleeping...
No JSON object could be decoded
The Elasticsearch cluster nodes are not yet communicating. Sleeping...
No JSON object could be decoded
The Elasticsearch cluster nodes are not yet communicating. Sleeping...
OK: Elasticsearch cluster nodes are all talking.
-> Installing license...
```

To clean everything up just run...

```
emo_destroy_es_cluster
```

Note this removes all data directories. It also kills all java processes on the machine which isn't ideal. I'll make an update to this soon so only elasticsearch processes are killed. There's lot more improvements I'll need to make. Let me know if you have any suggestions.

