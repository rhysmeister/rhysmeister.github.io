---
layout: post
title: Troubleshooting the sh mysql_load_db.sh script for dbt2
date: 2013-06-04 13:30:21.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613463872'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:84:"http://www.youdidwhatwithtsql.com/troubleshooting-sh-mysqlloaddbsh-script-dbt2/1579/";s:7:"tinyurl";s:26:"http://tinyurl.com/obhpa45";s:4:"isgd";s:19:"http://is.gd/O6pHFA";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/troubleshooting-sh-mysqlloaddbsh-script-dbt2/1579/"
---
I've been working with [dbt2](http://dev.mysql.com/downloads/benchmarks.html "MySQL DBT2 Benchmark tool")&nbsp;benchmarking tool recently and had a few issues I thought I'd detail here for anyone else having the same issues. I was attempting to load the dbt2 database with test data;

```
sh mysql_load_db.sh --database dbt2 --path /tmp/dbt2-w3 --mysql-path /usr/bin/mysql --user root --password secret
```

The script threw the following error;

```
Loading of DBT2 dataset located in /tmp/dbt2-w3 to database dbt2.

DB_ENGINE: INNODB
DB_HOST: localhost
DB_PORT: 3306
DB_USER: root
DB_SOCKET:
PARTITION:
PARTITION_NO:
NDB_DISK_DATA:
USING_HASH:
LOGFILE_GROUP: lg1
TABLESPACE: ts1
TABLESPACE SIZE: 12G
LOGFILE SIZE: 256M
DROP/CREATE Database
/usr/bin/mysql -p rootpa55 -h localhost -u root --protocol=tcp --port 3306 -e "drop database if exists dbt2"
Enter password:
ERROR 1049 (42000): Unknown database 'secret'
ERROR: rc=1
SCRIPT INTERRUPTED
```

Whatever combination or order of switches I provided the script it always complained. To get the script to run I simply hard-coded the appropriate switch in the call to the mysql client;

```
vi mysql_load_db.sh
```

Search for a function called **command\_exec** and change this line...

```
eval "$1";
```

To the following;

```
eval "$1 -psecret";
```

Replacing "secret" for the appropriate mysql user password. While this solved the initial problem it did uncover another problem with the load;

```
sh mysql_load_db.sh --database dbt2 --path /tmp/dbt2-w3 --mysql-path /usr/bin/mysql --user root
```

DB\_ENGINE: INNODB  
DB\_HOST: localhost  
DB\_PORT: 3306  
DB\_USER: root  
DB\_SOCKET:  
PARTITION:  
PARTITION\_NO:  
NDB\_DISK\_DATA:  
USING\_HASH:  
LOGFILE\_GROUP: lg1  
TABLESPACE: ts1  
TABLESPACE SIZE: 12G  
LOGFILE SIZE: 256M  
DROP/CREATE Database

Creating table STOCK in INNODB  
Creating table ITEM in INNODB  
Creating table ORDER\_LINE in INNODB  
Creating table ORDERS in INNODB  
Creating table NEW\_ORDER in INNODB  
Creating table HISTORY in INNODB  
Creating table CUSTOMER in INNODB  
Creating table DISTRICT in INNODB  
Creating table WAREHOUSE in INNODB

Loading table customer  
Loading table district  
Loading table history  
Loading table item  
Loading table new\_order  
Loading table order\_line  
ERROR 1292 (22007) at line 1: Incorrect datetime value: '' for column 'ol\_delivery\_d' at row 20083  
ERROR: rc=1  
SCRIPT INTERRUPTED  
To fix this edit the **mysql\_load\_db.sh** and search for the **command\_exec** function. Change this line...

```
"$MYSQL $DB_NAME -e \"LOAD DATA $LOCAL INFILE \\\"$DB_PATH/$FN.data\\\" \
```

To...

```
"$MYSQL $DB_NAME -e \"LOAD DATA $LOCAL INFILE \\\"$DB_PATH/$FN.data\\\" IGNORE\
```

The [IGNORE](http://dev.mysql.com/doc/refman/5.1/en/load-data.html "IGNORE keyword FOR LOAD DATA INFILE MySQL") will skip any errors so the rest of the process does not fail. Now I was able to load my data!

```
sh mysql_load_db.sh --database dbt2 --path /tmp/dbt2-w3 --mysql-path /usr/bin/mysql --user root
```

```
Loading of DBT2 dataset located in /tmp/dbt2-w3 to database dbt2.

DB_ENGINE: INNODB
DB_HOST: localhost
DB_PORT: 3306
DB_USER: root
DB_SOCKET:
PARTITION:
PARTITION_NO:
NDB_DISK_DATA:
USING_HASH:
LOGFILE_GROUP: lg1
TABLESPACE: ts1
TABLESPACE SIZE: 12G
LOGFILE SIZE: 256M
DROP/CREATE Database

Creating table STOCK in INNODB
Creating table ITEM in INNODB
Creating table ORDER_LINE in INNODB
Creating table ORDERS in INNODB
Creating table NEW_ORDER in INNODB
Creating table HISTORY in INNODB
Creating table CUSTOMER in INNODB
Creating table DISTRICT in INNODB
Creating table WAREHOUSE in INNODB

Loading table customer
Loading table district
Loading table history
Loading table item
Loading table new_order
Loading table order_line
Loading table orders
Loading table stock
Loading table warehouse
```
