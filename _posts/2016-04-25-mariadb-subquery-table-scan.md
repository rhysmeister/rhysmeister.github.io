---
layout: post
title: 'MariaDB:  subquery causes table scan'
date: 2016-04-25 18:15:02.000000000 +02:00
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
- subquery
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:67:"http://www.youdidwhatwithtsql.com/mariadb-subquery-table-scan/2208/";s:7:"tinyurl";s:26:"http://tinyurl.com/gmecd79";s:4:"isgd";s:19:"http://is.gd/YDrVhw";}
  tweetbackscheck: '1613452635'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mariadb-subquery-table-scan/2208/"
---
I got asked today to look at some slow queries on a [MariaDB 10](https://mariadb.com/) instance. Here are the anonymized results of the investigation I did into this and how I solved the issue...

There were a bunch of queries, expected to run very fast, that were taking 10-15 seconds to execute. The queries were all similar to this...

```
DELETE from my_user_table
WHERE u_id IN (SELECT u_id
		FROM other_table WHERE id = 9999);
```

I found that the appropriate columns were indexed. Next step was to [EXPLAIN](https://mariadb.com/kb/en/mariadb/explain/) the query...

```
***************************1. row***************************
           id: 1
  select_type: PRIMARY
        table: my_user_table
         type: ALL
possible_keys: NULL
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 4675
        Extra: Using where
***************************2. row***************************
           id: 2
  select_type: DEPENDENT SUBQUERY
        table: other_table
         type: unique_subquery
possible_keys: PRIMARY,other_index
          key: PRIMARY
      key_len: 4
          ref: func
         rows: 1
        Extra: Using where
2 rows in set (0.00 sec)
```

We can see from the output here that a table scan is performed on the first table and the subquery is executed against the second table for every row. The key here is **DEPENDENT SUBQUERY**. For some reason MariaDB has decided the subquery is dependent on the outer query. We know this isn't the case but what can we do about it? The solution is turns out is quite simple...

```
DELETE u
FROM my_user_table AS u
WHERE u.u_id IN (SELECT p.u_id
		FROM other_table o
		WHERE o.id = 9999);
```

Yep, just use aliases! The EXPLAIN for the modified query is much improved...

```
***************************1. row***************************
           id: 1
  select_type: PRIMARY
        table: p
         type: ref
possible_keys: PRIMARY,other_index
          key: other_index
      key_len: 4
          ref: const
         rows: 1
        Extra: Using index
***************************2. row***************************
           id: 1
  select_type: PRIMARY
        table: my_user_table
         type: ref
possible_keys: idx_t
          key: idx_t
      key_len: 4
          ref: p.u_id
         rows: 1
        Extra:
2 rows in set (0.00 sec)
```

Here we can see the join order has changed and MariaDB has recognised that the subquery can be changed to a constant. This results in speedier queries because far fewer rows need to read. I'd hazard a guess here that the absence of aliases causes MariaDB to get a little confused about what is dependent on what. Thus causing it to choose a less than optimum plan.

