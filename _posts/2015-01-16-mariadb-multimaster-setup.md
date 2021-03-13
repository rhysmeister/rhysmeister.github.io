---
layout: post
title: A MariaDB Multi-Master setup example
date: 2015-01-16 18:02:05.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MariaDB
tags:
- gtid
- mariadb
- multi-master replication
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/mariadb-multimaster-setup/2030/";s:7:"tinyurl";s:26:"http://tinyurl.com/nc9qqrb";s:4:"isgd";s:19:"http://is.gd/2TIKIh";}
  tweetbackscheck: '1613445417'
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: imadsani@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mariadb-multimaster-setup/2030/"
---
Here's a very quick example for how to setup [Multi-Master replication with MariaDB.&nbsp;](https://mariadb.com/kb/en/mariadb/documentation/managing-mariadb/replication/standard-replication/multi-source-replication/ "MariaDB Multi-MAster Replication")&nbsp;It's light on detail here to focus only on the multi-master aspects of the setup. Have a good read of the documentation before attempting this. This example also uses&nbsp;[GTIDs](https://mariadb.com/kb/en/mariadb/documentation/managing-mariadb/replication/standard-replication/global-transaction-id/ "MariaDB Global Transaction IDs") so you'll need some understanding of these as well.

The example here is pretty simple. There are two master servers. We will replicate two servers to a single slave. From&nbsp; **master1** we will replicate all databases to the slave. From&nbsp; **master2** we will replicate a single database to the same slave as&nbsp; **master1.** &nbsp;I have assumed you're working on the slave itself as I reference it by 127.0.0.1.

First dump and load the databases we want...

```
# all databases from one server
mysqldump -h master1 -P3306 --master-data=2 --routines --single-transaction --all-databases -u dba -pXXXXXXXX > all_databases.sql
cat all_databases.sql | mysql -h 127.0.0.1 -P3306

# Single database from another master
mysqldump -h master2 -P3306 --master-data=2 --routines --single-transaction --databases mydb -u dba -pXXXXXXXX > single_database.sql
cat single_database.sql | mysql -h 127.0.0.1 -P3306
```

Extract the GTID co-ordinates...

```
head -n 30 all_databases.sql | grep -i gtid
head -n 30 single_database.sql | grep -i gtid
```

You'll see something like this displayed...

```
-- GTID to start replication from
-- SET GLOBAL gtid_slave_pos='XXXX-XXXX-XXXX';
```

```
-- GTID to start replication from
-- SET GLOBAL gtid_slave_pos='XXXX-XXXX-XXXX';
```

Extract the GTID positions and combine them in a statement like below to execute on the slave...

```
SET GLOBAL gtid_slave_pos='XXXX-XXXX-XXXX,XXXX-XXXX-XXXX';
```

Configure the slave to point at both masters...

```
CHANGE MASTER 'mirror_master1' TO
			MASTER_HOST='master1',
			MASTER_PORT=3306,
			MASTER_USER='replication',
			MASTER_PASSWORD='XXXXXXXX',
			MASTER_USE_GTID=slave_pos;

CHANGE MASTER 'single_database' TO
			MASTER_HOST='master2',
			MASTER_PORT=3307,
			MASTER_USER='replication',
			MASTER_PASSWORD='XXXXXXXX',
			MASTER_USE_GTID=slave_pos;
```

Run the following statement so the slave will only process binlog entries for the appropriate database... (you'd also want this in your cnf file)

```
SET GLOBAL single_database.replicate_do_db=mydb;
```

Now you can start the slave threads...

```
START ALL SLAVES;
```

Double check the status to make sure it has worked...

```
SHOW SLAVE STATUS \G
```
