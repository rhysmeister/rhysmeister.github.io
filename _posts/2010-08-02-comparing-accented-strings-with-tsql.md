---
layout: post
title: Comparing accented strings with TSQL
date: 2010-08-02 21:38:47.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- collations
meta:
  tweetbackscheck: '1613164468'
  shorturls: a:4:{s:9:"permalink";s:74:"http://www.youdidwhatwithtsql.com/comparing-accented-strings-with-tsql/849";s:7:"tinyurl";s:26:"http://tinyurl.com/274ooyc";s:4:"isgd";s:18:"http://is.gd/dYU14";s:5:"bitly";s:20:"http://bit.ly/a8fdRW";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/comparing-accented-strings-with-tsql/849/"
---
Today a colleague was running into some difficulties matching football team names containing accented characters. For example _Olympique Alès_ and _Olympique Ales_ were not matching when he wanted them to. The issue here is all to do with [collations](http://msdn.microsoft.com/en-us/library/ms144260.aspx). We can use the **Latin1\_General\_CI\_AI** collation in our queries to force the comparison to ignore accents (AI stands for _Accent Insensitive_).

```
DECLARE @string1 VARCHAR(30), @string2 VARCHAR(30)

SET @string1 = 'Olympique Alès'; -- With accented e
SET @string2 = 'Olympique Ales'; -- Without accented e

IF @string1 = @string2
BEGIN
	PRINT 'Strings do not match!'; -- This will not print
END

IF @string1 COLLATE Latin1_General_CI_AI = @string2 COLLATE Latin1_General_CI_AI
BEGIN
	PRINT 'Strings match if we use COLLATE Latin1_General_CI_AI!'; -- This will print
END
```

Here’s how it works with GROUP BY.

```
CREATE TABLE dbo.Places
(
	Id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Place VARCHAR(30) NOT NULL
);

-- Insert some test data
INSERT INTO dbo.Places
(
	Place
)
VALUES
(
	'Olympique Alès'
),
(
	'Olympique Ales'
),
(
	'Gazélec Ajaccio'
),
(
	'Gazelec Ajaccio'
);

SELECT Place, COUNT(*)
FROM dbo.Places
GROUP BY Place;
```

[![group by no collate]({{ site.baseurl }}/assets/2010/08/group_by_no_collate_thumb.png "group by no collate")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/08/group_by_no_collate.png)

```
SELECT Place COLLATE Latin1_General_CI_AI, COUNT(*)
FROM dbo.Places
GROUP BY Place COLLATE Latin1_General_CI_AI;
```

[![group by with collate]({{ site.baseurl }}/assets/2010/08/group_by_with_collate_thumb.png "group by with collate")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/08/group_by_with_collate.png)

You can also use this with JOINS.

```
-- No COLLATE
SELECT *
FROM dbo.Places t1
INNER JOIN dbo.Places t2
	ON t1.Place = t2.Place;
```

[![join no collate]({{ site.baseurl }}/assets/2010/08/join_no_collate_thumb.png "join no collate")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/08/join_no_collate.png)

```
-- With COLLATE
SELECT *
FROM dbo.Places t1
INNER JOIN dbo.Places t2
	ON t1.Place COLLATE Latin1_General_CI_AI = t2.Place COLLATE Latin1_General_CI_AI;
```

[![join with collate]({{ site.baseurl }}/assets/2010/08/join_with_collate_thumb.png "join with collate")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/08/join_with_collate.png)

So that’s how you can force strings to match if they contain accented characters. I was using this for a quick data mapping task but be wary of using the COLLATE clause, in any applications or processes, where performance may become an issue.

If you use the COLLATE clause then this will mean the database engine cannot use any index on the referenced column. You could replace the accented characters before inserting them into your database but here’s a solution I prefer using persisted [computed columns](http://www.youdidwhatwithtsql.com/computed-columns-in-sql-server/377).

```
-- Alter Places table. Note we specify the collation
ALTER TABLE dbo.Places ADD CleanPlaceName AS Place COLLATE Latin1_General_CI_AI PERSISTED;
-- Index this column!
CREATE INDEX idx_CleanPlaceName ON dbo.Places (CleanPlaceName);

-- Note accents in CleanPlaceName are preserved
SELECT *
FROM dbo.Places

-- No COLLATE needed!
SELECT CleanPlaceName, COUNT(*)
FROM dbo.Places
GROUP BY CleanPlaceName;
```

[![group by no collate needed]({{ site.baseurl }}/assets/2010/08/group_by_no_collate_needed_thumb.png "group by no collate needed")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/08/group_by_no_collate_needed.png)

```
SELECT *
FROM dbo.Places t1
INNER JOIN dbo.Places t2
	ON t1.CleanPlaceName = t2.CleanPlaceName;
```

[![join no collate needed]({{ site.baseurl }}/assets/2010/08/join_no_collate_needed_thumb.png "join no collate needed")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/08/join_no_collate_needed.png)

This solution removes the need to include the COLLATE clause in your queries and keeps the possibility of using indices open!

