---
layout: post
title: 'Can''t reopen table: ''t1'''
date: 2010-07-19 22:24:08.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags: []
meta:
  tweetbackscheck: '1613443214'
  shorturls: a:4:{s:9:"permalink";s:58:"http://www.youdidwhatwithtsql.com/cant-reopen-table-t1/823";s:7:"tinyurl";s:26:"http://tinyurl.com/246rx4n";s:4:"isgd";s:18:"http://is.gd/dyxCm";s:5:"bitly";s:20:"http://bit.ly/daLy6b";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/cant-reopen-table-t1/823/"
---
I'm quite often jumping between [MySQL](http://www.mysql.com) and [SQL Server](http://www.microsoft.com/en/gb/sqlserver/default.aspx) so remembering the quirks and limitations of each system can be difficult. With MySQL, if you attempt to reference a temporary table more than once in the same query, you will encounter the following error;

```
Error Code : 1137
Can't reopen table: 't1’
```

The following provides an example of this...

```
USE test;

CREATE TEMPORARY TABLE test
(
                Id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
);

SELECT *
FROM test AS t1
INNER JOIN test AS t2
     ON t1.Id = t2.Id;
```

It's not just self-joins that have this issue **UNIONS** do as well;

```
SELECT *
FROM test AS t1
UNION ALL
SELECT *
FROM test AS t2;
```

There's a [thread over on Stackoverflow](http://stackoverflow.com/questions/343402/getting-around-mysql-cant-reopen-table-error) discussing this problem. Here's a solution I commonly use to get around the problem;

```
USE test;

# Create temp table
CREATE TEMPORARY TABLE test
(
                Id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
);

# Insert some test data
INSERT INTO test (Id) VALUES (1),(2),(3),(4),(5);

# Clone the table. This will do structure & indices but no data.
CREATE TEMPORARY TABLE test2 LIKE test;

# Insert the data into the new table
INSERT INTO test2
SELECT Id
FROM test;

# Now our queries will work if we use the tables clone
SELECT *
FROM test AS t1
INNER JOIN test2 AS t2
      ON t1.Id = t2.Id;

SELECT *
FROM test AS t1
UNION ALL
SELECT *
FROM test2 AS t2;

# Clean up
DROP TEMPORARY TABLE IF EXISTS test;
DROP TEMPORARY TABLE IF EXISTS test2;
```
