---
layout: post
title: Using the $lookup operator in MongoDB 3.2
date: 2015-11-29 16:28:54.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MongoDB
tags:
- aggregation framework
- lookup
- mongodb
meta:
  tweetbackscheck: '1612975406'
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/lookup-operator-mongodb-32/2161/";s:7:"tinyurl";s:26:"http://tinyurl.com/hxu2ml9";s:4:"isgd";s:19:"http://is.gd/CQSNxj";}
  tweetcount: '0'
  twittercomments: a:0:{}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/lookup-operator-mongodb-32/2161/"
---
I often loiter over on the [MongoDB User Google Group](https://groups.google.com/forum/#!forum/mongodb-user) and there was an interesting question posted the other day. The poster wanted to form a document like this from two collections (where foo is a document from another collection)...

```
{
    "_id" : ObjectId("ObjectId of this bar"),
    "name" : "Bar Name",
    "foo" : {
      "_id" : ObjectId("56534720e2359196cf20f791"),
      "name" : "Foo Name"
    }
  }
```

Historically this would have been a multi-step operation.&nbsp;&nbsp;We can now use the [$lookup](https://docs.mongodb.org/master/reference/operator/aggregation/lookup/) operator, in MongoDB 3.2, to achieve this in a single query using the [aggregate framework](https://docs.mongodb.org/manual/aggregation/). Here's a quick demo on how to create the above document using the aggregate framework.

Insert some test data...

```
use test

db.foo.insert({"name": "Foo Name", "lookup_id": 1});
db.bar.insert({"name" : "Bar Name", "lookup_id": 1 });
```

With this data the aim is to pull a document in from the **foo collection** by matching the lookup\_id field. We do this by running an aggregate on the **bar collection** using the **$lookup** operator.

```
db.bar.aggregate([
			{ "$match": { "lookup_id": 1 } },
			{ "$project": { "_id": 1, "name": 1, "lookup_id": 1 } },
			{ "$lookup": { "from": "foo",
					"localField": "lookup_id",
					"foreignField": "lookup_id",
					"as": "foo" }
				}
		]);
```

This produces the following document...

```
{
	"_id" : ObjectId("565b20ca7288e2c4e2b3b148"),
	"name" : "Bar Name",
	"lookup_id" : 1,
	"foo" : [
		{
			"_id" : ObjectId("565b20c97288e2c4e2b3b147"),
			"name" : "Foo Name",
			"lookup_id" : 1
		}
	]
}
```

Note how the foo document is contained within an array. This isn't completely what the posted wanted but we can sort that out with the [$unwind](https://docs.mongodb.org/manual/reference/operator/aggregation/unwind/) operator.

```
db.bar.aggregate([
			{ "$match": { "lookup_id": 1 } },
			{ "$project": { "_id": 1, "name": 1, "lookup_id": 1 } },
			{ "$lookup": { "from": "foo",
					"localField": "lookup_id",
					"foreignField": "lookup_id",
					"as": "foo" }
				},
			{ "$unwind": "$foo" },
			{ "$project": { "_id": 1, "name": 1, "foo._id": 1, "foo.name": 1 } }
		]);
```

This gives us our final document...

```
{
	"_id" : ObjectId("565b20ca7288e2c4e2b3b148"),
	"name" : "Bar Name",
	"foo" : {
		"_id" : ObjectId("565b20c97288e2c4e2b3b147"),
		"name" : "Foo Name"
	}
}
```
