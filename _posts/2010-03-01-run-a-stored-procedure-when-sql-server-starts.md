---
layout: post
title: Run a Stored Procedure when SQL Server starts
date: 2010-03-01 21:08:18.000000000 +01:00
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
  tweetbackscheck: '1613455646'
  shorturls: a:4:{s:9:"permalink";s:83:"http://www.youdidwhatwithtsql.com/run-a-stored-procedure-when-sql-server-starts/693";s:7:"tinyurl";s:26:"http://tinyurl.com/yh35kvx";s:4:"isgd";s:18:"http://is.gd/9tC0P";s:5:"bitly";s:20:"http://bit.ly/9Ohspd";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/run-a-stored-procedure-when-sql-server-starts/693/"
---
Recently I needed to setup a [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) box so it had access to a mapped drive to support a legacy application. I created the below stored procedure, which utilises the [subst](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/subst.mspx?mfr=true) command. to get this done.

```
CREATE PROCEDURE usp_mapDDrive
AS
BEGIN
	EXEC master.dbo.xp_cmdshell 'Subst d: c:\', no_output;
END
GO
```

I needed a way of ensuring this mapped drive was always available to SQL Server. After considering various ways of doing this I settled with [sp\_procoption](http://msdn.microsoft.com/en-us/library/ms181720.aspx). This is a neat little system stored procedure that you can use to execute a user proc at startup. Setting this up is easy.

```
exec sp_procoption @ProcName = usp_mapDDrive,
     @OptionName = 'STARTUP',
     @OptionValue = 'ON';
```

Turning it off again is simple.

```
exec sp_procoption @ProcName = usp_mapDDrive,
     @OptionName = 'STARTUP',
     @OptionValue = 'OFF';
```

Two caveats; you must create your stored procedure in the [master database](http://msdn.microsoft.com/en-us/library/ms187837.aspx) and it cannot contain input or output parameters.

