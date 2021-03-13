---
layout: post
title: Using the Twitter Search API with Tweet-SQL
date: 2009-04-28 19:05:09.000000000 +02:00
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
- Twitter API
- Twitter App
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461866'
  shorturls: a:7:{s:9:"permalink";s:80:"http://www.youdidwhatwithtsql.com/using-the-twitter-search-api-with-tweet-sql/89";s:7:"tinyurl";s:25:"http://tinyurl.com/cw2t88";s:4:"isgd";s:17:"http://is.gd/BqG6";s:5:"bitly";s:19:"http://bit.ly/sqmkg";s:5:"snipr";s:22:"http://snipr.com/id66m";s:5:"snurl";s:22:"http://snurl.com/id66m";s:7:"snipurl";s:24:"http://snipurl.com/id66m";}
  twittercomments: a:1:{i:1850947813;s:7:"retweet";}
  tweetcount: '1'
  _sg_subscribe-to-comments: n.r@usa.net
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/using-the-twitter-search-api-with-tweet-sql/89/"
---
Using the new version of [Tweet-SQL](http://www.tweet-sql.com/) you can consume data from the [Twitter Search API](http://search.twitter.com/api). The data in [Twitter Search](http://search.twitter.com/) is constantly updated with new tweets so anything you grab out of the API is near real-time. To perform a query with [Tweet-SQL](http://www.tweet-sql.com) run the following [T-SQL](http://en.wikipedia.org/wiki/T-SQL);

```
EXEC dbo.tweet_src_search 'MC Frontalot', null, null;
```

Data from [Twitter](http://twitter.com) can be dealt with as an xml resultset, regular resultsets and with [output parameters](http://www.sqlservercentral.com/articles/Stored+Procedures/outputparameters/1200/).

[![Twitter Search Results in Tweet-SQL]({{ site.baseurl }}/assets/2009/04/image-thumb7.png "Twitter Search Results in Tweet-SQL")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/image7.png)

The procedure supports the full range of optional parameters offered by the api. Here’s a few examples;

**lang** - Restricts tweets to the given language, given by an [ISO 639-1 code](http://en.wikipedia.org/wiki/ISO_639-1).

Search for Tweets containing ‘_Paris’_ in the French language only.

```
EXEC dbo.tweet_src_search 'Paris', 'lang=fr', null;
```

[![French tweets containing Paris]({{ site.baseurl }}/assets/2009/04/image-thumb8.png "French tweets containing Paris")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/image8.png)

**rpp** - The number of tweets to return per page, up to a max of 100.

Search for Tweets mentioning “_Swine Flu”_ and return up to 100 results.

```
EXEC dbo.tweet_src_search 'swine flu', 'rpp=100', null;
```

[![Request a maximum number of rows to return with Tweet-SQL]({{ site.baseurl }}/assets/2009/04/image-thumb9.png "Request a maximum number of rows to return with Tweet-SQL")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/image9.png)

**geocode** &nbsp; - Returns tweets by users located within a given radius of the given latitude/longitude, where the user's location is taken.

Search for my favourite [pub in Farringdon](http://www.thecastlefarringdon.co.uk/) by users within 10 miles of [EC1N 8FH](http://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=EC1N+8FH&sll=51.627395,-0.697632&sspn=0.381921,1.227722&ie=UTF8&ll=51.521935,-0.106859&spn=0.011963,0.038366&t=h&z=15&iwloc=A).

```
DECLARE @geocode VARCHAR(100) = 'geocode=51.521935,-0.106859,10mi';
-- Need to url encode the geocode
SET @geocode = dbo.tweet_fnc_urlEncode(@geocode);

EXEC dbo.tweet_src_search 'Castle EC1', @geocode, null;
```

[![Tweet-SQL geocode search]({{ site.baseurl }}/assets/2009/04/image-thumb10.png "Tweet-SQL geocode search")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/image10.png)

These, of course, can be chained together to procedure powerful [Twitter searches](http://search.twitter.com/). The example below will search for tweets containing ‘_Fabric’,_ within 1 mile of [EC1N 8FH](http://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=EC1N+8FH&sll=51.627395,-0.697632&sspn=0.381921,1.227722&ie=UTF8&ll=51.521935,-0.106859&spn=0.011963,0.038366&t=h&z=15&iwloc=A), returning up to 100 results.

```
DECLARE @optional VARCHAR(100),
		@geocode VARCHAR(50) = 'geocode=51.521935,-0.106859,1mi';
-- Need to url encode the geocode
SET @geocode = dbo.tweet_fnc_urlEncode(@geocode);
-- Combine the rpp and geocode parameters in the optional variable
SET @optional = 'rpp=100&' + @geocode;

EXEC dbo.tweet_src_search 'Fabric', @optional, null;
```

Using [Tweet-SQL](http://www.tweet-sql.com) you could;

- Archive Tweets containing certain terms and perform analytics. 
- Monitor [Twitter](http://twitter.com) for mentions of certain terms. 
- Auto-follow people mentioning specific subjects. 

Detailed examples to follow soon.

