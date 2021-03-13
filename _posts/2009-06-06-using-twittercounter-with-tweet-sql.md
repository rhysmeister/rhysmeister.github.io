---
layout: post
title: Using TwitterCounter with Tweet-SQL
date: 2009-06-06 15:10:46.000000000 +02:00
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
- Twitter API
- Twitter App
- TwitterCounter
meta:
  tweetbackscheck: '1613461378'
  shorturls: a:7:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/using-twittercounter-with-tweet-sql/165";s:7:"tinyurl";s:25:"http://tinyurl.com/l8vz6m";s:4:"isgd";s:18:"http://is.gd/16fQZ";s:5:"bitly";s:19:"http://bit.ly/r9kON";s:5:"snipr";s:22:"http://snipr.com/kfvvj";s:5:"snurl";s:22:"http://snurl.com/kfvvj";s:7:"snipurl";s:24:"http://snipurl.com/kfvvj";}
  twittercomments: a:1:{s:10:"6209384101";s:3:"117";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/using-twittercounter-with-tweet-sql/165/"
---
[TwitterCounter](http://twittercounter.com/) is a service that provides [Twitter](http://twitter.com) user statistics. In their own words; _“The TwitterCounter API allows you to retrieve everything TwitterCounter knows about a certain Twitter username.”_ [TwitterCounter](http://twittercounter.com) basically provides statistics on followers and predictions on growth. The next version of [Tweet-SQL](http://www.tweet-sql.com/) will include a procedure to work with this data. Here’s how you use it;

```
DECLARE @username VARCHAR(30);
-- Set Twitter username
SET @username = 'rhyscampbell';
-- Execute the procedure
EXEC dbo.tweet_util_twitterCounter @username, null, null;
```

[![Tweet-SQL results from TwitterCounter]({{ site.baseurl }}/assets/2009/06/image-thumb8.png "Tweet-SQL results from TwitterCounter")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image8.png)

Here’s the raw xml that is accessible by using OUTPUT parameters.

```
<twittercounter>
  <user_id>297689</user_id>
  <user_name>rhyscampbell</user_name>
  <followers_current>255</followers_current>
  <date_updated>2009-06-06</date_updated>
  <url>http://www.youdidwhatwithtsql.com</url>
  <avatar>70800065/n571986135_2362730_9166_normal.jpg</avatar>
  <follow_days>253</follow_days>
  <started_followers>18</started_followers>
  <growth_since>237</growth_since>
  <average_growth>1</average_growth>
  <tomorrow>256</tomorrow>
  <next_month>285</next_month>
  <followers_yesterday>258</followers_yesterday>
  <rank>90877</rank>
  <followers_2w_ago>18</followers_2w_ago>
  <growth_since_2w>237</growth_since_2w>
  <average_growth_2w>17</average_growth_2w>
  <tomorrow_2w>272</tomorrow_2w>
  <next_month_2w>765</next_month_2w>
  <followersperdate>
    <date2009-05-11>227</date2009-05-11>
    <date2009-05-12>227</date2009-05-12>
    <date2009-05-15>230</date2009-05-15>
    <date2009-05-17>230</date2009-05-17>
    <date2009-05-20>232</date2009-05-20>
    <date2009-05-22>239</date2009-05-22>
    <date2009-05-24>241</date2009-05-24>
    <date2009-05-26>249</date2009-05-26>
    <date2009-05-29>248</date2009-05-29>
    <date2009-05-31>250</date2009-05-31>
    <date2009-06-02>248</date2009-06-02>
    <date2009-06-04>258</date2009-06-04>
    <date2009-06-06>255</date2009-06-06>
  </followersperdate>
</twittercounter>
```
