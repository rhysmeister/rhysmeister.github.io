---
layout: post
title: A quick mongofile demo
date: 2016-11-15 21:23:34.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MongoDB
tags:
- gridfs
- mongodb
meta:
  shorturls: a:2:{s:9:"permalink";s:60:"http://www.youdidwhatwithtsql.com/quick-mongofile-demo/2251/";s:7:"tinyurl";s:26:"http://tinyurl.com/j5dzjpo";}
  _edit_last: '1'
  tweetbackscheck: '1613450740'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/quick-mongofile-demo/2251/"
---
Here's a few simple examples of using the [mongofiles](https://docs.mongodb.com/manual/reference/program/mongofiles/#commands) utility to use&nbsp;[MongoDB GridFS](https://docs.mongodb.com/manual/core/gridfs/)&nbsp;to store, search and retrieve files.

**Upload a file into MongoDB into a database called gridfs**

```
mongofiles -u admin -padmin --authenticationDatabase admin --db gridfs put xfiles.504-amc.avi
```

```
2016-11-15T21:44:30.728+0100	connected to: localhost
added file: xfiles.504-amc.avi
```

Two collections will be created in the gridfs database; fs.files and fs.chunks...

```
mongos> show dbs
admin 0.000GB
config 0.001GB
gridfs 0.343GB
test 0.003GB
mongos> use gridfs
switched to db gridfs
mongos> show collections
fs.chunks
fs.files
mongos> db.fs.files.findOne();
{
	"_id" : ObjectId("582b74e4d60dc3078824242c"),
	"chunkSize" : 261120,
	"uploadDate" : ISODate("2016-11-15T20:51:17.412Z"),
	"length" : 133881469,
	"md5" : "dfdc2e394e63f4b63591e0fc6823f3f9",
	"filename" : "xfiles.504-amc.avi"
}
```

Upload a few more files...

```
mongofiles -u admin -padmin --authenticationDatabase admin --db gridfs put the.venture.bros.s06e02.hdtv.x264-2hd.mp4
mongofiles -u admin -padmin --authenticationDatabase admin --db gridfs put the.venture.bros.s06e03.hdtv.x264-w4f.mp4
```

**List files available in the gridfs database**

```
mongofiles -u admin -padmin --authenticationDatabase admin --db gridfs list
```

```
2016-11-15T22:08:06.305+0100	connected to: localhost
xfiles.504-amc.avi	367001600
the.venture.bros.s06e02.hdtv.x264-2hd.mp4	133881469
the.venture.bros.s06e03.hdtv.x264-w4f.mp4	144681933
the.venture.bros.s06e07.hdtv.x264-mtg.mp4	128260039
```

**Search for files with a .avi extension**

```
mongofiles -u admin -padmin --authenticationDatabase admin --db gridfs search .avi
```

```
2016-11-15T22:09:22.398+0100	connected to: localhost
xfiles.504-amc.avi	367001600
```

**Download a file**

Download the xfiles.504-amc.avi file to /tmp/downloaded\_file.avi

```
mongofiles -u admin -padmin --authenticationDatabase admin --db gridfs get xfiles.504-amc.avi --local /tmp/downloaded_file.avi
```

Verify the file;

```
file /tmp/downloaded_file.avi
/tmp/downloaded_file.avi: RIFF (little-endian) data, AVI, 640 x 368, 23.98 fps, video: DivX 3 Low-Motion, audio: Dolby AC3 (stereo, 48000 Hz)
```

**Delete a file**

Delete the xfiles.504-amc.avi file;

```
mongofiles -u admin -padmin --authenticationDatabase admin --db gridfs delete xfiles.504-amc.avi
```

```
2016-11-15T22:14:16.192+0100	connected to: localhost
successfully deleted all instances of 'xfiles.504-amc.avi' from GridFS
```
