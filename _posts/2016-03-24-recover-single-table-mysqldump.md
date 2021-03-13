---
layout: post
title: Recover a single table from a mysqldump
date: 2016-03-24 18:34:59.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- DBA
- MariaDB
- MySQL
tags:
- DBA
- mariadb
- MySQL
- mysqldump
meta:
  tweetcount: '0'
  _edit_last: '1'
  twittercomments: a:0:{}
  tweetbackscheck: '1613410879'
  shorturls: a:3:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/recover-single-table-mysqldump/2187/";s:7:"tinyurl";s:26:"http://tinyurl.com/zw4skfo";s:4:"isgd";s:19:"http://is.gd/jywihq";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/recover-single-table-mysqldump/2187/"
---
I needed to recover the data, from a single table, from a [mysqldump](http://dev.mysql.com/doc/refman/5.7/en/mysqldump.html) containing all the databases from an entire instance. A quick google yielded this [result](http://stackoverflow.com/questions/6682916/how-to-take-backup-of-a-single-table-in-the-mysql-database). This produced a nifty little sed one-liner...

```
sed -n -e '/CREATE TABLE.*your_table_name/,/CREATE TABLE/p' mysqldump_file.sql > your_table_name.sql
```

I also wanted to import the data into a different table. Again sed came to the rescue...

```
sed -i -e 's/your_table_name/new_table_name/g' new_table_name.sql
```

As always, you should never 100% trust anything you find on the Internet. I did a quick check for any DROP statements...

```
cat new_table_name.sql | grep DROP;
```

This showed my file contained an unexpected DROP TABLE statement. It might be an idea to quick visually scan the file. If it's too big then inspecting each end of the file with head and tail would be a good idea. Quick, simple easy process to getting your data back!

