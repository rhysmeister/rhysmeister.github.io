---
layout: post
title: Temporary & Custom Database Object Naming
date: 2009-05-19 18:24:11.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
tags:
- DBA
- temporary database objects
- temporary tables
meta:
  shorturls: a:7:{s:9:"permalink";s:77:"http://www.youdidwhatwithtsql.com/temporary-custom-database-object-naming/102";s:4:"isgd";s:17:"http://is.gd/FieP";s:5:"bitly";s:19:"http://bit.ly/kUFcA";s:5:"snipr";s:22:"http://snipr.com/it7qe";s:5:"snurl";s:22:"http://snurl.com/it7qe";s:7:"snipurl";s:24:"http://snipurl.com/it7qe";s:7:"tinyurl";s:25:"http://tinyurl.com/pn43xd";}
  tweetbackscheck: '1613212550'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/temporary-custom-database-object-naming/102/"
---
Over the years I’ve experienced various problems with temporary and custom database objects (as in objects created specifically for certain client systems). Development and deployment teams are often distinct and this can create issues. These issues have included;

- Temporary objects persisting for months or years beyond their initial purpose. 
- Temporary objects spreading from development to live environments. 
- Client specific objects spreading to other client systems. 

These issues can be exacerbated as developers leave the organisation and sometimes by reluctance to identify redundant objects. This is especially true in organisations with multiple systems accessing the same data sources. Who knows if that legacy system still running needs that table? Here are some conventions I have developed to try and eliminate these issues with minimal fuss.

**Temporary Naming Conventions**

- For objects only required on the created date start table names with ‘temp\_’, i.e. 

```
CREATE TABLE temp_customer_import
(
	/*
	-- Table definition
	*/
);
```

- For tables required for an indeterminate period of time start with ‘temp\_\<contact\_name\>’ where \<contact name\> is the person to check with as to its status. i.e. 

```
CREATE TABLE temp_rhyscampbell_customer_import
(
	/*
	-- Table definition
	*/
);
```

**Client Specific Naming Conventions**

Often I have seen client specific stored procedures created in development environments which have then been deployed to other client sites.

- Include the company name in client specific database objects, i.e. 

```
CREATE PROCEDURE usp_ACME_LTD_process_customer
AS
BEGIN
	/*
	-- Proc definition
	*/
END
```

Adherence to these simple rules should solve many of these issues painlessly. Remember, a clean database, is a happy database!

