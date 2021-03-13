---
layout: post
title: 'System Documentation: My Method'
date: 2009-08-10 14:40:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- T-SQL
tags:
- Database documentation
- DBA
meta:
  _edit_last: '1'
  shorturls: a:7:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/system-documentation-method/319";s:7:"tinyurl";s:25:"http://tinyurl.com/kktxwo";s:5:"bitly";s:19:"http://bit.ly/nEwKG";s:5:"snipr";s:22:"http://snipr.com/pl0nf";s:5:"snurl";s:22:"http://snurl.com/pl0nf";s:7:"snipurl";s:24:"http://snipurl.com/pl0nf";s:4:"isgd";s:18:"http://is.gd/2atQ0";}
  tweetbackscheck: '1613375543'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/system-documentation-method/319/"
---
Jorge Segarra ([Blog](http://sqlchicken.com) | [Twitter](http://twitter.com/sqlchicken)) posed the question [System Documentation: What’s your method?](http://sqlchicken.com/2009/08/system-documentation-whats-your-method/). In my experience documentation has either been nonexistent, out of date or even worse, plain wrong. These situations often get blamed on lack of time dedicated to documentation tasks.

Therefore I’ve always aimed at making documentation easy or even fun. I’ve blogged before about [auditing SQL Servers with Powershell](http://www.youdidwhatwithtsql.com/auditing-your-sql-server-with-powershell/133) and [auditing network adapters with Powershell](http://www.youdidwhatwithtsql.com/auditing-network-adapters-with-powershell/126). I’m very much a proponent of using [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) to make documentation easy and fun. Of course, it can’t help with everything, so this should only form part of the overall strategy.

I’m also in favour of [Documenting Databases](http://www.youdidwhatwithtsql.com/documenting-databases/204) in the sense of actually adding comments, in the form of extended properties, to the database itself. This seems to be a no-brainer to me. Keep it inside the database and generate your documentation from this. I recently produced a few [views](http://msdn.microsoft.com/en-us/library/ms187956.aspx) to pull together this information that can be easily exported into a spreadsheet.

Firstly I created a schema to group these views together. This makes their function clear.

```
CREATE SCHEMA Documentation;
GO
```

Then I placed a comment on this new schema.

```
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This schema contains views that exposes extended properties for database tables, column, view and other objects.' , @level0type=N'SCHEMA',@level0name=N'Documentation'
GO
```

Then I created these views based on SQL Server’s [system views](http://www.microsoft.com/downloads/details.aspx?FamilyID=2ec9e842-40be-4321-9b56-92fd3860fb32&displaylang=en).

```
CREATE VIEW Documentation.ColumnComments
AS
-- Column Comments
SELECT sch.name AS SchemaName,
	   tabs.name AS TableName,
	   cols.name AS ColumnName,
	   ty.name AS DataType,
	   cols.max_length AS MaxLength,
	   ep.name AS PropertyName,
	   ep.value AS PropertyValue
FROM sys.columns cols
INNER JOIN sys.tables tabs
	ON cols.object_id = tabs.object_id
INNER JOIN sys.schemas sch
	ON sch.schema_id = tabs.schema_id
INNER JOIN sys.types ty
	ON ty.system_type_id = cols.system_type_id
	AND ty.user_type_id = cols.user_type_id
LEFT JOIN sys.extended_properties ep
	ON cols.object_id = ep.major_id
	AND ep.minor_id = cols.column_id;
GO
CREATE VIEW Documentation.TableComments
AS
-- Table comments
SELECT sch.name AS SchemaName,
	   tabs.name AS TableName,
	   ep.name AS PropertyName,
	   ep.value AS PropertyValue
FROM sys.tables tabs
INNER JOIN sys.schemas sch
	ON sch.schema_id = tabs.schema_id
LEFT JOIN sys.extended_properties ep
	ON tabs.object_id = ep.major_id
	AND ep.minor_id = 0;
GO
CREATE VIEW Documentation.SchemaComments
AS
-- Schema comments
SELECT sch.name AS SchemaName,
	   ep.name AS PropertyName,
	   ep.value AS PropertyValue
FROM sys.schemas sch
LEFT JOIN sys.extended_properties ep
	ON sch.schema_id = ep.major_id
WHERE sch.principal_id = 1;
GO
CREATE VIEW Documentation.ViewComments
AS
-- View Comments
SELECT sch.name AS SchemaName,
	   vw.name AS TableName,
	   ep.name AS PropertyName,
	   ep.value AS PropertyValue
FROM sys.views vw
INNER JOIN sys.schemas sch
	ON sch.schema_id = vw.schema_id
LEFT JOIN sys.extended_properties ep
	ON vw.object_id = ep.major_id
	AND ep.minor_id = 0;
GO
```

You should now have the following views in your database. I’ve created these in the [AdventureWorks](http://msdn.microsoft.com/en-us/library/ms124501.aspx) sample database.

[![Documentation Views in SSMS]({{ site.baseurl }}/assets/2009/08/image_thumb9.png "Documentation Views in SSMS")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/08/image9.png)

**Documentation.ColumnComments**

This view contains information about each tables columns, their data types and comments.

```
SELECT *
FROM Documentation.ColumnComments;
```

[![Documentation.ColumnComments View Results]({{ site.baseurl }}/assets/2009/08/image_thumb10.png "Documentation.ColumnComments View Results")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/08/image10.png)

**Documentation.SchemaComments**

This view shows the schemas in the database along with any comments.

```
SELECT *
FROM Documentation.SchemaComments;
```

[![Documentation.SchemaComments View Results]({{ site.baseurl }}/assets/2009/08/image_thumb11.png "Documentation.SchemaComments View Results")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/08/image11.png)

**Documentation.TableComments**

This view exposes comments that have been added to tables.

```
SELECT *
FROM Documentation.TableComments;
```

[![Documentation.TableComments View Results]({{ site.baseurl }}/assets/2009/08/image_thumb12.png "Documentation.TableComments View Results")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/08/image12.png)

**Documentation.ViewComments**

This view exposes comments that have been added to views.

```
SELECT *
FROM Documentation.ViewComments;
```

[![Documentation.ViewComments View Results]({{ site.baseurl }}/assets/2009/08/image_thumb13.png "Documentation.ViewComments View Results")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/08/image13.png)

