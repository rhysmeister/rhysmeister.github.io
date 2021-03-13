---
layout: post
title: 'Linux: Reclaim disk space used by "deleted" files'
date: 2019-05-13 12:18:34.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- Linux
tags:
- Bash
- Linux
meta:
  _edit_last: '1'
  tweetbackscheck: '1613405293'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/reclaim-disk-space-used-by-deleted-files/2438/"
---
I had a misbehaving application consuming a large amount of space in /tmp. The files were not visible in the /tmp volume itself but [lsof](https://linux.die.net/man/8/lsof) allowed me to identify them.

```
lsof -a +L1 -c s3fs /tmp
```

```
COMMAND PID USER FD TYPE DEVICE SIZE/OFF NLINK NODE NAME
s3fs 59614 root 28u REG 253,3 584056832 0 22 /tmp/tmpfMIMLU4 (deleted)
s3fs 59614 root 29u REG 253,3 584056832 0 15 /tmp/tmpfC3KN7h (deleted)
s3fs 59614 root 31u REG 253,3 584056832 0 24 /tmp/tmpfkA6wcj (deleted)
s3fs 59614 root 32u REG 253,3 584056832 0 23 /tmp/tmpfJxs04J (deleted)
s3fs 59614 root 34u REG 253,3 584056832 0 12 /tmp/tmpfgg8Ifr (deleted)
s3fs 59614 root 35u REG 253,3 584056832 0 27 /tmp/tmpfbR2pji (deleted)
```

The best way to reclaim this disk space would be to restart the application, in this case [s3fs](https://github.com/s3fs-fuse/s3fs-fuse). Sadly I wasn't in the position to be able to do this. So a little skulldugery was in need...

It's possible to truncate the file in the proc filesystem with the pid and fd. Example below...

```
: > /proc/59614/fd/31 # Yes the command starts with a colon
```

The above example truncates the file /tmp/tmpfkA6wcj to zero bytes and releases the space to the operating system. This should be safe to use but, as always with stuff you read on the Internet, make sure you do your own testing, due diligence, keep out of reach of children and so on.

