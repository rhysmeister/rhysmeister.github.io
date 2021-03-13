---
layout: post
title: Purging data & Partitioning for Paupers
date: 2012-02-20 22:33:34.000000000 +01:00
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
- delete
- partition
- partitioning
- purging data
- TSQL
meta:
  shorturls: a:3:{s:9:"permalink";s:76:"http://www.youdidwhatwithtsql.com/purging-data-partitioning-for-paupers/1448";s:7:"tinyurl";s:26:"http://tinyurl.com/83x7pc5";s:4:"isgd";s:19:"http://is.gd/uWnbYS";}
  tweetbackscheck: '1613479179'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/purging-data-partitioning-for-paupers/1448/"
---
Several months ago at work we started having some terrible problems with some jobs that purge old data from our system. These jobs were put into place before my time, and while fine at the time, were now causing us some big problems. Purging data would take hours and cause horrendous blocking while they were going on.

The original solution consisted of a simple trigger and an archive table something like below;

```
CREATE TABLE dbo.SomeTable
(
	id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
	created DATETIME NOT NULL,
	url VARCHAR(100) NOT NULL,
	html NVARCHAR(MAX) NOT NULL
);
```

```
CREATE TRIGGER trg_InsRecord
   ON dbo.SomeTable
   AFTER INSERT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO dbo.SomeArchiveTable
    (
		id,
		created,
		url,
		html
	)
	SELECT id,
		   created,
		   url,
		   html
	FROM inserted;

END
GO
```

```
CREATE TABLE dbo.SomeArchiveTable
(
	id INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	created DATETIME NOT NULL,
	url VARCHAR(100) NOT NULL,
	html NVARCHAR(MAX) NOT NULL
);
```

Probably a setup many DBAs have seen before. In the **dbo.SomeTable** we keep just a few hours of data while in **dbo.SomeArchiveTable** seven days of data was kept. The SQL Agent job to purge data ran nightly and was just a simple delete statement;

```
DELETE FROM dbo.SomeArchiveTable WHERE created <= DATEADD(dd, -14, GETDATE());
```

This was fine while the table was small (yes created was indexed) but over time, as the business grew, the amount of data increased from a few gigabytes to hundreds of gigabytes. The job was taking anywhere between 2 and 5 hours, locking the entire database, and causing client timeouts.&nbsp; My SQL Server probably felt like this;

[![crying-child]({{ site.baseurl }}/assets/2012/02/crying-child_thumb.jpg "crying-child")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2012/02/crying-child.jpg)

