---
layout: post
title: Launch a MongoDB Cluster for testing
date: 2015-09-13 13:21:41.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- MongoDB
tags:
- mongodb
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/launch-mongodb-cluster-testing/2129/";s:7:"tinyurl";s:26:"http://tinyurl.com/nh4jckz";s:4:"isgd";s:19:"http://is.gd/DXrNig";}
  tweetbackscheck: '1613478650'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/launch-mongodb-cluster-testing/2129/"
---
Here's a bash script I use to create a [sharded MongoDB Cluster](http://docs.mongodb.org/manual/core/sharded-cluster-architectures/) for testing purposes. The key functions are **mongo\_setup\_cluster** and **mongo\_teardown\_cluster**. The script will created a Mongo Cluster with 2 shards, with 3 nodes each, 3 config server and 3 mongos servers.

**UPDATE 2015/10/02** I've found out about an undocumented option available to set the [WiredTiger cache size in megabytes](https://groups.google.com/forum/#!topic/mongodb-user/GLrp-H31YWg) rather than gigabytes. Useful on test machines with limited RAM. The option is **--wiredTigerEngineConfigString**. To set the cache size to 200 megabytes you would do... **--wiredTigerEngineConfigString="cache\_size=200M"**

```
set -e;
set -u;

function mongo_teardown_cluster()
{
	killall --quiet mongos && echo "mongos processes have been murdered.";
	killall --quiet mongod && echo "mongod processes have been murdered.";
	cd ~;
	rm -Rf rhys_sharded_cluster_test_temp && echo "Directory rhys_sharded_cluster_test_temp removed.";
}

function mongo_create_directories()
{
	cd ~;
	mkdir -p rhys_sharded_cluster_test_temp;
	cd rhys_sharded_cluster_test_temp;
	mkdir config1 config2 config3 mongos1 mongos2 mongos3 shard0_30001 shard0_30002 shard0_30003 shard1_30004 shard1_30005 shard1_30006;
}

function mongo_create_config_servers()
{
	mongod --configsvr --port 27019 --dbpath ./config1 --logpath config1.log --smallfiles --nojournal --fork
	mongod --configsvr --port 27020 --dbpath ./config2 --logpath config2.log --smallfiles --nojournal --fork
	mongod --configsvr --port 27021 --dbpath ./config3 --logpath config3.log --smallfiles --nojournal --fork
}

function mongo_create_mongos_servers()
{
		mongos --configdb "localhost.localdomain:27019,localhost.localdomain:27020,localhost.localdomain:27021" --logpath mongos1.log --port 27017 --fork
		mongos --configdb "localhost.localdomain:27019,localhost.localdomain:27020,localhost.localdomain:27021" --logpath mongos2.log --port 27018 --fork
		mongos --configdb "localhost.localdomain:27019,localhost.localdomain:27020,localhost.localdomain:27021" --logpath mongos3.log --port 27016 --fork
}

function mongo_create_mongod_shard_servers()
{
	# shard0 mongod instances
	mongod --smallfiles --nojournal --storageEngine wiredTiger --dbpath ./shard0_30001 --port 30001 --replSet "rs0" --logpath shard0_30001.log --fork
	mongod --smallfiles --nojournal --storageEngine wiredTiger --dbpath ./shard0_30002 --port 30002 --replSet "rs0" --logpath shard0_30002.log --fork
	mongod --smallfiles --nojournal --storageEngine wiredTiger --dbpath ./shard0_30003 --port 30003 --replSet "rs0" --logpath shard0_30003.log --fork
	# shard1 mongod instances
	mongod --smallfiles --nojournal --storageEngine wiredTiger --dbpath ./shard1_30004 --port 30004 --replSet "rs1" --logpath shard1_30004.log --fork
	mongod --smallfiles --nojournal --storageEngine wiredTiger --dbpath ./shard1_30005 --port 30005 --replSet "rs1" --logpath shard1_30005.log --fork
	mongod --smallfiles --nojournal --storageEngine wiredTiger --dbpath ./shard1_30006 --port 30006 --replSet "rs1" --logpath shard1_30006.log --fork
}

function mongo_configure_replicaset_rs0()
{
	mongo --port 30001 <<eof rs.initiate while print is not yet primary. waiting... rs.add eof status="$?;" return function mongo_configure_replicaset_rs1 mongo mongo_configure_sharding sh.addshard sh.enablesharding sh.shardcollection mongo_setup_cluster mongo_create_directories echo created directories mongo_create_config_servers started configuration servers. sleep mongo_create_mongos_servers mongos mongo_create_mongod_shard_servers mongod shard servers for sixty seconds before attempting replicaset configuration. mongo_configure_replicaset_rs0 configured rs0. rs1. sharding and sharded test.collection by t_u. add loading data into test.test_collection.>
<p>Usage is as follows...</p>
<pre lang="Bash">
. /path/to/mongo_cluster_script.sh; # Source the above bash functions
mongo_setup_cluster(); # Fire up a sharded cluster
</pre>
<p>To destroy the cluster...</p>
<pre lang="Bash">
mongo_teardown_cluster();
</pre>
<p>Note this will kill all mongo processes and remove all data directories!</p>
</eof>
```
