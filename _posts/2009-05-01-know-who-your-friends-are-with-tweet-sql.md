---
layout: post
title: Know who your friends are with Tweet-SQL
date: 2009-05-01 12:49:43.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Tweet-SQL
tags:
- T-SQL
- Tweet-SQL
- twitter
- Twitter API
meta:
  tweetbackscheck: '1613461608'
  shorturls: a:7:{s:9:"permalink";s:77:"http://www.youdidwhatwithtsql.com/know-who-your-friends-are-with-tweet-sql/96";s:4:"isgd";s:17:"http://is.gd/C94u";s:5:"bitly";s:19:"http://bit.ly/ms2sG";s:5:"snipr";s:22:"http://snipr.com/iigmt";s:5:"snurl";s:22:"http://snurl.com/iigmt";s:7:"snipurl";s:24:"http://snipurl.com/iigmt";s:7:"tinyurl";s:25:"http://tinyurl.com/d736fr";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/know-who-your-friends-are-with-tweet-sql/96/"
---
[Tweet-SQL](http://www.tweet-sql.com) version 2 supports the new [Twitter](http://twitter.com) social graph [API methods](http://apiwiki.twitter.com/Twitter-API-Documentation). These are two very simple methods to get all of your followers, or friends, Twitter user ids. There are four procedures in [Tweet-SQL](http://www.tweet-sql.com/) that support these methods.

- tweet\_sog\_followers - Returns the ids of the authenticating users followers or, if a non-null value is supplied for @user\_id\_or\_nick, the ids of the specified user’s followers. 
- tweet\_sog\_friends - Returns the ids of the authenticating users friends or, if a non-null value is supplied for @user\_id\_or\_nick, the ids of the specified user’s friends. 
- tweet\_sog\_followersTable - Returns the same data from tweet\_sog\_followers but saves it to a table in the SQL Server database Tweet-SQL is hosted in. The table created is called tweet\_followersIds. Any existing table with this name is dropped at the start of the procedure execution. 
- tweet\_sog\_friendsTable - Returns the same data from tweet\_sog\_friends but saves it to a table in the SQL Server database Tweet-SQL is hosted in. The table created is called tweet\_friendsIds. Any existing table with this name is dropped at the start of the procedure execution. 

[Twitter](http://twitter.com) added these [new methods](http://groups.google.com/group/twitter-development-talk/browse_thread/thread/98f4c4d13954e8bf/b32f96fb0f73a7ae?lnk=gst&q=social+graph#b32f96fb0f73a7ae) to help out application developers that were finding the API limits too restrictive.

Executing the below [T-SQL](http://en.wikipedia.org/wiki/T-SQL) will fetch all the ids of the people you follow;

```
-- The ids of who you follow
EXEC dbo.tweet_sog_friendsTable null;
```

A new table will be created in the same database.

```
SELECT * FROM tweet_friendsIds;
```

[![image]({{ site.baseurl }}/assets/2009/05/image-thumb.png "image")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/05/image.png)

Getting the list of ids for the [Twitter](http://twitter.com) users is just as easy;

```
-- The ids of all your followers
EXEC dbo.tweet_sog_followersTable null;
```

This data can be found in a table called tweet\_followersTable

```
SELECT * FROM tweet_followersIds;
```

[![image]({{ site.baseurl }}/assets/2009/05/image-thumb1.png "image")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/05/image1.png)

Now we have this data it’s easy to find out the users we’re not following back.

```
-- People you're not following back
SELECT *
FROM dbo.tweet_followersIds
EXCEPT
SELECT *
FROM dbo.tweet_friendsIds;
```

People you follow and who follow you back.

```
-- Twitter buddies! You guys should have a beer!
SELECT *
FROM dbo.tweet_followersIds
INTERSECT
SELECT *
FROM dbo.tweet_friendsIds
```

and people who don't follow you back...

```
-- Who's not following you back?
SELECT *
FROM dbo.tweet_friendsIds
EXCEPT
SELECT *
FROM dbo.tweet_followersIds;
```

If you really must know the names, of the people who aren't following back, then run this [T-SQL](http://en.wikipedia.org/wiki/T-SQL) script. Just don’t react like [Mark Corrigan](http://en.wikipedia.org/wiki/Mark_Corrigan) would.

```
-- Really need to know the names of the
-- people who aren't following you back?

-- Insert the people who aren't following
-- you into a new table called NoFollows
SELECT *
INTO NoFollows
FROM dbo.tweet_friendsIds
EXCEPT
SELECT *
FROM dbo.tweet_followersIds;

-- Add PK
ALTER TABLE NoFollows ADD CONSTRAINT
	pk_id PRIMARY KEY CLUSTERED
	(
		Id
	)
	ON [PRIMARY];

-- Add a column to hold Twitter name & screen name
ALTER TABLE NoFollows ADD name VARCHAR(50), screen_name VARCHAR(50);

-- Create a cursor to cycle through the users
DECLARE twitterCursor CURSOR STATIC FOR SELECT Id
					FROM dbo.NoFollows
					WHERE name IS NULL;

DECLARE @id INT, @name VARCHAR(50), @screen_name VARCHAR(50),
	@xml XML, @handle INT;

-- Turn of resultsets from Tweet-SQL
EXEC dbo.tweet_cfg_resultset_send 0;

-- Open the cursor and get the first result
OPEN twitterCursor;
FETCH NEXT FROM twitterCursor INTO @Id;

-- Loop!
WHILE (@@FETCH_STATUS = 0)
BEGIN

	-- Get the user information
	EXEC dbo.tweet_usr_show @Id, null, @xml OUTPUT;
	-- Prepare an xml document
	EXEC sp_xml_preparedocument @handle OUTPUT, @xml;

	SELECT @name = name,
		   @screen_name = screen_name
	FROM OPENXML (@handle, '/user', 2)
	WITH
	(
		name VARCHAR(50),
		screen_name VARCHAR(50)
	);

	-- Update the table with the retrieved details
	UPDATE dbo.NoFollows
	SET name = @name,
	screen_name = @screen_name
	WHERE Id = @id;

	-- destroy the xml document
	EXEC sp_xml_removedocument @handle;

	-- Get the next row
	FETCH NEXT FROM twitterCursor INTO @Id;

	-- Be nice to Twitter Servers!
	WAITFOR DELAY '00:00:05';

END -- EOF While Loop

-- Clean up!
CLOSE twitterCursor;
DEALLOCATE twitterCursor;
-- Turn resultsets from Tweet-SQL back on as appropriate
EXEC dbo.tweet_cfg_resultset_send 1;
```

```
SELECT *
FROM dbo.NoFollows;
```
