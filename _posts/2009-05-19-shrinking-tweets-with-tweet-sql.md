---
layout: post
title: Shrinking Tweets with Tweet-SQL
date: 2009-05-19 20:24:23.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Tweet-SQL
tags:
- Tweet-SQL
- TweetShrink
- twitter
- Twitter API
- Twitter App
meta:
  tweetbackscheck: '1613461161'
  shorturls: a:7:{s:9:"permalink";s:69:"http://www.youdidwhatwithtsql.com/shrinking-tweets-with-tweet-sql/105";s:7:"tinyurl";s:25:"http://tinyurl.com/ksr3cq";s:4:"isgd";s:17:"http://is.gd/IPvT";s:5:"bitly";s:19:"http://bit.ly/CM8Hk";s:5:"snipr";s:22:"http://snipr.com/j00r2";s:5:"snurl";s:22:"http://snurl.com/j00r2";s:7:"snipurl";s:24:"http://snipurl.com/j00r2";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/shrinking-tweets-with-tweet-sql/105/"
---
To get your point across on [Twitter](http://twitter.com) you sometimes have to try and shorten your tweets. This can be a pain for anyone over 30 who doesn’t know [txtspk](http://en.wikipedia.org/wiki/SMS_language). Thankfully some clever chap has come to the rescue with [TweetShrink](http://tweetshrink.com) and I’ve integrated it into [Tweet-SQL](http://tweet-sql.com). Here’s how you use it;

```
DECLARE @shrunk VARCHAR(140),
		@shaved INT;

EXEC dbo.tweet_util_tweetShrink 'For some strange reason I have developed a tendency to think every new version of Windows is more of a resource pig.', @shrunk OUTPUT, @shaved OUTPUT;

-- The shortened Tweet
SELECT @shrunk AS shrunkTweet;
-- How may characters have been shaved off?
SELECT @shaved AS shaved;
```

[![Using TweetShrink in Tweet-SQL]({{ site.baseurl }}/assets/2009/05/image-thumb3.png "Using TweetShrink in Tweet-SQL")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/05/image3.png)

A future version of [Tweet-SQL](http://www.tweet-sql.com) will include this functionality along with a few more cool surprises.

