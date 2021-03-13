---
layout: post
title: Deleting sequential duplicates with TSQL
date: 2010-09-01 18:02:42.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- duplicates
- SQL Server
- T-SQL
- TSQL
meta:
  tweetbackscheck: '1613479361'
  shorturls: a:4:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/deleting-sequential-duplicates-with-tsql/869";s:7:"tinyurl";s:26:"http://tinyurl.com/39hhh4j";s:4:"isgd";s:18:"http://is.gd/ePAVZ";s:5:"bitly";s:20:"http://bit.ly/asPMOV";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/deleting-sequential-duplicates-with-tsql/869/"
---
I was recently given a du-duping task which was much more difficult than I anticipated and taxed my SQL brain to its limits. I thought of using a [CTE](http://msdn.microsoft.com/en-us/library/ms190766.aspx) to do this but all of the examples I could find for [deleting records with a CTE](http://blog.sqlauthority.com/2009/06/23/sql-server-2005-2008-delete-duplicate-rows/) wouldn’t have worked in my situation.

Essentially the table had a business key consisting of 3 parts. Each record would also come with two values attached. The current system pumped data into this fairly regularly and we only wanted to keep values that were not sequentially duplicated. By “sequentially duplicated” I mean an insert into a feed table has the same values attached as the previously inserted record for the same business key. For example, assuming a single key, the below table illustrates the input sequence and the desired de-dupe result.

| **sequence** | **de-duped** |
| 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 | 1 |
| 1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1 | 1,2,1 |
| 1,2,3,4,5,4,3,2,1 | 1,2,3,4,5,4,3,2,1 |

Now for a SQL example;

```
-- Create a test table
CREATE TABLE dbo.TestDupes
(
	Id INTEGER NOT NULL PRIMARY KEY CLUSTERED IDENTITY(1,1),
	KeyPart1 INTEGER NOT NULL,
	KeyPart2 INTEGER NOT NULL,
	KeyPart3 INTEGER NOT NULL,
	value1 FLOAT NOT NULL,
	value2 FLOAT NOT NULL
);
GO

-- Insert some test data
INSERT INTO dbo.TestDupes
(
	KeyPart1,
	KeyPart2,
	KeyPart3,
	value1,
	value2
)
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 5.5, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 5.5, 2.5
UNION ALL
SELECT 1, 2, 3, 5.5, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5;
GO
```

The records considered to be duplicates are outlined in red in the image below.

[![sequential dupes]({{ site.baseurl }}/assets/2010/09/sequential_dupes_thumb.png "sequential dupes")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/09/sequential_dupes.png)

A sequentially de-duped dataset would look like below.

[![no sequential dupes]({{ site.baseurl }}/assets/2010/09/no_sequential_dupes_thumb.png "no sequential dupes")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/09/no_sequential_dupes.png)

The solution I came up with, after much head-scratching, involved the use of the [DENSE\_RANK](http://msdn.microsoft.com/en-us/library/ms173825.aspx) & [ROW\_NUMBER](http://msdn.microsoft.com/en-us/library/ms186734.aspx) functions combined with a [Common Table Expression](http://msdn.microsoft.com/en-us/library/ms190766.aspx). The DENSE\_RANK function organises each business key (KeyPart1, KeyPart2, KeyPart3) into groups. The ROW\_NUMBER function gives us a sequence number for each record within the group. This is best illustrated with a select statement with another group thrown in for good measure.

```
TRUNCATE TABLE dbo.TestDupes;
-- Insert some test data
INSERT INTO dbo.TestDupes
(
	KeyPart1,
	KeyPart2,
	KeyPart3,
	value1,
	value2
)
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 5.5, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 5.5, 2.5
UNION ALL
SELECT 1, 2, 3, 5.5, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
SELECT 1, 2, 3, 2.0, 2.5
UNION ALL
-- Group 2
SELECT 2, 2, 3, 2.0, 2.5
UNION ALL
SELECT 2, 2, 3, 2.0, 2.5
UNION ALL
SELECT 2, 2, 3, 2.0, 2.5
UNION ALL
SELECT 2, 2, 3, 5.5, 2.5
UNION ALL
SELECT 2, 2, 3, 2.0, 2.5
UNION ALL
SELECT 2, 2, 3, 5.5, 2.5
UNION ALL
SELECT 2, 2, 3, 5.5, 2.5
UNION ALL
SELECT 2, 2, 3, 2.0, 2.5
UNION ALL
SELECT 2, 2, 3, 2.0, 2.5
UNION ALL
SELECT 2, 2, 3, 2.0, 2.5;
GO

WITH Dupe_CTE (
			Id,
			KeyPart1,
			KeyPart2,
			KeyPart3,
			value1,
			value2,
			group_num,
			group_row_num
		)
AS
(
	SELECT Id,
	       KeyPart1,
	       KeyPart2,
	       KeyPart3,
	       value1,
	       value2,
               DENSE_RANK() OVER(ORDER BY KeyPart1, KeyPart2, KeyPart3),
               ROW_NUMBER() OVER(PARTITION BY KeyPart1,
                                          KeyPart2,
                                          KeyPart3
                                 ORDER BY Id)
        FROM dbo.TestDupes
)
SELECT *
FROM Dupe_CTE;
```

Here you can see the data is organised into groups and each row, within the group, is numbered according to it's position.

[![duplicates organise into groups with DENSE_RANK]({{ site.baseurl }}/assets/2010/09/feed_dupes_two_sets_thumb.png "duplicates organise into groups with DENSE\_RANK")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/09/feed_dupes_two_sets.png)

Using this information about each group we can execute a delete. The delete self-joins to the CTE comparing the values for value1 and value2.

```
WITH Dupe_CTE (
			Id,
			KeyPart1,
			KeyPart2,
			KeyPart3,
			value1,
			value2,
			group_num,
			group_row_num
		)
AS
(
	SELECT Id,
		   KeyPart1,
		   KeyPart2,
		   KeyPart3,
		   value1,
		   value2,
           DENSE_RANK() OVER(ORDER BY KeyPart1, KeyPart2, KeyPart3),
           ROW_NUMBER() OVER(PARTITION BY KeyPart1,
                                          KeyPart2,
                                          KeyPart3
                             ORDER BY Id)
           FROM dbo.TestDupes
)
DELETE fg2
FROM Dupe_CTE fg1
INNER JOIN Dupe_CTE fg2
                ON fg1.Group_Num = fg2.Group_Num
                AND fg1.value1 = fg2.value1
                AND fg1.value2 = fg2.value2
WHERE fg1.group_row_num = fg2.group_row_num - 1;
```

This will remove any duplicates, keeping the oldest record in each case, giving us a clean dataset.

[![cleaned up group duplicates]({{ site.baseurl }}/assets/2010/09/cleaned_up_group_duplicates_thumb.png "cleaned up group duplicates")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/09/cleaned_up_group_duplicates.png)

Can anyone think of a ~~CURSOR~~ better way of doing this?

