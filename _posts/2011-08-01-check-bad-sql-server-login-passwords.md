---
layout: post
title: Check for bad SQL Server login passwords
date: 2011-08-01 14:28:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- T-SQL
tags:
- PWDCOMPARE
- security
- sql login
- TSQL
meta:
  tweetbackscheck: '1613296738'
  shorturls: a:3:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/check-for-bad-sql-server-login-passwords/1283";s:7:"tinyurl";s:26:"http://tinyurl.com/4yho3aa";s:4:"isgd";s:19:"http://is.gd/aaeVZl";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _edit_last: '1'
  _wp_old_slug: check-for-bad-sql-server-login-passwords
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-bad-sql-server-login-passwords/1283/"
---
The [PWDCOMPARE](http://msdn.microsoft.com/en-us/library/dd822792.aspx "TSQL PWDCOMPARE Function") function is really handy for further securing your SQL Servers by checking for a range of blank or common passwords. If you google for [common password list](http://www.google.co.uk/search?rlz=1C1SVEC_enGB381GB381&aq=f&sourceid=chrome&ie=UTF-8&q=common+password+list "Common password list") you'll probably recognise several if you've been working in IT for any reasonable amount of time. Fortunately you can use this function, in conjunction with the [sys.sql\_logins](http://msdn.microsoft.com/en-us/library/ms174355.aspx "sys.sql\_logins system view") view, to check an instance for bad passwords.

I'm only checking [ten common passwords](http://modernl.com/article/top-10-most-common-passwords "Ten common passwords") with the addition of a blank one. The list is based on a study of UK passwords so it's not going to suitable for all corners of the globe. For a live system check you'll probably want to use a more comprehensive list of passwords.

This TSQL will list any sql logins with a bad password.

```
DECLARE @passwords TABLE
(
	pwd VARCHAR(100)
)

INSERT INTO @passwords
(
	pwd
)
SELECT 'thomas'
UNION ALL
SELECT 'arsenal'
UNION ALL
SELECT 'monkey'
UNION ALL
SELECT 'charlie'
UNION ALL
SELECT 'qwerty'
UNION ALL
SELECT '123456'
UNION ALL
SELECT 'letmein'
UNION ALL
SELECT 'liverpool'
UNION ALL
SELECT 'password'
UNION ALL
SELECT '123'
UNION ALL
SELECT '';

-- List bad users
SELECT l.[name],
	   l.[sid],
	   p.pwd
FROM sys.sql_logins l
INNER JOIN @passwords p
	ON PWDCOMPARE(p.pwd, l.password_hash) = 1;
```

Hopefully you'll get no results from your check but if you do it may look something like this;

[![tsql_pwdcompare_sql_login_bad_password]({{ site.baseurl }}/assets/2011/08/tsql_pwdcompare_sql_login_bad_password_thumb.png "tsql\_pwdcompare\_sql\_login\_bad\_password")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Using-the-PWDCOMPARE-function-to-search-_C553/tsql_pwdcompare_sql_login_bad_password.png)

