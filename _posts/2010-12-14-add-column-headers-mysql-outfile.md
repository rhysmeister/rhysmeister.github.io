---
layout: post
title: Add column headers to a MySQL Outfile
date: 2010-12-14 21:11:30.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Linux
- MySQL
tags: []
meta:
  twittercomments: a:0:{}
  tweetbackscheck: '1613438703'
  shorturls: a:4:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/add-column-headers-to-a-mysql-outfile/911";s:7:"tinyurl";s:26:"http://tinyurl.com/276f6sr";s:4:"isgd";s:18:"http://is.gd/iKI4i";s:5:"bitly";s:20:"http://bit.ly/e50IjT";}
  tweetcount: '0'
  _edit_last: '1'
  _wp_old_slug: add-column-headers-to-a-mysql-outfile
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/add-column-headers-mysql-outfile/911/"
---
Unfortunately the [MySQL SELECT INTO OUTFILE](http://dev.mysql.com/doc/refman/5.0/en/select.html "MySQL SELECT INTO OUTFILE") command doesn't support an option to output the headers of the result set you are exporting. A [feature request](http://bugs.mysql.com/bug.php?id=34992 "Headers option for OUTFILE MySQL command") has been open for over 2 years to sort this with no apparent activity.

A few people have had the idea of using a [UNION ALL to include the headers](http://jasonswett.net/how-to-get-headers-when-using-mysqls-select-into-outfile/ "MySQL SELECT INTO OUTFILE UNION") but this becomes tedious with large queries. Tools like [sqlyog](http://www.webyog.com/en/ "sqlyog") are handy but can painfully slow for large result sets due to [RBAR](http://www.simple-talk.com/sql/t-sql-programming/rbar--row-by-agonizing-row/) methods.

For large result sets I like to first run;

```
# Create temp table
CREATE TEMPORARY TABLE tmp_MyTable
ENGINE = MEMORY
SELECT col1, col2, col3, col4 # etc
FROM myTable
INNER JOIN myTable2
	ON myTable.Id = myTable2.Id;

# Get the column info
DESCRIBE tmp_MyTable;
```

This will output the result set we want to export into a temporary table. We can then get the column headers using the [DESCRIBE](http://dev.mysql.com/doc/refman/5.0/en/describe.html "MySQL DESCRIBE command") command. Then I export my result set to a file using the OUTFILE command.

```
SELECT *
INTO OUTFILE '/home/user/export.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
FROM tmp_MyTable;
```

Now it's roll your sleeves up time with the Linux command-line and [sed](http://en.wikipedia.org/wiki/Sed "Unix SED command").

```
sed -i '1iOne,Two,Three,Four,Five' /home/user/export.csv
```

This command will add a single header line, to the file previously exported, and should end up looking something like below...

```
One,Two,Three,Four,Five
1,2,3,4,5
1,2,3,4,5
1,2,3,4,5
```
