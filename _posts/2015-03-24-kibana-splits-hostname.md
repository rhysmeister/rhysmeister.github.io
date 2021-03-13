---
layout: post
title: Kibana splits on hostname
date: 2015-03-24 17:47:53.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Data
- DBA
- Linux
tags:
- elasticsearch
- fluentd
- kibana
- logstash
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:62:"http://www.youdidwhatwithtsql.com/kibana-splits-hostname/2051/";s:7:"tinyurl";s:26:"http://tinyurl.com/or7sb3z";s:4:"isgd";s:19:"http://is.gd/IPZtJ6";}
  tweetbackscheck: '1613450866'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/kibana-splits-hostname/2051/"
---
If you're playing with Kibana and you notice any Pie charts splitting values incorrectly, i.e. on a hostname with hyphen characters, then here's the fix you need to apply. It's actually something&nbsp;[elasticsearch](https://github.com/elastic/kibana/issues/84 "elasticsearch split hostname kibana") does...

```
curl -XPUT http://localhost:9200/_template/syslog -d '
{
	"template": "*syslog*",
	"settings" : {
					"number_of_shards" : 1
	},
	"mappings" : {
					"file" : {
                              	"properties" : {
                                                	"host" : {
                                                              	"type" : "string",
                                                            	"index" : "not_analyzed"
                                                     }
                                                }
                                }
                }
}
'
```

This will instruct [elasticsearch](http://www.elastic.co/ "elasticsearch") not to break the fieldname "host" into tokens for any index with "syslog" in the name. Note this will only apply to new indexes. You'll need to delete all the current indexes and re-import your data if you need the backlog corrected too.

