---
layout: post
title: Twitter lists with Tweet-SQL 3.6
date: 2013-08-10 10:53:52.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Tweet-SQL
tags:
- Tweet-SQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613389369'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/twitter-lists-tweetsql-36/1651/";s:7:"tinyurl";s:26:"http://tinyurl.com/k552kyj";s:4:"isgd";s:19:"http://is.gd/TrUCNB";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/twitter-lists-tweetsql-36/1651/"
---
Here's a quick post about viewing Twitter lists with [Tweet-SQL](www.tweet-sql.com "Tweet-SQL Twitter app SQL Server") 3.6. First you can view your lists by running;

```
EXEC dbo.tweet_lists_list null, null, null;
```

This will show the lists followed by the authenticating user.

[![Tweet-SQL Lists]({{ site.baseurl }}/assets/2013/08/tweetsql_lists.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2013/08/tweetsql_lists.png)

To work with specific list tweets copy the appropriate **@list\_id** into the script below and execute it.

```
DECLARE @xml XML,
		 @handle INTEGER,
		 @list_id INTEGER,
		 @optional NVARCHAR(50);

  SET @list_id = '17542298';

  -- Turn of resultsets from Tweet-SQL
  EXEC dbo.tweet_cfg_resultset_send 0;

  EXEC dbo.tweet_lists_statuses @list_id, @optional, @xml OUTPUT;

  -- Prepare an xml document
  EXEC sp_xml_preparedocument @handle OUTPUT, @xml;

  SELECT created_at,
		  id,
		  [text],
		  source,
		  truncated,
		  in_reply_to_status_id,
		  in_reply_to_user_id,
		  favorited
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
	  favorited NVARCHAR(5)
  );

  -- destroy the xml document
  EXEC sp_xml_removedocument @handle;

-- Turn resultsets from Tweet-SQL back on as appropriate
EXEC dbo.tweet_cfg_resultset_send 1;
```

This will present the last twenty tweets from the list.

[![Tweet-SQL Twitter List Statuses]({{ site.baseurl }}/assets/2013/08/tweetsql_lists_tweets.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2013/08/tweetsql_lists_tweets.png)

