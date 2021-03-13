---
layout: post
title: The NTILE TSQL Function
date: 2011-07-27 13:15:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- NTILE
- TSQL
meta:
  tweetbackscheck: '1613218785'
  shorturls: a:3:{s:9:"permalink";s:62:"http://www.youdidwhatwithtsql.com/the-ntile-tsql-function/1280";s:7:"tinyurl";s:26:"http://tinyurl.com/3c7h69f";s:4:"isgd";s:19:"http://is.gd/0YtEMH";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/the-ntile-tsql-function/1280/"
---
The [NTILE](http://msdn.microsoft.com/en-us/library/ms175126.aspx "NTILE TSQL Function") is used to assigned records into the desired number of groups. NTILE assigns a number to each record indicating the group it belongs to. The number of records in each group will be the same if possible, otherwise some groups will have less than the others.

This function may be useful for assigning a number of sales leads to a certain number of groups. Run the following TSQL in [SSMS](http://msdn.microsoft.com/en-us/library/ms174173.aspx "SQL Server Management Studio").

```
WITH MyCTE
(
	Company,
	Telephone
)
AS
(
	SELECT 'ACME LTD', '0123456789'
	UNION ALL
	SELECT 'Big Corp', '0987654321'
	UNION ALL
	SELECT 'Bobs Bits', '9999999999'
	UNION ALL
	SELECT 'Daves Hardware', '000000000000'
	UNION ALL
	SELECT 'Maestrosoft', '111111111111'
	UNION ALL
	SELECT 'Boracle Corp', '333333333333'
	UNION ALL
	SELECT 'White Dwarf Microsystems', '5555555555555'
	UNION ALL
	SELECT 'Big Telecom', '4444444444444'
	UNION ALL
	SELECT 'DOL', '666666666666'
	UNION ALL
	SELECT 'London Media Ltd', '888888888888'
)
SELECT Company,
	   Telephone,
	   NTILE(3) OVER(ORDER BY Company) AS [Group]
FROM MyCTE;
```

Note how there are four records in group 1 and the remaining groups get three each.

[![ntile tsql function]({{ site.baseurl }}/assets/2011/07/ntile_tsql_function_thumb.png "ntile tsql function")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/The-NTILE-TSQL-Function_B66A/ntile_tsql_function.png)

