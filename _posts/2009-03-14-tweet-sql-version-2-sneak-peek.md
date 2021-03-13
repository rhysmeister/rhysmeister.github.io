---
layout: post
title: Tweet-SQL Version 2 Sneak Peek
date: 2009-03-14 14:14:52.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Tweet-SQL
tags:
- CLR
- SQL Server
- Tweet-SQL
- Twitter API
- Twitter App
meta:
  tweetbackscheck: '1613460991'
  shorturls: a:7:{s:9:"permalink";s:67:"http://www.youdidwhatwithtsql.com/tweet-sql-version-2-sneak-peek/45";s:7:"tinyurl";s:25:"http://tinyurl.com/cewdfk";s:4:"isgd";s:17:"http://is.gd/sBRq";s:5:"bitly";s:20:"http://bit.ly/14WB6m";s:5:"snipr";s:22:"http://snipr.com/fykod";s:5:"snurl";s:22:"http://snurl.com/fykod";s:7:"snipurl";s:24:"http://snipurl.com/fykod";}
  twittercomments: a:14:{i:1331305648;s:7:"retweet";i:1529170075;s:7:"retweet";i:1527163917;s:7:"retweet";i:1527135648;s:7:"retweet";s:17:"37302458611007488";s:7:"retweet";s:17:"37256128345817088";s:7:"retweet";s:17:"37253367688331264";s:7:"retweet";s:17:"37253152864477184";s:7:"retweet";s:17:"37252605256138753";s:7:"retweet";s:17:"37249244448559104";s:7:"retweet";s:17:"37210362017218561";s:7:"retweet";s:17:"37209863234781184";s:7:"retweet";s:17:"37205278415917056";s:7:"retweet";s:17:"37179186581864448";s:7:"retweet";}
  tweetcount: '16'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tweet-sql-version-2-sneak-peek/45/"
---
[Tweet-SQL](http://www.tweet-sql.com) is a Twitter Client for Microsoft SQL Server 2005 and above allowing you to interact with the [Twitter API](apiwiki.twitter.com) with standard T-SQL. The forthcoming version 2 of [Tweet-SQL](http://www.tweet-sql.com) contains a host of new features and improvements. Here’s a sneak peek at what is coming in [Tweet-SQL](http://www.tweet-sql.com) V2;

- New procedure allowing the use of the [Twitter Search API](apiwiki.twitter.com/Search+API+Documentatio).
```
DECLARE @query NVARCHAR(100);
SET @query = 'Tweet-SQL';

EXEC dbo.tweet_src_search @query, null, null;
```

[![Tweet-SQL showing Twitter Search API Results]({{ site.baseurl }}/assets/2009/03/image-thumb.png "Tweet-SQL showing Twitter Search API Results")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/03/image.png)&nbsp;

- New procedures allowing profile modification. 

```
EXEC dbo.tweet_acc_update_profile @name,
				  @email,
				  @profile_url,
				  @location,
				  @description,
				  null;
EXEC tweet_acc_update_profile_colors @profile_background_color,
				     @profile_text_color,
				     @profile_link_color,
				     @profile_sidebar_fill,
				     @profile_sidebar_border_color,
				     null;
```

- Four new procedures implementing the new [Social Graph](http://apiwiki.twitter.com/REST+API+Documentation#SocialGraphMethods) API methods either returning data to the user or replicating the data to local tables. 

```
-- Follower ids for the authenticating user
EXEC dbo.tweet_sog_followers null, null;
-- Same as above but copies data to a local table
EXEC dbo.tweet_sog_followersTable null;
-- Friend ids for the authenticating user
EXEC dbo.tweet_sog_friends null, null;
-- Same as above but copies data to a local table
EXEC dbo.tweet_sog_friendsTable;
```

- New procedure to shorten urls with [TinyURL](http://tinyurl.com). 

[![Shorten URLs with Tweet-SQL]({{ site.baseurl }}/assets/2009/03/image-thumb1.png "Shorten URLs with Tweet-SQL")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/03/image1.png)

- New function tweet\_fnc\_httpformat allowing easier work with datetime values. 

[![HTTP dates with Tweet-SQL]({{ site.baseurl }}/assets/2009/03/image-thumb2.png "HTTP dates with Tweet-SQL")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/03/image2.png)

There’s even more to come in version 2 that will compliment the [existing features](http://www.tweet-sql.com/features.php) of Tweet-SQL. There’s a feature freeze in place at the moment but what would you like to see in future versions of [Tweet-SQL](http://www.tweet-sql.com)?

