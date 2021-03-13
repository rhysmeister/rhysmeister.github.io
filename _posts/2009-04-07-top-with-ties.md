---
layout: post
title: TOP WITH TIES
date: 2009-04-07 19:37:13.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- top records
- TOP WITH TIES
- TSQL
meta:
  tweetbackscheck: '1613263734'
  shorturls: a:7:{s:9:"permalink";s:50:"http://www.youdidwhatwithtsql.com/top-with-ties/54";s:7:"tinyurl";s:25:"http://tinyurl.com/delgfq";s:4:"isgd";s:17:"http://is.gd/tWua";s:5:"bitly";s:19:"http://bit.ly/7mYbm";s:5:"snipr";s:22:"http://snipr.com/gh1np";s:5:"snurl";s:22:"http://snurl.com/gh1np";s:7:"snipurl";s:24:"http://snipurl.com/gh1np";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: usarianskiff@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/top-with-ties/54/"
---
Not many people seem to be aware of the **WITH TIES** clause introduced in SQL Server 2005+. This simple feature is worth adding to your query armoury. In the words of [BOL](http://msdn.microsoft.com/en-us/library/ms130214.aspx) **WITH TIES** …

_“Specifies that additional rows be returned from the base result set with the same value in the ORDER BY columns appearing as the last of the TOP n (PERCENT) rows. TOP...WITH TIES can be specified only in SELECT statements, and only if an ORDER BY clause is specified.”_

Many of us would have been asked in our professional lives “_Give me the top n of \<whatever\>“_ and would have automatically thought of using **TOP**. Lets take the following scenario…

```
CREATE TABLE SalesPerson
(
	Id INT NOT NULL PRIMARY KEY CLUSTERED IDENTITY(1, 1),
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	CurrentMonthSales MONEY NOT NULL DEFAULT '0.00',
);
```

Now insert some test data...

```
INSERT INTO SalesPerson
(
	FirstName,
	LastName,
	CurrentMonthSales
)
VALUES
(
	'Rhys',
	'Campbell',
	'1000.00'
);
INSERT INTO SalesPerson
(
	FirstName,
	LastName,
	CurrentMonthSales
)
VALUES
(
	'John',
	'Doe',
	'3500.00'
);
INSERT INTO SalesPerson
(
	FirstName,
	LastName,
	CurrentMonthSales
)
VALUES
(
	'Joe',
	'Bloggs',
	'3500.00'
);
INSERT INTO SalesPerson
(
	FirstName,
	LastName,
	CurrentMonthSales
)
VALUES
(
	'Jane',
	'Doe',
	'3500.00'
);
INSERT INTO SalesPerson
(
	FirstName,
	LastName,
	CurrentMonthSales
)
VALUES
(
	'John',
	'Smith',
	'5000.00'
);
```

Now if the under pressure [DBA](http://en.wikipedia.org/wiki/Database_administrator) was asked for the top 3 performing sales people this month they might blast out something like...

```
SELECT TOP 3 *
FROM SalesPerson
ORDER BY CurrentMonthSales DESC;
```

[![image]({{ site.baseurl }}/assets/2009/04/image-thumb.png "image")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/image.png)

In many circumstances this may not be an issue. But here it could cause one of our friends in sales to miss out on a bonus! So keep friendly with sales and use the **WITH TIES** &nbsp; clause when appropriate.

```
SELECT TOP 3 WITH TIES *
FROM SalesPerson
ORDER BY CurrentMonthSales DESC;
```

[![image]({{ site.baseurl }}/assets/2009/04/image-thumb1.png "image")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/image1.png)

