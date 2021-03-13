---
layout: post
title: Cassandra 3 Node Cluster Setup Notes
date: 2017-07-27 11:14:50.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Big Data
- Cassandra
- DBA
tags:
- cassandra
meta:
  _edit_last: '1'
  tweetbackscheck: '1613409047'
  shorturls: a:2:{s:9:"permalink";s:76:"http://www.youdidwhatwithtsql.com/cassandra-3-node-cluster-setup-notes/2324/";s:7:"tinyurl";s:27:"http://tinyurl.com/y7v92hvm";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/cassandra-3-node-cluster-setup-notes/2324/"
---
 **Install on each node**

```
wget http://www-eu.apache.org/dist/cassandra/redhat/30x/cassandra-3.0.13-1.noarch.rpm
yum install jre
rpm -ivh cassandra-3.0.13-1.noarch.rpm
chkconfig cassandra on
```

**Configuration changes on each node**

```
vi /etc/cassandra/conf/cassandra.yaml
```

Customise the seeds / ip address for your environment

```
cluster_name: 'cassandra_cluster'
seeds: "192.168.65.120,192.168.65.121,192.168.65.122"
listen_address:<ip of host>
rpc_address: <ip of host>
</ip></ip>
```

**Start the cassandra service on each node**

```
service cassandra start
service cassandra status
```

If you get the following error;

```
org.apache.cassandra.exceptions.ConfigurationException: Saved cluster name Test Cluster != configured name cassandra_cluster

```
Then you need to reset the data folder (note this removes all data so take a backup if you're not sure).

```
rm -rf /var/lib/cassandra/data/system/*
service cassandra start
```

**View the status of the cluster**

```
nodetool status
```

Output will be similar to below;

```
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
-- Address Load Tokens Owns (effective) Host ID Rack
UN 192.168.65.120 108.04 KB 256 65.8% 92119740-cbf7-406a-9237-a1f4036e26e9 rack1
UN 192.168.65.121 166.99 KB 256 65.6% 13b5a4f8-6d98-481b-809e-f1a2ffd8ae94 rack1
UN 192.168.65.122 143.53 KB 256 68.6% fe0068b2-2dca-403a-b5f2-93e827250bc5 rack1
```

**Login with the command-line client**

```
export CQLSH_HOST=$(hostname --ip-address)
cqlsh
```

Do some stuff;

```
cqlsh> CREATE KEYSPACE rhys WITH REPLICATION = {'class':'SimpleStrategy','replication_factor':2};
cqlsh> USE rhys;
cqlsh> CREATE TABLE rhys (empid int primary key, emp_first varchar, emp_last varchar, emp_dept varchar);
cqlsh> INSERT INTO rhys (empid, emp_first, emp_last, emp_dept) VALUES (1, 'Rhys', 'Campbell', 'ENT');
```

**Enable authentication on each node**

```
vi /etc/cassandra/conf/cassandra.conf
```

Change the option in this file on each node;

```
authenticator: PasswordAuthenticator
```

Restart each node;

```
service cassandra restart
```

Login to one node to update the cassandra admin user;

```
export CQLSH_HOST=$(hostname --ip-address)
cqlsh -u cassandra -p cassandra
```

Alter the replication factor for the system\_auth namespace;

```
cqlsh> ALTER KEYSPACE "system_auth" WITH REPLICATION = {'class' : 'NetworkTopologyStrategy', 'datacenter1': 3 };
```

Ensure the change is propogated through the system;

```
nodetool repair system_auth
```

Restart;

```
service cassandra restart
```

Create a new superuser

```
cqlsh -u cassandra -p cassandra
csqlsh> CREATE ROLE admin WITH PASSWORD = 'BigSecret' AND SUPERUSER = true AND LOGIN = true;
exit
```

Change the default user;

```
cqlsh -u ucid_admin -p BigSecret
cqlsh> ALTER ROLE cassandra WITH PASSWORD='xfvasdfvsxv3456456uyhnfdfgu657rt87ytygwe3456' AND SUPERUSER=false;
```

Change some settings to update the system roles;

```
vi /etc/cassandra/conf/cassandra.conf
```

Set to ten minutes refresh 5

```
roles_validity_in_ms: 600000
roles_update_interval_in_ms: 300000
```
```
```
