---
layout: post
title: Using Bash with MySQL
date: 2010-04-19 20:58:37.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- MySQL
meta:
  tweetbackscheck: '1613478517'
  shorturls: a:4:{s:9:"permalink";s:61:"http://www.youdidwhatwithtsql.com/using-bash-with-mysql-2/748";s:7:"tinyurl";s:26:"http://tinyurl.com/yysp3ra";s:4:"isgd";s:18:"http://is.gd/bzGBS";s:5:"bitly";s:20:"http://bit.ly/9VZE8q";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/using-bash-with-mysql-2/748/"
---
Now I'm back working with [MySQL](http://www.mysql.com/) on Linux I'm starting to learn [Bash](http://en.wikipedia.org/wiki/Bash_(Unix_shell)) scripting to automate various tasks. Here's a very simple script demonstrating how to interact with MySQL from Bash.

Just set the localhost, user and pwd (password) variables to something appropriate for the MySQL server you want to query. The script will use the MySQL database, run the [SHOW TABLES](http://dev.mysql.com/doc/refman/5.0/en/show-tables.html) command, before listing each table name in the console.

```
#!/bin/bash
# MySQL details
HOST="localhost";
USER="xxxxxx";
PWD="xxxxxx";

# Output sql to a file that we want to run
echo "USE mysql; SHOW TABLES;" > /tmp/query.sql;

# Run the query and get the results
results=`mysql -h $HOST -u $USER -p$PWD < /tmp/query.sql`;

# Loop through each row
for row in $results
do
	echo $row;
done
```

![show_tables_bash_mysql.gif]({{ site.baseurl }}/assets/2010/04/show_tables_bash_mysql.gif)

If you save this to a file you'll need to make it executable. You can do this with [chmod;](http://en.wikipedia.org/wiki/Chmod)

```
chmod 755 /path/to/bash/script/script.sh
```
