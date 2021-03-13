---
layout: post
title: Creating a sqlserverpedia list with Tweet-SQL
date: 2010-07-24 17:24:20.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Software
- Tweet-SQL
tags: []
meta:
  tweetbackscheck: '1613462016'
  twittercomments: a:1:{s:11:"19651499073";s:7:"retweet";}
  shorturls: a:4:{s:9:"permalink";s:83:"http://www.youdidwhatwithtsql.com/creating-a-sqlserverpedia-list-with-tweet-sql/835";s:7:"tinyurl";s:26:"http://tinyurl.com/2bzuq2p";s:4:"isgd";s:18:"http://is.gd/dEDEA";s:5:"bitly";s:20:"http://bit.ly/bSKUB9";}
  tweetcount: '1'
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/creating-a-sqlserverpedia-list-with-tweet-sql/835/"
---
Many moons ago I posted an article illustrating how to befriend twitter users on the [sqlserverpedia list](http://sqlclrnews.blogspot.com/2009/01/befriend-twitter-users-on.html) with [Tweet-SQL](http://www.tweet-sql.com). Since [Twitter](http://twitter.com) have added various list methods to their [API](http://apiwiki.twitter.com/Twitter-API-Documentation) I thought it would be fun to rehash this post to create a list with [Tweet-SQL](http://www.tweet-sql.com).

First copy the list of users from the [sqlserverpedia page](http://sqlserverpedia.com/wiki/Twitter).

[![copy sqlserverpedia list]({{ site.baseurl }}/assets/2010/07/copy_sqlserverpedia_list_thumb.png "copy sqlserverpedia list")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/07/copy_sqlserverpedia_list.png)

Paste this into Excel and you should get something looking like below.

[![sqlserverpedia_excel_list]({{ site.baseurl }}/assets/2010/07/sqlserverpedia_excel_list_thumb.png "sqlserverpedia\_excel\_list")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/07/sqlserverpedia_excel_list.png)

Remove the section titles, empty rows and any text after the url so we are just left with a list of Twitter profile pages.

[![sqlserverpedia users in excel]({{ site.baseurl }}/assets/2010/07/excel_sqlserverpedia_users_thumb.png "sqlserverpedia users in excel")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/07/excel_sqlserverpedia_users.png)

Next we need to extract the Twitter username from the url. This little bit of Excel wizardry should do it.

```
=MID(A1,SEARCH("http://twitter.com/",A1)+19, LEN(A1) - 19)
```

[![excel_ formula to extract sqlserverpedia list]({{ site.baseurl }}/assets/2010/07/excel__formula_sqlserverpedia_thumb.png "excel\_ formula to extract sqlserverpedia list")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/07/excel__formula_sqlserverpedia.png)

This formula may break as the page changes in the future so watch out for this. Review the list and remove any invalid values. At the time of writing there’s one of the list that doesn’t contain a twitter url. Save this as a csv and then import it into a database containing the [Tweet-SQL Procedures](http://www.tweet-sql.com/features.php). I’ve uploaded a copy of the file I produced today [here](http://www.tweet-sql.com/files/sqlserverpedia_users_20100724.csv). This file contains 261 Twitter users. I used the below table structure.

```
USE [TweetSQLV3]
GO

/******Object: Table [dbo].[sqlserverpedia] Script Date: 07/24/2010 16:16:24******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[sqlserverpedia](
	[url] [varchar](255) NULL,
	[tweep] [varchar](255) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
```

There’s a few dupes in the below list, because people are listed in multiple sections, so run the below TSQL script to de-duplicate it.

```
ALTER TABLE dbo.sqlserverpedia ADD Id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY;
GO

DELETE t1
FROM dbo.sqlserverpedia AS t1
INNER JOIN dbo.sqlserverpedia AS t2
	ON t1.tweep = t2.tweep
WHERE t1.id < t2.id;

-- Additional column we'll use later
ALTER TABLE dbo.sqlserverpedia ADD done BIT DEFAULT 0;
```

Next we’ll need to create the list. The below TSQL will do this (for SQL 2008). Make a note of the list id as we’ll need this later.

```
DECLARE @list_name VARCHAR(30) = 'sqlserverpedia list';
-- Turn on relational resultsets in Tweet-SQL
EXEC dbo.tweet_cfg_resultset_send 1;
-- Create the list
EXEC dbo.tweet_list_post_lists @list_name, 'public', null;
```

[![Tweet-SQL twitter list created]({{ site.baseurl }}/assets/2010/07/tweetsql_twitter_list_created_thumb.png "Tweet-SQL twitter list created")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/07/tweetsql_twitter_list_created.png)

Next we’ll add the users onto this list. After each record is added to the Twitter list it is flagged as done so you can simply re-run the script if something fails halfway through.

```
DECLARE @tweep VARCHAR(30), @list_id INTEGER;

-- Set your list id here
SET @list_id = 17542298;

-- Turn off resultsets in Tweet-SQL
EXEC dbo.tweet_cfg_resultset_send 0;

DECLARE tweeps CURSOR LOCAL FAST_FORWARD FOR SELECT tweep
					 FROM dbo.sqlserverpedia
					 WHERE done IS NULL;

-- Open the cursor and get the first result
OPEN tweeps;
FETCH NEXT FROM tweeps INTO @tweep;

WHILE(@@FETCH_STATUS = 0)
BEGIN

	-- Add the tweep to the list
	EXEC dbo.tweet_list_post_list_members @list_id, @tweep, null;
	-- Flag the current record as done
	UPDATE dbo.sqlserverpedia
	SET done = 1
	WHERE tweep = @tweep;
	-- Wait for a bit so we don't annoy twitter
	WAITFOR DELAY '00:00:05'
	-- Fetch the next row
	FETCH NEXT FROM tweeps INTO @tweep;

END

-- Clean up
DEALLOCATE tweeps;
-- Turn Tweet-SQL resultsets back on
EXEC dbo.tweet_cfg_resultset_send 1;
```

See my finished list [here](http://twitter.com/rhyscampbell/sqlserverpedia-list) and follow [me on twitter](http://twitter.com/rhyscampbell) for more TSQL tomfoolery!

