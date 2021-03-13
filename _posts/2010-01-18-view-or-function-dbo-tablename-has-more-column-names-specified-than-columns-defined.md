---
layout: post
title: View or function 'dbo.Viewname' has more column names specified than columns
  defined
date: 2010-01-18 21:08:22.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- T-SQL
tags:
- SQL Server
- views
meta:
  tweetbackscheck: '1613452653'
  shorturls: a:4:{s:9:"permalink";s:121:"http://www.youdidwhatwithtsql.com/view-or-function-dbo-tablename-has-more-column-names-specified-than-columns-defined/546";s:7:"tinyurl";s:26:"http://tinyurl.com/yjz6rjk";s:4:"isgd";s:18:"http://is.gd/6xEky";s:5:"bitly";s:20:"http://bit.ly/6PhoNp";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/view-or-function-dbo-tablename-has-more-column-names-specified-than-columns-defined/546/"
---
If you ever encounter this [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) error when selecting from a view then somebody has probably dropped columns from the base table. Here's a quick run through of the problem.

```
CREATE TABLE dbo.Contact
(
	Id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	DOB DATETIME NOT NULL,
	Phone VARCHAR(30) NULL,
	Email VARCHAR(200) NULL,
	Mobile VARCHAR(20) NULL,
	Website VARCHAR(100) NULL
);
```

Insert a test record.

```
INSERT INTO dbo.Contacts
(
	FirstName,
	LastName,
	DOB,
	Email,
	Website
)
VALUES
(
	'Rhys',
	'Campbell',
	'01-Jun-80',
	'noone@tempinbox.com',
	'http://www.youdidwhatwithtsql.com'
);
```

Create a view on this table.

```
CREATE VIEW vw_Contacts
AS
	SELECT *
	FROM dbo.Contacts;
```

Verify the view is functional

```
SELECT *
FROM vw_Contacts;
```

[![sql server view results]({{ site.baseurl }}/assets/2010/01/view_results_thumb1.png "sql server view results")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/view_results1.png)

Now drop a column from the **Contacts** table.

```
ALTER TABLE dbo.Contacts DROP COLUMN Phone;
```

Now try selecting from the view again.

```
SELECT *
FROM vw_Contacts;
```

[![View or function 'vw_Contacts' has more column names specified than columns defined]({{ site.baseurl }}/assets/2010/01/sql_server_view_error_thumb.png "View or function 'vw\_Contacts' has more column names specified than columns defined")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/sql_server_view_error.png)

So what's going on here? The view is expecting the **Phone** column to still be in the **Contact** table. We created our view with an asterisk so this shouldn't matter right? [Uvavu](http://en.wikipedia.org/wiki/Shooting_Stars#Catchphrases)! SQL Server stores metadata about the view when you create it. Changes to underlying tables can cause issues. Luckily the fix is easy.

```
EXEC sp_refreshview 'vw_Contacts';
```

```
SELECT *
FROM vw_Contacts;
```

[![fixed sql server view]({{ site.baseurl }}/assets/2010/01/fixed_sql_server_view_thumb.png "fixed sql server view")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/fixed_sql_server_view.png)

This procedure will update the metadata stored by the view making it functional again. Presumably this is akin to dropping and recreating the view. This is a fairly trivial example but in a large system, with lots of views, and lots of developers, this could cause big headaches. I recommend you read the [MSDN](http://msdn.microsoft.com) page for [sp\_refreshview](http://msdn.microsoft.com/en-us/library/ms187821.aspx). There's a couple of useful scripts in the comments section for making light work of this.

