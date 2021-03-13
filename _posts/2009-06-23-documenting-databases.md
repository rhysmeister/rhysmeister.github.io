---
layout: post
title: Documenting Databases
date: 2009-06-23 19:05:00.000000000 +02:00
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
- MySQL
- SQL Server
- T-SQL
meta:
  tweetbackscheck: '1613316182'
  shorturls: a:7:{s:9:"permalink";s:59:"http://www.youdidwhatwithtsql.com/documenting-databases/204";s:7:"tinyurl";s:25:"http://tinyurl.com/nhnd2w";s:4:"isgd";s:18:"http://is.gd/1ly4c";s:5:"bitly";s:19:"http://bit.ly/Bl4t5";s:5:"snipr";s:22:"http://snipr.com/ln0zv";s:5:"snurl";s:22:"http://snurl.com/ln0zv";s:7:"snipurl";s:24:"http://snipurl.com/ln0zv";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: z1024@yandex.ru
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/documenting-databases/204/"
---
Asking for database documentation in many tech shops will result in blank stares. Other places do see the value of but it forever remains on the to-do list. There are a few commercial products available hoping to help with this;

SchemaToDoc - [http://www.schematodoc.com/](http://www.schematodoc.com/ "http://www.schematodoc.com/")  
SqlSpec - [http://www.elsasoft.org/](http://www.elsasoft.org/ "http://www.elsasoft.org/")  
SQL Doc - [http://www.red-gate.com/products/SQL\_Doc/index.htm](http://www.red-gate.com/products/SQL_Doc/index.htm "http://www.red-gate.com/products/SQL\_Doc/index.htm")

I’m not convinced of their value especially when important object metadata, or business information,&nbsp; is missing from your database.

All databases objects should be tagged if appropriate with need-to-know information; Tables should be tagged with some basic information, if that data is licensed and needs annual renewal why not document this inside the database itself?

Columns should have a brief description; it may be obvious to you what the column holds but is it to everyone else? One system I worked with had a [TINYINT](http://dev.mysql.com/doc/refman/5.0/en/numeric-types.html) column called phone\_permission with values of 0 or 1. My first guess was that ‘1’ meant you could call the telephone number on the record. Luckily I didn't run the telesales department so no problem was caused from this misunderstanding.

**Adding comments to database tables**

<font color="#666666">In <a href="http://www.mysql.com" target="_blank">MySQL</a> we can add a comment to a table like so;</font>

```
ALTER TABLE TestTable COMMENT 'Data supplied by ACME Corp.';
```

Table comments can then be viewed by using the [SHOW CREATE TABLE](http://dev.mysql.com/doc/refman/5.0/en/show-create-table.html) syntax.

```
mysql> SHOW CREATE TABLE TestTable \G
***************************1. row***************************
       Table: TestTable
Create Table: CREATE TABLE `TestTable` (
  `idnm` int(11) default NULL,
  `fullName` varchar(255) default NULL,
  `old_id` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The data in this table is supplied by ACME Corp.'
1 row in set (0.00 sec)

mysql>
```

Or by querying [INFORMATION\_SCHEMA](http://dev.mysql.com/doc/refman/5.0/en/information-schema.html);

```
-- View table comments for the current database
SELECT TABLE_NAME, TABLE_COMMENT
FROM information_schema.tables
WHERE TABLE_SCHEMA = DATABASE();
```

For [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) it’s a little more complicated. We have to add an [extended property](http://msdn.microsoft.com/en-us/library/ms190243.aspx) to attach a comment onto the table.

```
EXEC sys.sp_addextendedproperty @name=N'Description',
				@value=N'hello table Customer',
				@level0type=N'SCHEMA',
				@level0name=N'dbo',
				@level1type=N'TABLE',
				@level1name=N'Customer';
```

Viewing this comment isn’t as easy as [MySQL](http://www.mysql.com) either. Use the below [T-SQL](http://msdn.microsoft.com/en-us/library/ms189826.aspx) to view all table level comments in the current database (dbo schema);

```
-- Table comments
SELECT objtype, objname, name, value
FROM fn_listextendedproperty
(
	NULL,
	'schema',
	'dbo',
	'table',
	default,
	NULL,
	NULL
);
GO
```

[![Viewing Table comments in SSMS]({{ site.baseurl }}/assets/2009/06/image-thumb18.png "Viewing Table comments in SSMS")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image18.png)

Obviously [Microsoft](http://www.microsoft.com/en/us/default.aspx) didn’t intend people to hand-code [T-SQL](http://msdn.microsoft.com/en-us/library/ms189826.aspx) to add comments to their databases, but rather use tool support like [SSMS](http://msdn.microsoft.com/en-us/library/ms174173.aspx). This would probably be rather tedious if you needed to comment a large number of tables. Here’s a suggested method for making this task a little easier. First get the schema and name for all tables in the database you wish to document.

```
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
```

Copy and paste this into Excel, or other [spreadsheet program](http://www.openoffice.org/product/calc.html), so you can comment each table easily.

[![Comment your tables in Excel]({{ site.baseurl }}/assets/2009/06/image-thumb19.png "Comment your tables in Excel")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image19.png)

When you are finished import this data into [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) and run this [T-SQL](http://msdn.microsoft.com/en-us/library/ms189826.aspx) statement against it. N.B. This statement assumes you imported the table comment data into a table called **temp\_table\_comments**.

```
-- Generate T_SQL to add extended properties to all tables
-- in temp_table_comments
SELECT 'EXEC sys.sp_addextendedproperty @name=N''TABLE_COMMENT'',
					@value=N''' + COMMENT + ''',
					@level0type=N''SCHEMA'',
					@level0name=N''' + TABLE_SCHEMA + ''',
					@level1type=N''TABLE'',
					@level1name=N''' + TABLE_NAME + ''';'
FROM temp_table_comments;
```

Here’s the [T-SQL](http://msdn.microsoft.com/en-us/library/ms189826.aspx) it generates if run against the [AdventureWorks](http://www.microsoft.com/downloads/details.aspx?familyid=e719ecf7-9f46-4312-af89-6ad8702e4e6e) database table names. Once you have generated the [T-SQL](http://msdn.microsoft.com/en-us/library/ms189826.aspx) then you’re ready to run it against your database and apply your comments to the tables.

[![Running the script against the AdventureWorks database]({{ site.baseurl }}/assets/2009/06/image-thumb20.png "Running the script against the AdventureWorks database")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image20.png)

View the table comments added for the Sales schema.

```
-- Table comments for AdventureWorks
-- Sales schema
SELECT objtype, objname, name, value
FROM fn_listextendedproperty
(
	NULL,
	'schema',
	'Sales',
	'table',
	NULL,
	NULL,
	NULL
)
WHERE [name] = 'TABLE_COMMENT'
GO
```

[![Table comments in the Sales schema]({{ site.baseurl }}/assets/2009/06/image-thumb21.png "Table comments in the Sales schema")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image21.png)

It would be fairly easy to take a similar approach for commenting your table columns too. Once your database is nicely documented it’ll be easy to knock up a couple of reports in [SSRS](http://msdn.microsoft.com/en-us/library/ms159106.aspx) and surprise the next person who asks for “_the documentation”._

