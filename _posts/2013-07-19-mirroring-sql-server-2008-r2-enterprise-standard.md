---
layout: post
title: Mirroring SQL Server 2008 R2 Enterprise to Standard
date: 2013-07-19 18:55:33.000000000 +02:00
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
  shorturls: a:3:{s:9:"permalink";s:88:"http://www.youdidwhatwithtsql.com/mirroring-sql-server-2008-r2-enterprise-standard/1630/";s:7:"tinyurl";s:26:"http://tinyurl.com/mkfbn7e";s:4:"isgd";s:19:"http://is.gd/Rvbgmz";}
  tweetbackscheck: '1613376911'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mirroring-sql-server-2008-r2-enterprise-standard/1630/"
---
If you attempt to mirror SQL Server 2008 R2 Enterprise to Standard edition, using [SSMS](http://msdn.microsoft.com/en-us/library/ms174173.aspx "SQL Server Management Studio"), you will receive the following error message;

```
This mirroring configuration is not supported. Because the principal server instance, , is not Standard Edition, the mirror server instance cannot be Standard Edition.
```

You should never mirror between different editions, of SQL Server, in a live situation but it's possible to configure this using TSQL. I wanted to test mirroring over a WAN link, the SQL Server we had over there was Standard Edition, and I didn't want to go through the rigmarole of setting up another SQL box.

So here's how you setup mirroring between Enterprise and Standard Editions. A simple mirroring setup is assumed with no witness box. I've kept the details down to an absolute minimum. See here for some more detailed documentation on [database mirroring](http://msdn.microsoft.com/en-us/library/ms190941(v=sql.105).aspx "SQL Server Database Mirroring").

First create the endpoint on the principal server.

```
CREATE ENDPOINT Endpoint_Mirroring
    STATE=STARTED
    AS TCP (LISTENER_PORT=5022)
    FOR DATABASE_MIRRORING (ROLE=PARTNER)
GO
```

Grant access to the endpoint to the mirror SQL Server domain account. I've assumed here that you're using domain accounts to run SQL under and both servers are in the same domain.

```
USE master ;
GO
CREATE LOGIN [domain\mirror] FROM WINDOWS ;
GO

GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [domain\mirror];
GO
```

Now on your mirror create the endpoint;

```
CREATE ENDPOINT Endpoint_Mirroring
    STATE=STARTED
    AS TCP (LISTENER_PORT=5022)
    FOR DATABASE_MIRRORING (ROLE=PARTNER)
GO
```

Configure security;

```
USE master ;
GO
CREATE LOGIN [domain\principal] FROM WINDOWS ;
GO

GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [domain\principal];
GO
```

Now we can mirror our databases. Before doing this you need to set the database you want to mirror to [FULL recovery model](http://msdn.microsoft.com/en-us/library/ms189275.aspx "FULL Recovery model"), back it up and restore it on the mirror server with [NORECOVERY](http://msdn.microsoft.com/en-us/library/ms191455(v=sql.105).aspx "SQL Server Backups NORECOVERY").

```
ALTER DATABASE db
    SET PARTNER = 'TCP://principal.domain.co.uk:5022'
GO
```

Then back on the principal;

```
ALTER DATABASE db
    SET PARTNER = 'TCP://mirror.domain.co.uk:5022'
GO
```

Then fingers crossed mirroring for your database will successfully initialize!

