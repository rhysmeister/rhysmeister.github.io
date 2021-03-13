---
layout: post
title: Executing MySQL Stored Procedures from SQL Server
date: 2009-06-08 19:01:25.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MySQL
- T-SQL
tags:
- Database Integration
- MySQL
- T-SQL
- TSQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613327744'
  shorturls: a:7:{s:9:"permalink";s:87:"http://www.youdidwhatwithtsql.com/executing-mysql-stored-procedures-from-sql-server/170";s:7:"tinyurl";s:25:"http://tinyurl.com/m75q4a";s:4:"isgd";s:18:"http://is.gd/16ggr";s:5:"bitly";s:19:"http://bit.ly/6rXfw";s:5:"snipr";s:22:"http://snipr.com/kfwal";s:5:"snurl";s:22:"http://snurl.com/kfwal";s:7:"snipurl";s:24:"http://snipurl.com/kfwal";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: fan.eddy@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/executing-mysql-stored-procedures-from-sql-server/170/"
---
If you ever need to call a [MySQL](http://www.mysql.com) procedure from [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) it’s fairly simple thanks to [ODBC](http://en.wikipedia.org/wiki/Open_Database_Connectivity) and [Linked Servers](http://msdn.microsoft.com/en-us/library/ms188279.aspx). This will allow you to reuse any logic already invested in [MySQL Stored Procedures](http://dev.mysql.com/doc/refman/5.0/en/stored-routines.html) saving you from rewriting them. Here's a simple example on how you can do it;

- Create the following procedure in your MySQL ‘test’ database. 

```
DELIMITER $$
DROP PROCEDURE IF EXISTS `test`.`usp_test`$$
CREATE PROCEDURE `test`.`usp_test`()
	LANGUAGE SQL
	DETERMINISTIC
	SQL SECURITY INVOKER
	COMMENT 'Test Procedure returns the numbers 1-5'
BEGIN
	SELECT 1
	UNION ALL
	SELECT 2
	UNION ALL
	SELECT 3
	UNION ALL
	SELECT 4
	UNION ALL
	SELECT 5;
END$$
DELIMITER ;
```

- Configure your [MySQL](http://www.mysql.com) Server as a [Linked Server](http://msdn.microsoft.com/en-us/library/ms188279.aspx) in [SSMS](http://msdn.microsoft.com/en-us/library/ms174173.aspx). Plenty of guides on the net about this so I won’t repeat it here. Here’s a [good one](http://www.ideaexcursion.com/2009/02/25/howto-setup-sql-server-linked-server-to-mysql/). 

If you get the following message&nbsp;&nbsp;

```
Msg 7411, Level 16, State 1, Line 1
Server 'MYSQL' is not configured for RPC.
```

You need to change the [Linked Server](http://msdn.microsoft.com/en-us/library/ms188279.aspx) property "RPC Out" to true.

[![Linked Server Properties - Enable RPC Out]({{ site.baseurl }}/assets/2009/06/image-thumb9.png "Linked Server Properties - Enable RPC Out")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image9.png)

- Once your [Linked Server](http://msdn.microsoft.com/en-us/library/ms188279.aspx) has been configured correctly you’re ready to go. Execute the following [T-SQL](http://msdn.microsoft.com/en-us/library/ms189826.aspx) in [SSMS](http://msdn.microsoft.com/en-us/library/ms188279.aspx). 

```
EXEC('CALL test.usp_test()') AT MYSQL;
```

[![Executing MySQL Stored Procedures from SQL Server]({{ site.baseurl }}/assets/2009/06/image-thumb10.png "Executing MySQL Stored Procedures from SQL Server")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image10.png)

In fact the [EXEC](http://msdn.microsoft.com/en-us/library/aa175921(SQL.80).aspx) can be used to run any [MySQL](http://www.mysql.com) specific command. All the following will work;

```
EXEC('SHOW TABLES') AT MySQL; -- Show the tables in the current database
EXEC('SHOW SLAVE STATUS') AT MySQL; -- Show Slave status info (if applicable)
EXEC('SHOW DATABASES') AT MySQL; -- Show the accessible databases
EXEC('SHOW CREATE TABLE mysql.user') AT MySQL; -- Show the SQL used to create mysql.users
```

[MySQL](http://www.mysql.com) [Linked Servers](http://msdn.microsoft.com/en-us/library/ms188279.aspx) work pretty solidly with [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) and allow complex integrations between systems to happen reasonably easily. So if your needs are simple there’s no need to resort to an additional layer like [SSIS](http://msdn.microsoft.com/en-us/library/ms141026.aspx) if it’s going to complicate your environment.

