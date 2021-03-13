---
layout: post
title: MariaDB's federatedx engine
date: 2015-01-05 21:12:42.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MariaDB
tags:
- FederatedX
- MariDB
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/mariadbs-federatedx-engine/2015/";s:7:"tinyurl";s:26:"http://tinyurl.com/l2xbfc9";s:4:"isgd";s:19:"http://is.gd/IUjKCR";}
  tweetbackscheck: '1613417495'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mariadbs-federatedx-engine/2015/"
---
I've been experimenting a little with the [federatedx](https://mariadb.com/kb/en/mariadb/documentation/storage-engines/federatedx-storage-engine/about-federatedx/ "FederatedX Engine MariaDB") engine in [MariaDB](https://mariadb.org/en/ "MariaDB"). For those of you coming from MSSQL think linked servers and that's pretty much it, albeit with a few differences. Here's a quick primer on the basics.

Firstly you might need to enable the engine...

```
# Try "SHOW ENGINES" if federated isn't listed you need to execute the below line
INSTALL SONAME 'ha_federatedx';
```

On one MariaDB server create a database and table as below. This will use the InnoDB engine so will actually contain the data of our federated database..

```
CREATE DATABASE federated;

# Create a table with InnoDB
CREATE TABLE firstfederatedtable
(
id INTEGER NOT NULL PRIMARY KEY,
name VARCHAR(30) NOT NULL
) ENGINE='INNODB' DEFAULT CHARSET=latin1;
```

On the same server we need to create a user that will be used for the federated x connections from other servers...

```
CREATE USER federated@'%' IDENTIFIED BY 'secret';
GRANT ALL ON federated.* TO federated@'%';
FLUSH PRIVILEGES;
```

On a different MariaDB instance we need to create a FederatedX server. This provides the connection to the remote data source.

```
CREATE SERVER 'MyFederatedServer' FOREIGN DATA WRAPPER 'mysql'
OPTIONS
(
HOST '127.0.0.1',
PORT 4002,
DATABASE 'federated',
USER 'federated',
PASSWORD 'secret',
OWNER 'root'
);
```

Create the federated table. The link to the table is simply provided by name. The server you created earlier does the rest. From MariaDB 10.0.2 you don't need to specify the structure like previous versions.

```
CREATE DATABASE federated;
USE federated;
CREATE TABLE firstfederatedtable ENGINE=FEDERATED CONNECTION='MyFederatedServer';
```

If you get this error you need to look at the details of the server you created.

```
ERROR 1434 (HY000): Can't create federated table. Foreign data src error: database: 'federated' username: 'federated' hostname: 'XXXXXX'
```

If all went well you can give it a whirl...

```
# Insert some data...
INSERT INTO firstfederatedtable VALUES (1, 'Rhys Campbell'), (2, 'Dave Smith');

SELECT *
FROM firstfederatedtable;
```

Not convinced it's on your other server? Well mosey on over and take a look...

```
SELECT *
FROM firstfederatedtable;
```
