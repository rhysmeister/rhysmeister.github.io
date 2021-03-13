---
layout: post
title: Archiving a Twitter users timeline with Tweet-SQL 3.6
date: 2013-06-30 17:01:37.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Tweet-SQL
tags:
- Tweet-SQL
- twitter
meta:
  _edit_last: '1'
  tweetbackscheck: '1613450170'
  _wp_old_slug: archiving-users-timeline-tweetsql
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:76:"http://www.youdidwhatwithtsql.com/archiving-users-timeline-tweetsql-36/1616/";s:7:"tinyurl";s:26:"http://tinyurl.com/ptwh3w6";s:4:"isgd";s:19:"http://is.gd/mnqE20";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/archiving-users-timeline-tweetsql-36/1616/"
---
Here's a quick update of a post I made [way back in 2008](http://sqlclrnews.blogspot.co.uk/2008/12/archiving-another-twitter-users.html)&nbsp;to archive a users timeline. This script will allow you download the tweets from any unprotected twitter account. Let's get started!

First create the following table in your [Tweet-SQL](http://www.tweet-sql.com "Tweet-SQL Twitter Client SQL Server") database.

```
CREATE TABLE TwitterArchive
(
	created_at NVARCHAR(30),
	id BIGINT PRIMARY KEY CLUSTERED,
	[text] NVARCHAR(140),
	source NVARCHAR(100),
	truncated NVARCHAR(5),
	in_reply_to_status_id BIGINT,
	in_reply_to_user_id BIGINT,
	favorited NVARCHAR(5),
	status_Id BIGINT,
	statuses_Id BIGINT
);
```

Just change **@screen\_name** to the user whose timeline you want to archive and you're good to go.

```
DECLARE @xml XML,
         @handle INT,
         @screen_name NVARCHAR(200),
         @since_id BIGINT,
         @optional NVARCHAR(50),
         @rowcount TINYINT;

  SET @screen_name = 'rhyscampbell';
  SET @since_id = 1;

  -- Turn of resultsets from Tweet-SQL
  EXEC dbo.tweet_cfg_resultset_send 0;

  -- Set the optional parameter to request page 1
  SET @optional = 'count=200&since_id=' + CAST(@since_id AS NVARCHAR(20));
  -- Get page 1 of your timeline
  EXEC dbo.tweet_sts_user_timeline @screen_name, @optional, @xml OUTPUT;
  SET @rowcount = 1;

  WHILE (@rowcount != 0) -- While we still have results to deal with
  BEGIN
      -- Prepare an xml document
      EXEC sp_xml_preparedocument @handle OUTPUT, @xml;

      -- Insert the page into a table
      INSERT INTO dbo.TwitterArchive
      (
          created_at,
          id,
          [text],
          source,
          truncated,
          in_reply_to_status_id,
          in_reply_to_user_id,
          favorited,
          status_Id,
          statuses_Id
      )
      SELECT created_at,
              id,
              [text],
              source,
              truncated,
              in_reply_to_status_id,
              in_reply_to_user_id,
              favorited,
              status_Id,
              statuses_Id
      FROM OPENXML (@handle, '/objects/objects', 2)
      WITH
      (
          created_at NVARCHAR(30),
          id BIGINT,
          [text] NVARCHAR(140),
          source NVARCHAR(100),
          truncated NVARCHAR(5),
          in_reply_to_status_id BIGINT,
          in_reply_to_user_id BIGINT,
          favorited NVARCHAR(5),
          status_Id BIGINT,
          statuses_Id BIGINT
      );

      -- Get the rowcount
      SET @rowcount = @@ROWCOUNT;
      -- destroy the xml document
      EXEC sp_xml_removedocument @handle;
      -- Increment the ssince_id
      SET @since_id = (SELECT MIN(id) FROM dbo.TwitterArchive) -1;
      -- Setup the optional parameter
      SET @optional = 'count=200&max_id=' + CAST(@since_id AS NVARCHAR(20));
      -- Wait for a bit...
      WAITFOR DELAY '00:00:05';
      -- Get the next page
      EXEC dbo.tweet_sts_user_timeline @screen_name, @optional, @xml OUTPUT;
  END
  -- Turn resultsets from Tweet-SQL back on as appropriate
  EXEC dbo.tweet_cfg_resultset_send 1;
```

The twitter API documentation states up to 3200 tweets can be retrieved this way. I got an extra one for free!

[![rhyscampbell_twitter_archive]({{ site.baseurl }}/assets/2013/06/rhyscampbell_twitter_archive.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2013/06/rhyscampbell_twitter_archive.png)

