---
layout: post
title: Table & Tablespace encryption in MariaDB 10.1.3
date: 2015-04-14 13:42:03.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- Encryption
- mariadb
- table encryption
- tablespace encryption
meta:
  _edit_last: '1'
  tweetbackscheck: '1613450886'
  shorturls: a:3:{s:9:"permalink";s:63:"http://www.youdidwhatwithtsql.com/encryption-mariadb-1013/2064/";s:7:"tinyurl";s:26:"http://tinyurl.com/lfxu7y4";s:4:"isgd";s:19:"http://is.gd/GhQWIh";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/encryption-mariadb-1013/2064/"
---
Here's just a few notes detailing my investigations into [table & tablespace encryption in MariaDB 10.1.3.](https://blog.mariadb.org/table-and-tablespace-encryption-on-mariadb-10-1-3/ "MariaDB Table Tablespace Encryption")

**Table Encryption**

First Generate encryption keys

```
linux> openssl enc -aes-256-cbc -k secretPassword -P -md sha1
```

Next build your key file from the above output. This should be in the following format..

```
1;<iv>;<key>
```

This will look something like...

```
1;770A8A65DA156D24EE2A09327753014218;F5502320F8429037B8DAEF761B189D12F5502320F8429037B8DAEF761B189D12
```

Where 1 is the id of the key. I can't see anything specific in the documentation but presumably you'd just start a new line for each key. Place this into a file called **key.txt**. It's worth noting that you must generate the enc file in the directory you will point to in MariaDB. Decryption doesn't seem to work after they are moved.

```
linux> openssl enc -aes-256-cbc -md sha1 -k secretPassword2 -in key.txt -out key.enc
```

Don’t forget to cleanup the server of any unencrypted key files. You may wish to keep copies securely on a different server. Now we need to configure MariaDB

```
linux> vi /etc/my.cnf.d/server.cnf
```

Add the following options...

```
[mariadb-10.1]
plugin-load-add=file_key_management_plugin.so
file-key-management-plugin
encryption_algorithm=aes_cbc
file_key_management_plugin_filename=/home/mdb/key.enc
file_key_management_plugin_filekey=secretPassword2
```

Note that the filekey password will be visible to anyone on the server. In MariaDB 10.1.4 we can set it with a file path, i.e. FILE:/path/to/pwd.txt, and it would be a sensible idea to do so for production. Now create and view some data using the table encryption feature...

```
linux> systemctl restart mysql
mariadb> CREATE DATABASE encrypted;
maraidb> USE encrypted;
mariadb> CREATE TABLE test (id INTEGER NOT NULL PRIMARY KEY, col1 VARCHAR(100)) ENGINE=Innodb PAGE_ENCRYPTION=1;
mariadb> INSERT INTO test VALUES (101, ‘Hello, World!’);
mariadb> SELECT * FROM test;
# data will display
mariadb> exit
```

Lets simulate someone stealing the data files and attempting to access them. We can do this by simply renaming the key file and restarting the MariaDB server...

```
linux> mv /home/mdb/key.enc /home/mdb/_key.enc
linux> systemctl restart mysql
linux> mysql -u root -p
```

```
mariadb> USE encrypted;
mariadb> SELECT * FROM test;
```

We will receive the following error...

```
ERROR 1932 (42S02): Table ‘encrypted.test’ doesn’t exist in engine
```

The error log will also contain lots of messages complaining about missing ibd files, tablespace corruption and so on. Now put the key back…

```
linux> mv /home/mdb/_key.enc /home/mdb/key.enc
linux> systemctl restart mysql
linux> mysql -u root -p
```

The data can be accessed again...

```
mariadb> USE encryption
mariadb> SELECT * FROM test;
```

To turn off encryption on individual tables with ALTER TABLE...

```
mariadb> ALTER TABLE test PAGE_ENCRYPTION = 0;
```

**Tablespace Encryption**

I also had a quick stab at tablespace encryption but ran into a whole series of problems. Lots of the documentation appears to be wrong. For example innodb-encrypt-tables insists it must be set with a value while the [documentation shows otherwise](https://blog.mariadb.org/table-and-tablespace-encryption-on-mariadb-10-1-3/ "MariaDB table tablespace encryption"). Looks like there's been further work on encryption for 10.1.4 so I'll have another go with that.

**UPDATE 2015-04-18:** I had a play with MariaDB 10.1.4. Various issues found. See the [bug report](https://mariadb.atlassian.net/browse/MDEV-8011 "MariaDB Table Encryption Bug Report").

