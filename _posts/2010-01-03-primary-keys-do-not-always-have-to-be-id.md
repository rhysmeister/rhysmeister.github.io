---
layout: post
title: Primary Keys do not always have to be 'Id'!
date: 2010-01-03 15:41:50.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Data
- DBA
tags:
- database
- database design
- primary keys
meta:
  tweetbackscheck: '1613345857'
  shorturls: a:4:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/primary-keys-do-not-always-have-to-be-id/499";s:7:"tinyurl";s:26:"http://tinyurl.com/yceu44p";s:4:"isgd";s:18:"http://is.gd/5KJaQ";s:5:"bitly";s:20:"http://bit.ly/6nOZHQ";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/primary-keys-do-not-always-have-to-be-id/499/"
---
We've all more than likely spotted tables in databases with no [primary keys](http://databases.about.com/cs/administration/g/primarykey.htm). But does a primary key always have to be defined something like...

```
ALTER TABLE MyTable ADD Id INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED;
```

I think we have [ORM](http://en.wikipedia.org/wiki/Object-relational_mapping) to blame for this widespread practice of using auto-incrementing integers as PK's.

> In the ORM, these additional restrictions are placed on primary keys:
> 
> - Primary keys should be anonymous integer or numeric identifiers. 
> 
> source [http://en.wikipedia.org/wiki/Unique\_key](http://en.wikipedia.org/wiki/Unique_key)
> 
> <font style="background-color: #ffffff"></font>

I'm not saying this isn't generally sensible. Probably most of the primary keys I have ever defined have been of this type. This is the best choice if the key will be used regularly in table joins. But this need not always be the case. Lets take an example. The table below contains UK Postcodes and location information.

[![Postcode Table with Id]({{ site.baseurl }}/assets/2010/01/Postcode_Table_with_Id_thumb.png "Postcode Table with Id")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/Postcode_Table_with_Id.png)

What's my beef with this? Well, lets assume that this table is solely used for for location lookups by postcode. What is the purpose of Id? Will it ever be used in any joins to other tables? Very unlikely in my opinion. Why not change the **Postcode** column to be the primary key?

[![Postcode Table]({{ site.baseurl }}/assets/2010/01/Postcode_Table_thumb.png "Postcode Table")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/Postcode_Table.png)

I saw this exact situation in a live system a few years ago. The **Id** column was redundant but the **Postcode** column wasn't even indexed. Not good in a table with 2.4+ Million records. Careful selection of your Primary Keys not only result in fewer redundant columns but will also help with your indexing strategy.

Primary Keys, when selected like this, also protect us from screwing up our data. The **Postcode** table above contained over 300K duplicated postcodes. I've seen this cause developers to [eliminate duplicates with SQL SELECT DISTINCT](http://www.databasedev.co.uk/eliminate_duplicates.html). Lets fix our data, not our compose our queries around it causing performance hits!

For further reading see this article about [the proper selection of a Primary Key](http://www.pseudotheos.com/view_object.php?object_id=1273).

