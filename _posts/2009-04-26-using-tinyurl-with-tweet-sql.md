---
layout: post
title: Using TinyURL with Tweet-SQL
date: 2009-04-26 15:17:19.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Tweet-SQL
tags:
- TinyURL
- Tweet-SQL
- twitter
meta:
  tweetbackscheck: '1613208226'
  twittercomments: a:0:{}
  shorturls: a:7:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/using-tinyurl-with-tweet-sql/77";s:4:"isgd";s:17:"http://is.gd/Bp0l";s:5:"bitly";s:20:"http://bit.ly/105d8s";s:5:"snipr";s:22:"http://snipr.com/icvxy";s:5:"snurl";s:22:"http://snurl.com/icvxy";s:7:"snipurl";s:24:"http://snipurl.com/icvxy";s:7:"tinyurl";s:25:"http://tinyurl.com/csmhuu";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/using-tinyurl-with-tweet-sql/77/"
---
As every post to [Twitter](http://twitter.com) is limited to [140 characters](http://www.140characters.com/2008/11/13/hello-world/) it’s important we are able to squeeze as much as we can out of it. <font color="#000000">To help users of <a href="http://www.tweet-sql.com/" target="_blank">Tweet-SQL</a> with this I’ve integrated <a href="http://tinyurl.com/" target="_blank">TinyURL</a> into <a href="http://www.tweet-sql.com/download.php" target="_blank">version 2</a> of the product. Here’s how you use it;</font>

```
DECLARE @long_url NVARCHAR(1000),
	@short_url NVARCHAR(100);

SET @long_url = 'http://rover.ebay.com/rover/1/711-53200-19255-0/1?type=3&campid=5336224516&toolid=10001&customid=tiny-hp&ext=unicycle&satitle=unicycle';

-- Make the long url short!
EXEC dbo.tweet_util_shortenUrl @long_url, @short_url OUTPUT;

SELECT @short_url AS TinyURL;
```

[![Using TinyURL with Tweet-SQL]({{ site.baseurl }}/assets/2009/04/image-thumb6.png "Using TinyURL with Tweet-SQL")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/image6.png)

