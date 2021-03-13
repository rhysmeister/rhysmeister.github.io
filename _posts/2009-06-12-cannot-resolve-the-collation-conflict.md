---
layout: post
title: Cannot resolve the collation conflict
date: 2009-06-12 17:57:53.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- collations
- DBA
- T-SQL
- TSQL
meta:
  tweetbackscheck: '1613477724'
  shorturls: a:7:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/cannot-resolve-the-collation-conflict/176";s:7:"tinyurl";s:25:"http://tinyurl.com/lpomll";s:4:"isgd";s:18:"http://is.gd/1cekr";s:5:"bitly";s:19:"http://bit.ly/CufT4";s:5:"snipr";s:22:"http://snipr.com/ksv9r";s:5:"snurl";s:22:"http://snurl.com/ksv9r";s:7:"snipurl";s:24:"http://snipurl.com/ksv9r";}
  twittercomments: a:2:{s:10:"2621805735";s:7:"retweet";s:10:"2614127848";s:7:"retweet";}
  tweetcount: '2'
  _sg_subscribe-to-comments: suhasp619@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/cannot-resolve-the-collation-conflict/176/"
---
I do a fair bit of work with [Linked Servers](http://msdn.microsoft.com/en-us/library/ms188279.aspx) and [cross-database queries](http://www.sqlservercentral.com/articles/Advanced/designingcrossdatabasequeries/1753/)&nbsp; and sometimes come across the following error when joining between databases with different [collations](http://msdn.microsoft.com/en-us/library/aa214408(SQL.80).aspx);

```
Msg 468, Level 16, State 9, Line 1

Cannot resolve the collation conflict between 'Latin1_General_CI_AS' and 'SQL_Latin1_General_Pref_CP850_CI_AS'; in the equal to operation.
```

To replicate this error run the below [TSQL](http://msdn.microsoft.com/en-us/library/ms189826.aspx) to create two databases with tables and data.&nbsp;

```
-- Create first database
CREATE DATABASE database1 COLLATE Latin1_General_CI_AS;
GO
-- Create second database
CREATE DATABASE database2 COLLATE SQL_Latin1_General_Pref_CP850_CI_AS;
GO

USE database1;
GO
-- Create Customer table in database1
CREATE TABLE Customer
(
	CustID INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	DOB DATETIME NOT NULL,
	StartDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO
USE database2;
GO
-- Create Customer table in database2
CREATE TABLE Customer
(
	CustID INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	DOB DATETIME NOT NULL,
	StartDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

USE database1;
GO
-- Insert test data
INSERT INTO dbo.Customer
(
	FirstName,
	LastName,
	DOB
)
SELECT 'Joe', 'Bloggs', '1975-01-01 00:00:00'
UNION ALL
SELECT'Dave', 'Smith', '1977-10-11 00:00:00'
UNION ALL
SELECT'Fred', 'Bloggs', '1965-11-28 00:00:00'
UNION ALL
SELECT'Sue', 'Smith', '1974-06-17 00:00:00'
UNION ALL
SELECT 'Steve', 'Smith', '1981-07-07 00:00:00';
GO
USE database2;
GO
-- Insert test data
INSERT INTO dbo.Customer
(
	FirstName,
	LastName,
	DOB
)
SELECT 'Joe', 'Bloggs', '1975-01-01 00:00:00'
UNION ALL
SELECT'Dave', 'Smith', '1977-10-11 00:00:00'
UNION ALL
SELECT'Fred', 'Bloggs', '1965-11-28 00:00:00'
UNION ALL
SELECT'Sue', 'Smith', '1974-06-17 00:00:00'
UNION ALL
SELECT 'Steve', 'Smith', '1981-07-07 00:00:00';
GO
```

Run the following query to observe the collation conflict.

```
-- Cross-database query causing the collation conflict
SELECT *
FROM dbo.Customer c1
INNER JOIN database1.dbo.Customer AS c2
	ON c1.FirstName = c2.FirstName
AND c1.LastName = c2.LastName;
```

[![SQL Server collation conflict]({{ site.baseurl }}/assets/2009/06/image-thumb11.png "SQL Server collation conflict")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image11.png)

You could fix this by changing the collation in one of the databases, i.e.

```
-- Set database2 to the same collation as database1
ALTER DATABASE database2 COLLATE Latin1_General_CI_AS;
-- Change VARCHAR columns on our existing tables
ALTER TABLE Customer ALTER COLUMN FirstName VARCHAR(30) COLLATE Latin1_General_CI_AS;
ALTER TABLE Customer ALTER COLUMN LastName VARCHAR(30) COLLATE Latin1_General_CI_AS;
```

Sometimes you may not want, or be able, to change a database in this way. In these situations you can add [COLLATE](http://msdn.microsoft.com/en-us/library/aa258237(SQL.80).aspx) DATABASE\_DEFAULT to the JOINS or expressions in your query.

```
-- Using COLLATE DATABASE_DEFAULT
SELECT *
FROM dbo.Customer c1
INNER JOIN database1.dbo.Customer AS c2
	ON c1.FirstName = c2.FirstName COLLATE DATABASE_DEFAULT
AND c1.LastName = c2.LastName COLLATE DATABASE_DEFAULT;
```

[![Query using COLLATE DATABASE_DEFAULT]({{ site.baseurl }}/assets/2009/06/image-thumb12.png "Query using COLLATE DATABASE\_DEFAULT")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image12.png)

