---
layout: post
title: 'Elasticsearch: Turn off index replicas'
date: 2015-03-31 16:50:28.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Big Data
- Data
tags:
- elasticsearch
meta:
  shorturls: a:3:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/elasticsearch-turn-index-replicas/2058/";s:7:"tinyurl";s:26:"http://tinyurl.com/ox4pkpk";s:4:"isgd";s:19:"http://is.gd/LKLolG";}
  _edit_last: '1'
  tweetbackscheck: '1613459512'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/elasticsearch-turn-index-replicas/2058/"
---
If you're playing with [elasticsearch](https://www.elastic.co/ "elasticsearch") on a single host you may notice your cluster health is always yellow. This is probably because your indexes are set to have one replica but there's no other node to replicate it to.

To confirm if this is the case or not you can look in [elasticsearch-head](http://mobz.github.io/elasticsearch-head/ "elasticsearch-head"). In the Overview tab you should see a bunch of index shards marked as "Unassigned". If your cluster health is 50% of the total then you probably have the setup of 1 shard and 1 replica per index. To make the status green change replicas to zero...

```
curl -XPUT http://127.0.0.1:9200/_settings -d '
{
    "index" : {
        "number_of_replicas" : 0
    }
}
'
```

Please note this will affect all indexes. Do not execute this on a production cluster and be sure to back up any data you don't want to lose.

