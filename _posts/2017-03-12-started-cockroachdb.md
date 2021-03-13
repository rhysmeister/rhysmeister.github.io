---
layout: post
title: Getting started with CockRoachDB
date: 2017-03-12 15:29:44.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- CockroachDB
- DBA
tags:
- CockRoachDB
meta:
  _edit_last: '1'
  twittercomments: a:0:{}
  tweetbackscheck: '1613352851'
  shorturls: a:2:{s:9:"permalink";s:59:"http://www.youdidwhatwithtsql.com/started-cockroachdb/2274/";s:7:"tinyurl";s:26:"http://tinyurl.com/j9v8rnq";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/started-cockroachdb/2274/"
---
<p>I've been quite interested in <a href="https://www.cockroachlabs.com/" target="_blank">CockRoachDB</a> as it claims to be <a href="https://en.wikipedia.org/wiki/Cockroach_Labs" target="_blank">"almost impossible to take down"</a>.</p>
<p>Here's a quick example for setting up a CockRoachDB cluster. This was done on a mac but should work with no, or minimal, modifications on *nix.</p>
<p>First, download and set the path PATH</p>
<pre lang="Bash">
wget https://binaries.cockroachdb.com/cockroach-latest.darwin-10.9-amd64.tgz
tar xvzf cockroach-latest.darwin-10.9-amd64.tgz
PATH="$PATH:/Users/rhys1/cockroach-latest.darwin-10.9-amd64";
export PATH;
</pre>
<p>Setup the cluster directories...</p>
<pre lang="Bash">
mkdir -p cockroach_cluster_tmp/node1;
mkdir -p cockroach_cluster_tmp/node2;
mkdir -p cockroach_cluster_tmp/node3;
mkdir -p cockroach_cluster_tmp/node4;
mkdir -p cockroach_cluster_tmp/node5;
cd cockroach_cluster_tmp
</pre>
<p>Fire up 5 CockRoachDB hosts...</p>
<pre lang="Bash">
cockroach start --background --cache=50M --store=./node1;
cockroach start --background --cache=50M --store=./node2 --port=26258 --http-port=8081 --join=localhost:26257;
cockroach start --background --cache=50M --store=./node3 --port=26259 --http-port=8082 --join=localhost:26257;
cockroach start --background --cache=50M --store=./node4 --port=26260 --http-port=8083 --join=localhost:26257;
cockroach start --background --cache=50M --store=./node5 --port=26261 --http-port=8084 --join=localhost:26257;
</pre>
<p>You should now be able to access the Cluster web-console at http://localhost:8084.</p>
<p>Command-line access is achieved with...</p>
<pre lang="Bash">
cockroach sql;
</pre>
<p>Those familiar with sql will be comfortable...</p>
<pre lang="PostgreSQL">
root@:26257/> CREATE DATABASE rhys;
root@:26257/> SHOW DATABASES;
root@:26257/> CREATE TABLE rhys.test (id SERIAL PRIMARY KEY, text VARCHAR(100) NOT NULL);
root@:26257/> INSERT INTO rhys.test(text) VALUES ('Hello World');
root@:26257/> SELECT * FROM rhys.test;
</pre>
<p>Any data you insert should be replicated to all nodes. You can check this with...</p>
<pre lang="Bash">
cockroach sql --port 26257 --execute "SELECT COUNT(*) FROM rhys.test";
cockroach sql --port 26258 --execute "SELECT COUNT(*) FROM rhys.test";
cockroach sql --port 26259 --execute "SELECT COUNT(*) FROM rhys.test";
cockroach sql --port 26260 --execute "SELECT COUNT(*) FROM rhys.test";
cockroach sql --port 26261 --execute "SELECT COUNT(*) FROM rhys.test";
</pre>
<p>We can also insert into any of the nodes...</p>
<pre lang="Bash">
cockroach sql --port 26257 --execute "INSERT INTO rhys.test (text) VALUES ('Node 1')";
cockroach sql --port 26258 --execute "INSERT INTO rhys.test (text) VALUES ('Node 2')";
cockroach sql --port 26259 --execute "INSERT INTO rhys.test (text) VALUES ('Node 3')";
cockroach sql --port 26260 --execute "INSERT INTO rhys.test (text) VALUES ('Node 4')";
cockroach sql --port 26261 --execute "INSERT INTO rhys.test (text) VALUES ('Node 5')";
</pre>
<p>Check the counts again...</p>
<pre lang="Bash">
cockroach sql --port 26257 --execute "SELECT COUNT(*) FROM rhys.test";
cockroach sql --port 26258 --execute "SELECT COUNT(*) FROM rhys.test";
cockroach sql --port 26259 --execute "SELECT COUNT(*) FROM rhys.test";
cockroach sql --port 26260 --execute "SELECT COUNT(*) FROM rhys.test";
cockroach sql --port 26261 --execute "SELECT COUNT(*) FROM rhys.test";
</pre>
<p>Check how the data looks on each node...</p>
<pre lang="Bash">
cockroach sql --port 26261 --execute "SELECT * FROM rhys.test";
</pre>
<pre>
+--------------------+-------------+
|         id         |    text     |
+--------------------+-------------+
| 226950927534555137 | Hello World |
| 226951064182259713 | Hello World |
| 226951080098856961 | Hello World |
| 226952456016003073 | Node 1      |
| 226952456149368834 | Node 2      |
| 226952456292663299 | Node 3      |
| 226952456455684100 | Node 4      |
| 226952456591376389 | Node 5      |
+--------------------+-------------+
(8 rows)
</pre>
<pre lang="Bash">
cockroach sql --port 26260 --execute "SELECT * FROM rhys.test";
</pre>
<pre>
+--------------------+-------------+
|         id         |    text     |
+--------------------+-------------+
| 226950927534555137 | Hello World |
| 226951064182259713 | Hello World |
| 226951080098856961 | Hello World |
| 226952456016003073 | Node 1      |
| 226952456149368834 | Node 2      |
| 226952456292663299 | Node 3      |
| 226952456455684100 | Node 4      |
| 226952456591376389 | Node 5      |
+--------------------+-------------
+ (8 rows)

To clean up...

```
# clean up (gets rid of all processes and data!)
cockroach quit --port=26257
cockroach quit --port=26258
cockroach quit --port=26259
cockroach quit --port=26260
cockroach quit --port=26261
cd;
rm -Rf cockroach_cluster_tmp;
```

I'll probably continuing playing with CockRoachDB. As usual resources will be available on [my github](https://github.com/rhysmeister/CockroachDB_Cluster).

