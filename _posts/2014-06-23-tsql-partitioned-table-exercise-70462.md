---
layout: post
title: 'TSQL: Partitioned table exercise for 70-462'
date: 2014-06-23 22:32:26.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
tags:
- 70-462
- exam
- partitions
- SQL Server
- WingTipToys2012
meta:
  _edit_last: '1'
  tweetbackscheck: '1613479206'
  shorturls: a:3:{s:9:"permalink";s:77:"http://www.youdidwhatwithtsql.com/tsql-partitioned-table-exercise-70462/1915/";s:7:"tinyurl";s:26:"http://tinyurl.com/qfar94n";s:4:"isgd";s:19:"http://is.gd/V3dV2x";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-partitioned-table-exercise-70462/1915/"
---
Here's some TSQL for the WingTipToys2012 [table partitioning](http://msdn.microsoft.com/en-us/library/ms188730.aspx "SQL Server 2012 Table Partitions") exercise in the [70-462 training materials](https://www.microsoft.com/learning/en-gb/exam-70-462.aspx "Administering Microsoft SQL Server 2012 Databases").

```
CREATE DATABASE WingTipToys2012

USE WingTipToys2012;
GO

CREATE PARTITION FUNCTION WTPartFunction(INTEGER)
AS RANGE LEFT FOR VALUES (30, 60)

CREATE PARTITION SCHEME WTPartScheme
AS PARTITION WTPartFunction
TO (fgOne, fgTwo, fgThree);

CREATE TABLE toys
(
	column1 INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	column2 CHAR(30) NOT NULL
) ON WTPartScheme(column1);

INSERT INTO dbo.toys
VALUES (1, 'Car'), (2, 'Truck'), (3, 'Bike'),
	(4, 'Doll'), (5, 'Football'), (6, 'Transformer'),
	(7, 'Action Man'), (8, 'Barbie'), (9, 'Pokemon'),
	(10, 'Nintendo'), (25, 'Hula-Hoop'), (31, 'Playing Cards');

-- In execution plan partition count should = 1 for each
SELECT * FROM dbo.toys WHERE column1 = 1;
SELECT * FROM dbo.toys WHERE column1 = 25;
SELECT * FROM dbo.toys WHERE column1 = 31;
-- Partition count should now be = 3
SELECT * FROM dbo.toys WHERE column1 >= 1;
```
