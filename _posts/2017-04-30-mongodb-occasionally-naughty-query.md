---
layout: post
title: MongoDB and the occasionally naughty query
date: 2017-04-30 13:03:19.000000000 +02:00
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
meta:
  _edit_last: '1'
  tweetbackscheck: '1613444407'
  tweetcount: '0'
  twittercomments: a:0:{}
  shorturls: a:2:{s:9:"permalink";s:74:"http://www.youdidwhatwithtsql.com/mongodb-occasionally-naughty-query/2284/";s:7:"tinyurl";s:27:"http://tinyurl.com/ycfnkqh6";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mongodb-occasionally-naughty-query/2284/"
---
It's no secret that databases like uniqueness and high cardinality. Low cardinality columns do not make good candidates for indexes. A recent issue I had with [MongoDB](https://www.mongodb.com/)&nbsp;proved that NoSQL is no different in this regard.

The [MongoDB Query Planner](https://docs.mongodb.com/manual/core/query-plans/)&nbsp;is quite simple and works as follows (simplified)...

- If there are no usable indexes; perform a collation scan.
- If there is one usable index; use that index.
- If there is more than one usable index; generate candidate plans, score plans and cache them, use the plan with the best score.
- Periodically or due to certain actions (creating, dropping indexes); purge plans from cache and re-evaluate possible plans again.

This fairly simple method generally seems to perform well but I have observed occasional problems resulting from this method.

Assuming the following document schema;

```
{
     "_id": XXXXXXXXX,
     "email1": "fakeemail@here.com",
     "email2": "fakeemail@here.com",
     "identifier": "XXXXXXXX"
}
```

Assume the following indexes are defined;

```
{ "email1": 1, "email2": 1 }
{ "identifier": 1 }
```

The value for "identifier" was originally specified to be unique but was changed after developer feedback as they said this will "not always" be the case.

Let's assume we have the following query;

```
db.collection.find({ "email1": XXXXXX, "email2": XXXXXX, "identifier": XXXXXX });
```

For several months this query performed great always selecting the "identifier" index. As time went on we started to notice some slow instances of this query were creating higher load. Upon initial investigation we discovered that MongoDB was selecting the index on email1, email2 when the index on "identifier" was clearly a better choice. Often there would be tens of thousands of documents for a combination of (email1, email2) and just a single document for the "identifier" value. Why was MongoDB making this bad choice?

After further investigation we discover queries like this...

```
db.collection.find({ "email1": XXXXXX, "email2": XXXXXX, "identifier": "welcome-message" })
```

The key here was the value of "identifier". There were a few hundred thousand documents with the value of "welcome-message" in the system. When one of these queries, that happened to have the value of "welcome-message" came in and MongoDB decided to re-evaluate plans for this query. Sometimes MongoDB decided that "identifier" was not the best choice of index. While that was certainly true for that instance of the query it wasn't for the vast majority of them. So 99% of these queries that used to only scan one index key / document now scanned hundreds of thousands!

So how did we fix it? We thought about changing our indexes to...

```
{ "email1": 1, "email2": 1, "identifier": 1 }
```

But that would have taken us too long to deploy across our multiple shards and been quite disruptive. We could also have implemented [index filters](https://docs.mongodb.com/manual/core/query-plans/#index-filters)&nbsp;but decided against it as they don't persist through restarts. As a short term fix we deleted the documents with the "welcome-message" identifier and the developers agreed to append a random code to the end of the identifier, i.e. "welcome-message-s6geR4tgds36". This quickly resolved the problem and we've had no repeating instances since. Databases, including NoSQL ones, love uniqueness!

Possibly in the future MongoDB may implement something like [Column Statistics](https://mariadb.com/kb/en/mariadb/mysqlcolumn_stats-table/) that many other traditional databases employ to solve these problems. In the meantime we all need to be a little bit more aware of our indexes and the data being pushed into our systems.

