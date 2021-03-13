---
layout: post
title: 'MongoDB: Making the most of a 2 Data-Centre Architecture'
date: 2017-05-13 18:07:46.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MongoDB
tags:
- Data Centres
- mongodb
meta:
  _edit_last: '1'
  tweetbackscheck: '1613364926'
  shorturls: a:2:{s:9:"permalink";s:80:"http://www.youdidwhatwithtsql.com/mongodb-making-2-datacentre-architecture/2288/";s:7:"tinyurl";s:27:"http://tinyurl.com/ya2or2mx";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mongodb-making-2-datacentre-architecture/2288/"
---
There's a big initiative at my employers to improve the uptime of the services we provide. The goal is 100% uptime as perceived by the customer. There's obviously a certain level of flexibility one could take in the interpretation of this. I choose to be as strict as I can about this to avoid any disappointments! I've decided to work on this in the context of our primary MongoDB Cluster. Here is a logical view of the current architecture, spread over two data centres;

[caption id="attachment\_2289" align="alignnone" width="300"][![MongoDB Cluster Architecture Two Data Centres]({{ site.baseurl }}/assets/2017/05/MongoDB-Cluster-Architecture-Two-Data-Centres-300x205.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2017/05/MongoDB-Cluster-Architecture-Two-Data-Centres.png) What happens with this architecture?[/caption]

If **DC1** goes down **shard0** and **shard2** &nbsp;are both read-only while **shard1** remains read/write. **DC1** contains only a single config server so some [meta-data operations will be unavailable](https://docs.mongodb.com/manual/core/sharded-cluster-config-servers/#config-server-availability). If **DC2** goes down **shard0** and **shard2** remain read/write while **shard1** becomes read only. 2 config servers are hosted in **DC1** so cluster meta-data operations remain available.

What are the options we can consider when&nbsp;working within the constraints of a two data-centre architecture?

1. Do nothing and depend on the failed&nbsp;data-centre coming back online quickly. Obviously not an ideal solution. If either data-centre goes down we suffer some form of impairment to the customer.
2. Nominate one site as the PRIMARY data-centre which will contain enough shard members, for each shard, to achieve quorum should the secondary site go down. Under this architecture we remain fully available assuming the PRIMARY data centre remains up. The entire cluster becomes read-only if the main data-centre goes down. To achieve our goal, of 100% uptime, we have to hope our PRIMARY Data centre never goes down. We could request that application developers make some changes to cope with short periods of write unavailability.
3. A third option, which would actually work combined with both of the above approaches, would be to force a replicaset to accept writes when only a single server is available. You need to be careful here and be sure the other nodes in the replicaset aren't receiving any writes. We can follow the procedure [Reconfigure a replicaset with unavailable members](https://docs.mongodb.com/manual/tutorial/reconfigure-replica-set-with-unavailable-members/)&nbsp;to make this happen. This would require manual intervention and there would be some work to reconfigure the replicaset when the offline nodes returned.

Clearly none of these options are ideal. In the event of a data-centre outage we are likely to suffer some form of impairment to service. The only exception here is if the SECONDARY data-centre goes down in #2. This strategy depends, to some extent, on luck. With full documented, and tested, failover procedures we can minimise this downtime. The goal of 100% uptime seems pretty tricky to achieve without moving to a 3 data-centre architecture.

&nbsp;

