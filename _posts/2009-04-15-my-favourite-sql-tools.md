---
layout: post
title: My Favourite SQL Tools
date: 2009-04-15 18:49:36.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Software
tags:
- bids
- bidshelper
- sql tools
- sqlyog
- SSMS
meta:
  _edit_last: '1'
  tweetbackscheck: '1613003746'
  shorturls: a:7:{s:9:"permalink";s:59:"http://www.youdidwhatwithtsql.com/my-favourite-sql-tools/59";s:7:"tinyurl";s:25:"http://tinyurl.com/cwnncf";s:4:"isgd";s:17:"http://is.gd/uGko";s:5:"bitly";s:19:"http://bit.ly/JcTkz";s:5:"snipr";s:22:"http://snipr.com/grj68";s:5:"snurl";s:22:"http://snurl.com/grj68";s:7:"snipurl";s:24:"http://snipurl.com/grj68";}
  twittercomments: a:1:{s:10:"2500166098";s:7:"retweet";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/my-favourite-sql-tools/59/"
---
[BIDSHelper](http://www.codeplex.com/bidshelper)

Enhances and extends the functionality of [BIDS](http://msdn.microsoft.com/en-us/library/ms173767.aspx). I’ve mainly used this with [SSIS](http://msdn.microsoft.com/en-us/library/aa213778(SQL.80).aspx) but there are many tools for [SSAS](http://msdn.microsoft.com/en-us/library/ms175609(SQL.90).aspx) and [SSRS](http://msdn.microsoft.com/en-us/library/ms159106.aspx) included in the package. Two of my favourites include the variable editor (useful when you add them in the wrong scope) and the deployment wizard. These two things alone have probably saved me hours of time. The [Performance Visualisation](http://bidshelper.codeplex.com/Wiki/View.aspx?title=SSIS%20Performance%20Visualization) feature is great for identifying where you should focus your optimisation efforts.

[![BidHelper SSIS Performance Tab]({{ site.baseurl }}/assets/2009/04/ssisperformancetab-thumb.png "BidHelper SSIS Performance Tab")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/ssisperformancetab.png)

Features include;

- Create Fixed Width Columns
- Deploy SSIS Packages
- dtsConfig File Formatter
- Expression and Configuration Highlighter
- Expression List
- Fix Relative Paths
- Non-Default Properties Report
- Pipeline Component Performance Breakdown
- Reset GUIDs
- Smart Diff
- Sort Project Files
- Sortable Package Properties Report
- SSIS Performance Visualization
- Variables Window Extensions
- Dataset Usage Reports
- Delete Dataset Cache Files

[SSMS Tools Pack](http://www.ssmstoolspack.com/)

SSMS Tools PACK is an Add-In (Add-On) for Microsoft SQL Server Management Studio and Microsoft SQL Server Management Studio Express. Like [BIDSHelper](http://www.codeplex.com/bidshelper) SSMS Tools Pack adds some really handy functionality to the host application. Its features include;

- Window Connection Colouring.
- Query Execution History (Soft Source Control) and Current Window History.
- Search Table or Database Data.
- Uppercase/Lowercase keywords and proper case Database Object Names.
- Run one script on multiple databases.
- Copy execution plan bitmaps to clipboard.
- Search Results in Grid Mode and Execution Plans.
- Generate Insert statements for a single table, the whole database or current resultsets in grids.
- Text document Regions and Debug sections.
- Running custom scripts from Object explorer's Context menu.
- CRUD (Create, Read, Update, Delete) stored procedure generation.
- New query template.

[Redgate SQL Compare](http://www.red-gate.com/products/SQL_Compare/index.htm)

This tool makes it so easy to compare and synchronise SQL Server databases. SQL Compare solved a lot of issues we had with deployment at a software house I worked at a few years ago. This was so valuable to me that I joked I’d resign if they took it away from me! All good things said I have noticed the tendency of some people to sync all ~~developer junk~~ objects between databases without any checking. I guess that’s a criticism of people rather than the tool itself. To see the product in action check out these [demos](http://www.red-gate.com/products/SQL_Compare/video.htm). There are some good [whitepapers](http://www.red-gate.com/Products/SQL_Compare/technical_papers/index.htm) on Redgate’s site explaining the use of the product.

[SQLYog](http://www.webyog.com/en/sqlyog_feature_matrix.php)

A GUI Tool for [MySQL](http://www.mysql.com/) similar in look to Query Analyser from [SQL Server 2000](http://msdn.microsoft.com/en-us/library/ms950404.aspx). Whenever anybody asks about GUI tools for [MySQL](http://www.mysql.com), this is the one I [recommend](http://twitter.com/rhyscampbell/statuses/1518479686). Free and [paid](http://www.webyog.com/en/buy.php) for version are available for [download](http://www.webyog.com/en/downloads.php). I’ve been using the free Community edition for a few years now and have always appreciated its lightweight GUI and nice editor. Worth checking out over and above the pitiful [MySQL Query Browser](http://dev.mysql.com/doc/query-browser/en/mysql-query-browser-introduction.html).

[![SQLYog Main WIndow]({{ site.baseurl }}/assets/2009/04/main-multi-thumb.jpg "SQLYog Main WIndow")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/main-multi.jpg)

[SQL Server Migration Assistant for Access](http://www.microsoft.com/downloads/details.aspx?FamilyID=d842f8b4-c914-4ac7-b2f3-d25fff4e24fb&DisplayLang=en)

Now there are no more excuses for keeping those horrible Access databases! The tool isn’t perfect but provides a good start to any conversion project. For more complex projects it might [not perform well](http://www.ssw.com.au/ssw/upsizingpro/SQL_Server_Migration_Assistant_Wizard_for_Access.aspx) so it’s worth considering [commercial tools](http://www.ssw.com.au/SSW/upsizingpro/default.aspx).

[SQLInform](http://www.sqlinform.com/)

SQL Formatter for [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx), [MySQL](http://www.mysql.com), [Oracle](http://www.oracle.com), [PostgreSQL](http://www.postgresql.org/) and others. Online and desktop versions available.

[MySQL Connector / ODBC Driver](http://dev.mysql.com/downloads/connector/odbc/3.51.html)

Need to connect to MySQL from SQL Server? Use this with [Linked Servers](http://msdn.microsoft.com/en-us/library/aa213778(SQL.80).aspx) and make that integration happen fast!

