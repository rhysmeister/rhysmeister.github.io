---
layout: post
title: Update on pymmo and demo app
date: 2016-03-28 18:19:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MongoDB
tags:
- mongodb
- python
meta:
  _edit_last: '1'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:61:"http://www.youdidwhatwithtsql.com/update-pymmo-demo-app/2196/";s:7:"tinyurl";s:26:"http://tinyurl.com/j8tdvw9";s:4:"isgd";s:19:"http://is.gd/87ow6n";}
  tweetbackscheck: '1613450850'
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/update-pymmo-demo-app/2196/"
---
Just a quick update on my [pymmo](https://github.com/rhysmeister/mmo) project I started over on [github](https://github.com/rhysmeister). As I stated [earlier this year](http://www.youdidwhatwithtsql.com/technical-goals-2016/2171/) I want to get deeper into Python and would be writing tools for [MongoDB](https://www.mongodb.org/) (and potentially other databases).

It doesn't do a whole lot yet but I hope to make regular small improvements. Using the MongoDB shell for some stuff isn't really ideal. I'm not keen on looking at large [JSON](https://de.wikipedia.org/wiki/JavaScript_Object_Notation) documents to get little bits of information. This tool is an attempt to rectify some of that.&nbsp;I'm not 100% sure where I'm going with this project but I imagine it will be some type of DBA tool for MongoDB.

To list the help for the tool...

```
python mm.py --help
```

Output will look something like this...

```
usage: mm.py [-h] [--summary] [--repl]

MongoDB Manager

optional arguments:
  -h, --help show this help message and exit
  --summary Show a summary of the MongoDB Cluster Topology
  --repl Show a summary of the replicaset state
```

It's still very simple so there's only two options. It also currently uses a default connection on the localhost. More improvements will come.

We connect initially to a mongos server so if you're using a standalone shard setup this tool won't work for you.

We can display the structure&nbsp;of our cluster....

[![MongoDB Cluster Summary]({{ site.baseurl }}/assets/2016/03/MongoDB_Cluster_Summary-300x124.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2016/03/MongoDB_Cluster_Summary.png)

We can also display the status of replication...

[![MongoDB Replication Status]({{ site.baseurl }}/assets/2016/03/MongoDB_Replication_Status-300x124.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2016/03/MongoDB_Replication_Status.png)

That's it for now! If you have any suggestions, for what you'd like to see in this tool, let me know in the comments.