A temporary solution was to delete the data in small batches to prevent [lock escalation](http://msdn.microsoft.com/en-us/library/ms184286.aspx "Lock Escalation in SQL Server").

```
DECLARE @rc INTEGER = -1;

WHILE(@rc != 0)
BEGIN

	-- Delete 4999 rows to prevent lock escalation
	-- http://msdn.microsoft.com/en-us/library/ms184286.aspx
	DELETE TOP (4999)
	FROM dbo.SomeArchiveTable
	WHERE created <= DATEADD(dd, -7, GETDATE())

	SET @rc = @@ROWCOUNT;

END
```

This solved the horrendous blocking issue but our SQL Server still wasn't happy with several hours of heaving Disk I/O each night.

[![Hard Drive on fire]({{ site.baseurl }}/assets/2012/02/hdd_on_fire_thumb.jpg "Hard Drive on fire")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2012/02/hdd_on_fire.jpg)

I've read a lot of great blogs about [SQL Server Partitioning](http://www.sqlmag.com/article/database-administration/using-table-partitions-to-archive-old-data-in-oltp-environments) and thought it could be of use here. Essentially these blogs demonstrate how to use partitioning to make dealing with large amounts of data easier.

Partitioning is an Enterprise only feature and we run standard in production. Do we upgrade to Enterprise and pay for a Microsoft executives bonus?

[![Fat Cat]({{ site.baseurl }}/assets/2012/02/fat_cat_thumb.jpg "Fat Cat")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2012/02/fat_cat.jpg)

With a little TSQL trickery we can stick with standard edition but get partition-like benefits.

Say we split our archive table into seven new tables, one for each day of the week, and change our trigger to insert an appropriate table according to the day.

```
CREATE TABLE [dbo].[SomeArchiveTable_Sunday](
	[id] [int] NOT NULL,
	[created] [datetime] NOT NULL,
	[url] [varchar](100) NOT NULL,
	[html] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[SomeArchiveTable_Monday](
	[id] [int] NOT NULL,
	[created] [datetime] NOT NULL,
	[url] [varchar](100) NOT NULL,
	[html] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[SomeArchiveTable_Tuesday](
	[id] [int] NOT NULL,
	[created] [datetime] NOT NULL,
	[url] [varchar](100) NOT NULL,
	[html] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
```

... and so on for each day of the week.

[![purging_data_partitioning_for_paupers]({{ site.baseurl }}/assets/2012/02/purging_data_partitioning_for_paupers_thumb.png "purging\_data\_partitioning\_for\_paupers")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2012/02/purging_data_partitioning_for_paupers.png)

Then we need to alter our trigger to insert data into the correct table. In this case it is determined by the current day returned via the [DATEPART](http://msdn.microsoft.com/en-us/library/ms174420.aspx "DATEPART") function.

```
ALTER TRIGGER [dbo].[trg_InsRecord]
   ON [dbo].[SomeTable]
   AFTER INSERT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- What day is it?
	DECLARE @day TINYINT = DATEPART(dw, GETDATE());

	IF(@day = 1)
	BEGIN
		INSERT INTO dbo.SomeArchiveTable_Sunday
		(
			id,
			created,
			url,
			html
		)
		SELECT id,
			   created,
			   url,
			   html
		FROM inserted;
	END
	ELSE IF (@day = 2)
	BEGIN
		INSERT INTO dbo.SomeArchiveTable_Monday
		(
			id,
			created,
			url,
			html
		)
		SELECT id,
			   created,
			   url,
			   html
		FROM inserted;
	END
	ELSE IF (@day = 3)
	BEGIN
		INSERT INTO dbo.SomeArchiveTable_Tuesday
		(
			id,
			created,
			url,
			html
		)
		SELECT id,
			   created,
			   url,
			   html
		FROM inserted;
	END
	ELSE IF (@day = 4)
	BEGIN
		INSERT INTO dbo.SomeArchiveTable_Wednesday
		(
			id,
			created,
			url,
			html
		)
		SELECT id,
			   created,
			   url,
			   html
		FROM inserted;
	END
	ELSE IF (@day = 5)
	BEGIN
		INSERT INTO dbo.SomeArchiveTable_Thursday
		(
			id,
			created,
			url,
			html
		)
		SELECT id,
			   created,
			   url,
			   html
		FROM inserted;
	END
	ELSE IF (@day = 6)
	BEGIN
		INSERT INTO dbo.SomeArchiveTable_Friday
		(
			id,
			created,
			url,
			html
		)
		SELECT id,
			   created,
			   url,
			   html
		FROM inserted;
	END
	ELSE IF (@day = 7)
	BEGIN
		INSERT INTO dbo.SomeArchiveTable_Saturday
		(
			id,
			created,
			url,
			html
		)
		SELECT id,
			   created,
			   url,
			   html
		FROM inserted;
	END
END
```

So how do we purge data? Simple, just run something like this a little before midnight each day...

```
-- What day is it?
	DECLARE @day TINYINT = DATEPART(dw, GETDATE());

	IF(@day = 1) -- Sunday - truncate Mondays table
	BEGIN
		TRUNCATE TABLE dbo.SomeArchiveTable_Monday;
	END
	ELSE IF (@day = 2) -- Monday -- truncate Tuesdays table
	BEGIN
		TRUNCATE TABLE dbo.SomeArchiveTable_Tuesday;
	END
	ELSE IF (@day = 3)
	BEGIN
		TRUNCATE TABLE dbo.SomeArchiveTable_Wednesday;
	END -- and so on for each day of the week...
```

Truncating a table takes milliseconds so our SQL Server is now much happier. Disk I/O is massively reduced. There's also a couple of additional benefits from this approach; each table is smaller so re-indexing is much quicker, and usually a table being re-indexed is not being inserted into so no blocking occurs.

