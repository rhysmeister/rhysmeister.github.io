---
layout: post
title: The GROUPING_ID TSQL Function
date: 2011-07-25 12:57:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- GROUPING_ID
- TSQL
meta:
  shorturls: a:3:{s:9:"permalink";s:68:"http://www.youdidwhatwithtsql.com/the-grouping_id-tsql-function/1279";s:7:"tinyurl";s:26:"http://tinyurl.com/3zyz8fq";s:4:"isgd";s:19:"http://is.gd/D2dCJn";}
  tweetbackscheck: '1613267603'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/the-grouping_id-tsql-function/1279/"
---
The [GROUPING\_ID](http://msdn.microsoft.com/en-us/library/bb510624.aspx "GROUPING\_ID TSQL Function") function computes the level of grouping in a resultset. It can be used in the SELECT, HAVING or ORDER BY clauses when used along with GROUP BY. The expression used in this function must match what has been used in the GROUP BY clause.

This function can be usefully deployed to order a resultset according to it's grouping hierarchy. For example we may wish to order aggregated sales results according to period.

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
	   GROUPING([Quarter]) AS IsQuarterGroup,
	   GROUPING_ID(Division, [Quarter])
FROM MyCTE
GROUP BY Division,
		 [Quarter]
WITH ROLLUP
ORDER BY GROUPING_ID(Division, [Quarter]);
```

Note how the resultset is ordered showing increasingly aggregated rows at the end.

[![grouping_id tsql function]({{ site.baseurl }}/assets/2011/07/grouping_id_tsql_function_thumb.png "grouping\_id tsql function")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/The-GROUPING_ID-TSQL-Function_B366/grouping_id_tsql_function.png)

