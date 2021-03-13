---
layout: post
title: Are you checking for possible integer overflow?
date: 2013-05-02 18:43:54.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- integer overflow
- SQL Server
- TSQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613462252'
  shorturls: a:3:{s:9:"permalink";s:47:"http://www.youdidwhatwithtsql.com/archives/1556";s:7:"tinyurl";s:26:"http://tinyurl.com/bufgjnd";s:4:"isgd";s:19:"http://is.gd/W1UYyF";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/checking-integer-overflow/1556/"
---
I&nbsp;realized&nbsp;I wasn't! We run a&nbsp;couple&nbsp;of systems that I know stick a mass of records through on a daily basis. Better start doing this then or I might end up doing a [whoopsie](http://www.bbc.co.uk/news/world-us-canada-11491937 "US offenders unmonitored as tagging system fails")!

Here's a script I've quickly knocked up to make&nbsp;checking&nbsp;this simple. This script will check the specified tables [TINYINT, SMALLINT, INT & BIGINT](http://msdn.microsoft.com/en-us/library/aa933198(v=sql.80).aspx "int, bigint, smallint, and tinyint") values against the allowable maximum.

A few things to note about this script;

- Don't run on a live system.
- To check all tables in a database you can remove the line&nbsp;specifying&nbsp;TABLE\_NAME in the cursor. Be aware this may take a long time and stress your server.
- % are expressed as a value between 0 and 1 i.e. 0.5 = 50%.
- % may be slightly off but should not matter considering the scales involved.
- % also ignores negative&nbsp;numbers since we typically start [IDENTITY](http://msdn.microsoft.com/en-us/library/ms186775.aspx "SQL Server IDENTITY property") columns at 1.
- Change&nbsp;@used\_warn\_level\_percent to a sensible value&nbsp;according&nbsp;to your system.
- If you observe "Warning: Null value is eliminated by an aggregate or other SET operation." then your table has a column only&nbsp;containing&nbsp;nulls.

```
DECLARE @table_schema VARCHAR(50),
		@table_name VARCHAR(50),
		@column_name VARCHAR(50),
		@data_type VARCHAR(30),
		@max_id BIGINT,
		@used_warn_level_percent DECIMAL(4,2);

SET @used_warn_level_percent = 49.0;

SET NOCOUNT ON;

DECLARE myCursor CURSOR LOCAL FAST_FORWARD FOR SELECT TOP 10 TABLE_SCHEMA,
													   TABLE_NAME,
													   COLUMN_NAME,
													   DATA_TYPE
												FROM INFORMATION_SCHEMA.COLUMNS
												WHERE DATA_TYPE IN ('tinyint', 'smallint', 'int', 'bigint')
												AND TABLE_CATALOG = DB_NAME()
												AND TABLE_NAME = 'test_numbers';

OPEN myCursor;
FETCH NEXT FROM myCursor INTO @table_schema,
							  @table_name,
							  @column_name,
							  @data_type;

DECLARE @max_id_table TABLE
(
	id BIGINT
);

WHILE (@@FETCH_STATUS = 0)
BEGIN

	INSERT INTO @max_id_table
	EXEC('SELECT MAX(' + @column_name + ') FROM ' + @table_schema + '.' + @table_name);

	SET @max_id = (SELECT id FROM @max_id_table);

	IF(@data_type = 'bigint')
	BEGIN
		IF(@max_id > FLOOR(((9223372036854775807 / 100.0) * @used_warn_level_percent)))
		BEGIN
			PRINT @column_name + '.' + @table_schema + '.' + @table_name + ' max id is greater than warning level: ' + CONVERT(VARCHAR(30), @max_id);
		END
		PRINT @column_name + '.' + @table_schema + '.' + @table_name + ': ' + CONVERT(VARCHAR(30), CAST(@max_id AS FLOAT) / CAST(9223372036854775807 AS FLOAT)) + ' int space used.';
	END
	ELSE IF (@data_type = 'int')
	BEGIN
		IF(@max_id > FLOOR(((2147483647 / 100.0) * @used_warn_level_percent)))
		BEGIN
			PRINT @column_name + '.' + @table_schema + '.' + @table_name + ' max id is greater than warning level: ' + CONVERT(VARCHAR(30), @max_id);
		END
		PRINT @column_name + '.' + @table_schema + '.' + @table_name + ': ' + CONVERT(VARCHAR(30), CAST(@max_id AS FLOAT) / CAST(2147483647 AS FLOAT)) + ' int space used.';
	END
	ELSE IF (@data_type = 'smallint')
	BEGIN
		IF(@max_id > FLOOR(((32767 / 100.0) * @used_warn_level_percent)))
		BEGIN
			PRINT @column_name + '.' + @table_schema + '.' + @table_name + ' max id is greater than warning level: ' + CONVERT(VARCHAR(30), @max_id);
		END
		PRINT @column_name + '.' + @table_schema + '.' + @table_name + ': ' + CONVERT(VARCHAR(30), CAST(@max_id AS FLOAT) / CAST(32767 AS FLOAT)) + ' int space used.';
	END
	ELSE IF (@data_type = 'tinyint')
	BEGIN
		IF(@max_id > FLOOR(((255 / 100.0) * @used_warn_level_percent)))
		BEGIN
			PRINT @column_name + '.' + @table_schema + '.' + @table_name + ' max id is greater than warning level: ' + CONVERT(VARCHAR(30), @max_id);
		END
		PRINT @column_name + '.' + @table_schema + '.' + @table_name + ': ' + CONVERT(VARCHAR(30), CAST(@max_id AS FLOAT) / CAST(255 AS FLOAT)) + ' int space used.';
	END

	FETCH NEXT FROM myCursor INTO @table_schema,
								  @table_name,
								  @column_name,
								  @data_type;

	DELETE FROM @max_id_table;

END;

CLOSE myCursor;
DEALLOCATE myCursor;
```

Now we're ready for testing!

```
CREATE TABLE test_numbers
(
	t_int TINYINT,
	s_int SMALLINT,
	i_int INT,
	b_int BIGINT
);
```

```
-- 100% usage
INSERT INTO test_numbers VALUES (255, 32767, 2147483647, 9223372036854775807);
```

Run the script and we should be warned!

```
t_int.dbo.test_numbers max id is greater than warning level: 255
t_int.dbo.test_numbers: 1 int space used.
s_int.dbo.test_numbers max id is greater than warning level: 32767
s_int.dbo.test_numbers: 1 int space used.
i_int.dbo.test_numbers max id is greater than warning level: 2147483647
i_int.dbo.test_numbers: 1 int space used.
b_int.dbo.test_numbers max id is greater than warning level: 9223372036854775807
b_int.dbo.test_numbers: 1 int space used.
```

```
TRUNCATE TABLE test_numbers;
-- 99% (ish)
INSERT INTO test_numbers VALUES (252, 32439, 2126008810, 9131138316486228048);
```

```
t_int.dbo.test_numbers max id is greater than warning level: 252
t_int.dbo.test_numbers: 0.988235 int space used.
s_int.dbo.test_numbers max id is greater than warning level: 32439
s_int.dbo.test_numbers: 0.98999 int space used.
i_int.dbo.test_numbers max id is greater than warning level: 2126008810
i_int.dbo.test_numbers: 0.99 int space used.
b_int.dbo.test_numbers max id is greater than warning level: 9131138316486228048
b_int.dbo.test_numbers: 0.99 int space used.
```

And finally;

```
TRUNCATE TABLE test_numbers ;
-- 50% (ish)
INSERT INTO test_numbers VALUES (127, 16383, 1073741823, 4611686018427387903);
```

```
t_int.dbo.test_numbers max id is greater than warning level: 127
t_int.dbo.test_numbers: 0.498039 int space used.
s_int.dbo.test_numbers max id is greater than warning level: 16383
s_int.dbo.test_numbers: 0.499985 int space used.
i_int.dbo.test_numbers max id is greater than warning level: 1073741823
i_int.dbo.test_numbers: 0.5 int space used.
b_int.dbo.test_numbers max id is greater than warning level: 4611686018427387903
b_int.dbo.test_numbers: 0.5 int space used.
```

```
-- clean up
DROP TABLE test_numbers;
```
