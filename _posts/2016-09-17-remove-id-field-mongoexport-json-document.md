---
layout: post
title: Remove an _id field from a mongoexport json document
date: 2016-09-17 12:46:56.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Data
- MongoDB
tags:
- json
- mongoexport
meta:
  twittercomments: a:0:{}
  _edit_last: '1'
  tweetbackscheck: '1613461852'
  tweetcount: '0'
  shorturls: a:2:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/remove-id-field-mongoexport-json-document/2237/";s:7:"tinyurl";s:26:"http://tinyurl.com/j6curfu";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/remove-id-field-mongoexport-json-document/2237/"
---
Although the [mongoexport tool](https://docs.mongodb.com/manual/reference/program/mongoexport/#options) has a --fields option&nbsp;it will always include the \_id field by default. You can remove this with a simple line of sed. This was slightly modified from this [sed expression](http://unix.stackexchange.com/questions/168416/command-to-remove-a-portion-of-json-data-from-each-line).

Given the following data...

```
{"_id":{"$oid":"57dd2809beed91a333ebe7d1"},"a":"Rhys"}
{"_id":{"$oid":"57dd2810beed91a333ebe7d2"},"a":"James"}
{"_id":{"$oid":"57dd2815beed91a333ebe7d3"},"a":"Campbell"}
```

This command-line expression will export and munge the data...

```
mongoexport --authenticationDatabase admin --db test --collection test -u admin -pXXXXXX | sed '/"_id":/s/"_id":[^,]*,//'
```

Results in the following list of documents...

```
{"a":"Rhys"}
{"a":"James"}
{"a":"Campbell"}
```
