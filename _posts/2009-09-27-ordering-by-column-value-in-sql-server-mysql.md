---
layout: post
title: Ordering by Column Value in SQL Server & MySQL
date: 2009-09-27 16:40:19.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MySQL
- T-SQL
tags:
- MySQL
- ORDER BY
- order by column value
- TSQL
meta:
  tweetbackscheck: '1613463881'
  shorturls: a:4:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/ordering-by-column-value-in-sql-server-mysql/384";s:7:"tinyurl";s:26:"http://tinyurl.com/ybxnxm7";s:4:"isgd";s:18:"http://is.gd/3IYbM";s:5:"bitly";s:19:"http://bit.ly/YQKJW";}
  twittercomments: a:1:{s:10:"4415364123";s:7:"retweet";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ordering-by-column-value-in-sql-server-mysql/384/"
---
Today I needed to order some data by specific column value and I recalled the really handy [FIELD](http://dev.mysql.com/doc/refman/5.0/en/string-functions.html#function_field) function in [MySQL](http://www.mysql.com). Here’s a demo of this feature in [MySQL](http://www.mysql.com)

```
# Test table
CREATE TABLE City
(
	Id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	City VARCHAR(50)
);

# Insert some test data
INSERT INTO City
(
	City
)
VALUES
(
	'London'
),
(
	'Hong Kong'
),
(
	'New York'
),
(
	'Bangkok'
),
(
	'Los Angeles'
),
(
	'Paris'
),
(
	'Singapore'
),
(
	'Moscow'
),
(
	'Lagos'
),
(
	'Johannesburg'
);
```

Using the [FIELD](http://dev.mysql.com/doc/refman/5.0/en/string-functions.html#function_field) function we can order the resultset how ever we like.

```
-- Ordering by the value of City
SELECT *
FROM City
ORDER BY FIELD(City, 'Moscow',
		     'Lagos',
		     'Hong Kong',
		     'New York',
		     'Johannesburg',
		     'Singapore',
		     'London',
		     'Paris',
		     'Bangkok',
		     'Los Angeles');
```

[![mysql_ordering_by_column_value]({{ site.baseurl }}/assets/2009/09/mysql_ordering_by_column_value_thumb.png "mysql\_ordering\_by\_column\_value")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/mysql_ordering_by_column_value.png)

This is all very well but I needed to do this using [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx). I immediately though of using a [CASE](http://msdn.microsoft.com/en-us/library/ms181765.aspx) statement to do the ordering but thought I’d try to find something as easy as the [FIELD](http://dev.mysql.com/doc/refman/5.0/en/string-functions.html#function_field) function. This search proved to be unfruitful with the [documentation](http://msdn.microsoft.com/en-us/library/ms188723.aspx) pointing me nowhere. Should anybody know of a simpler way then please let me know. In the end I settled for a ordering using a CASE statement. The script below contains 2008 [TSQL](http://msdn.microsoft.com/en-us/library/bb510741.aspx).

```
-- Test table
CREATE TABLE City
(
	Id INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
	City VARCHAR(50)
);

-- Insert some test data
INSERT INTO City
(
	City
)
VALUES
(
	'London'
),
(
	'Hong Kong'
),
(
	'New York'
),
(
	'Bangkok'
),
(
	'Los Angeles'
),
(
	'Paris'
),
(
	'Singapore'
),
(
	'Moscow'
),
(
	'Lagos'
),
(
	'Johannesburg'
);
```

Now lets order our data by the value of the **City** column.

```
-- Ordering by the value of City
SELECT *
FROM City
ORDER BY CASE(City)
		WHEN 'Moscow' THEN 1
		WHEN 'Lagos' THEN 2
		WHEN 'Hong Kong' THEN 3
		WHEN 'New York' THEN 4
		WHEN 'Johannesburg' THEN 5
		WHEN 'Singapore' THEN 6
		WHEN 'London' THEN 7
		WHEN 'Paris' THEN 8
		WHEN 'Bangkok' THEN 9
		WHEN 'Los Angeles' THEN 10
	 END;
```

[![sql_server_ordering_by_column_value]({{ site.baseurl }}/assets/2009/09/sql_server_ordering_by_column_value_thumb.png "sql\_server\_ordering\_by\_column\_value")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/sql_server_ordering_by_column_value.png)

Both methods are perfectly functional but [MySQL](http://www.mysql.com) wins for me, on the grounds on simplicity, and a few less keystrokes!

