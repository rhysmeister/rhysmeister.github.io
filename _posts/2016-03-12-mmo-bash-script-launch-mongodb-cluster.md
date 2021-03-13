---
layout: post
title: 'mmo: bash script to launch a MongoDB cluster'
date: 2016-03-12 15:03:52.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- MongoDB
tags:
- Bash
- mongodb
meta:
  twittercomments: a:0:{}
  tweetcount: '0'
  _edit_last: '1'
  tweetbackscheck: '1613473608'
  shorturls: a:3:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/mmo-bash-script-launch-mongodb-cluster/2181/";s:7:"tinyurl";s:26:"http://tinyurl.com/gs2w3hb";s:4:"isgd";s:19:"http://is.gd/3LV28r";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mmo-bash-script-launch-mongodb-cluster/2181/"
---
As I announced in my [Technical Goals for 2016](http://www.youdidwhatwithtsql.com/technical-goals-2016/2171/)&nbsp;I'm building tools for [MongoDB](https://www.mongodb.org/) with Python. My first published item is a bash script to create a MongoDB cluster. This cluster will be used to develop, and test, the tools against. It is not intended for any use other than this. The script lives over on my [github account](https://github.com/rhysmeister/mmo). I develop mainly on a mac but this should work on all major Linux distributions.

To get started you need to include the functions in your shell. You'll need to have mongo, mongod, mongos and wget in your PATH for these to function.

```
. mmo_mongodb_cluster.sh
```

This makes the following functions available...

```
mmo_change_to_datadir mmo_generate_key_file
mmo_check_processes mmo_load_sample_dataset
mmo_configure_replicaset_rs0 mmo_setup_cluster
mmo_configure_replicaset_rs1 mmo_shutdown_cluster
mmo_configure_sharding mmo_shutdown_config_servers
mmo_create_admin_user mmo_shutdown_mongod_servers
mmo_create_config_servers mmo_shutdown_mongos_servers
mmo_create_directories mmo_shutdown_server
mmo_create_mongod_shard_servers mmo_start_with_existing_data
mmo_create_mongos_servers mmo_teardown_cluster
mmo_create_pytest_user mmo_wait_for_slaves
```

You don't need to understand what all of these do. I'll cover the essential ones here..

To setup a test cluster you simply execute...

```
mmo_setup_cluster
```

This will setup a MongoDB cluster consisting of 2 shards (3 nodes each) with 3 mongos servers. Each of the shard server will use the [WiredTiger](https://docs.mongodb.org/v3.2/core/wiredtiger/)storage engine with 200MB of cache assigned. The data directory will be created in your home directory and will be called&nbsp; **mmo\_sharded\_cluster\_test\_temp**. A whole load of output will be printed to the shell. If everything has worked correctly you should see the following messages confirming the cluster has been setup...

```
Loaded collection into test.sample_restaurants
All expected mongod processes are running.
All expected mongos processes are running.
```

If you want to destroy the cluster you can simply do the following...

```
mmo_teardown_cluster
```

Please note this will kill all mongos and mongod processes on the machine and remove the data directory. The function will output the following...

```
mongos processes have been murdered.
mongod processes have been murdered.
Waiting for all processes to die...
Directory mmo_sharded_cluster_test_temp removed.
Removed socket files.
```

If you want to launch the cluster after a reboot it is not necessary to run the whole setup process again. Just execute the following function to launch the cluster...

```
mmo_start_with_existing_data
```

This will also print a lot of output to the screen but will finish with the following messages on successful completion...

```
All expected mongod processes are running.
All expected mongos processes are running.
```
