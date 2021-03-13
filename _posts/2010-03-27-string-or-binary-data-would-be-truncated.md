---
layout: post
title: String or binary data would be truncated.
date: 2010-03-27 19:25:51.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- TSQL
meta:
  tweetbackscheck: '1613070493'
  shorturls: a:4:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/string-or-binary-data-would-be-truncated/706";s:7:"tinyurl";s:26:"http://tinyurl.com/yarovux";s:4:"isgd";s:18:"http://is.gd/b2sj6";s:5:"bitly";s:20:"http://bit.ly/cLT6yz";}
  twittercomments: a:1:{s:11:"12529597226";s:7:"retweet";}
  tweetcount: '1'
  _sg_subscribe-to-comments: michael_bourgon@yahoo.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/string-or-binary-data-would-be-truncated/706/"
---
This error message really irritates me.

```
Msg 8152, Level 16, State 2, Line 1
String or binary data would be truncated.
The statement has been terminated.
```

I should probably open a [Microsoft Connect](http://connect.microsoft.com/) item about this but would it really be that hard to tell you the column name? When you're importing a data from temporary tables with a large amount of columns it can be rather tedious to check which one is causing the problem. Here's an approach I often take to identify the column quickly.

```
USE AdventureWorks
GO

-- Generate SQL for all the character columns
SELECT 'MAX(LEN(' + COLUMN_NAME + ')) AS ' + COLUMN_NAME + ','
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Contact'
AND TABLE_SCHEMA = 'Person'
AND (DATA_TYPE LIKE '%char%'
OR DATA_TYPE LIKE '%text%');

-- Run the generated SQL against your table
SELECT MAX(LEN(Title)) AS Title,
MAX(LEN(FirstName)) AS FirstName,
MAX(LEN(MiddleName)) AS MiddleName,
MAX(LEN(LastName)) AS LastName,
MAX(LEN(Suffix)) AS Suffix,
MAX(LEN(EmailAddress)) AS EmailAddress,
MAX(LEN(Phone)) AS Phone,
MAX(LEN(PasswordHash)) AS PasswordHash,
MAX(LEN(PasswordSalt)) AS PasswordSalt
FROM Person.Contact;
```

When ran against your target table the script will produce a MAX character count for all the char / text type fields. Not exactly rocket science but this makes it easy to identify the column(s) causing the issue.

[![max data lengths]({{ site.baseurl }}/assets/2010/03/max_data_lengths_thumb.png "max data lengths")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/03/max_data_lengths.png)

