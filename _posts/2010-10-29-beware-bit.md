---
layout: post
title: Beware of the BIT!
date: 2010-10-29 11:47:47.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1612920200'
  shorturls: a:4:{s:9:"permalink";s:48:"http://www.youdidwhatwithtsql.com/beware-bit/891";s:7:"tinyurl";s:26:"http://tinyurl.com/32f4w85";s:4:"isgd";s:18:"http://is.gd/grFY5";s:5:"bitly";s:20:"http://bit.ly/bQHvRu";}
  twittercomments: a:1:{s:11:"28865858701";s:7:"retweet";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/beware-bit/891/"
---
I've been spending the past week or so changing a colleagues scripts into [SSRS](http://msdn.microsoft.com/en-us/library/ms159106.aspx "SQL Server Reporting Services") reports so we can automate things a bit better. During some [QA](http://en.wikipedia.org/wiki/Quality_assurance "Quality Assurance") checks I noticed that I was coming out with higher counts on one section of the report.

Much to my frustration the two queries looked identical and I had no explanation as to why the counts were different.&nbsp; Both queries were pointing at the same database, using the same tables, using the same variable and variable values. How was this possible?

It was all down to a single variable being declared as a [BIT](http://msdn.microsoft.com/en-us/library/ms177603.aspx "SQL Server BIT Data Type") when it should have been a [TINYINT](http://msdn.microsoft.com/en-us/library/ms187745.aspx "SQL Server TINYINT Data Type"). The below TSQL demonstrates this issue...

```
DECLARE @bit BIT;
SET @bit = 2;
SELECT @bit AS whoops;
```

[![Shows what happens when you set SQL Servers BIT data type to two!]({{ site.baseurl }}/assets/2010/10/whoops.png "whoops")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/10/whoops.png)

That's right, no overflow error, it just happily truncates the value down to one! I've blogged about a [similar issue](http://www.youdidwhatwithtsql.com/unsigned-integer-arithmetic-in-sql/794 "Integer arithmetic in SQL") before but [MySQL](http://www.mysql.com/) was the badly behaved one in this situation.&nbsp; I'm guessing here that the BIT variable was based on a column that was, at one time, a BIT. But as the system evolved the column changed into a TINYINT but reports weren't updated.&nbsp; I'm unsure if there's a way to make SQL Server error on this but it's certainly something to keep an eye on!

