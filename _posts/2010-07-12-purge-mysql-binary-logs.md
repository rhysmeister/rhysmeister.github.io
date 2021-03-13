---
layout: post
title: Purge MySQL Binary Logs
date: 2010-07-12 11:58:03.000000000 +02:00
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
  shorturls: a:4:{s:9:"permalink";s:61:"http://www.youdidwhatwithtsql.com/purge-mysql-binary-logs/816";s:7:"tinyurl";s:26:"http://tinyurl.com/327k9ru";s:4:"isgd";s:18:"http://is.gd/doW0T";s:5:"bitly";s:20:"http://bit.ly/9dwMJN";}
  tweetbackscheck: '1613419912'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/purge-mysql-binary-logs/816/"
---
From time-to-time you may need to manually purge binary logs on your [MySQL slaves](http://dev.mysql.com/doc/refman/5.1/en/replication.html "MySQL replication") to free up a bit of disk space. We can achieve this by using the [PURGE BINARY LOGS command](http://dev.mysql.com/doc/refman/5.5/en/purge-binary-logs.html "PURGE BINARY LOGS") from the MySQL command line client. MySQL advises the following procedure when purging these logs

> To safely purge binary log files, follow this procedure:
> 
> 1. On each slave server, use [`SHOW SLAVE STATUS`](http://dev.mysql.com/doc/refman/5.5/en/show-slave-status.html "12.4.5.35. SHOW SLAVE STATUS Syntax") to check which log file it is reading.
> 2. Obtain a listing of the binary log files on the master server with [`SHOW BINARY LOGS`](http://dev.mysql.com/doc/refman/5.5/en/show-binary-logs.html "12.4.5.2. SHOW BINARY LOGS Syntax").
> 3. Determine the earliest log file among all the slaves. This is the target file. If all the slaves are up to date, this is the last log file on the list.
> 4. Make a backup of all the log files you are about to delete. (This step is optional, but always advisable.)
> 5. Purge all log files up to but not including the target file. [source](http://dev.mysql.com/doc/refman/5.5/en/purge-binary-logs.html "MySQL purge binary logs")

The below example will purge all binary logs older than the one called **backup-master.001271**.

```
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 2640654
Server version: 5.1.34-log SUSE MySQL RPM

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> PURGE BINARY LOGS TO 'backup-master.001271'
```

Provided your slave is running this command is reasonably safe as MySQL will prevent you from purging any log files that are currently being read. If the slave thread is not running then you do have to make sure you are not purging a needed file. If you purge a needed file the slave will break when it is restarted. You can also use the [expire\_logs\_days](http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html#sysvar_expire_logs_days "expire\_logs\_days in my.cnf") variable to automatically control when binary logs are purged.

