---
layout: post
title: The behavior of gtid_strict_mode in MariaDB
date: 2015-04-24 17:53:41.000000000 +02:00
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
- gtid
- mariadb
- replication
meta:
  _edit_last: '1'
  tweetbackscheck: '1613454754'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:71:"http://www.youdidwhatwithtsql.com/behavior-gtidstrictmode-mariadb/2089/";s:7:"tinyurl";s:26:"http://tinyurl.com/klkk9nt";s:4:"isgd";s:19:"http://is.gd/UAJtqp";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/behavior-gtidstrictmode-mariadb/2089/"
---
[GTIDs in MariaDB](https://mariadb.com/kb/en/mariadb/global-transaction-id/) are a nice improvement to replication and make fail-over a simpler process. I struggled a little with the explanation of [gtid\_strict\_mode](https://mariadb.com/kb/en/mariadb/global-transaction-id/#gtid_strict_mode)&nbsp;and what to expect. So I thought I'd run through a simple scenario to make my own understanding clear.

In this scenario I have created two instances of MySQL; primary and secondary. I have setup replication using standard binlog filename & positions offset and then switched to GTID using slave\_pos. I will cover the behavior of replication with gtid\_strict\_mode off and on, how problems are caused, how you might like to recover, and how to avoid problems.

**gtid\_strict\_mode = 0**

Consider the starting gtids for our primary and secondary instances...

primary: gtid\_current\_pos = 1-1-2146  
secondary: gtid\_slave\_pos & gtid\_current\_pos = 1-1-2146

Run a few transactions on the primary...

```
mysql> CREATE DATABASE rhys;
mysql> USE rhys;
mysql> CREATE TABLE t1 (id INTEGER NOT NULL PRIMARY KEY);
mysql> INSERT INTO t1 VALUES (1);
mysql> INSERT INTO t1 VALUES (2);
mysql> INSERT INTO t1 VALUES (3);
```

The gtid state now corresponds to...

primary: gtid\_current\_pos = 1-1-2151 (as are gtid\_binlog\_pos, gtid\_binlog\_state)  
secondary: gtid\_current\_pos = 1-1-2151 (as are gtid\_binlog\_pos & gtid\_slave\_pos)  
gtid\_binlog\_state = 1-2-2146,1-1-2151

Run a few transactions on the secondary. We would consider these to be [errant transactions](http://www.percona.com/blog/2014/05/19/errant-transactions-major-hurdle-for-gtid-based-failover-in-mysql-5-6/)&nbsp;on our slave server.

```
mysql> USE rhys;
mysql> INSERT INTO t1 VALUES (101);
mysql> INSERT INTO t1 VALUES (102);
mysql> INSERT INTO t1 VALUES (103);
mysql> INSERT INTO t1 VALUES (104);
mysql> INSERT INTO t1 VALUES (105);
mysql> INSERT INTO t1 VALUES (999);
```

The gtid state is now as follows...

primary: gtid\_current\_pos = 1-1-2151 (as are gtid\_binlog\_pos, gtid\_binlog\_state)  
secondary: gtid\_binlog\_pos = 1-2-2157  
gtid\_binlog\_state = 1-1-2151, 1-2-2157  
gtid\_current\_pos = 1-2-2157  
gtid\_slave\_pos = 1-1-2151

Run another transaction on the primary. Note the next generated gtid here would be 1-1-2152

```
mysql> USE rhys;
mysql> INSERT INTO t1 VALUES (1001);
```

What's our gtid state?

primary: gtid\_current\_pos = 1-1-2152 (as are gtid\_binlog\_pos, gtidbinlog\_state)  
secondary: gtid\_binlog\_pos = 1-1-2152  
gtid\_binlog\_state = 1-2-2157,1-1-2152  
gtid\_current\_pos = 1-1-2152  
gtid\_slave\_pos = 1-1-2152

[SHOW SLAVE STATUS](https://mariadb.com/kb/en/mariadb/show-slave-status/) on the secondary will show the slave thread running happily. In other words, when gtid\_strict\_mode = 0, the replication thread behaves in a similar way to standard replication. We just have some gtid order checking and extra validation when failing over. But errant transactions are allowed on slave servers.

**gtid\_strict\_mode = 1**

Now set gtid\_strict\_mode = 1 in my.cnf and restart both instances. Run a transaction on the primary...

```
mysql> USE rhys;
mysql> INSERT INTO t1 VALUES 100001);
```

Our gtid state is now as follows...

primary: gtid\_current\_pos = 1-1-2153 (as are gtid\_binlog\_pos, gtidbinlog\_state)  
secondary: gtid\_binlog\_pos = 1-1-2152  
gtid\_binlog\_state 1-2-2157,1-1-2153  
gtid\_current\_pos = 1-1-2153  
gtid\_slave\_pos = 1-1-2153

SHOW SLAVE STATUS will show the slave thread running happy even after we have put it into gtid\_strict\_mode. This is because the errant transactions happened before so they get a pass on this occasion. Execute an errant transaction on the secondary MariaDB instance...

```
mysql> USE rhys;
mysql> INSERT INTO t1 VALUES (17);
```

SHOW SLAVE STATUS will continue to show the slave thread is running happily. The gtid state is as follows...

primary: gtid\_current\_pos = 1-1-2153 (as are gtid\_binlog\_pos, gtidbinlog\_state)  
secondary: gtid\_binlog\_pos = 1-2-2158  
gtid\_binlog\_state 1-1-2153,1-2-2158  
gtid\_current\_pos = 1-2-2158  
gtid\_slave\_pos = 1-1-2153

Next, execute a transaction on the primary...

```
mysql> USE rhys
mysql> INSERT INTO t1 VALUES (8888);
```

Our gtid state is..

primary: gtid\_current\_pos = 1-1-2154 (as are gtid\_binlog\_pos, gtidbinlog\_state)  
secondary: gtid\_binlog\_pos = 1-2-2158  
gtid\_binlog\_state 1-1-2153,1-2-2158  
gtid\_current\_pos = 1-2-2158  
gtid\_slave\_pos = 1-1-2153

Note the gtid\_current\_pos for the primary has incremented, but the gtid\_slave\_pos for the secondary has not. Something has happened...

```
mysql> SHOW SLAVE STATUS \G
```

The slave thread on the secondary has failed with the error...

```
An attempt was made to binlog GTID 1-1-2154 which would create an out-of-order sequence number with existing GTID 1-2-2158, and gtid strict mode is enabled.
```

**How can this be fixed?**

The Smartass answer here would be to say don't execute errant transactions on your slave servers. But since we're here already let's have a look at some alternatives...

This skip trick works but you have to do it for every transaction until the GTIDS don't clash any more. Don't forget this [skips entire transactions not individual statements](http://www.percona.com/blog/2013/07/23/another-reason-why-sql_slave_skip_counter-is-bad-in-mysql/).

```
mysql> STOP SLAVE;
mysql> SET GLOBAL sql_slave_skip_counter=1
mysql> START SLAVE;
```

Alternatively if there are a lot of transactions it may be easier to do...

```
mysql> SET GLOBAL gtid_strict_mode = 0;
mysql> START SLAVE;
```

Once the primary gtid sequence is higher the slave won't complain any more. We can then switch back to gtid\_strict\_mode = 1.

It's also possible to switch back to binlog filename & positions, replicate past the problem, and then switch back to gtid style replication. Whatever approach you take you have a data verification exercise to get cracking on.

**Strategies to avoid this**

No writes on slaves is the ideal situation but perhaps we're forced to for various reasons. Instead we may wish to consider...

1. Execute SET SESSION gtid\_domain=0 before your statement. This will avoid any problems if you use a domain\_id that does not exist. Be careful about your replication hierarchy (i.e. slaves of slaves).  
2. Execute SET SESSION sql\_log\_bin = 0 before your statement. No&nbsp;gtid generated, no problem. This can be [dangerous](http://blog.jcole.us/2014/08/08/stupid-and-dangerous-set-global-sql_log_bin/) though.  
3. Be aware of what statements & actions will increment the gtid counter. You might not expect it but [OPTIMIZE](https://mariadb.com/kb/en/mariadb/optimize-table/) and [ANALYZE](https://mariadb.com/kb/en/mariadb/analyze-table/) table will increment the sequence number.

I'd be interested to know any thoughts you might have on this.

