---
layout: post
title: Check disk space with Bash
date: 2010-05-18 19:34:31.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Linux
tags:
- Bash
- Disk Space
- Linux
meta:
  _edit_last: '1'
  tweetbackscheck: '1613478435'
  shorturls: a:4:{s:9:"permalink";s:59:"http://www.youdidwhatwithtsql.com/check-disk-space-bash/770";s:7:"tinyurl";s:26:"http://tinyurl.com/2cw77ko";s:4:"isgd";s:18:"http://is.gd/ceWQY";s:5:"bitly";s:20:"http://bit.ly/9qjBf0";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-disk-space-bash/770/"
---
Now I'm working mainly with Linux and MySQL I've had to learn how to accomplish basic tasks in entirely new ways. As a [DBA](http://en.wikipedia.org/wiki/Database_administrator "Database Administrator") I like to keep an eye on disk space. I wanted something like my [Check disk space with Powershell](http://www.youdidwhatwithtsql.com/check-disk-space-with-powershell-2/195 "Check disk space with Powershell") script, but this only works with Windows, so naturally I turned to [Bash](http://www.gnu.org/software/bash/ "GNU Bash"). Here's a very basic solution that will allow you to check the disk space on multiple Linux servers quickly.

Save the script below to your home directory called **chk\_dsk\_space.sh** and mark this as executable. Open a terminal and enter **./chk\_dsk\_space.sh**. You will be prompted for the password for each server before it displays disk usage information.

```
#!/bin/bash

# Set computer names here to check
computers="user@server1 user@server2 user@server3"
# Work through each computer in the array
for c in $computers
do
                echo "================================================="
                echo "= $c"
                echo "================================================="
                command="ssh $c 'df -h'"
                eval $command
done
```

Here's some sample output.

```
rhys@linux-n0sm:~> ./chk_dsk_space.sh
=================================================
= rhys@server1
=================================================
Password:
Filesystem Size Used Avail Use% Mounted on
/dev/sda6 6.7G 4.2G 2.2G 67% /
udev 1.7G 444K 1.7G 1% /dev
/dev/sda7 8.9G 417M 8.0G 5% /home
/dev/sda2 75G 71G 4.1G 95% /windows/C
/dev/sda3 55G 47G 7.6G 86% /windows/D
=================================================
= user@server2
=================================================
Password:
Filesystem Size Used Avail Use% Mounted on
/dev/sda6 6.7G 4.2G 2.2G 67% /
udev 1.7G 444K 1.7G 1% /dev
/dev/sda7 8.9G 417M 8.0G 5% /home
/dev/sda2 75G 71G 4.1G 95% /windows/C
/dev/sda3 55G 47G 7.6G 86% /windows/D
=================================================
= user@server3
=================================================
Password:
Filesystem Size Used Avail Use% Mounted on
/dev/sda6 6.7G 4.2G 2.2G 67% /
udev 1.7G 444K 1.7G 1% /dev
/dev/sda7 8.9G 417M 8.0G 5% /home
/dev/sda2 75G 71G 4.1G 95% /windows/C
/dev/sda3 55G 47G 7.6G 86% /windows/D
```

Not as elegant as my [Powershell script](http://www.youdidwhatwithtsql.com/check-disk-space-with-powershell-2/195 "Check disk space with Powershell") but it's functional and saves me a little time each day. I'm not finding [Bash](http://www.gnu.org/software/bash/ "GNU Bash") as easy to work with as [Powershell](http://technet.microsoft.com/en-us/library/bb978526.aspx "Powershell") but that's probably more due to my lack of experience than anything else. There's an [Open Source implementation of Powershell](http://igorshare.wordpress.com/2008/04/06/pash-cross-platform-powershell-is-out-in-the-wild-announcement/ "Open Source Powershell") I've been thinking of checking out, it doesn't implement the Windows specific [cmdlets](http://msdn.microsoft.com/en-us/library/ms714395%28VS.85%29.aspx "Powershell cmdlet"), but it's been good to look at another way of doing things with [Bash](http://www.gnu.org/software/bash/ "GNU Bash").

