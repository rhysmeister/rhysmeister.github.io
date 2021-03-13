---
layout: post
title: For RANGE partitions each partition must be defined
date: 2010-07-09 13:08:30.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- MySQL
- partition
- partitioning
meta:
  shorturls: a:4:{s:9:"permalink";s:89:"http://www.youdidwhatwithtsql.com/for-range-partitions-each-partition-must-be-defined/815";s:7:"tinyurl";s:26:"http://tinyurl.com/345suuo";s:4:"isgd";s:18:"http://is.gd/dlqDA";s:5:"bitly";s:20:"http://bit.ly/bHX1Aq";}
  tweetbackscheck: '1613464385'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/for-range-partitions-each-partition-must-be-defined/815/"
---
If you encounter the following error when trying to create a partitioned table in MySQL

```
Error Code : 1492
For RANGE partitions each partition must be defined
```

Assuming you have defined your partitions then you probably have a syntax error. Take the following incorrect example.

```
CREATE TABLE People
(
	PersonId INTEGER NOT NULL AUTO_INCREMENT,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	DateOfBirth DATE NOT NULL,
	Telephone VARCHAR(30) NULL,
	Email VARCHAR(200) NULL,
	GroupId SMALLINT NOT NULL,
	PRIMARY KEY (PersonId, GroupId)
)
PARTITION BY RANGE (GroupId)
PARTITION p0 VALUES LESS THAN (100),
PARTITION p1 VALUES LESS THAN (200),
PARTITION p2 VALUES LESS THAN (300),
PARTITION p3 VALUES LESS THAN (400),
PARTITION p4 VALUES LESS THAN (500),
PARTITION p5 VALUES LESS THAN (600),
PARTITION p6 VALUES LESS THAN (700);
```

The above statement is not syntactically correct but the error thrown in this case is not particularly helpful. All that is missing here is a couple of braces around the partition range definitions. The below DDL statement is correct.

```
CREATE TABLE People
(
	PersonId INTEGER NOT NULL AUTO_INCREMENT,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	DateOfBirth DATE NOT NULL,
	Telephone VARCHAR(30) NULL,
	Email VARCHAR(200) NULL,
	GroupId SMALLINT NOT NULL,
	PRIMARY KEY (PersonId, GroupId)
)
PARTITION BY RANGE (GroupId)
(
	PARTITION p0 VALUES LESS THAN (100),
	PARTITION p1 VALUES LESS THAN (200),
	PARTITION p2 VALUES LESS THAN (300),
	PARTITION p3 VALUES LESS THAN (400),
	PARTITION p4 VALUES LESS THAN (500),
	PARTITION p5 VALUES LESS THAN (600),
	PARTITION p6 VALUES LESS THAN (700)
);
```
