---
layout: post
title: Grok expression for MariaDB Audit Log
date: 2015-03-27 09:38:48.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MariaDB
- MySQL
tags:
- grok
- logstash
- mariadb
- MySQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613464042'
  shorturls: a:3:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/grok-expression-mariadb-audit-log/2053/";s:7:"tinyurl";s:26:"http://tinyurl.com/oglebxw";s:4:"isgd";s:19:"http://is.gd/J5bae0";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: josiah.ritchie@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/grok-expression-mariadb-audit-log/2053/"
---
Here's a [grok](http://logstash.net/docs/1.1.0/filters/grok "grok logstash") expression for the [MariaDB Audit Plugin Log](https://mariadb.com/kb/en/mariadb/about-the-mariadb-audit-plugin/ "MariaDB Audit Plugin"). This has only been tested against CONNECT/DISCONNECT/FAILED\_CONNECT events and will likely need modification for other event types.

```
^%{YEAR:year}%{MONTHNUM:month}%{MONTHDAY:day} %{TIME:time},%{GREEDYDATA:host},%{GREEDYDATA:username},%{GREEDYDATA:client_hostname},%{INT:connection_id},%{INT:query_id},%{GREEDYDATA:operation},%{GREEDYDATA:schema},%{GREEDYDATA:object},%{INT:return_code}
```
