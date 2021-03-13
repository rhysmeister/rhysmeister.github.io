---
layout: post
title: Working with the PlanCache in MongoDB
date: 2017-01-20 15:30:25.000000000 +01:00
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
- PlanCache
meta:
  _edit_last: '1'
  tweetbackscheck: '1613444531'
  twittercomments: a:0:{}
  shorturls: a:2:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/working-plancache-mongodb/2261/";s:7:"tinyurl";s:26:"http://tinyurl.com/zr77atl";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/working-plancache-mongodb/2261/"
---
I've been working a little with the [PlanCache](https://docs.mongodb.com/manual/reference/method/js-plan-cache/) in [MongoDB](http://www.mongodb.com) to troubleshoot some performance problems we've been experiencing. The contents of the Plan Cache are json documents (obviously) and this isn't great to work with in the shell. Here's a couple of javascript functions I've come up with to make things a little easier.

These are far from complete, are not well tested or suitable for all cases but they are a start for breaking down some of the complexity. If you have any suggestions or corrections let me know. I may add similar functionality to the [mmo](https://github.com/rhysmeister/mmo) tool if I can get it to display nicely.

**Display the cached queries by db / collection**

```
use admin;
# List number of plan caches for each collection in a database
var dbs = db.runCommand({ "listDatabases": 1 }).databases;

dbs.forEach(function(database) {
	if(database.name != "config") {
		db = db.getSiblingDB(database.name)
		db.getCollectionNames().forEach(function(collection) {
			var plan_count = db[collection].getPlanCache().listQueryShapes().length;
			if(plan_count > 0) {
				print(db + "." + collection + " - " + plan_count.toString());
			}
		});
	}
});
```

**Extract the critical statistics for each cached plan**

Runs against each collection in the current database. This can enable you to quickly answer...

- Number of candidate plans
- Plan score
- Number of documents returned
- Number of documents examined
- The index used
- The number of index keys examined

```
db.getCollectionNames().forEach(function(collection) {
	db[collection].getPlanCache().listQueryShapes().forEach(function(queryShape) {
		var query = queryShape.query;
		print(db + "." + collection + "\n\n");
		printjson(query)
		var plans = db[collection].getPlanCache().getPlansByQuery(query);
		print("This query shape has " + plans.length.toString() + " plans.");
		if(plans.length > 0) {
			var plan_count = 0;
			plans.forEach(function(plan) {
				//printjson(plan);
				plan_count++;
				print("Plan " + plan_count.toString());
				print("score: " + plan.reason.score);
				print("nreturned: " + plan.reason.stats.nReturned);
				print("docsExamined: " + plan.reason.stats.docsExamined);
				print("stage: " + plan.reason.stats.inputStage.stage);
				print("indexName: " + plan.reason.stats.inputStage.indexName);
				print("keysExamined: " + plan.reason.stats.inputStage.keysExamined);
			});
		}
	});
});
```

**Update** : I added this functionality to the [mm](https://github.com/rhysmeister/mmo) tool. It's pretty basic and will more than likely only work with relatively simple queries.

Getting query stats can be invoked as follows...

```
./mm --plan_cache_query "{'restaurant_id': {'\$gt': 1.0}, 'name': {'\$gt': 'a'}}" --collection test.restaurants
```

The following data is displayed...

```
There are 2 cached plans for this query shape
{'restaurant_id': {'$gt': 1.0}, 'name': {'$gt': 'a'}}
hostname port shard db collection score nReturned docsExamined stage indexName keysExamined
rhysmacbook.local 30001 rs0 test restaurants 1.0003 0 0 IXSCAN restaurant_id_1 0
rhysmacbook.local 30001 rs0 test restaurants 1.0003 0 0 IXSCAN name_1_borough_1_address.zipcode_1 0
```
