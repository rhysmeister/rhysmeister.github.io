---
layout: post
title: Parse MySQL Slow Logs with mysqlsla
date: 2010-08-10 20:36:21.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- Bash
- MySQL
meta:
  tweetbackscheck: '1613287482'
  twittercomments: a:0:{}
  shorturls: a:4:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/parse-mysql-slow-logs-with-mysqlsla/856";s:7:"tinyurl";s:26:"http://tinyurl.com/26j7qjb";s:4:"isgd";s:18:"http://is.gd/ebSOQ";s:5:"bitly";s:20:"http://bit.ly/apGfT2";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/parse-mysql-slow-logs-with-mysqlsla/856/"
---
Here's a bash script that you can use to parse multiple [MySQL Slow Query Log](http://dev.mysql.com/doc/refman/5.1/en/slow-query-log.html "MySQL Slow Query Logs") files, in one sweep, into something much more understandable. The script uses the handy utility [mysqlsla](http://hackmysql.com/mysqlsla) so make sure this is in your path.&nbsp;

> mysqlsla parses, filters, analyzes and sorts MySQL [slow](http://dev.mysql.com/doc/refman/5.0/en/slow-query-log.html), [general](http://dev.mysql.com/doc/refman/5.0/en/query-log.html), [binary](http://dev.mysql.com/doc/refman/5.0/en/binary-log.html) and [microslow patched](http://www.mysqlperformanceblog.com/2008/04/20/updated-msl-microslow-patch-installation-walk-through/) logs in order to create a customizable report of the queries and their meta-property values. Since these reports are customizable, they can be used for human consumption or be fed into other scripts to further analyze the queries. For example, to profile with [mk-query-profiler](http://maatkit.sourceforge.net/doc/mk-query-profiler.html) (a script from Baron Schwartz's [Maatkit](http://www.maatkit.org/)) every unique SELECT statement using database foo from a slow log: [source](http://hackmysql.com/mysqlsla "mysqlsla")

Place all your slow logs into a directory. Change the **sl\_dir** variable to point at this directory. When you execute the script it will create a directory, within your slow logs directory, called reports. This will contain the reports produced by [mysqlsla](http://hackmysql.com/mysqlsla "mysqlsla").

```
#!/bin/bash

# Script to process multiple mysql slow logs
# using mysqlsla http://hackmysql.com/mysqlsla

# Directory containing slow logs
sl_dir="/home/rhys/Desktop/slow_logs";

cd "$sl_dir";
#slow_logs=$(ls "$sl_dir");

# Folder for reports
if [! -d "$sl_dir"/reports]; then
                mkdir "$sl_dir"/reports;
fi

# process each slow log file
for file in "$sl_dir"/*
do
                echo "Processing file: $file";
                filename=$(basename "$file")
                mysqlsla -lt slow "$file" > "reports/$filename.rpt";
                echo "Finished processing file: $file";
done
```

The reports produced are much easier to work with than the raw mysql logs so this should be a good time saver when optimising those queries!

