---
layout: post
title: Using sp_rename with schemas
date: 2010-09-23 22:22:50.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- T-SQL
tags:
- schemas
- schemata
meta:
  tweetbackscheck: '1613477134'
  shorturls: a:4:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/using-sp_rename-with-schemas/870";s:7:"tinyurl";s:26:"http://tinyurl.com/25mr4v3";s:4:"isgd";s:18:"http://is.gd/fpywx";s:5:"bitly";s:20:"http://bit.ly/cl0cKA";}
  twittercomments: a:2:{s:11:"25435828749";s:7:"retweet";s:11:"26672439293";s:7:"retweet";}
  tweetcount: '2'
  _sg_subscribe-to-comments: ednaule@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/using-sp_rename-with-schemas/870/"
---
I’ve noticed people before struggling using [sp\_rename](http://msdn.microsoft.com/en-us/library/ms188351.aspx) with tables that aren’t in the default schema. Many people don’t use schemas, so there’s often confusion, when they finally do come across the need to rename a table belonging to another schema.

Assuming the below ‘<font color="#666666">Suppliers’ table is in the users default schema (usually dbo) then the following will work as expected.</font>

```
EXEC sp_rename 'Suppliers', 'Suppliers2';
```

```
Caution: Changing any part of an object name could break scripts and stored procedures.
```

If the table had not been in the users default schema the following error would have occurred.

```
Msg 15225, Level 11, State 1, Procedure sp_rename, Line 338
No item by the name of 'Suppliers' could be found in the current database 'test', given that @itemtype was input as '(null)'.
```

After encountering this many people then figure, quite correctly, that the schema should be referenced but get it slightly wrong.

```
EXEC sp_rename 'AnotherSchema.Suppliers', 'AnotherSchema.Suppliers2';
```

This works, but not in the way you want, you end up with a table called **AnotherSchema.Suppliers2**. This can then only be referenced by using the following structure; **AnotherSchema.[AnotherSchema.Suppliers2]**. The correct syntax is;

```
EXEC sp_rename 'schema.old table name', 'new table name';
```

For example;

```
EXEC sp_rename 'AnotherSchema.Suppliers', 'Suppliers2';
```
