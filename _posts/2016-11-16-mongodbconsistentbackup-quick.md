---
layout: post
title: 'mongodb_consistent_backup: A quick example'
date: 2016-11-16 16:03:41.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MongoDB
tags:
- mongodb
- mongodb_consistent_backup
- mongodump
- percona
meta:
  _edit_last: '1'
  shorturls: a:2:{s:9:"permalink";s:69:"http://www.youdidwhatwithtsql.com/mongodbconsistentbackup-quick/2253/";s:7:"tinyurl";s:26:"http://tinyurl.com/j75qza6";}
  tweetbackscheck: '1613461056'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mongodbconsistentbackup-quick/2253/"
---
Just a quick post here to share some notes I made when using the&nbsp;[mongodb\_consistent\_backup](https://github.com/Percona-Lab/mongodb_consistent_backup) tool.

This was performed on a installed of&nbsp;Red Hat Enterprise Linux Server release 7.2 (Maipo) running python&nbsp;2.7.5.

Install required packages and clone the tools repo;

```
yum install python python-devel python-virtualenv gcc
yum install mongodb-org-tools
yum install git
git clone https://github.com/Percona-Lab/mongodb_consistent_backup.git
cd mongodb_consistent_backup/
make
make install
```

This will install the tool to /usr/local/bin/mongodb-consistent-backup. The tool looks for mongodump in the following location' /usr/bin/mongodump. The packages I used deviated from this default;

```
which mongodump
/bin/mongodump
```

We need to tell mongodb-consistent-backup the location of mongodump is it's not in the default path. Here's a redacted version of my backup command-line;

```
mongodb-consistent-backup --host=mongocfg3 --port=27017 --user=xxxxxx --password=xxxxxx --backup_binary=/bin/mongodump --location=/home/mcb --name=REFBACKUP
```

Here's a redacted version of the output;

```
[2016-11-16 15:55:47,998] [INFO] [MainProcess] [Backup:run:220] Starting mongodb-consistent-backup version 0.3.1 (git commit hash: 5acdc83a924afb017c0c6eb740a0fd7c2c0df3f6)
[2016-11-16 15:55:48,000] [INFO] [MainProcess] [Backup:run:267] Running backup of mongocfg3:27017 in sharded mode
[2016-11-16 15:55:48,076] [INFO] [MainProcess] [Sharding:get_start_state:41] Began with balancer state running: True
[2016-11-16 15:55:48,186] [INFO] [MainProcess] [Sharding:get_config_server:129] Found sharding config server: mongocfg1:27019
[2016-11-16 15:55:53,280] [INFO] [MainProcess] [Replset:find_primary:72] Found PRIMARY: shard2/mongodb9:27019 with optime Timestamp(1478868578, 1)
[2016-11-16 15:55:53,280] [INFO] [MainProcess] [Replset:find_secondary:128] Found SECONDARY shard2/mongodb7:27019: {'priority': 1, 'lag': 0, 'optime': Timestamp(1478868578, 1), 'score': 98}
[2016-11-16 15:55:53,281] [INFO] [MainProcess] [Replset:find_primary:72] Found PRIMARY: shard2/mongodb9:27019 with optime Timestamp(1478868578, 1)
[2016-11-16 15:55:53,281] [INFO] [MainProcess] [Replset:find_secondary:128] Found SECONDARY shard2/mongodb8:27019: {'priority': 1, 'lag': 0, 'optime': Timestamp(1478868578, 1), 'score': 98}
[2016-11-16 15:55:53,281] [INFO] [MainProcess] [Replset:find_secondary:138] Choosing SECONDARY mongodb7:27019 for replica set shard2 (score: 98)
[2016-11-16 15:55:53,320] [INFO] [MainProcess] [Replset:find_primary:72] Found PRIMARY: shard0/mongodb3:27019 with optime Timestamp(1478868569, 3)
[2016-11-16 15:55:53,320] [INFO] [MainProcess] [Replset:find_secondary:128] Found SECONDARY shard0/mongodb1:27019: {'priority': 1, 'lag': 0, 'optime': Timestamp(1478868569, 3), 'score': 98}
[2016-11-16 15:55:53,321] [INFO] [MainProcess] [Replset:find_primary:72] Found PRIMARY: shard0/mongodb3:27019 with optime Timestamp(1478868569, 3)
[2016-11-16 15:55:53,321] [INFO] [MainProcess] [Replset:find_secondary:128] Found SECONDARY shard0/mongodb2:27019: {'priority': 1, 'lag': 0, 'optime': Timestamp(1478868569, 3), 'score': 98}
[2016-11-16 15:55:53,322] [INFO] [MainProcess] [Replset:find_secondary:138] Choosing SECONDARY mongodb1:27019 for replica set shard0 (score: 98)
[2016-11-16 15:55:53,388] [INFO] [MainProcess] [Replset:find_primary:72] Found PRIMARY: shard1/mongodb5:27019 with optime Timestamp(1474364574, 1)
[2016-11-16 15:55:53,388] [INFO] [MainProcess] [Replset:find_secondary:128] Found SECONDARY shard1/mongodb4:27019: {'priority': 1, 'lag': 0, 'optime': Timestamp(1474364574, 1), 'score': 98}
[2016-11-16 15:55:53,389] [INFO] [MainProcess] [Replset:find_primary:72] Found PRIMARY: shard1/mongodb5:27019 with optime Timestamp(1474364574, 1)
[2016-11-16 15:55:53,389] [INFO] [MainProcess] [Replset:find_secondary:128] Found SECONDARY shard1/mongodb6:27019: {'priority': 1, 'lag': 0, 'optime': Timestamp(1474364574, 1), 'score': 98}
[2016-11-16 15:55:53,390] [INFO] [MainProcess] [Replset:find_secondary:138] Choosing SECONDARY mongodb4:27019 for replica set shard1 (score: 98)
[2016-11-16 15:55:53,390] [INFO] [MainProcess] [Sharding:stop_balancer:89] Stopping the balancer and waiting a max of 300 sec
[2016-11-16 15:55:58,574] [INFO] [MainProcess] [Sharding:stop_balancer:99] Balancer is now stopped
[2016-11-16 15:55:58,972] [INFO] [OplogTail-1] [Tail:run:68] Tailing oplog on mongodb7:27019 for changes
[2016-11-16 15:55:58,983] [INFO] [OplogTail-2] [Tail:run:68] Tailing oplog on mongodb1:27019 for changes
[2016-11-16 15:55:58,983] [INFO] [OplogTail-3] [Tail:run:68] Tailing oplog on mongodb4:27019 for changes
[2016-11-16 15:55:59,029] [INFO] [MainProcess] [Dumper:run:90] Starting backups in threads using mongodump r3.2.10 (inline gzip: True)
[2016-11-16 15:55:59,044] [INFO] [Dump-6] [Dump:run:51] Starting mongodump (with oplog) backup of shard1/mongodb4:27019
[2016-11-16 15:55:59,058] [INFO] [Dump-4] [Dump:run:51] Starting mongodump (with oplog) backup of shard2/mongodb7:27019
[2016-11-16 15:55:59,067] [INFO] [Dump-5] [Dump:run:51] Starting mongodump (with oplog) backup of shard0/mongodb1:27019
[2016-11-16 15:55:59,572] [INFO] [Dump-6] [Dump:run:91] Backup for shard1/mongodb4:27019 completed in 0.543478012085 sec with 0 oplog changes captured to: None
[2016-11-16 15:56:00,209] [INFO] [Dump-4] [Dump:run:91] Backup for shard2/mongodb7:27019 completed in 1.18052315712 sec with 0 oplog changes captured to: None
[2016-11-16 15:56:00,944] [INFO] [Dump-5] [Dump:run:91] Backup for shard0/mongodb1:27019 completed in 1.91488313675 sec with 0 oplog changes captured to: None
[2016-11-16 15:56:03,952] [INFO] [MainProcess] [Dumper:wait:63] All mongodump backups completed
[2016-11-16 15:56:03,952] [INFO] [MainProcess] [Dumper:run:97] Using non-replset backup method for config server mongodump
[2016-11-16 15:56:03,960] [INFO] [Dump-7] [Dump:run:51] Starting mongodump (with oplog) backup of configsvr/mongocfg1:27019
[2016-11-16 15:56:04,755] [INFO] [Dump-7] [Dump:run:91] Backup for configsvr/mongocfg1:27019 completed in 0.802173137665 sec with 0 oplog changes captured to: None
[2016-11-16 15:56:07,763] [INFO] [MainProcess] [Dumper:wait:63] All mongodump backups completed
[2016-11-16 15:56:07,764] [INFO] [MainProcess] [Tailer:stop:49] Stopping oplog tailing threads
[2016-11-16 15:56:07,841] [INFO] [OplogTail-2] [Tail:run:121] Done tailing oplog on mongodb1:27019, 0 changes captured to: None
[2016-11-16 15:56:07,976] [INFO] [OplogTail-1] [Tail:run:121] Done tailing oplog on mongodb7:27019, 0 changes captured to: None
[2016-11-16 15:56:08,435] [INFO] [OplogTail-3] [Tail:run:121] Done tailing oplog on mongodb4:27019, 0 changes captured to: None
[2016-11-16 15:56:08,765] [INFO] [MainProcess] [Tailer:stop:55] Stopped all oplog threads
[2016-11-16 15:56:08,766] [INFO] [MainProcess] [Sharding:restore_balancer_state:82] Restoring balancer state to: True
[2016-11-16 15:56:08,810] [INFO] [MainProcess] [Resolver:run:52] Resolving oplogs using 4 threads max
[2016-11-16 15:56:08,811] [INFO] [MainProcess] [Resolver:run:67] No oplog changes to resolve for mongodb4:27019
[2016-11-16 15:56:08,811] [INFO] [MainProcess] [Resolver:run:87] No tailed oplog for host mongocfg1:27019
[2016-11-16 15:56:08,812] [INFO] [MainProcess] [Resolver:run:67] No oplog changes to resolve for mongodb7:27019
[2016-11-16 15:56:08,812] [INFO] [MainProcess] [Resolver:run:67] No oplog changes to resolve for mongodb1:27019
[2016-11-16 15:56:08,915] [INFO] [MainProcess] [Resolver:run:102] Done resolving oplogs
[2016-11-16 15:56:08,925] [INFO] [MainProcess] [Archiver:run:88] Archiving backup directories with 2 threads max
[2016-11-16 15:56:08,927] [INFO] [PoolWorker-12] [Archiver:run:57] Archiving directory: /home/mcb/REFBACKUP/20161116_1555/shard2
[2016-11-16 15:56:08,927] [INFO] [PoolWorker-13] [Archiver:run:57] Archiving directory: /home/mcb/REFBACKUP/20161116_1555/shard0
[2016-11-16 15:56:09,200] [INFO] [PoolWorker-12] [Archiver:run:57] Archiving directory: /home/mcb/REFBACKUP/20161116_1555/shard1
[2016-11-16 15:56:09,203] [INFO] [PoolWorker-13] [Archiver:run:57] Archiving directory: /home/mcb/REFBACKUP/20161116_1555/configsvr
[2016-11-16 15:56:09,328] [INFO] [MainProcess] [Archiver:run:104] Archiver threads completed
[2016-11-16 15:56:09,330] [INFO] [MainProcess] [Backup:run:402] Backup completed in 21.413216114 sec
```

The tool appears to correctly discover and backup all of my shards. In this case there were no updates to record in the oplog. The backup location contains a bunch of tar archives. One for each shard as well as the config servers;

```
ls -lh REFBACKUP/20161116_1555/
total 2.2M
-rw-r--r--. 1 root root 190K Nov 16 15:56 configsvr.tar
-rw-r--r--. 1 root root 1.3M Nov 16 15:56 shard0.tar
-rw-r--r--. 1 root root 20K Nov 16 15:56 shard1.tar
-rw-r--r--. 1 root root 680K Nov 16 15:56 shard2.tar
```

Here's a redacted version of the contents of an archive;

```
tar xvf shard0.tar
shard0/
shard0/dump/
shard0/dump/userdb/
shard0/dump/userdb/xxxxx.metadata.json.gz
shard0/dump/userdb/xxxxxx.bson.gz
shard0/dump/admin/system.users.metadata.json.gz
shard0/dump/admin/system.roles.metadata.json.gz
shard0/dump/admin/system.version.metadata.json.gz
shard0/dump/admin/system.users.bson.gz
shard0/dump/admin/system.roles.bson.gz
shard0/dump/admin/system.version.bson.gz
shard0/dump/oplog.bson
```

Note the files here are gzip compressed. If you're using a version of mongodump earlier than 3.2 the top level archive would be called shard0.tar.gz and the internal files are not gzipped; [As they quickly pointed out](https://github.com/Percona-Lab/mongodb_consistent_backup/issues/57).

