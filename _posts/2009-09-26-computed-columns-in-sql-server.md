---
layout: post
title: Computed Columns in SQL Server
date: 2009-09-26 20:33:32.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- Computed Columns
- SQL Server 2008
- T-SQL
- TSQL
meta:
  tweetbackscheck: '1613464367'
  shorturls: a:4:{s:9:"permalink";s:68:"http://www.youdidwhatwithtsql.com/computed-columns-in-sql-server/377";s:7:"tinyurl";s:26:"http://tinyurl.com/yezx36m";s:4:"isgd";s:18:"http://is.gd/3HqY8";s:5:"bitly";s:20:"http://bit.ly/2BitZq";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/computed-columns-in-sql-server/377/"
---
So exactly what is a computed column? [MSDN](http://msdn.microsoft.com/en-us/library/ms191250.aspx) has this to say

> A computed column is computed from an expression that can use other columns in the same table. The expression can be a noncomputed column name, constant, function, and any combination of these connected by one or more operators. The expression cannot be a subquery.

Essentially there are two types of computed columns; a virtual column where the data is not physically stored in the table, values are calculated each time it is referenced in a query. These cannot be indexed. By making use of the PERSISTED TSQL keyword we can force the database engine to physically store this data in the table. These can be indexed provided the computation definition is deterministic. For example, we wouldn’t be permitted to index columns containing a call to the [GETDATE](http://msdn.microsoft.com/en-us/library/ms188383.aspx) function.

Some people consider virtual computed columns to be a [waste of time](http://forums.mysql.com/read.php?10,218549,218555#msg-218555). Sure, it’s easy enough to build something like monthPay \* 12 AS YearlySalary into your queries but in my opinion they offer the following benefits.

- Enforce a particular calculation method in your organisation. 
- Should the calculation need to change, modify the computed column definition and not loads of queries, procedures and reports. (Anyone having to cope with the UK’s [change in VAT](http://www.hmrc.gov.uk/pbr2008/measure1.htm) last year will appreciate this). 

I’ve put persisted computed columns to good use recently. Some data came in from a client in an unexpected format. The record key value was sometimes contained in a column that was basically a [hodge-podge](http://en.wikipedia.org/wiki/Hodge-podge) of notes. I created a computed column that extracted this value which then allowed it to be indexed.

Here’s an brief example of what I did to achieve this.

The code here uses SQL Server 2008. Firstly I created a [user-defined function](http://msdn.microsoft.com/en-us/library/ms186755.aspx) that would extract the required key value from a note field.

```
-- This function will provide the computed column definition
CREATE FUNCTION udf_extractPersonCode
(
	@input VARCHAR(100)
)
RETURNS CHAR(7)
WITH SCHEMABINDING
AS
BEGIN

	DECLARE @extractedPersonCode CHAR(7) = NULL;

	IF(PATINDEX('%[A-Z][0-9][0-9][0-9][0-9][0-9][0-9]%', @input) > 0)
	BEGIN
		SET @extractedPersonCode = SUBSTRING(@input, PATINDEX('%[A-Z][0-9][0-9][0-9][0-9][0-9][0-9]%', @input), 7);
	END

	RETURN @extractedPersonCode;

END
GO
```

The WITH SCHEMABINDING is needed in the function definition or the following error will occur when attempting to create the function.

```
Msg 4936, Level 16, State 1, Line 1
Computed column 'ExtractedPersonCode' in table 'ComputedColTable' cannot be persisted because the column is non-deterministic.
```

Create this test table in the same database as the function. Note the definition of the computed column **ExtractedPersonCode**.

```
CREATE TABLE dbo.ComputedColTable
(
	Id INTEGER IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	PersonCode CHAR(7) NULL,
	Notes VARCHAR(100) NULL,
	ExtractedPersonCode AS dbo.udf_extractPersonCode(Notes) PERSISTED
);
```

Now insert some test data.

```
-- Insert some sample data into our table
INSERT INTO dbo.ComputedColTable
(
	FirstName,
	LastName,
	PersonCode,
	Notes
)
VALUES
(
	'Rhys',
	'Campbell',
	'C123456', -- Correctly entered PersonCode
	NULL
),
(
	'John',
	'Smith',
	NULL, -- No Person Code here
	'Person code = C654321 New Customer' -- PersonCode put in notes
),
(
	'Joe',
	'Bloggs',
	NULL, -- No Person Code here
	'Visited London store C654320 customer code.' -- PersonCode put in notes
);
```

Now lets view the data.

```
-- Select data
SELECT *
FROM dbo.ComputedColTable
```

[![computed_column_sql_server]({{ site.baseurl }}/assets/2009/09/computed_column_sql_server_thumb.png "computed\_column\_sql\_server")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/computed_column_sql_server.png)

Now we have cleaner data without any manual intervention needed.

