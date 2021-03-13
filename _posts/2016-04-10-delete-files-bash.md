---
layout: post
title: Delete all but the most recent files in Bash
date: 2016-04-10 12:59:35.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- DBA
- Linux
tags:
- Bash
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:57:"http://www.youdidwhatwithtsql.com/delete-files-bash/2203/";s:7:"tinyurl";s:26:"http://tinyurl.com/zyky7mo";s:4:"isgd";s:19:"http://is.gd/WEjiYF";}
  tweetbackscheck: '1613478358'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/delete-files-bash/2203/"
---
I've been reviewing a few things I do and decided I need to be a bit smarter about managing backups. I currently purge by date only. Which is fine if everything is working and checked regularly. I wouldn't want to return from a two week holiday to find my backups had been failing, nobody checked it, but the purge job was running happily.

Here's what I came up to try and solve the problem...

```
cd /path/to/backup/location && f="backup_pattern*.sql.gz" && [$(find ${f} -type f | wc -l) -gt 14] && find ${f} -type f -mtime +14 -delete 2>/dev/null
```

Breaking this down...

cd /path/to/backup/location - cd to backup location.  
f="backup\_pattern\*.sql.gz" - set pattern to match backups in variable.  
[$(find ${f} -type f | wc -l) -gt 14] - Return true if more than 14 backups are found. Otherwise false and the command will exit at this point.  
find ${f} -type f -mtime +14 -delete 2\>/dev/null - Delete files that are older than 14 days and throw away error output to /dev/null

This approach makes use of the && (AND) operator to make its magic work. There's a lot of good discussion on the web about tackling [this problem](http://stackoverflow.com/questions/25785/delete-all-but-the-most-recent-x-files-in-bash).

