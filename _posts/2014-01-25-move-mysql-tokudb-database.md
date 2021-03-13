---
layout: post
title: Move a MySQL / TokuDB database?
date: 2014-01-25 16:52:02.000000000 +01:00
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
- TokuDB
meta:
  _edit_last: '1'
  tweetbackscheck: '1613460824'
  shorturls: a:3:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/move-mysql-tokudb-database/1743/";s:7:"tinyurl";s:26:"http://tinyurl.com/nbrgs3w";s:4:"isgd";s:19:"http://is.gd/8GOzsb";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: jvataman@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/move-mysql-tokudb-database/1743/"
---
I've been having a look at TokuDB recently and I'm quite excited about[some of its claims](http://www.tokutek.com/products/tokudb-for-mysql/ "TokuDB features"). But everything comes with its limitations!&nbsp;If you search Google for ["move tokudb database"](https://www.google.co.uk/search?q=move+tokudb+database&oq=move+tokudb+database&aqs=chrome..69i57.3641j0j7&sourceid=chrome&espv=210&es_sm=122&ie=UTF-8 "Move TokuDB Database") You'll be presented with a big page of **NO!&nbsp;** Aside from moving the entire data directory the advice here is use [mysqldump](http://dev.mysql.com/doc/refman/5.6/en/mysqldump.html "mysqldump") or change to another storage engine, i.e. [MyISAM](http://dev.mysql.com/doc/refman/5.6/en/myisam-storage-engine.html "MyISAM Storage Engine"), before moving the database files.

Either of these options are fine when your data size is fairly small but when you run into the ten of gigabytes it's simply not feasible. Thankfully there may be a workaround for this! This method for moving a [TokuDB](http://www.tokutek.com/ "TokuDB Storage Engine for MySQL") database is based on an idea I had for moving an [InnoDB](https://dev.mysql.com/doc/refman/5.6/en/innodb-storage-engine.html "InnoDB Storage Engine") database but never attempted. Perhaps that's for a future blog post!

**WARNING** - Please beware of this method. While I have not found any problems I have only attempted it in a particular set of circumstances. Your mileage may vary according to your own set of circumstances.&nbsp;&nbsp;Ensure you have backups, a contingency plan, supervision of an adult etc. The process outlined assumes all your tables use the TokuDB storage engine. If you use a mixture of storage engines you will need to modify the process slightly.

- Execute the following query on the source

```
FLUSH TABLES WITH READ LOCK;
```

N.B. You can probably get away with locking just the tables in the database you're copying but I'm doing this to keep it simple for now. It's probably sensible to leave the source locked for a short time to allow a checkpoint to occur. We don't want any relevant data hanging about in the logs!

  - &nbsp;Create an empty database on the destination.
  - Copy the database structure from source -\> destination.
  - Map TokuDB files from source and destination. Each table will have a data file (main), a status file, and a file for each index. All these will have an extension of TokuDB. All files should have a matching counterpart. The datadir can be different you simply have to make sure all these files are mapped correctly. If you have some files that are not matched you have done something wrong. Some useful queries to assist;

```
SELECT *
FROM `information_schema`.`TokuDB_file_map`
```

Generate scp commands to transfer files from the source to the destination;

```
SELECT CONCAT(' scp /var/lib/mysql/', SUBSTR(internal_file_name, 3, 255), ' root@destination:/new/destination/')
FROM information_schema.`TokuDB_file_map`
WHERE `database` = 'your_database';
```

Using your mapping you also need to generate some [mv](http://unixhelp.ed.ac.uk/CGI/man-cgi?mv "mv man page") commands to rename the files at the destination;

```
mv ./_your_database_source_XXXXXX_main_XX_XX_XX_XX.tokudb ./_your_database_destination_XXXXX_main_XX_XX_XX_XX.tokudb
mv ./_your_database_source_XXXXXX_status_XX_XX_XX_XX.tokudb ./_your_database_destination_XXXXX_status_XX_XX_XX_XX.tokudb
mv ./_your_database_source_XXXXXX_key1_XX_XX_XX_XX.tokudb ./_your_database_destination_XXXXX_key1_XX_XX_XX_XX.tokudb
```

- Execute the scp commands to move the data files from source -\> destination. No changes should be made on the source server database during this time.
- Once the datafiles have been sucessfully moved you can UNLOCK the source server.
- Rename the tokudb files on the destination server according to the mappings you generated earlier.
- chown the files to mysql:mysql (or appropriate user/group).
- Execute "mysql\>FLUSH TABLES" on your destination server.
- Check the integrity of your database using COUNT(\*) statement, CHECK TABLE, CHECKSUM etc.
- Check, and monitor, your mysql error log for any potential problems

It would probably be reasonably easy to to write a tool or script to automate this process. Does this method work for you? Please try and post a comment!

