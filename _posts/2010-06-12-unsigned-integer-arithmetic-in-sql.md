---
layout: post
title: Unsigned Integer Arithmetic in SQL
date: 2010-06-12 17:45:27.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MySQL
- T-SQL
tags:
- integers
- MySQL
- T-SQL
- unsigned
meta:
  tweetbackscheck: '1613478862'
  shorturls: a:4:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/unsigned-integer-arithmetic-in-sql/794";s:7:"tinyurl";s:26:"http://tinyurl.com/34859qd";s:4:"isgd";s:18:"http://is.gd/cMQkR";s:5:"bitly";s:20:"http://bit.ly/dB3cUB";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/unsigned-integer-arithmetic-in-sql/794/"
---
Not the sexiest blog title in the world but I thought I’d knock up a little post on the behaviour of MySQL and SQL Server with integer subtraction. How would you expect a database system to behave with positive and negative data types? Microsoft SQL Server doesn’t really have unsigned data types. All integer types can be positive and negative with the exception of [TINYINT](http://msdn.microsoft.com/en-us/library/ms187745.aspx). MySQL implements the concept of [signedness](http://en.wikipedia.org/wiki/Signedness) so we can specify that TINYINT ranges from –128 to 127 or 0 to 255.

What would you expect SQL Server to do with this?

```
DECLARE @num1 TINYINT = 50, @num2 TINYINT = 75;

SELECT @num1 - @num2;
```

Well it errors. Good RDBMS!

```
Msg 8115, Level 16, State 2, Line 3
Arithmetic overflow error converting expression to data type tinyint.
```

What does MySQL do? Lets see.

```
USE test;

CREATE TABLE nums
(
	num1 INTEGER UNSIGNED NOT NULL,
	num2 INTEGER UNSIGNED NOT NULL
);

INSERT INTO nums
(
	num1,
	num2
)
VALUES
(
	50,
	75
);

SELECT num1 - num2
FROM nums;
```

[![mysql unsigned division]({{ site.baseurl }}/assets/2010/06/mysql_unsigned_division_thumb.png "mysql unsigned division")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/06/mysql_unsigned_division.png)

Oh dear not a pretty behaviour! Bad RDBMS! A colleague said to me “you need to set [sql\_mode](http://dev.mysql.com/doc/refman/5.0/en/server-sql-mode.html) to traditional”. Mmmmmm, I thought I was running in traditional mode already. As it turns out we need to set the NO\_UNSIGNED\_SUBTRACTION option.

```
SET @@SESSION.sql_mode = 'TRADITIONAL,NO_UNSIGNED_SUBTRACTION';

SELECT num1 - num2
FROM nums;
```

[![mysql correct unsigned division]({{ site.baseurl }}/assets/2010/06/mysql_correct_unsigned_division_thumb.png "mysql correct unsigned division")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/06/mysql_correct_unsigned_division.png)

Got to love MySQL for keeping you on your toes!

