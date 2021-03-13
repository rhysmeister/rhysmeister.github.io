---
layout: post
title: 'TSQL: Enable & Disable Logins and DENY connect'
date: 2014-07-30 22:44:34.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- T-SQL
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461755'
  shorturls: a:3:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/tsql-enable-disable-logins-deny-connect/1948/";s:7:"tinyurl";s:26:"http://tinyurl.com/q3y784p";s:4:"isgd";s:19:"http://is.gd/IRUmhK";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-enable-disable-logins-deny-connect/1948/"
---
More notes for the [70-462](https://www.microsoft.com/learning/en-gb/exam-70-462.aspx "Administering SQL Server 2012 Databases") exam. This time we're showing examples from [ALTER LOGIN](http://msdn.microsoft.com/en-gb/library/ms189828.aspx "TSQL ALTER LOGIN") to enable and disable logins, as well a denying and granting the connect permission.

To Deny connect and disable a sql login...

```
USE [master]
GO
DENY CONNECT SQL TO [sql_user_c]
GO
ALTER LOGIN [sql_user_c] DISABLE
GO
```

```
Grant connect and enable a sql login
```

```
USE [master]
GO
GRANT CONNECT SQL TO [sql_user_c]
GO
ALTER LOGIN [sql_user_c] ENABLE
GO
```

To deny connect and disable a Windows login...

```
USE [master]
GO
DENY CONNECT SQL TO [SQL-A\local_account_b]
GO
ALTER LOGIN [SQL-A\local_account_b] DISABLE
GO
```

To grant connect and enable a Windows login...

```
USE [master]
GO
GRANT CONNECT SQL TO [SQLA\local_account_b]
GO
ALTER LOGIN [SQLA\local_account_b] ENABLE
GO
```

To deny connect to a windows domain group

```
USE [master]
GO
DENY CONNECT SQL TO [DOMAIN\domain_group_b]
GO
```

This doesn't work for a windows group buy denying connect is essentially the same thing...

```
ALTER LOGIN [DOMAIN\domain_group_b] DISABLE
GO
```

This statement will return the following error...

```
Msg 33129, Level 16, State 1, Line 1
Cannot use ALTER LOGIN with the ENABLE or DISABLE argument for a Windows group. GRANT or REVOKE the CONNECT SQL permission instead.
```
