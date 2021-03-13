---
layout: post
title: Ping-SQL Sneak Peek
date: 2009-03-13 19:16:20.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ping-SQL
tags:
- ".Net"
- api
- CLR
- Ping-SQL
- ping.fm
- SQL Server
- sql server 2005
meta:
  tweetbackscheck: '1613387874'
  shorturls: a:7:{s:9:"permalink";s:56:"http://www.youdidwhatwithtsql.com/ping-sql-sneak-peek/38";s:7:"tinyurl";s:25:"http://tinyurl.com/afxcve";s:4:"isgd";s:17:"http://is.gd/rgl7";s:5:"bitly";s:19:"http://bit.ly/JFrfC";s:5:"snipr";s:22:"http://snipr.com/ffp6z";s:5:"snurl";s:22:"http://snurl.com/ffp6z";s:7:"snipurl";s:24:"http://snipurl.com/ffp6z";}
  twittercomments: a:25:{i:1323597408;s:7:"retweet";s:10:"2621903930";s:7:"retweet";s:10:"2599577174";s:7:"retweet";s:10:"2599555247";s:7:"retweet";s:10:"2599460989";s:7:"retweet";s:10:"2599371837";s:7:"retweet";s:10:"2575455695";s:7:"retweet";s:10:"2557103399";s:7:"retweet";s:10:"2538255456";s:7:"retweet";s:10:"2538247517";s:7:"retweet";s:10:"2538185486";s:7:"retweet";s:10:"2537479499";s:7:"retweet";s:10:"2535928745";s:7:"retweet";s:10:"2535317257";s:7:"retweet";s:10:"2533215523";s:7:"retweet";s:10:"2532685702";s:7:"retweet";s:10:"2532663573";s:7:"retweet";s:10:"2532281255";s:7:"retweet";s:10:"2532181845";s:7:"retweet";s:10:"2532181760";s:7:"retweet";s:10:"2531675294";s:7:"retweet";s:10:"2524976201";s:7:"retweet";s:10:"2621805735";s:7:"retweet";s:10:"2614127848";s:7:"retweet";s:10:"4839454358";s:7:"retweet";}
  tweetcount: '26'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ping-sql-sneak-peek/38/"
---
[Ping-SQL](http://ping-sql.com/) allows you to play with the [Ping.fm](http://ping.fm)&nbsp;[API](http://groups.google.com/group/pingfm-developers/web/api-documentation) with standard T-SQL in Microsoft SQL Server 2005 and above. [Ping-SQL](http://www.ping-sql.com) includes procedures to programmatically adjust configuration, replicate data to local tables and, of course, interact directly with the ping.fm API. Here’s a quick summary of the procedures currently in the suite…

| 

**Procedure**

 | 

**Classification**

 | 

**Comment**

 |
| 

ping\_cfg\_debug

 | 

Configuration

 | 

Allows you to avoid posting test data to the ping.fm API when set to On / 1.

 |
| 

ping\_cfg\_license\_key

 | 

Configuration

 | 

Change the Ping-SQL License key.

 |
| 

ping\_cfg\_no\_rsp

 | 

Configuration

 | 

Removes any data table called “rsp” from resultsets.

 |
| 

ping\_cfg\_no\_services

 | 

Configuration

 | 

Removes any data tables called “services” from resultsets.

 |
| 

ping\_cfg\_resultset\_send

 | 

Configuration

 | 

Changes the way resultsets are presented.

 |
| 

ping\_cfg\_sys\_debug

 | 

Configuration

 | 

Enables Ping-SQL application debugging.

 |
| 

ping\_cfg\_user\_key

 | 

Configuration

 | 

Allows the user key used to authenticate with ping.fm to be changed.

 |
| 

ping\_sys\_systemServicesTable

 | 

Data Replication

 | 

Creates a local table containing the data returned from the system.services API method. This table is called ping\_systemServicesTable. Any existing table with this name is dropped first.

 |
| 

ping\_sys\_userServicesTable

 | 

Data Replication

 | 

Creates a local table containing the data returned from the user.services API method. The table is called ping\_userServicesTable. Any existing table with this name is dropped first.

 |
| 

ping\_systemServices

 | 

Ping.fm API

 | 

Retuns a complete list of services supported by ping.fm.

 |
| 

ping\_userKey

 | 

Ping.fm API

 | &nbsp; |
| 

ping\_userLatest

 | 

Ping.fm API

 | 

Returns the last 25 messages a user has posted through Ping.fm.

 |
| 

ping\_userPost

 | 

Ping.fm API

 | 

Post a message to the users ping.fm services.

 |
| 

ping\_userServices

 | 

Ping.fm API

 | 

Returns a list of services the user has configured in their ping.fm account.

 |
| 

ping\_userTriggers

 | 

Ping.fm API

 | 

Returns a list of custom triggers.

 |
| 

ping\_userValidate

 | 

Ping.fm API

 | 

Validates the configured user key.

 |

So what can you do with [Ping-SQL](http://www.ping-sql.com)?

**Update your Facebook status with Ping-SQL**

```
-- Update your facebook status with Ping-SQL
DECLARE @status VARCHAR(140),
		@optional VARCHAR(100);

-- Status message to post
SET @status = 'is posting my status to facebook';
-- Specify the service to post to here
SET @optional = 'service=facebook'

EXEC dbo.ping_userPost null, @status, @optional, null, null;
```

**Post to Twitter with Ping-SQL**

```
-- Twitter microblogging with Ping-SQL
DECLARE @microblog VARCHAR(140),
		@optional VARCHAR(100);

-- Status message to post
SET @microblog = 'Drinking Coffee at home';
-- Specify the service to post to here
SET @optional = 'service=twitter'

EXEC dbo.ping_userPost null, @microblog, @optional, null, null;
```

**Post to Blogger with Ping-SQL**

```
-- Post to Blogger with Ping-SQL
DECLARE @title VARCHAR(100),
		@blog VARCHAR(MAX),
		@optional VARCHAR(100);

-- Set the title of your blog
SET @title= 'Test Blog Title';
-- The blog text
SET @blog = 'Lorem ipsum dolor sit amet, consectetur
adipisicing elit, sed do eiusmod tempor incididunt ut
labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip
ex ea commodo consequat. Duis aute irure dolor in
reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat
non proident, sunt in culpa qui officia deserunt mollit
anim id est laborum.';

-- Specify the service to post to here
-- and set the title tag
SET @optional = 'service=blogger&title=' + @title;

-- Important @post_method must be set to blog!
EXEC dbo.ping_userPost 'blog', @blog, @optional, null, null;
```

**Upload Photos to Flickr with Ping-SQL**

```
-- Upload a photo to Flickr!
DECLARE @title VARCHAR(140),
		@optional VARCHAR(100),
		@media_path VARCHAR(100);

-- Title of the Photo
SET @title = 'Pink Floyd Album Covers';
-- Specify the service to post to here
SET @optional = 'service=flickr';
-- Set the image path
SET @media_path = 'C:\Users\Rhys\Pictures\pink_floyd_001.jpg';

EXEC dbo.ping_userPost null, @title, @optional, @media_path, null;
```

[Ping-SQL](http://www.ping-sql.com) is also capable of calling [triggers](http://ping.fm/triggers/) that you have setup on your [ping.fm](http://ping.fm) account. In fact [Ping-SQL](http://www.ping-sql.com) should be capable of calling any of the services supported by ping.fm. Write T-SQL to play with Bebo, Blogger, BrightKite, Facebook, FriendFeed, MySpace, Plurk, Twitter, Wordpress.com, Yahoo 360, Yammer and many more.

