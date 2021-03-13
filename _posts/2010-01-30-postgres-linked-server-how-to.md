---
layout: post
title: Postgres Linked Server How To
date: 2010-01-30 16:44:07.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
tags:
- Linked Server
- ODBC
- Postgres
- SQL Server
meta:
  tweetbackscheck: '1613425197'
  shorturls: a:4:{s:9:"permalink";s:67:"http://www.youdidwhatwithtsql.com/postgres-linked-server-how-to/590";s:7:"tinyurl";s:26:"http://tinyurl.com/yejoc29";s:4:"isgd";s:18:"http://is.gd/7mFOI";s:5:"bitly";s:20:"http://bit.ly/bpWjCh";}
  twittercomments: a:2:{s:11:"17455976905";s:7:"retweet";s:11:"21891560402";s:7:"retweet";}
  tweetcount: '2'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/postgres-linked-server-how-to/590/"
---
Just a quick post showing how to add a [Postgres](http://www.postgresql.org/) database server as a [Linked Server](http://msdn.microsoft.com/en-us/library/ms188279.aspx) in [Microsoft](http://www.microsoft.com/en/us/default.aspx)&nbsp;[SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx).

- Install the [psqlODBC](http://www.postgresql.org/ftp/odbc/versions/) driver for Windows. 
- Control Panel \> Administrative Tools \> Data Sources (ODBC). 
- Click the "System DSN" tab and click the Add button. 

[![Create New Data Source Dialog]({{ site.baseurl }}/assets/2010/01/new_data_source_thumb.png "Create New Data Source Dialog")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/new_data_source.png)

- Choose "PostreSQL ANSI" and click Finish. 
- Configure the data source by entering the server, username, password and database details. 

[![Postgres ODBC Setup]({{ site.baseurl }}/assets/2010/01/Postgres_ODBC_Setup_thumb.png "Postgres ODBC Setup")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/Postgres_ODBC_Setup.png)

- Click "Test" to confirm the data source functions. If it fails ensure that [Postgres](http://www.postgresql.org/) is running and check your configuration details. 
- Click "Save" and then "OK" once successful. 
- Fire up [SSMS](http://msdn.microsoft.com/en-us/library/ms174173.aspx) and run the following [T-SQL](http://en.wikipedia.org/wiki/Transact-SQL) to create the Linked Server to Postgres. 

```
USE [master]
GO
EXEC master.dbo.sp_addlinkedserver @server = N'POSTGRES', @srvproduct=N'Postgres', @provider=N'MSDASQL', @datasrc=N'PostgreSQL30'

GO
EXEC master.dbo.sp_serveroption @server=N'POSTGRES', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'POSTGRES', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'POSTGRES', @optname=N'rpc', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'POSTGRES', @optname=N'rpc out', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'POSTGRES', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'POSTGRES', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'POSTGRES', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'POSTGRES', @optname=N'use remote collation', @optvalue=N'true'
GO
USE [master]
GO
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'POSTGRES', @locallogin = NULL , @useself = N'False'
GO
```

Alternatively copy the below configuration in SSMS. The most critical thing here is to get the setting for "Data source" correct. This should be the name of the System DSN you added earlier.

[![Postgres Linked Server Configuration]({{ site.baseurl }}/assets/2010/01/Postgres_Linked_Server_Configuration_thumb.png "Postgres Linked Server Configuration")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/Postgres_Linked_Server_Configuration.png)

- Finally execute the query below. This uses [OPENQUERY](http://technet.microsoft.com/en-us/library/ms188427.aspx) and will list all the tables in your [Postgres](http://www.postgresql.org/) system database. 

```
SELECT *
FROM OPENQUERY(POSTGRES, 'SELECT * FROM INFORMATION_SCHEMA.TABLES');
```

If everything is running correctly you should see something like below.

[![Postgres openquery result]({{ site.baseurl }}/assets/2010/01/postgres_openquery_result_thumb.png "Postgres openquery result")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/postgres_openquery_result.png)

