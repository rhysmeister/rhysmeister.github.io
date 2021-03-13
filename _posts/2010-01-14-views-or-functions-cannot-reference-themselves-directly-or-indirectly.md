---
layout: post
title: Views or functions cannot reference themselves directly or indirectly
date: 2010-01-14 21:18:38.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- T-SQL
tags:
- self-reference
- SQL Server
- T-SQL
- views
meta:
  tweetbackscheck: '1613463876'
  shorturls: a:4:{s:9:"permalink";s:107:"http://www.youdidwhatwithtsql.com/views-or-functions-cannot-reference-themselves-directly-or-indirectly/519";s:7:"tinyurl";s:26:"http://tinyurl.com/ybtwfo6";s:4:"isgd";s:18:"http://is.gd/6h4in";s:5:"bitly";s:20:"http://bit.ly/73iZU7";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/views-or-functions-cannot-reference-themselves-directly-or-indirectly/519/"
---
Today I received the following [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) error which I had never encountered before.

> Msg 4429, Level 16, State 1, Line 1   
> View or function 'Table\_1' contains a self-reference. Views or functions cannot reference themselves directly or indirectly.   
> Msg 4413, Level 16, State 1, Line 1   
> Could not use view or function 'Test.Table\_1' because of binding errors.

Here's a quick walk-through of the issue.

```
CREATE TABLE [dbo].[Table_1]
(
	[id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[test] [nchar](10) NOT NULL
);
```

Insert some test data

```
INSERT INTO dbo.Table_1
(
	test
)
SELECT 'One'
UNION ALL
SELECT 'Two'
UNION ALL
SELECT 'Three'
UNION ALL
SELECT 'Four'
UNION ALL
SELECT 'Five';
```

Add a schema called 'Test' to the database by running the TSQL below. We will then create a view in this schema.

```
CREATE SCHEMA Test;
```

Now create this view.

```
CREATE VIEW Test.Table_1
AS
	SELECT Id, Test
	FROM Table_1;
```

Now try to select from this view.

[![sql server view self reference error]({{ site.baseurl }}/assets/2010/01/sql_view_self_reference_thumb.png "sql server view self reference error")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/sql_view_self_reference.png)&nbsp;

I'd been creating lots of views for a third party application we've started to deploy at work. I'd simply created a new schema and named the views after the corresponding table in the database. This one was my fault for being a copy and paste monkey! I'd forgotten to specify the schema in one view. The fix?

```
ALTER VIEW Test.Table_1
AS
	SELECT Id, Test
	FROM dbo.Table_1;
```

[![view results]({{ site.baseurl }}/assets/2010/01/view_results_thumb.png "view results")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/view_results.png)

Even though my user [default schema](http://msdn.microsoft.com/en-us/library/ms190387.aspx) was set to dbo [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) got its pants in a twist over this. So there you have it; it's definitely good practice to specify schemas in your TSQL!

