---
layout: post
title: The CONNECTIONPROPERTY TSQL Function
date: 2011-08-08 12:53:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- CONNECTIONPROPERTY
- TSQL
meta:
  tweetbackscheck: '1612985674'
  shorturls: a:3:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/the-connectionproperty-tsql-function/1286";s:7:"tinyurl";s:26:"http://tinyurl.com/3hdsudd";s:4:"isgd";s:19:"http://is.gd/0SQkuh";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/the-connectionproperty-tsql-function/1286/"
---
The CONNECTIONPROPERTY function can be used to obtain information about the current connection. The information available is similar to the [sys.dm\_exec\_connections](http://msdn.microsoft.com/en-us/library/ms181509.aspx "sys.dm\_exec\_connections system view") system view.

```
SELECT 'Net Transport' AS Property, CONNECTIONPROPERTY('net_transport') AS Value
UNION ALL
SELECT 'Protocol type', CONNECTIONPROPERTY('protocol_type')
UNION ALL
SELECT 'Auth scheme', CONNECTIONPROPERTY('auth_scheme')
UNION ALL
SELECT 'Local net address', CONNECTIONPROPERTY('local_net_address')
UNION ALL
SELECT 'Local TCP port', CONNECTIONPROPERTY('local_tcp_port')
UNION ALL
SELECT 'Client net address', CONNECTIONPROPERTY('client_net_address');
```

[![connectionproperty tsql function]({{ site.baseurl }}/assets/2011/08/connectionproperty_tsql_function_thumb.png "connectionproperty tsql function")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/The-CONNECTIONPROPERTY-TSQL-Function_B1E4/connectionproperty_tsql_function.png)

