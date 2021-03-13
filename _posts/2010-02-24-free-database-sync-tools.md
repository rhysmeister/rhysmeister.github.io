---
layout: post
title: Free Database Sync Tools
date: 2010-02-24 21:45:55.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Software
tags:
- Database Synchronisation
- SQL Compare
meta:
  twittercomments: a:0:{}
  tweetbackscheck: '1613274242'
  shorturls: a:4:{s:9:"permalink";s:62:"http://www.youdidwhatwithtsql.com/free-database-sync-tools/684";s:7:"tinyurl";s:26:"http://tinyurl.com/yjkcxl4";s:4:"isgd";s:18:"http://is.gd/96G8M";s:5:"bitly";s:20:"http://bit.ly/bo4EBt";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/free-database-sync-tools/684/"
---
I'm a big fan of [Redgate SQL Compare](http://www.red-gate.com/products/SQL_Compare/index-2.htm) but it's been good to see the arrival of a few free alternatives. Life previous to these tools really does seem like the stone age now eliminating those _"oh $h\*\*, I forgot about that!"_ moments. I'd always go for Redgate every time but, if you don't have it in your budget, these tools may be worth checking out.

[OpenDBDiff](http://www.codeplex.com/OpenDBiff/)

This is an open source project hosted on [Codeplex](http://www.codeplex.com) that has database compare and, crucially, synchronisation abilities. I've used this tool in a few production deployments and have found it useful. I don't fully trust it yet, it took a while to trust Redgate, but I haven't encountered any major difficulties yet. I've had issues with synchronisation scripts and dependency ordering but nothing I have found too frustrating.

The user interface is basic, but well designed, and it's easy to get productive straight away.

[![OpenDBDiff Main Screen]({{ site.baseurl }}/assets/2010/02/OpenDBDiff_1_thumb.png "OpenDBDiff Main Screen")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/OpenDBDiff_1.png)

You can't stay within the tool to synchronise your databases but, as there is a non-functional "Actions Report" tab, it seems this is on the roadmap.

Open DBDiff can synchronize the following object types.

- Tables (including Table Options like vardecimal, text in row, etc.) 
- Columns (including Computed Columns, XML options, Identities, etc.) 
- Constraints 
- Indexes (and XML Indexes) 
- XML Schemas 
- Table Types 
- User Data Types (UDT) 
- CLR Objects (Assemblies, CLR-UDT, CLR-Stored Procedure, CLR-Triggers) 
- Triggers (including DDL Triggers) 
- Synonyms 
- Schemas 
- File groups 
- Views 
- Functions 
- Store Procedures 
- Partition Functions/Schemes 
- Users 
- Roles

[![OpenDBDiff Syncronisation Script]({{ site.baseurl }}/assets/2010/02/OpenDBDiff_Syncronisation_Script_thumb.png "OpenDBDiff Syncronisation Script")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/OpenDBDiff_Syncronisation_Script.png)

I did have trouble connecting to different instances of SQL Server on the same machine. This shouldn't matter much for production use as we'd normally be synchronising different boxes.

[Starinix Database Compare](http://www.starinix.com/sqlcompare02.htm)

This is a freeware tool that is able to compare [MySQL](http://www.mysql.com), Access and [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) databases and any combinations thereof. Not sure this would be useful in my case but I guess someone might do (I can already tell you your MySQL and SQL Server procedures do not match!).

[![Starinix Database Compare]({{ site.baseurl }}/assets/2010/02/Starnix_Database_Compare_thumb.png "Starinix Database Compare")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/Starnix_Database_Compare.png)

[![Starinix Database Compare]({{ site.baseurl }}/assets/2010/02/Starinix_Database_Compare_1_thumb.png "Starinix Database Compare")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/Starinix_Database_Compare_1.png)

**Key features**

- Take snapshots of the structure of the database and review it later. 
- Snapshots can be saved anywhere, allowing you to take snapshots of any database for reviewing later. 
- Compare two online database connections. 
- Compare an online database connection to an off-line snapshot. 
- Compare two off-line snapshots. 
- Use integrated or user based security. 
- Compares: views, constraints, stored procedures, functions, tables and fields. 
- Compare Access database to an SQL Server database. 
- Compare Access database to a MySQL database. 
- Compare Access database to another Access database. 
- Compare MySQL Database to an SQL Server Database. 
- Compare SQL Server 2000 to SQL Server 2005.

I've done some quick testing of this tool and it does seem to be accurate, spotting all of my edits made to tables, procedures and functions. The interface is ok but does need some polish. For example, it would be a nice touch for the "SQL View" scroll bar to scroll both the source and destination views. Identifying differences to large procedures isn't as easy as it should be but clicking "Script Comparison" launches an external diff tool that does a better job.

[![Starinix Procedure Compare]({{ site.baseurl }}/assets/2010/02/Starnix_Procedure_Compare_thumb.png "Starinix Procedure Compare")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/Starnix_Procedure_Compare.png)

This is strictly a compare tool, meaning there are no synchronisation abilities, so you'll have to do a little leg work to implement any needed changes.

Overall there's no clear winner for me out of these two free tools. Both products have easy to use GUIs. [OpenDBDiff](http://opendbiff.codeplex.com/) clearly has the edge as a synchronisation tool but [Starinix](http://starinix.com/sqlcompare02.htm) has a few nice touches like the external diff tool and the snapshot feature.

