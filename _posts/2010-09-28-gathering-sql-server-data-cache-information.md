---
layout: post
title: Gathering SQL Server Data Cache Information
date: 2010-09-28 13:17:59.000000000 +02:00
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
- buffer pool
- data cache
- Powershell
- SQL Server
meta:
  tweetbackscheck: '1613415487'
  shorturls: a:4:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/gathering-sql-server-data-cache-information/874";s:7:"tinyurl";s:26:"http://tinyurl.com/28s6nuw";s:4:"isgd";s:18:"http://is.gd/fxqby";s:5:"bitly";s:20:"http://bit.ly/9YdEhf";}
  twittercomments: a:2:{s:11:"25880217429";s:7:"retweet";s:11:"27055543124";s:7:"retweet";}
  tweetcount: '2'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/gathering-sql-server-data-cache-information/874/"
---
I’m currently building a [CMDB](http://en.wikipedia.org/wiki/Configuration_management_database) at work and I wanted to include a bit of performance data in the information collected. The data cache is probably the biggest consumer of memory within SQL Server so It makes sense to collect this for future analysis. As a start I’m gathering the amount of space each database consumes in the data cache. I’ve created the below proc from a query in the excellent [Pro SQL Server 2008 Internals & Troubleshooting](http://www.brentozar.com/archive/2009/12/pro-sql-server-2008-internals-and-troubleshooting/).

```
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Rhys Campbell
-- Create date: 2010-09-28
-- Description:	Provides a summary of how much
-- space each database is using in the data cache
-- =============================================
CREATE PROCEDURE GetDataCache
AS
BEGIN

	SET NOCOUNT ON;

    SELECT COUNT(*) * 8 / 1024 AS 'Cache Size (MB)',
		   CASE database_id
				WHEN 32767 THEN 'ResourceDb'
				ELSE DB_NAME(database_id)
		   END AS 'Database',
		   @@SERVERNAME AS 'Server',
		   GETDATE() AS 'collected_at'
	FROM sys.dm_os_buffer_descriptors
	GROUP BY DB_NAME(database_id), database_id
	ORDER BY 'Cache Size (MB)' DESC;

END
GO
```

This will produce a dataset similar to below.

[![sql data cache use by database]({{ site.baseurl }}/assets/2010/09/sql_data_cache_use_by_database_thumb.png "sql data cache use by database")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/09/sql_data_cache_use_by_database.png)

I’ve written a [Powershell](http://technet.microsoft.com/en-us/scriptcenter/powershell.aspx) script to make it easy to query multiple servers. The script assumes that each sql instance to be queried contains the same database with the above proc. This script should be able to call any procedure as it simply exports the resultset to a csv file.

```
# array of sql server instances to query
$instances = @("localhost\sqlexpress", "RHYS-VAIO\sqlexpress");
# assumes proc is located in the same db on all servers
$database = "test";
# proc to call
$proc = "EXEC dbo.GetDataCache";
# Datetime stamp for filename
$dt = Get-Date -Format "yyyyMMddHHmmss";

# Query each instance
foreach($sql_instance in $instances)
{
	$con = New-Object System.Data.SqlClient.SqlConnection("Data Source=$sql_instance;Integrated Security=true;Initial Catalog=$database");
	$resultset = New-Object "System.Data.DataSet" "myDs";
	$data_adap = new-object "System.Data.SqlClient.SqlDataAdapter" ($proc, $con);
	$data_adap.Fill($resultset);
	# Replace any '\' chars from instance names to use in the filename
	$tmp_srv = $sql_instance -replace "\\", "_";
	# Add data to csv file
	$resultset.Tables[0] | Export-Csv -NoTypeInformation -Path "$Env:USERPROFILE\$tmp_srv`_sql_data_cache_$dt.csv";
	# Clean up
	$resultset.Dispose();
	$con.Close();
}
```

The script will spit out a csv file for each sql instance ready to be imported into the CMDB.

```
"Cache Size (MB)","Database","Server","collected_at"
"0","master","RHYS-VAIO\SQLEXPRESS","28/09/2010 13:12:52"
"0","msdb","RHYS-VAIO\SQLEXPRESS","28/09/2010 13:12:52"
"1","test","RHYS-VAIO\SQLEXPRESS","28/09/2010 13:12:52"
"20","TweetSQLV3","RHYS-VAIO\SQLEXPRESS","28/09/2010 13:12:52"
"1","tweetsql_31","RHYS-VAIO\SQLEXPRESS","28/09/2010 13:12:52"
"0","ResourceDb","RHYS-VAIO\SQLEXPRESS","28/09/2010 13:12:52"
```
