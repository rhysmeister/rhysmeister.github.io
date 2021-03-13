---
layout: post
title: A Clone of the STRING_SPLIT MSSQL 2016 Function
date: 2017-07-18 13:00:28.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
- T-SQL
tags:
- SQL Server
- TSQL
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  _edit_last: '1'
  tweetbackscheck: '1613310875'
  shorturls: a:2:{s:9:"permalink";s:77:"http://www.youdidwhatwithtsql.com/clone-stringsplit-mssql-2016-function/2317/";s:7:"tinyurl";s:27:"http://tinyurl.com/y8tk4dpk";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/clone-stringsplit-mssql-2016-function/2317/"
---
I have recently been developing some stuff using MSSQL 2016 and used the [STRING\_SPLIT](https://docs.microsoft.com/en-us/sql/t-sql/functions/string-split-transact-sql) function. This doesn't exist in earlier versions and I discovered I would be required to deploy to 2008 or 2012. So here's a my own version of the STRING\_SPLIT function I have developed and tested on MSSQL 2008 (may also work on 2005).

```
CREATE FUNCTION [dbo].[STRING_SPLIT_2008]
(
	@string VARCHAR(1024),
	@seperator CHAR(1)
)
	RETURNS @table TABLE (
		[Value] VARCHAR(1024)
	)
AS
BEGIN

	DECLARE @x XML;
	SELECT @x = CAST('' + REPLACE(@string, @seperator, '') + '' AS XML);

	INSERT INTO @table
	SELECT t.value('.', 'varchar(1024)') as inVal
	FROM @X.nodes('/A') AS x(t)

	RETURN
END
```

Usage is as follows;

```
SELECT *
FROM dbo.STRING_SPLIT_2008('mail1.com;mail2.com;mail3.com;mail4.com;mail5.com;mail6.com;mail7.com;mail8.com;mail9.com', ';')
```

This would return the following resultset;

![string_split_2008 resultset]({{ site.baseurl }}/assets/2017/07/string_split_2008.png)

