---
layout: post
title: 'TSQL: Query Pipe-Delimited text files with OPENROWSET'
date: 2009-11-10 21:49:06.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- csv
- OPENROWSET
- pipe
- text files
- TSQL
- vertical bar
meta:
  tweetbackscheck: '1613436669'
  shorturls: a:4:{s:9:"permalink";s:90:"http://www.youdidwhatwithtsql.com/tsql-query-pipe-delimited-text-files-with-openrowset/429";s:7:"tinyurl";s:26:"http://tinyurl.com/yhy26be";s:4:"isgd";s:18:"http://is.gd/4S437";s:5:"bitly";s:20:"http://bit.ly/4jj7AI";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/tsql-query-pipe-delimited-text-files-with-openrowset/429/"
---
Sometimes, when working with extracts of data, it can be a pain to have to load these files into a database in order to work with them. It's easy to use [OPENROWSET](http://technet.microsoft.com/en-us/library/ms190312.aspx) to save yourself a little time. Here's a basic example;

```
SELECT *
FROM OPENROWSET
('MSDASQL',
'Driver={Microsoft Text Driver (*.txt; *.csv)};
DefaultDir=C:\Users\Rhys\Desktop\csv;Extended properties=''ColNameHeader=True;Format=Delimited;''',
'SELECT * FROM file1.csv');
```

The **DefaultDir** property points to a directory containing standard comma separated files. Now the text files can be treated just like tables, note the SELECT query above in red text. There can be any number of files in the same directory and they can be queried simply by changing the appropriate filename, i.e. **file1.csv** to **file2.txt**.

[![csv openrowset sql server]({{ site.baseurl }}/assets/2009/11/csv_openrowset_sql_server_thumb.png "csv openrowset sql server")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/csv_openrowset_sql_server.png)

If you experience the below error you need to enable the feature on your [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) instance.

```
Msg 15281, Level 16, State 1, Line 1
SQL Server blocked access to STATEMENT 'OpenRowset/OpenDatasource' of component 'Ad Hoc Distributed Queries' because this component is turned off as part of the security configuration for this server. A system administrator can enable the use of 'Ad Hoc Distributed Queries' by using sp_configure. For more information about enabling 'Ad Hoc Distributed Queries', see "Surface Area Configuration" in SQL Server Books Online.
```

Run the below [T-SQL](http://msdn.microsoft.com/en-us/library/ms189826.aspx) to enable.

```
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
```

Now this is handy but some people, myself included, prefer to use Pipe-Delimited csv files. [Microsoft](http://www.microsoft.com/en/us/default.aspx) seem insistent on calling pipes the [vertical-bar](http://en.wikipedia.org/wiki/Vertical_bar). If you attempt the above, with pipe-delimited files, here's what you get!

[![csv pipe openrowset sql server]({{ site.baseurl }}/assets/2009/11/csv_pipe_openrowset_sql_server_thumb.png "csv pipe openrowset sql server")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/csv_pipe_openrowset_sql_server.png)

Not something we can work with very easily! By modifying a registry entry we can quickly resolve this. Usual warnings about editing your registry apply, i.e. [backup](http://support.microsoft.com/kb/322756) and know what you're doing.

Using [regedit](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/tools_regeditors.mspx?mfr=true), navigate to the following key;

```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Jet\4.0\Engines\Text
```

[![regedit jet text driver]({{ site.baseurl }}/assets/2009/11/regedit_jet_text_driver_thumb.png "regedit jet text driver")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/regedit_jet_text_driver.png)

Edit the value for the **Format** key;

[![jet text driver format registry]({{ site.baseurl }}/assets/2009/11/text_driver_format_registry_thumb.png "jet text driver format registry")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/text_driver_format_registry.png)

Change the value from **CSVDelimited** to **Delimited(|)**. To reverse this change just set the value back to **CSVDelimited** when you need to.

[![jet text driver format registry pipe]({{ site.baseurl }}/assets/2009/11/text_driver_format_registry_pipe_thumb.png "jet text driver format registry pipe")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/text_driver_format_registry_pipe.png)

Run the same query again and you'll see our data is how we need it to be!

[![csv pipe openrowset sql server fixed]({{ site.baseurl }}/assets/2009/11/csv_pipe_openrowset_sql_server_fixed_thumb.png "csv pipe openrowset sql server fixed")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/csv_pipe_openrowset_sql_server_fixed.png)

Read more about the [Text Data Source Driver](http://msdn.microsoft.com/en-us/library/bb177651.aspx) if you need to query files with other types of delimiters.

