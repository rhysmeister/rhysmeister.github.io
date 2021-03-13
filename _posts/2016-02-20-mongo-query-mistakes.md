---
layout: post
title: Mongo Query Mistakes
date: 2016-02-20 15:28:19.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MongoDB
tags:
- mongodb
meta:
  tweetcount: '0'
  tweetbackscheck: '1613215370'
  shorturls: a:3:{s:9:"permalink";s:60:"http://www.youdidwhatwithtsql.com/mongo-query-mistakes/2178/";s:7:"tinyurl";s:26:"http://tinyurl.com/jpaevyh";s:4:"isgd";s:19:"http://is.gd/ciiycr";}
  twittercomments: a:0:{}
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mongo-query-mistakes/2178/"
---
After years of writing SQL we sometimes think we know it all and treat [MongoDB](https://www.mongodb.org/) as "just another database". While there are many similarities there's a few thing to watch out for. Here's a few mistakes you'll want to avoid...

**Update syntax**

Let's say I insert the following document...

```
db.my_collection.insert ( { "name": "Rhys Campbell",
			    "tag": "Rhys loves MongoDB",
			     "age": "Not telling" } );
```

I'll now have a document that looks like this...

```
{
	"_id" : ObjectId("56c87ecc14c13ac15b0b71bd"),
	"name" : "Rhys Campbell",
	"tag" : "Rhys loves MongoDB",
	"age" : "Not telling"
}
```

Later on I want to update the value held in age. Simple, right?

```
db.my_collection.update( { "name": "Rhys Campbell" }, { "age": 21 } );
```

Now my document looks like this...

```
{ "_id" : ObjectId("56c87ecc14c13ac15b0b71bd"), "age" : 21 }
```

Whoops! Remember we're not using SQL here. We should have performed an update using the [$set](https://docs.mongodb.org/manual/reference/operator/update/set/) operator.

```
db.my_collection.update( { "name": "Rhys Campbell" }, { "$set": { "age": 21 } } );
```

When performing the update like this we end up with what we want...

```
{
	"_id" : ObjectId("56c8806114c13ac15b0b71be"),
	"name" : "Rhys Campbell",
	"tag" : "Rhys loves MongoDB",
	"age" : 21
}
```

**Delete & limit**

What do you think this might do?

```
db.my_collection.remove({}).limit(1);
```

If you know SQL you might think this is akin to...

```
DELETE FROM my_table LIMIT 1;
```

If you were to execute this you'll the following response...

```
2016-02-20T16:06:10.516+0100 E QUERY TypeError: Object WriteResult({ "nRemoved" : 5 }) has no method 'limit'
    at (shell):1:29
```

Boom, all of your documents are gone. Now, perhaps this could be considered a bug. Arguably the entire statement should be evaluated for correctness before execution. But it's important to remember we're not using SQL here and we shouldn't make any assumptions.

**And syntax**

Consider the following query...

```
db.my_collection.find ( { "age": { "$lte": 10 }, "age": { "$gte": 1 } } );
```

This is just a simple range query analogous to

```
SELECT *
FROM myTable
WHERE age >= 1
AND age <= 10;
```

Now, if we execute an [explain](https://docs.mongodb.org/manual/reference/method/cursor.explain/) on the MongoDB query we'll see this in the output...

```
...
"parsedQuery" : {
			"age" : {
				"$gte" : 1
			}
		}
...
```

Yep, the first age clause is overridden by the second. Make this mistake on a production server and you could be in trouble. We need to use the [$and](https://docs.mongodb.org/manual/reference/operator/query/and/) operator here...

```
db.my_collection.find( { "$and": [{ "age": { "$lte": 10, "$gte": 1 } }] } );
```

Looking at the explain we now get the desired result...

```
...
		"parsedQuery" : {
			"$and" : [
				{
					"age" : {
						"$lte" : 10
					}
				},
				{
					"age" : {
						"$gte" : 1
					}
				}
			]
		}
...
```

We should obviously be a little careful when working out of our comfort zones and, of course, [RTFM](https://en.wikipedia.org/wiki/RTFM).

