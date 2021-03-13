---
layout: post
title: Installing the DBT2 Benchmark Tool on Linux
date: 2013-05-30 18:37:36.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Linux
- MySQL
tags: []
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:76:"http://www.youdidwhatwithtsql.com/installing-dbt2-benchmark-tool-linux/1576/";s:7:"tinyurl";s:26:"http://tinyurl.com/keykkot";s:4:"isgd";s:19:"http://is.gd/ge8qsa";}
  tweetbackscheck: '1613412949'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/installing-dbt2-benchmark-tool-linux/1576/"
---
Just recording the process I used to install the [DBT2 bench-marking](http://dev.mysql.com/downloads/benchmarks.html "DBT2 Benchmarking tool") tool. I used [OpenSuSE](http://www.opensuse.org/en/ "OpenSuSE") 12.1 for this but should work on many distributions.

```
cd /opt/src
wget http://downloads.mysql.com/source/dbt2-0.37.50.3.tar.gz
tar xvf dbt2-0.37.50.3.tar.gz
cd dbt2-0.37.50.3/
./configure --with-mysql
make
make install
```

Don't forget to read the documentaiton to start running MySQL benchmarks...

```
cat README-MYSQL
```
