---
layout: post
title: Running multiple instances of MySQL
date: 2010-05-15 22:26:09.000000000 +02:00
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
  tweetbackscheck: '1613343881'
  shorturls: a:4:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/running-multiple-instances-mysql/756";s:7:"tinyurl";s:26:"http://tinyurl.com/2bkk478";s:4:"isgd";s:18:"http://is.gd/caAMn";s:5:"bitly";s:20:"http://bit.ly/cWNqzT";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: yannamnaresh@yahoo.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/running-multiple-instances-mysql/756/"
---
It's reasonably easy to run multiple instances of MySQL with the [mysqld\_multi](http://dev.mysql.com/doc/refman/5.5/en/mysqld-multi.html) bash script. This can be really useful in development environments where you need to give several developers their own instance. To install multiple Microsoft SQL Server instances we have to get the install DVD and go through a laborious series of wizards. [MySQL](http://www.mysql.com "MySQL homepage") makes this easy with a few configuration files changes. In this example I'm going to outline how to configure 2 instances of MySQL by cloning an existing single instance.  
Login to your existing mysql instance and run the below statement to create a user.

```
GRANT SHUTDOWN ON *.* TO 'multi_admin'@'localhost' IDENTIFIED BY 'secret';
FLUSH PRIVILEGES;
```

The mysqld\_multi script needs this user, on each instance, to function correctly. This user only needs the [SHUTDOWN privilege](http://dev.mysql.com/doc/refman/5.1/en/privileges-.html#priv_shutdown "MySQL SHUTDOWN privilege").  
If you already have an instance of MySQL running then you'll want to shut it down before beginning. You can do this at the command prompt with...

```
sudo /sbin/service mysql stop
```

Next we need to edit the [my.cnf](http://dev.mysql.com/tech-resources/articles/mysql_intro.html#SECTION0001500000 "MySQL configuration file") file.

First we need to comment out a few lines in the mysqld section.

```
# The MySQL server
[mysqld]
#port = 3306
#socket = /var/run/mysql/mysql.sock
# Change following line if you want to store your database elsewhere
#datadir = /var/lib/mysql
```

Any other configuration options you leave in the mysqld section will serve as defaults for all MySQL instances. I'm keeping things simple here but, for production environments, you'll want to pay more attention to these settings. I'm particulary thinking of memory usage for each instance.

```
# The MySQL server
[mysqld]
#port = 3306
#socket = /var/run/mysql/mysql.sock
# Change following line if you want to store your database elsewhere
#datadir = /var/lib/mysql
```

Add the lines below replacing the username and password values the **multi\_admin** user you created earlier. The mysqld line tells the mysqld\_multi script the MySQL binary to use.

```
[mysqld_multi]
mysqld = /usr/bin/mysqld_safe # location MySQL binary
mysqladmin = /usr/bin/mysqladmin
log = /var/log/mysqld_multi.log
user = multi_admin
password = secret
```

Add the below line to create 2 instances. It is critical that each instance has its own unique values or the server will fail to start or your data could be corrupted.

```
[mysqld1]
port = 3306
datadir = /var/lib/mysql
pid-file = /var/lib/mysql/mysqld.pid
socket = /var/lib/mysql/mysql.sock
user = mysql
log-error = /var/log/mysql1.err

[mysqld2]
port = 3307
datadir = /var/lib/mysql-databases/mysqld2
pid-file = /var/lib/mysql-databases/mysqld2/mysql.pid
socket = /var/lib/mysql-databases/mysqld2/mysql.sock
user = mysql
log-error = /var/log/mysql2.err
```

Next create all the required directories on your system.

```
rhys@linux-n0sm:~> sudo mkdir /var/lib/mysql-databases/
rhys@linux-n0sm:~> sudo mkdir /var/lib/mysql-databases/mysqld2
```

Create a directory for the mysql database for instance 2.

```
rhys@linux-n0sm:~> sudo mkdir /var/lib/mysql-databases/mysql
```

Copy the mysql database files from the original instance to the second instances database directory. Then this instance will have all of the same users as instance 1.

```
sudo cp -r /var/lib/mysql/mysql/ /var/lib/mysql-databases/mysqld2/mysql
```

You can also copy across any other databases you want the new server to host. Change the owner of the data directory to the **mysql** user so the instance can read them.

```
sudo chown -R mysql:mysql /var/lib/mysql-databases
```

Finally we are ready to start up the instances.

```
rhys@linux-n0sm:~> mysqld_multi start
```

To check both instances have started correctly execute the below command.

```
rhys@linux-n0sm:~> mysqld_multi report
```

```
Reporting MySQL servers
MySQL server from group: mysqld1 is running
MySQL server from group: mysqld2 is running
```

You can see that the mysqld\_multi script has started multiple mysql processes with the following commands.

```
ps -e | grep "mysql"
10779 pts/2 00:00:00 mysqld_safe
11002 pts/2 00:00:00 mysqld
11166 pts/2 00:00:00 mysqld_safe
11279 pts/2 00:00:00 mysqld
```

To stop both instances just execute the below command.

```
rhys@linux-n0sm:~> mysqld_multi stop
```

We are also able to control individual instances by referring to the assigned number.

```
rhys@linux-n0sm:~> mysqld_multi stop 1
rhys@linux-n0sm:~> mysqld_multi report
Reporting MySQL servers
MySQL server from group: mysqld1 is not running
MySQL server from group: mysqld2 is running
rhys@linux-n0sm:~> mysqld_multi start 1
rhys@linux-n0sm:~> mysqld_multi report
Reporting MySQL servers
MySQL server from group: mysqld1 is running
MySQL server from group: mysqld2 is running
```

Check the manual for more details on [mysqld\_multi](http://dev.mysql.com/doc/refman/5.0/en/mysqld-multi.html "mysqld\_multi").

