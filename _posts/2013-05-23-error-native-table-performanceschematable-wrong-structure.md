---
layout: post
title: "[ERROR] Native table 'performance_schema'.'table name' has the wrong structure"
date: 2013-05-23 13:21:24.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MySQL
tags:
- MySQL
- mysql_upgrade
- performance schema
meta:
  _edit_last: '1'
  _aioseop_title: Fix [ERROR] Native table 'performance_schema'.'<table name>' has
    the wrong structure
  _aioseop_description: "[ERROR] Native table 'performance_schema'.'users' has the
    wrong structure"
  tweetbackscheck: '1613453969'
  tweetcount: '0'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:97:"http://www.youdidwhatwithtsql.com/error-native-table-performanceschematable-wrong-structure/1561/";s:7:"tinyurl";s:26:"http://tinyurl.com/ovlspuy";s:4:"isgd";s:19:"http://is.gd/zOQV4V";}
  _sg_subscribe-to-comments: nico.c85@live.com.ar
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/error-native-table-performanceschematable-wrong-structure/1561/"
---
After I upgraded an instance to [MySQL 5.7](http://dev.mysql.com/doc/refman/5.7/en/mysql-nutshell.html "MySQL 5.7")&nbsp;I noted the following errors in the log;

```
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'events_statements_current' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'events_statements_history' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'events_statements_history_long' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'events_statements_summary_by_thread_by_event_name' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'events_statements_summary_by_account_by_event_name' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'events_statements_summary_by_user_by_event_name' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'events_statements_summary_by_host_by_event_name' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'events_statements_summary_global_by_event_name' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'events_statements_summary_by_digest' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'users' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'accounts' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'hosts' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'socket_instances' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'socket_summary_by_instance' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'socket_summary_by_event_name' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'session_connect_attrs' has the wrong structure
2013-05-23 11:40:24 30199 [ERROR] Native table 'performance_schema'.'session_account_connect_attrs' has the wrong structure
```

You can fix this with [mysql\_upgrade](http://dev.mysql.com/doc/refman/5.7/en/mysql-upgrade.html "mysql\_upgrade tool"). Be aware of what the tool does before running this. Most importantly bear this in mind;

> Because mysql\_upgrade invokes mysqlcheck with the --all-databases option, it processes all tables in all databases, which might take a long time to complete. Each table is locked and therefore unavailable to other sessions while it is being processed. Check and repair operations can be time-consuming, particularly for large tables.

```
mysql_upgrade -h localhost -u root -p
```

After you have restarted the instance the errors will no longer be reported.

