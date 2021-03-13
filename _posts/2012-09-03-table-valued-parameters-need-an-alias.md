---
layout: post
title: Table-Valued Parameters need an alias!
date: 2012-09-03 22:14:21.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SQL Server
- T-SQL
tags:
- Table-Valued Parameters
- TSQL
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:76:"http://www.youdidwhatwithtsql.com/table-valued-parameters-need-an-alias/1497";s:7:"tinyurl";s:26:"http://tinyurl.com/c56lm8f";s:4:"isgd";s:19:"http://is.gd/6gWOER";}
  tweetbackscheck: '1613444493'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/table-valued-parameters-need-an-alias/1497/"
---
I'm always the one to say [RTFM](http://en.wikipedia.org/wiki/RTFM) but this one stumped me for a while. I had problems using a [Table-Valued Parameter](http://msdn.microsoft.com/en-us/library/bb675163.aspx "Table-Valued Parameter") in a Stored Procedure today.

The explanation is indeed in the documentation but it's perhaps not as clear as it should be. Hopefully this post will be picked up better in Google for those having similar issues.

Here's a quick outline of the problem...

Firstly, create a TVP type, just a simple list of integers...

```
-- Create a simple TVP
CREATE TYPE dbo.ListOfIntegers AS TABLE
(
	id INTEGER NOT NULL PRIMARY KEY CLUSTERED
);
GO
```

Now let's create a simple proc using this type.

```
-- Simple proc using this tvp
CREATE PROCEDURE dbo.testtvp
(
	@table AS dbo.ListOfIntegers READONLY
)
AS
BEGIN

	SELECT *
	FROM @table;

END
GO
```

Does it work?

```
-- Let's use it!
DECLARE @table AS dbo.ListOfIntegers;
INSERT INTO @table (id) VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
EXEC dbo.testtvp @table;
GO
```

OK, that works, let's try something a little more complicated...

```
-- OK, that works, how about this....
CREATE PROCEDURE dbo.testtvp2
(
	@table AS dbo.ListOfIntegers READONLY,
	@table2 AS dbo.ListOfIntegers READONLY
)
AS
BEGIN

	SELECT *
	FROM @table
	INNER JOIN @table2
		ON @table.id = @table2.id
END
GO
```

This will not compile...

```
-- Get the following errors
Msg 137, Level 16, State 1, Procedure testtvp2, Line 12
Must declare the scalar variable @table.
Msg 137, Level 16, State 1, Procedure testtvp2, Line 12
Must declare the scalar variable @table2.
```

The documentation does indeed say; _"When you use a table-valued parameter with a JOIN in a FROM clause, you must also alias it"_ but it's perhaps not as prominent as it could be. So let's alias the Table-Valued Parameters...

```
CREATE PROCEDURE dbo.testtvp3
(
	@table AS dbo.ListOfIntegers READONLY,
	@table2 AS dbo.ListOfIntegers READONLY
)
AS
BEGIN

	SELECT *
	FROM @table AS t1
	INNER JOIN @table2 AS t2
		ON t1.id = t2.id
END
GO
```

This will compile and function as expected...

```
DECLARE @table AS dbo.ListOfIntegers;
INSERT INTO @table (id) VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
DECLARE @table2 AS dbo.ListOfIntegers;
INSERT INTO @table2 (id) VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
EXEC dbo.testtvp3 @table, @table2;
GO
```

Happy TSQL'ing!

