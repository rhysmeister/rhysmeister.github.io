---
layout: post
title: The GROUPING TSQL Function
date: 2011-07-20 12:43:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- GROUPING
- TSQL
meta:
  shorturls: a:3:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/the-grouping-tsql-function/1278";s:7:"tinyurl";s:26:"http://tinyurl.com/3voh2ln";s:4:"isgd";s:19:"http://is.gd/peecyS";}
  tweetbackscheck: '1613376057'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/the-grouping-tsql-function/1278/"
---
You can use the [GROUPING](http://msdn.microsoft.com/en-us/library/ms178544.aspx "TSQL GROUPING Function") function to indicate if a column in a resultset has been aggregated or not. A value of 1 will be returned if the result is aggregated, otherwise 0 is returned. It is best used to identify the additional rows returned when a query uses the ROLLUP, CUBE or GROUPING\_SETS clauses.

To see this in action run the below TSQL in [SSMS](http://msdn.microsoft.com/en-us/library/ms174173.aspx "SQL Server Management Studio").

```
WITH MyCTE
(
	Division,
	[Quarter],
	Value
)
AS
(
	SELECT 'Sales 1', 1, 0.12
	UNION ALL
	SELECT 'Sales 1', 1, 0.34
	UNION ALL
	SELECT 'Sales 1', 2, 0.45
	UNION ALL
	SELECT 'Sales 2', 3, 0.77
	UNION ALL
	SELECT 'Sales 2', 1, 0.55
	UNION ALL
	SELECT 'Sales 1', 3, 0.78
	UNION ALL
	SELECT 'Sales 2', 2, 0.45
	UNION ALL
	SELECT 'Sales 2', 4, 0.67
	UNION ALL
	SELECT 'Sales 1', 4, 0.77
)
SELECT Division,
	   [Quarter],
	   SUM(Value) AS SummedValue,
	   GROUPING(Division) AS IsDivisionGroup,
	   GROUPING([Quarter]) AS IsQuarterGroup
FROM MyCTE
GROUP BY Division,
		 [Quarter]
WITH ROLLUP;
```

This query will return the following resultset. Note how **IsQuarterGroup** is flagged for each division total as well as the grand total row where **IsQuarterGroup** and **IsDivisionGroup** is also flagged.

[![grouping tsql function]({{ site.baseurl }}/assets/2011/07/grouping_tsql_function_thumb.png "grouping tsql function")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/The-GROUPING-TSQL-Function_AD6B/grouping_tsql_function.png)

