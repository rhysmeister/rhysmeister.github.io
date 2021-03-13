---
layout: post
title: 'Tweet-SQL: Storing searches in a table'
date: 2010-10-23 16:05:28.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Software
- Tweet-SQL
tags:
- Tweet-SQL
- Twitter search
meta:
  tweetbackscheck: '1613461486'
  shorturls: a:4:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/tweet-sql-storing-searches-in-a-table/888";s:7:"tinyurl";s:26:"http://tinyurl.com/2czekov";s:4:"isgd";s:18:"http://is.gd/gekYP";s:5:"bitly";s:20:"http://bit.ly/9Ovm3H";}
  twittercomments: a:1:{s:16:"1820025535070208";s:7:"retweet";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tweet-sql-storing-searches-in-a-table/888/"
---
A [Tweet-SQL](http://www.tweet-sql.com) user emailed me recently about how to store results from the tweet\_src\_search procedure in a table. [Twitter](http://twitter.com) returns an [atom](http://search.cpan.org/~miyagawa/XML-Atom-0.37/lib/XML/Atom.pm) feed for search requests so you have to handle this slightly differently compared to other [Tweet-SQL](http://www.tweet-sql.com) procedures.

Here’s a quick walk-through of how we can get Twitter search results into a database table using [Tweet-SQL](http://www.tweet-sql.com). First create a table to hold the tweets.

```
CREATE TABLE dbo.TwitterSearchResults
(
	Id INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
	twitter_id VARCHAR(100),
	published VARCHAR(30),
	title VARCHAR(160),
	content VARCHAR(160),
	updated VARCHAR(30),
	author_name VARCHAR(50),
	uri VARCHAR(100),
	keyword_searched VARCHAR(100)
);
```

Now we can run the below script to use [Tweet-SQL](http://www.tweet-sql.com) to store twitter search results in the above table. Just change the value set for **@keyword**.

```
DECLARE @xml XML,
        @handle INT,
        @keyword VARCHAR(100);

-- Set keyword to search for
SET @keyword = 'Obama'

-- Turn off resultset from Tweet-SQL
EXEC dbo.tweet_cfg_resultset_send 0;

-- Peform a twitter search
EXEC dbo.tweet_src_search @keyword, null, @xml OUTPUT;

-- Prepare an xml document
EXEC sp_xml_preparedocument @handle OUTPUT, @xml, '<root xmlns:a="http://www.w3.org/2005/Atom"></root>';

INSERT INTO dbo.TwitterSearchResults
(
	twitter_id,
	published,
	title,
	content,
	updated,
	author_name,
	uri,
	keyword_searched
)
SELECT [a:id],
	   [a:published],
	   [a:title],
	   [a:content],
	   [a:updated],
	   [author_name],
	   [uri],
	   @keyword -- Store the keyword associated with this search
FROM OPENXML (@handle, '//a:feed/a:entry', 2) -- Path to tweets in the xml docs
WITH
(
	[a:id] VARCHAR(160),
	[a:published] VARCHAR(160),
	[a:title] VARCHAR(160),
	[a:content] VARCHAR(160),
	[a:updated] VARCHAR(160),
	author_name VARCHAR(100) 'a:author/a:name', -- Query further down the xml doc to get author info
	uri VARCHAR(100) 'a:author/a:uri'
 );

-- Clean up
EXECUTE sp_xml_removedocument @handle;

-- Turn on resultset from Tweet-SQL
EXEC dbo.tweet_cfg_resultset_send 1;
```

Now the TwitterSearchResults table should contain and bunch of tweets.

```
SELECT *
FROM dbo.TwitterSearchResults;
```

[![tweet-sql twitter search results]({{ site.baseurl }}/assets/2010/10/tweetsql_twitter_search_results_thumb.png "tweet-sql twitter search results")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/10/tweetsql_twitter_search_results.png)

Get yourself a copy of [Tweet-SQL](http://www.tweet-sql.com/dl.php) and try this out now!

