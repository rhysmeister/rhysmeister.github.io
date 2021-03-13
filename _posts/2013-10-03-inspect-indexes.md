---
layout: post
title: Inspect those indexes
date: 2013-10-03 17:17:04.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- T-SQL
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613419706'
  shorturls: a:3:{s:9:"permalink";s:55:"http://www.youdidwhatwithtsql.com/inspect-indexes/1673/";s:7:"tinyurl";s:26:"http://tinyurl.com/qy89dbk";s:4:"isgd";s:19:"http://is.gd/IA4sji";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/inspect-indexes/1673/"
---
Here's a few queries I often use to review the indexes in our SQL Server systems.

Tables should usually have a primary key. Are all of these intentional in your system?

```
-- Tables with no primary key
SELECT OBJECT_SCHEMA_NAME(t.[object_id]) AS [schema_name],
OBJECT_NAME(t.[object_id]) AS [table_name]
FROM sys.tables t
LEFT JOIN sys.indexes i
ON i.[object_id] = t.[object_id]
AND i.is_primary_key = 1
WHERE i.index_id IS NULL
AND t.[type] = 'U'
AND t.is_ms_shipped = 0;
```

Ignoring the PK it may be appropriate for some tables in your system to have a unique index defined to constrain your data. This query will identify those tables for review.

```
-- Table with no unique constraint (ignoring the PK)
SELECT OBJECT_SCHEMA_NAME(t.[object_id]) AS [schema_name],
OBJECT_NAME(t.[object_id]) AS [table_name]
FROM sys.tables t
LEFT JOIN sys.indexes i
ON i.[object_id] = t.[object_id]
AND i.is_primary_key = 0
AND i.is_unique = 1
WHERE i.index_id IS NULL
AND t.[type] = 'U'
AND t.is_ms_shipped = 0;
```

Has a developer defined a PK but forgotten to define additional indexes? The developers I work with often do. Do yours? Find out now...

```
SELECT OBJECT_SCHEMA_NAME(t.[object_id]) AS [schema_name],
		OBJECT_NAME(t.[object_id]) AS [table_name],
		SUM(CASE
				WHEN i.index_id IS NOT NULL
					THEN 1
				ELSE 0
			END) AS index_count
FROM sys.tables t
LEFT JOIN sys.indexes i
	ON i.[object_id] = t.[object_id]
	AND i.is_primary_key <> 1 -- Ignore primary keys
WHERE t.[type] = 'U'
AND t.is_ms_shipped = 0
GROUP BY OBJECT_SCHEMA_NAME(t.[object_id]),
		 OBJECT_NAME(t.[object_id])
HAVING SUM(CASE
				WHEN i.index_id IS NOT NULL
					THEN 1
				ELSE 0
			END) = 0
ORDER BY [schema_name],
		 table_name;
```

Here's a few index properties that may not be a good idea. Check out what they mean in the [sys.indexes](http://technet.microsoft.com/en-us/library/ms173760.aspx "sys.indexes")

```
-- Potentially "bad" index properties set. Are these justified?
SELECT OBJECT_SCHEMA_NAME(t.[object_id]) AS [schema_name],
OBJECT_NAME(t.[object_id]) AS [table_name],
i.name AS index_name,
i.[ignore_dup_key],
i.is_disabled,
i.is_hypothetical,
i.is_disabled
FROM sys.tables t
INNER JOIN sys.indexes i
ON i.[object_id] = t.[object_id]
WHERE (i.[ignore_dup_key] = 1
OR i.is_disabled = 1
OR i.is_hypothetical = 1
OR i.[allow_row_locks] = 0
OR i.[allow_page_locks] = 0);
```
