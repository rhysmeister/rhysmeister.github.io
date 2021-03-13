---
layout: post
title: 'DBT2: stmt ERROR: 1406 Data too long for column ''out_w_city'' at row 1'
date: 2013-06-08 10:57:13.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- DBT2
- MySQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613185261'
  shorturls: a:3:{s:9:"permalink";s:92:"http://www.youdidwhatwithtsql.com/dbt2-stmt-error-1406-data-long-column-outwcity-row-1/1592/";s:7:"tinyurl";s:26:"http://tinyurl.com/peb9hlv";s:4:"isgd";s:19:"http://is.gd/imsfUz";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/dbt2-stmt-error-1406-data-long-column-outwcity-row-1/1592/"
---
Another issue with the DBT2 benchmarking suite.

```
mysql reports SQL STMT: stmt ERROR: 1406 Data too long for column 'out_w_city' at row 1
```

Just edit the payment stored procedure and change;

```
DECLARE out_w_city VARCHAR(10);
```

To;

```
DECLARE out_w_city VARCHAR(20);
```
