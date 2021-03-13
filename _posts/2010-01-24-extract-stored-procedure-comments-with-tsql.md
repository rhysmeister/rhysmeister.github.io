---
layout: post
title: Extract Stored Procedure Comments with TSQL
date: 2010-01-24 15:16:42.000000000 +01:00
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
- TSQL
meta:
  tweetbackscheck: '1613476486'
  shorturls: a:4:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/extract-stored-procedure-comments-with-tsql/563";s:7:"tinyurl";s:26:"http://tinyurl.com/ycfc9a3";s:4:"isgd";s:18:"http://is.gd/6WdHT";s:5:"bitly";s:20:"http://bit.ly/5E1PeP";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: geographika@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/extract-stored-procedure-comments-with-tsql/563/"
---
I've blogged before about [documenting databases](http://www.youdidwhatwithtsql.com/documenting-databases/204). I'm very much a fan of extracting documentation from systems themselves so it's as up-to-date as it can be. That's probably why I'm such a big fan of [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) a tool that excels at this task. This week I was thinking about how to get at the comments often placed at the top of stored procedure definitions. I'm referring to the little block of comments that [Microsoft](http://www.microsoft.com/en/us/default.aspx) are encouraging us to fill out when we create a new store procedure.

```
-- =============================================
-- Author:<author>
-- Create date: <create date>
-- Description:	<description>
-- =============================================</description></create></author>
```

Would it not be useful to get our hands on these comments? Here's quick [TSQL](http://en.wikipedia.org/wiki/Transact-SQL) script you can use to attempt to extract those comments.

```
-- Drop temporary tables if they exist
IF OBJECT_ID('tempdb..#ProcDoc') IS NOT NULL
BEGIN
	DROP TABLE #ProcDoc;
END
 IF OBJECT_ID('tempdb..#temp') IS NOT NULL
 BEGIN
	DROP TABLE #temp;
END

-- Create a table to hold procedure documentation
CREATE TABLE #ProcDoc
(
	Id INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
	[Schema] VARCHAR(100),
	[Proc] VARCHAR(100),
	[Author] VARCHAR(100),
	[CreatedDate] VARCHAR(20),
	[Description] TEXT
);

DECLARE @proc VARCHAR(100),
		@schema VARCHAR(100),
		@proc_id INTEGER,
		@schema_proc VARCHAR(200);

-- Cursor to work through our procs
DECLARE procCursor CURSOR LOCAL FAST_FORWARD FOR SELECT p.[name] AS [proc],
							s.[name] AS [schema]
						 FROM sys.procedures p
						 INNER JOIN sys.schemas s
							ON s.schema_id = p.schema_id;

OPEN procCursor;
FETCH NEXT FROM procCursor INTO @proc,
				@schema;

WHILE (@@FETCH_STATUS = 0)
BEGIN

	INSERT INTO #ProcDoc
	(
		[Schema],
		[Proc]
	)
	VALUES
	(
		@Schema,
		@Proc
	);

	SET @proc_id = SCOPE_IDENTITY();

	-- Create a temp table to hold comments
	CREATE TABLE #temp
	(
		[Text] VARCHAR(4000) NULL
	);

	 -- Build schema + proc string
	SET @schema_proc = @schema + '.' + @proc;

	-- sp_helptext to get proc definition
	-- and insert into a temp table
	INSERT INTO #temp
	EXEC sys.sp_helptext @schema_proc;

	-- Just an id we'll use later to identify rows
	ALTER TABLE #temp ADD Id INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED;

	-- Get proc author
	UPDATE #ProcDoc
	SET [Author] =
	(
		SELECT (SELECT SUBSTRING([Text], PATINDEX('--Author: ', [text]) + 12, LEN([Text]) - (PATINDEX('--Author: ', [text]) + 12))) AS Author
		FROM #temp
		WHERE [text] LIKE '-- Author:%'
	)
	WHERE Id = @Proc_Id;

	-- Get proc created date
	UPDATE #ProcDoc
	SET CreatedDate =
	(
		SELECT (SELECT SUBSTRING([Text], PATINDEX('--Author: ', [text]) + 17, LEN([Text]) - (PATINDEX('--Author: ', [text]) + 17)))
		FROM #temp
		WHERE [text] LIKE '-- Create date:%'
	)
	WHERE Id = @Proc_Id;

	-- Get proc description
	-- Bit messy here but works for my situation
	-- probably need modification dpending on your commenting habits
	UPDATE #ProcDoc
	SET [Description] = REPLACE(CONVERT(VARCHAR(4000),
	(
		SELECT *
		FROM
		(
			SELECT REPLACE(REPLACE([text], '-- Description:', ''), '-- ', '') AS [text()]
			FROM #temp
			WHERE Id >= (SELECT Id FROM #temp WHERE [text] LIKE '-- Description:%')
			AND Id < (SELECT (Id - 1) FROM #temp WHERE [text] LIKE '%CREATE PROCEDURE%')
		) AS t FOR XML PATH('')
	)), '', '') -- Replace CR entities
	WHERE ID = @Proc_id;

	-- Drop the temp table
	DROP TABLE #temp;

	-- Get the next row
	FETCH NEXT FROM procCursor INTO @proc,
					@schema;

END

-- Clean up
CLOSE procCursor;
DEALLOCATE procCursor;

-- View procedure documentation
SELECT *
FROM #ProcDoc
WHERE [Description] IS NOT NULL;
```

All tables are temporary so there's nothing to clean up. You'll probably have to tweak this script as your commenting habits will likely vary. If all goes well the script should produce something looking like below.

[![extracting stored procedure comments]({{ site.baseurl }}/assets/2010/01/extracting_stored_procedure_comments_thumb.png "extracting stored procedure comments")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/extracting_stored_procedure_comments.png)

