---
layout: post
title: 'Notes from the field: CockroachDB Cluster Setup'
date: 2017-05-15 15:33:30.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- CockroachDB
tags:
- CockRoachDB
meta:
  _edit_last: '1'
  tweetbackscheck: '1613371437'
  shorturls: a:2:{s:9:"permalink";s:77:"http://www.youdidwhatwithtsql.com/notes-field-cockroachdb-cluster-setup/2295/";s:7:"tinyurl";s:27:"http://tinyurl.com/yd4ylug2";}
  tweetcount: '0'
  twittercomments: a:0:{}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/notes-field-cockroachdb-cluster-setup/2295/"
---
 **Download the CockroachDB Binary**

Perform on each node.

```
wget https://binaries.cockroachdb.com/cockroach-latest.linux-amd64.tgz
tar xvzf cockroach-latest.linux-amd64.tgz
mv cockroach-latest.linux-amd64/cockroach /usr/bin/
chmod +x /usr/bin/cockroach
```

**Create cockroach user and directories**

Perform on each node.

```
groupadd cockroach
useradd -r cockroach -g cockroach
su - cockroach
cd /home/cockroach
mkdir -p certs my-safe-directory cockroach_db
```

**Check ntp status**

Check NTP is running and configured correctly. [CockroachDB replies on syncronised clock](https://www.cockroachlabs.com/blog/living-without-atomic-clocks/)s to function correctly.

```
service ntpd.service status
```

**Secure the Cluster**

Perform on each node.

Copy all keysgenerate on the first host to the others but regenerate the node certificates (This means the command with create-node). For further details see [Secure a Cluster](https://www.cockroachlabs.com/docs/secure-a-cluster.html).

```
cockroach cert create-ca --certs-dir=certs --ca-key=my-safe-directory/ca.key # These keys, in both dirs, need to be copied to each host
ls -l certs
cockroach cert create-node localhost $(hostname) --certs-dir=certs --ca-key=my-safe-directory/ca.key
ls -l certs
cockroach cert create-client root --certs-dir=certs --ca-key=my-safe-directory/ca.key --overwrite
ls -l certs
```

**Start the nodes**

**node1**

```
su - cockroach
cockroach start --background --host=node1 --http-host=node1 --port=26257 --http-port=8080 --store=/home/cockroach/cockroach_db --certs-dir=/home/cockroach/certs;
```

**node2**

```
su - cockroach
cockroach start --background --host=node2 --http-host=node2 --port=26257 --http-port=8080 --store=/home/cockroach --join=node1:26257 --certs-dir=/home/cockroach/certs
```

**node3**

```
su - cockroach
cockroach start --background --host=node3 --http-host=node3 --port=26257 --http-port=8080 --store=/home/cockroach --join=node1.ucid.local:26257 --certs-dir=/home/cockroach/certs
```

**Check the status of the cluster**

```
sudo su - cockroach
cockroach node ls --certs-dir=certs --host node1
cockroach node status --certs-dir=certs --host node1
```

**Create a cron to start CockroachDB on boot**

Create the file /etc/cron.d/cockroach\_start with the below cron command for each node...

**node1**

```
@reboot cockroach cockroach start --background --host=node1 --http-host=node1 --port=26257 --http-port=8080 --store=/home/cockroach/cockroach_db --join="node2:26257,node3:26257" --certs-dir=/home/cockroach/certs;
```

**node2**

```
@reboot cockroach cockroach start --background --host=node2 --http-host=node2 --port=26257 --http-port=8080 --store=/home/cockroach --join="node1:26257,node3:26257" --certs-dir=/home/cockroach/certs;
```

**node3**

```
@reboot cockroach cockroach start --background --host=node3 --http-host=node3 --port=26257 --http-port=8080 --store=/home/cockroach --join="node1:26257,node2:26257" --certs-dir=/home/cockroach/certs;
```

Reboot the nodes to ensure the CockroachDB comes up and all join the cluster successfully.

