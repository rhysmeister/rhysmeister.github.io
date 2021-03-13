---
layout: post
title: Get database size With T-SQL and MySQL
date: 2009-10-31 13:40:18.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
- T-SQL
tags:
- Database documentation
- database size
- MySQL
- T-SQL
meta:
  tweetbackscheck: '1613479120'
  shorturls: a:4:{s:9:"permalink";s:76:"http://www.youdidwhatwithtsql.com/get-database-size-with-t-sql-and-mysql/414";s:7:"tinyurl";s:26:"http://tinyurl.com/yfk5vcg";s:4:"isgd";s:18:"http://is.gd/4J9Y9";s:5:"bitly";s:20:"http://bit.ly/2BqWJe";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/get-database-size-with-t-sql-and-mysql/414/"
---
I've recently been busy documentation various systems at work and came up with these queries to get a list of databases and their sizes for each [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx). These queries will show the server name, database names, and their sizes in KB, MB and GB.

For SQL Server 2005 & 2008

```
-- SQL Server 2005 /2008
CREATE TABLE #databases
(
 DATABASE_NAME VARCHAR(50),
 DATABASE_SIZE FLOAT,
 REMARKS VARCHAR(100)
)

INSERT #Databases EXEC ('EXEC sp_databases');

SELECT @@SERVERNAME AS SERVER_NAME,
    DATABASE_NAME,
    DATABASE_SIZE AS '(KB)',
    ROUND(DATABASE_SIZE / 1024, 2) AS '(MB)',
    ROUND((DATABASE_SIZE / 1024) / 1024, 2) AS '(GB)',
    REMARKS
FROM #databases;

DROP TABLE #databases;
```

[![database sizes sql server]({{ site.baseurl }}/assets/2009/10/database_sizes_sql_server_thumb.png "database sizes sql server")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/10/database_sizes_sql_server.png)

For SQL Server 2000

```
-- SQL 2000
SELECT @@SERVERNAME AS SERVER_NAME,
    db.name AS DATABASE_NAME,
    SUM(size * 8) AS '(KB)',
    ROUND(SUM(CAST((size * 8) AS FLOAT)) / 1024, 2) AS '(MB)',
    ROUND(((SUM(CAST((size * 8) AS FLOAT)) / 1024) / 1024), 2) AS '(GB)'
FROM sysaltfiles files
INNER JOIN sysdatabases db
 ON db.dbid = files.dbid
GROUP BY db.name
```

For MySQL. Note the [@@hostname](http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html#sysvar_hostname) variable. This was introduced in MySQL 5.0.3.8 so you'll need to remove this if you're using an earlier version.

```
-- @@hostname variable introduced in MySQL 5.0.38
SELECT @@hostname,
       TABLE_SCHEMA AS `DATABASE`,
       ROUND(SUM(data_length + index_length +data_free) / 1024, 2) '(KB)',
       ROUND(SUM(data_length + index_length +data_free)/ 1024 / 1024, 2) '(MB)',
       ROUND(SUM(data_length + index_length +data_free)/ 1024 / 1024 /1024, 2) '(GB)'
FROM information_schema.TABLES
GROUP BY TABLE_SCHEMA;
```

[![database sizes mysql]({{ site.baseurl }}/assets/2009/10/database_sizes_mysql_thumb.png "database sizes mysql")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/10/database_sizes_mysql.png)

