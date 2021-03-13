---
layout: post
title: 'SSMS SQLCMD Mode: a half done job?'
date: 2010-05-28 21:59:53.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SQL Server
- T-SQL
tags:
- sqlcmd
- SSMS
- TSQL
meta:
  tweetbackscheck: '1613410295'
  shorturls: a:4:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/ssms-sqlcmd-mode-a-half-done-job/782";s:7:"tinyurl";s:26:"http://tinyurl.com/3xpznvk";s:4:"isgd";s:18:"http://is.gd/ctwdW";s:5:"bitly";s:20:"http://bit.ly/aflzTp";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssms-sqlcmd-mode-a-half-done-job/782/"
---
I’ve always been aware of [SQLCMD mode](http://msdn.microsoft.com/en-us/library/ms174187.aspx) in SQL Server Management Studio but until a few days ago I never considered using it. So what is SQLCMD?

> SQLCMD is a command line application that comes with Microsoft SQL Server, and exposes the management features of SQL Server. It allows SQL queries to be written and executed from the command prompt. It can also act as a [scripting language](http://en.wikipedia.org/wiki/Scripting_language) to create and run a set of SQL statements as a script. Such scripts are stored as a `.sql` file, and are used either for management of databases or to create the database schema during the deployment of a database. [source](http://en.wikipedia.org/wiki/Microsoft_SQL_Server#SQLCMD)

Even better SQLCMD Mode allows us to mix [T-SQL](http://msdn.microsoft.com/en-us/library/ms189826(SQL.90).aspx) with these handy commands. You can activate the feature by clicking Query \> SQLCMD Mode.

[![sqlcmd_mode_ssms]({{ site.baseurl }}/assets/2010/05/sqlcmd_mode_ssms_thumb.png "sqlcmd\_mode\_ssms")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/05/sqlcmd_mode_ssms.png)

I remember reading on a blog somewhere that people starting out with T-SQL often try to do stuff like;

```
DECLARE @table VARCHAR(20);
SET @table = 'Customer';

SELECT *
FROM @table;
```

This doesn’t work but look what we can do in SQLCMD mode.

```
:setvar table Customer

SELECT *
FROM $(table);
```

Bang, we have a resultset. Now I was excited! There’s a few things in TSQL that will not accept a variable as input. Off the top of my head I can think of references to Linked Servers and [OPENQUERY](http://technet.microsoft.com/en-us/library/ms188427.aspx). Perhaps SQLCMD Mode was the answer to some of these, admittedly very rare, problems.

```
:setvar linkedservername MyLinkedServer

SELECT *
FROM $(linkedservername).db.dbo.table;
```

Another resultset. So far, so good. Now lets try something a little different.

```
DECLARE @linkedserver CHAR(1);
SET @linkedserver = '1';

IF (@linkedserver = '1')
BEGIN
                PRINT '1';
                :setvar linkedservername MyFirstLinkedServer
END
ELSE
BEGIN
                PRINT '2';
                :setvar linkedservername MySecondLinkedServer
END

SELECT *
FROM $(linkedservername).db.dbo.Customer;
```

This appears to work, when you reference genuine linked server, but if you change the names to ones that don't exist you'll get the following error.

```
Msg 7202, Level 11, State 2, Line 13
Could not find server 'MySecondLinkedServer' in sys.servers. Verify that the correct server name was specified. If necessary, execute the stored procedure sp_addlinkedserver to add the server to sys.servers.
```

Yep, it seems all the SQLCMD lines are executed regardless of the TSQL conditions around them. OK, so perhaps if I do all the assignment in TSQL and then feed a variable to the SQLCMD?

```
DECLARE @linkedservername VARCHAR(20);
SET @linkedservername = 'MyLinkedServer';

:setvar linkedservername @linkedservername;

SELECT *
FROM $(linkedservername).db.dbo.Customer;
```

No joy with this either. So no flow control or TSQL variable assignments with SQLCMD mode? This is a big disappointment.&nbsp; Not very many SQLCMD keywords are supported and no real flow control commands.

> The Database Engine Query Editor supports the following SQLCMD script keywords:
> 
> `[!!:]GO[count]`
> 
> `!! `
> 
> `:exit(statement)`
> 
> `:Quit`
> 
> `:r `
> 
> `:setvar `
> 
> `:connect server[\instance] [-l login_timeout] [-U user [-P password]]`
> 
> `:on error [ignore|exit]`
> 
> `:error |stderr|stdout`
> 
> `:out |stderr|stdout source`

This happens because all the processing of SQLCMD happens client-side before the TSQL hits the database engine.The reason makes sense but I don’t like the result! Surely it wouldn’t have been that hard to add a few conditional commands to the product?

Don’t get me wrong, you can do some [cool things with sqlcmd mode](http://www.simple-talk.com/sql/sql-tools/the-sqlcmd-workbench/), but without conditional processing and variable handling it misses being something awesome by quite a long shot.

