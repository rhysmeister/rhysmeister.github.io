---
layout: post
title: Modifying elasticsearch index settings
date: 2014-09-19 15:05:06.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Big Data
- Linux
tags:
- efk
- elasticsearch
- fluentd
- kibana
- logstash
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/modifying-elasticsearch-index-settings/1985/";s:7:"tinyurl";s:26:"http://tinyurl.com/ot5qjg3";s:4:"isgd";s:19:"http://is.gd/kEIzsP";}
  tweetbackscheck: '1613260455'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/modifying-elasticsearch-index-settings/1985/"
---
To view the settings of an index run the following at the command-line...

```
curl -XGET http://hostname:9200/indexname/_settings
```

From here you can indeify the setting you need and modify it as you wish. This example sets the number of replicas to zero.

```
curl -XPUT http://hostname:9200/indexname/_settings -d '{ "index": {"number_of_replicas":"0"}}'
```

For further details see the [manual](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/indices-update-settings.html "elasticsearch manual").

