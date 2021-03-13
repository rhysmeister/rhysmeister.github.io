---
layout: post
title: Correct a log file with too many VLFs
date: 2014-02-08 17:14:15.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613478466'
  shorturls: a:3:{s:9:"permalink";s:61:"http://www.youdidwhatwithtsql.com/correct-log-file-vlfs/1761/";s:7:"tinyurl";s:26:"http://tinyurl.com/phwjhuw";s:4:"isgd";s:19:"http://is.gd/3HxE27";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/correct-log-file-vlfs/1761/"
---
The what and why of this post is explained here [Transaction Log VLFs – too many or too few?](http://www.sqlskills.com/blogs/kimberly/transaction-log-vlfs-too-many-or-too-few/ "SQL Server Virtual Log Files"). Presented here is a quick practical example of how you might correct this issue in a database log file.

As a first step you'll need to get the logical name of your log file for the database in question.

```
USE your_database;

SELECT *
FROM sys.database_files;
GO
```

You'll want to make sure there is no activity in the database so it doesn't interfere with our efforts. Note this does kick everyone out of the database.

```
ALTER DATABASE your_database SET RESTRICTED_USER WITH ROLLBACK IMMEDIATE;
```

Next shrink your log file;

```
DBCC SHRINKFILE(log_name, 0, TRUNCATEONLY);
```

Now we can resize the log. Here I am growing the log in 8GB increments (ok, slightly over) so we end up with VLFs 512MB in size.

```
USE master
GO

ALTER DATABASE your_database
MODIFY FILE
(
	NAME = log_name,
	SIZE = 8200MB
);
GO

ALTER DATABASE your_database
MODIFY FILE
(
	NAME = log_name,
	SIZE = 16400MB
);
GO

ALTER DATABASE your_database
MODIFY FILE
(
	NAME = log_name,
	SIZE = 24600MB
);
GO

ALTER DATABASE your_database
MODIFY FILE
(
	NAME = log_name,
	SIZE = 32800MB
);
GO
```

Now set the database back to multi user.

```
ALTER DATABASE your_database SET MULTI_USER;
```

Inspect your log VLF structure.

```
DBCC LOGINFO;
```

You may also be interested in the following post about [Auditing VLFs on your SQL Server](http://www.youdidwhatwithtsql.com/audit-vlfs-on-your-sql-server/1358/ "Virtual Logs Files SQL server").

