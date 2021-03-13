---
layout: post
title: TRIGGER_NESTLEVEL TSQL Function
date: 2011-08-10 13:27:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- TRIGGER_NESTLEVEL
- TSQL
meta:
  tweetbackscheck: '1613468204'
  shorturls: a:3:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/trigger_nestlevel-tsql-function/1287";s:7:"tinyurl";s:26:"http://tinyurl.com/3tr58jz";s:4:"isgd";s:19:"http://is.gd/LOqloP";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/trigger_nestlevel-tsql-function/1287/"
---
This function is used to determine the current nest level or number of triggers that fired the current one. This could be used to prevent triggers from firing when fired by others. Here's an example that does that; we have two tables with triggers, that fire AFTER INSERT, and insert into the other table. The use of [TRIGGER\_NESTLEVEL](http://msdn.microsoft.com/en-us/library/ms182737.aspx "TRIGGER\_NESTLEVEL TSQL Function") allows us to control the flow gracefully.

First create the tables and triggers;

```
CREATE TABLE dbo.Table1
(
	Id INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	Value VARCHAR(20) NOT NULL
);
GO

CREATE TABLE dbo.Table2
(
	Id INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	Value VARCHAR(20) NOT NULL
);
GO

-- Trigger on table 1
CREATE TRIGGER dbo.trg_Table1 ON dbo.Table1
AFTER INSERT
AS
BEGIN
	DECLARE @nest INTEGER;
	SET @nest = TRIGGER_NESTLEVEL();

	IF (@nest = 1)
	BEGIN
		INSERT INTO dbo.Table2
		(
			Id,
			Value
		)
		SELECT i.Id,
			   i.Value
		FROM inserted i;
	END
	ELSE
	BEGIN
		PRINT 'Trigger 1: Insert aborted trigger_nestlevel is ' + CAST(@nest AS VARCHAR(10));
	END
END
GO

-- Trigger on table 2
CREATE TRIGGER dbo.trg_Table2 ON dbo.Table2
AFTER INSERT
AS
BEGIN
	DECLARE @nest INTEGER;
	SET @nest = TRIGGER_NESTLEVEL();

	IF (@nest = 1)
	BEGIN
		INSERT INTO dbo.Table1
		(
			Id,
			Value
		)
		SELECT i.Id,
			   i.Value
		FROM inserted i;
	END
	ELSE
	BEGIN
		PRINT 'Trigger 2: Insert aborted trigger_nestlevel is ' + CAST(@nest AS VARCHAR(10));
	END
END
GO
```

Now insert data into **dbo.Table1**.

```
INSERT INTO dbo.Table1
(
	Id,
	Value
)
VALUES
(
	1,
	'Blah'
);
```

```
Trigger 2: Insert aborted trigger_nestlevel is 2

(1 row(s) affected)

(1 row(s) affected)
```

```
SELECT *
FROM dbo.Table1
UNION ALL
SELECT *
FROM dbo.Table2;
```

[![table1 trigger_nestlevel TSQL function]({{ site.baseurl }}/assets/2011/08/table1_trigger_nestlevel_thumb.png "table1 trigger\_nestlevel TSQL function")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/TRIGGER_NESTLEVEL-TSQL-Function_B5A6/table1_trigger_nestlevel.png)

Now insert data into **dbo.Table2**.

```
INSERT INTO dbo.Table2
(
	Id,
	Value
)
VALUES
(
	2,
	'Blah'
);
```

```
Trigger 1: Insert aborted trigger_nestlevel is 2

(1 row(s) affected)

(1 row(s) affected)
```

```
SELECT *
FROM dbo.Table1
UNION ALL
SELECT *
FROM dbo.Table2;
```

[![table2 trigger_nestlevel TSQL Function]({{ site.baseurl }}/assets/2011/08/table2_trigger_nestlevel_thumb.png "table2 trigger\_nestlevel TSQL Function")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/TRIGGER_NESTLEVEL-TSQL-Function_B5A6/table2_trigger_nestlevel.png)

Of course this situation is best avoided in the first place but it's nice to have an awareness of some of these lesser known functions.

