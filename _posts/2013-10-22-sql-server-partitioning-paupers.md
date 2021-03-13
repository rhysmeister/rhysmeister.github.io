---
layout: post
title: SQL Server Partitioning for Paupers
date: 2013-10-22 12:33:26.000000000 +02:00
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
- partitioing
meta:
  _edit_last: '1'
  tweetbackscheck: '1613426254'
  shorturls: a:3:{s:9:"permalink";s:71:"http://www.youdidwhatwithtsql.com/sql-server-partitioning-paupers/1692/";s:7:"tinyurl";s:26:"http://tinyurl.com/ovo2x8b";s:4:"isgd";s:19:"http://is.gd/UQTQyQ";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: brianchristopherbrown@hotmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/sql-server-partitioning-paupers/1692/"
---
Last year I posted about a [pauper's partitioning technique](http://www.youdidwhatwithtsql.com/purging-data-partitioning-for-paupers/1448/ "SQL Server Partitioning") I used with SQL Server to solve some data purging issues. In a similar vein I recently found [SQL Server partitioning without Enterprise Edition](https://www.simple-talk.com/sql/sql-tools/sql-server-partitioning-without-enterprise-edition/ "SQL Server Partitioning without Enterprise Edition")&nbsp;that looks like the answer to an issue in our systems. We have large amounts of data but simply can't justify the cost of SQL Server Enterprise. All is not lost. Time to roll-up our TSQL sleeves!

This example is similar to this&nbsp;[SimpleTalk](https://www.simple-talk.com/ "SQL Server Site SimpleTalk")&nbsp; post but uses ranges of ids as the partitioning key.

First create a test database with separate filegroups for each table / partition.

```
CREATE DATABASE PoorMansPartitions;
GO

USE PoorMansPartitions;
GO

ALTER DATABASE PoorMansPartitions
ADD FILEGROUP Partition1;
GO

-- Create a filegroup for Partition1
ALTER DATABASE PoorMansPartitions
ADD FILE
(
	NAME = [Partition1],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Partition1.mdf'
) TO FILEGROUP Partition1;
GO

ALTER DATABASE PoorMansPartitions
ADD FILEGROUP Partition2;
GO

ALTER DATABASE PoorMansPartitions
ADD FILE
(
	NAME = [Partition2],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Partition2.mdf'
) TO FILEGROUP Partition2;
GO

ALTER DATABASE PoorMansPartitions
ADD FILEGROUP Partition3;
GO

ALTER DATABASE PoorMansPartitions
ADD FILE
(
	NAME = [Partition3],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Partition3.mdf'
) TO FILEGROUP Partition3;
GO

ALTER DATABASE PoorMansPartitions
ADD FILEGROUP Partition4;
GO

ALTER DATABASE PoorMansPartitions
ADD FILE
(
	NAME = [Partition4],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Partition4.mdf'
) TO FILEGROUP Partition4;
GO

ALTER DATABASE PoorMansPartitions
ADD FILEGROUP Partition5;
GO

ALTER DATABASE PoorMansPartitions
ADD FILE
(
	NAME = [Partition5],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Partition5.mdf'
) TO FILEGROUP Partition5;
GO
```

Create the tables (or pseudo-partitions) within the appropriate filegroup.

```
-- Create tables on these files
CREATE TABLE dbo.Partition1
(
	id INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	created_at DATETIME NOT NULL DEFAULT GETUTCDATE(),
	random_text VARCHAR(100) NOT NULL,
	CONSTRAINT CK_Partition1_id_Between_1_and_10000000 CHECK(id BETWEEN 1 AND 10000000)
) ON [Partition1]
GO

CREATE TABLE dbo.Partition2
(
	id INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	created_at DATETIME NOT NULL DEFAULT GETUTCDATE(),
	random_text VARCHAR(100) NOT NULL,
	CONSTRAINT CK_Partition2_id_Between_10000001_and_20000000 CHECK(id BETWEEN 10000001 AND 20000000)
) ON [Partition2]
GO

CREATE TABLE dbo.Partition3
(
	id INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	created_at DATETIME NOT NULL DEFAULT GETUTCDATE(),
	random_text VARCHAR(100) NOT NULL,
	CONSTRAINT CK_Partition3_id_Between_20000001_and_30000000 CHECK(id BETWEEN 20000001 AND 30000000)
) ON [Partition3]
GO

CREATE TABLE dbo.Partition4
(
	id INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	created_at DATETIME NOT NULL DEFAULT GETUTCDATE(),
	random_text VARCHAR(100) NOT NULL,
	CONSTRAINT CK_Partition3_id_Between_30000001_and_40000000 CHECK(id BETWEEN 30000001 AND 40000000)
) ON [Partition4]
GO

CREATE TABLE dbo.Partition5
(
	id INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	created_at DATETIME NOT NULL DEFAULT GETUTCDATE(),
	random_text VARCHAR(100) NOT NULL,
	CONSTRAINT CK_Partition3_id_Between_40000001_and_50000000 CHECK(id BETWEEN 40000001 AND 50000000)
) ON [Partition5]
GO
```

Next we need to create a view over the top of these pseudo-partitions. Our applications will use this view rather than the partitions directly.

```
CREATE VIEW dbo.Partitions
WITH SCHEMABINDING
AS
	SELECT id, created_at, random_text
	FROM dbo.Partition1
	UNION ALL
	SELECT id, created_at, random_text
	FROM dbo.Partition2
	UNION ALL
	SELECT id, created_at, random_text
	FROM dbo.Partition3
	UNION ALL
	SELECT id, created_at, random_text
	FROM dbo.Partition4
	UNION ALL
	SELECT id, created_at, random_text
	FROM dbo.Partition5;
GO
```

Now lets try some queries.

```
SELECT *
FROM dbo.Partitions
WHERE id = 1;
```

Here we can see that only the dbo.Partition1 table is scanned.

[![query1_partitions]({{ site.baseurl }}/assets/2013/10/query1_partitions.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2013/10/query1_partitions.png)

```
SELECT *
FROM dbo.Partitions
WHERE id = 10000001;
```

Likewise this query only scans the dbo.Partition2 table.

[![query2_partitions]({{ site.baseurl }}/assets/2013/10/query2_partitions.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2013/10/query2_partitions.png)

Unfortunately it seems that UPDATEs, DELETEs and INSERTs don't behave in the same way...

```
UPDATE dbo.Partitions
SET created_at = GETUTCDATE()
WHERE id = 1;
```

[![query_update_partitions]({{ site.baseurl }}/assets/2013/10/query_update_partitions.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2013/10/query_update_partitions.png)

```
DELETE
FROM dbo.Partitions
WHERE id = 1;
```

[![query_delete_partitions]({{ site.baseurl }}/assets/2013/10/query_delete_partitions.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2013/10/query_delete_partitions.png)

```
INSERT INTO dbo.Partitions
(
	id, created_at, random_text
)
VALUES (1, GETUTCDATE(), CONVERT(VARCHAR(100), NEWID()));
```

[![query_insert_partitions]({{ site.baseurl }}/assets/2013/10/query_insert_partitions.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2013/10/query_insert_partitions.png)

I need to test the performance impact of this but I'm confident this won't be too important for my situation. I'll be putting this to use in an archive database where the data never changes once inserted.

Not only does this approach improve queries it also makes re-indexing much simpler; small tables are easier to handle and are less likely to send performance through the floor when they are being rebuilt.

