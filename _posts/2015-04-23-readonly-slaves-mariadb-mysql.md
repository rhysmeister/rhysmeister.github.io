---
layout: post
title: Better "read_only" slaves in MariaDB / MySQL
date: 2015-04-23 16:07:43.000000000 +02:00
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
- mariadb
- MySQL
- read_only
- replication
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:69:"http://www.youdidwhatwithtsql.com/readonly-slaves-mariadb-mysql/2083/";s:7:"tinyurl";s:26:"http://tinyurl.com/no4by3c";s:4:"isgd";s:19:"http://is.gd/qlzQ6p";}
  tweetbackscheck: '1613461072'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/readonly-slaves-mariadb-mysql/2083/"
---
 **UPDATE:** As of MySQL 5.7.8 there is [super\_read\_only](http://dev.mysql.com/doc/relnotes/mysql/5.7/en/news-5-7-8.html)&nbsp;so use this instead of this trick.

It's always been an annoyance that&nbsp; **read\_only** in MySQL actually means "read only apart from those with the [SUPER](https://dev.mysql.com/doc/refman/5.1/en/privileges-provided.html#priv_super "MySQL SUPER privilege") priv". Now I know it's best practice not to give this permission out to users but sometimes we are stuck with the choices others have made.

We now have another option in the form of [tx\_read\_only](http://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_tx_read_only "tx\_read\_only transaction\_read\_only")&nbsp;which was introduced in MariaDB 10 and MySQL 5.6.5. If we set this variable to ON then any writes will be rejected with...

```
ERROR 1792 (25006): Cannot execute statement in a READ ONLY transaction.
```

This also applies to users with the SUPER priv. A user with the SUPER priv can still perform some action entitled by that privileges, i.e. SET GLOBAL var, PURGE BINARY LOGS, CHANGE MASTER etc. Check your specific use case. Unfortunately this also&nbsp;prevents&nbsp;replication working. We can get around this restriction using the [init\_slave](https://dev.mysql.com/doc/refman/5.0/en/replication-options-slave.html#sysvar_init_slave "init\_slave MySQL") variable and the following SQL...

```
SET SESSION TRANSACTION READ WRITE;
```

Now the replication thread will work! This all goes to hell if a user logs in and executes

```
SET SESSION TRANSACTION READ WRITE;
```

You may be able to check the [performance\_schema](https://mariadb.com/kb/en/mariadb/performance-schema-overview/ "MariaDB performance\_schema")&nbsp;to see if you have any users doing this...

```
SELECT *
FROM performance_schema.`events_statements_summary_by_digest`
WHERE DIGEST_TEXT LIKE '%TRANSACTION%';
```

It may be possible to override this using [init\_connect](https://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html#sysvar_init_connect "init\_connect MySQL")&nbsp;if you have any clients executing this by default as part of the connection setup (I need to test this). It would also go a good idea to keep using [read\_only](https://mariadb.com/kb/en/mariadb/server-system-variables/#read_only "MariaDB read\_only") as well. The my.cnf settings for this would be...

```
transaction_read_only = 1
read_only = 1
init_slave "SET SESSION TRANSACTION READ WRITE;"
```

tx\_read\_only doesn't seem to work in the cnf file for some reason. This is an inconsistency they may fix in a future version. There's obviously still holes in this approach but I'm hopeful this will make my setup a little more resilient.

