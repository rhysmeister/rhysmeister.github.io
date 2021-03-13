---
layout: post
title: The difference statistics can make
date: 2011-10-07 21:47:29.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SQL Server
tags:
- statistics
meta:
  tweetbackscheck: '1612946114'
  shorturls: a:3:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/the-difference-statistics-can-make/1371";s:7:"tinyurl";s:26:"http://tinyurl.com/6ynngxz";s:4:"isgd";s:19:"http://is.gd/555UrH";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/the-difference-statistics-can-make/1371/"
---
A few days ago a developer came to me with a query that was executing slowly on a staging server. On this server it took 16 long seconds to execute while on other servers it took about 1 second.

I did a quick schema compare and found them to be identical. So I ran the query against each server asking for the [actual execution plan](http://technet.microsoft.com/en-us/library/ms189562.aspx "How to display the actual execution plan"). Result, different execution plans! I saved the execution plan as a [.sqlplan file](http://msdn.microsoft.com/en-us/library/ms190646.aspx "Save an execution plan as a sqlplan file") and opened it up with [SQL Sentry's Plan Explorer](http://www.sqlsentry.com/plan-explorer/sql-server-query-view.asp "SQL Sentry Plan Explorer"). This is a great tool that breaks down an execution plan into something far more comprehensible than we're provided with in [SSMS](http://msdn.microsoft.com/en-us/library/ms174173.aspx "SQL Server Management Studio").

By comparing this with the original plan I could see a big difference in the actual and estimated number of rows for a particular join.

[![sql_sentry_plan_explorer_top_operations]({{ site.baseurl }}/assets/2011/10/sql_sentry_plan_explorer_top_operations_thumb.png "sql\_sentry\_plan\_explorer\_top\_operations")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/10/sql_sentry_plan_explorer_top_operations.png)

This resulted in the optimizer deciding to go with a [clustered index scan](http://msdn.microsoft.com/en-us/library/ms175184.aspx "Clustered Index Scan") for this join rather than a more efficient [index seek](http://msdn.microsoft.com/en-us/library/ms190400.aspx "Index Seek"). Clearly the [statistics](http://msdn.microsoft.com/en-us/library/dd535534(v=sql.100).aspx "SQL Server Statistics") for this table were out of date. Here's what I did;

```
UPDATE STATISTICS tablename;
```

This took just a few seconds to execute and the execution of this query went down to milliseconds!

