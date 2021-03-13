---
layout: post
title: 'Gathering SQL Server Data Cache Information: Part 2'
date: 2010-09-29 15:20:18.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
- SQL Server
tags:
- data cache
- Powershell
- SQL Server
meta:
  tweetbackscheck: '1613143679'
  shorturls: a:4:{s:9:"permalink";s:88:"http://www.youdidwhatwithtsql.com/gathering-sql-server-data-cache-information-part-2/879";s:7:"tinyurl";s:26:"http://tinyurl.com/36ecaf5";s:4:"isgd";s:18:"http://is.gd/fA3tg";s:5:"bitly";s:20:"http://bit.ly/cP3MHz";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/gathering-sql-server-data-cache-information-part-2/879/"
---
In a previous post I showed how you can collect information on [what is held in the data cache](http://www.youdidwhatwithtsql.com/gathering-sql-server-data-cache-information/874). The data collected here was just a simple summary of how much space each database was consuming. While useful we will need more detailed information on what is inside the cache to get a proper handle on things.

The below query has been modified from the post: [What’s swimming in your buffer pool?](http://blogs.msdn.com/b/sqlperf/archive/2007/05/18/bufferpooldatapagesbreakdown.aspx) This procedure will tell us exactly what objects are contained within the data cache.

```
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Rhys Campbell
-- Create date: 2010-09-28
-- Description:	Gets info on objects in the data
-- cache broken by database.
-- =============================================
CREATE PROCEDURE [dbo].[GetDataCacheObjects]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT @@SERVERNAME AS 'Server',
		   GETDATE() AS collected_at,
		   DB_NAME(database_id) AS 'database',
		   COUNT(*)AS cached_pages_count,
		   obj.name AS objectname,
		   ind.name AS indexname,
		   obj.index_id AS indexid
	FROM sys.dm_os_buffer_descriptors AS bd
    INNER JOIN
    (
        SELECT object_id AS objectid,
                           object_name(object_id) AS name,
                           index_id,allocation_unit_id
        FROM sys.allocation_units AS au
            INNER JOIN sys.partitions AS p
                ON au.container_id = p.hobt_id
                    AND (au.type = 1 OR au.type = 3)
        UNION ALL
        SELECT object_id AS objectid,
                           object_name(object_id) AS name,
                           index_id,allocation_unit_id
        FROM sys.allocation_units AS au
            INNER JOIN sys.partitions AS p
                ON au.container_id = p.partition_id
                    AND au.type = 2
    ) AS obj
        ON bd.allocation_unit_id = obj.allocation_unit_id
	LEFT OUTER JOIN sys.indexes ind
		ON obj.objectid = ind.object_id
	AND obj.index_id = ind.index_id
	WHERE bd.page_type IN ('data_page', 'index_page')
	GROUP BY DB_NAME(database_id), obj.name, ind.name, obj.index_id
	ORDER BY cached_pages_count DESC

END

GO
```

This will produce a dataset similar to below.

[![objects in the sql server data cache]({{ site.baseurl }}/assets/2010/09/objects_in_the_sql_server_data_cache_thumb.png "objects in the sql server data cache")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/09/objects_in_the_sql_server_data_cache.png)

This proc can be called by the [Powershell script in the previous post](http://www.youdidwhatwithtsql.com/gathering-sql-server-data-cache-information/874) (nice and easy to run against multiple servers) and will produce a csv file looking like below. Just change the line

```
$proc = "EXEC dbo.GetDataCache";
```

to

```
$proc = "EXEC dbo.GetDataCacheObjects";
```

This is ready to be imported into a database for future analysis.

```
"Server","collected_at","database","cached_pages_count","objectname","indexname","indexid"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","","1167","sysobjvalues","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","","304","syscolpars","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","","190","tweet_followersIds","PK __tweet_fo__ 3214EC0735DCF99B","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","","56","sysschobjs","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","test","32","sysobjvalues","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","","27","sysobjkeycrypts","cl","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","msdb","25","sysschobjs","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","master","22","sysobjvalues","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","msdb","14","sysobjvalues","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","test","13","syscolpars","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","msdb","13","syscolpars","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","","12","sysrscols","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","msdb","12","sysrscols","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","master","11","sysrscols","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","msdb","10","sysobjkeycrypts","cl","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","","9","sysschobjs","nc2","3"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","","8","sysidxstats","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","model","8","sysobjvalues","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","model","8","sysrscols","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","tempdb","8","sysobjvalues","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","tempdb","8","sysrscols","clst","1"
"RHYS-VAIO\SQLEXPRESS","29/09/2010 14:58:32","test","8","sysrscols","clst","1"
```

Once several snapshots of the data cache have been made this should help us with performance problem diagnosis and estimate the “warm-up time” after a reboot.

