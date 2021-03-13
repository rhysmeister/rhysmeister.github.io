---
layout: post
title: Backing up the structure of MySQL databases
date: 2011-01-25 21:00:20.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Linux
- MySQL
tags:
- Bash
- MySQL
- mysqldump
meta:
  tweetbackscheck: '1613461909'
  shorturls: a:4:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/backing-up-the-structure-of-mysql-databases/1063";s:7:"tinyurl";s:26:"http://tinyurl.com/642xawq";s:4:"isgd";s:19:"http://is.gd/rtuW7S";s:5:"bitly";s:20:"http://bit.ly/hUaX5N";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/backing-up-the-structure-of-mysql-databases/1063/"
---
Today I wanted a quick and easy way to generate a backup of the structure of all MySQL databases in one easy hit. Here's a couple of ways you can do this with the tools you're likely to find everywhere.

Firstly, we can use the following query to generate a list of [mysqldump](http://dev.mysql.com/doc/refman/5.1/en/mysqldump.html "mysqldump database backup program") commands. The backups generated here pretty much just contain tables, triggers and functions so customise the command to your needs. Just change the output directory from . **/home/rhys**.

```
SELECT CONCAT('mysqldump -d --routines -h mysql_host -u username -pSecret ', SCHEMA_NAME, ' > "/home/rhys/Desktop/', SCHEMA_NAME, '.sql"')
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME NOT IN ('mysql', 'information_schema', 'performance_schema');
```

These commands can be copied and then pasted into a terminal to be executed.

Here's a pure bash way of achieving the same thing. The script is called on the command line with the MySQL host, user name and password supplied as parameters. Backups are generated in the current users home directory in the format **db\_name.sql**.

```
#!/bin/bash
# MySQL details passed on command line
HOST=$1
USER=$2;
PWD=$3;

# Query to get database excluding a few system ones
QUERY="SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME NOT IN ('mysql','information_schema','performance_schema')";
# Run the query and get the results
results=`mysql -h $HOST -u $USER -p$PWD -N -e "$QUERY"`;

# Loop through each row
for db in $results
do
	bkp="mysqldump -d --routines -h $HOST -u $USER -p$PWD $db > '$HOME/$db.sql'";
	echo "Backing up $db...";
	eval $bkp;
done
```

Save this to a file called **backup\_mysql.sh** and don;t forget to do a **chmod + x** to make the script executable. The backup can be executed from the command line with;

```
./backup_mysql.sh localhost username password
```

[![mysqldump backup databases]({{ site.baseurl }}/assets/2011/01/mysqldump_backup_databases_thumb.png "mysqldump backup databases")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/8f94a578fd9d_11B87/mysqldump_backup_databases.png)

