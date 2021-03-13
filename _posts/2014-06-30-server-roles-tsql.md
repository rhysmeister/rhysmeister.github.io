---
layout: post
title: Server Roles with TSQL
date: 2014-06-30 23:47:59.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
- T-SQL
tags:
- Permissions
- server roles
- TSQL
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:57:"http://www.youdidwhatwithtsql.com/server-roles-tsql/1923/";s:7:"tinyurl";s:26:"http://tinyurl.com/prpkbcq";s:4:"isgd";s:19:"http://is.gd/azGp6x";}
  tweetbackscheck: '1613450572'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/server-roles-tsql/1923/"
---
Here's a few bits of TSQL you can use when working with [Server-Level Roles](http://msdn.microsoft.com/en-gb/library/ms188659(v=sql.110).aspx "Server-Level Roles SQL Server 2012") in SQL Server 2012.

List the server roles setup on an instance...

```
EXEC sp_helpsrvrole;
```

List the members of a role...

```
EXEC sp_helpsrvrolemember 'sysadmin';
```

List the permissions assigned to a server-level role...

```
EXEC sp_srvrolepermission 'sysadmin';
```

Test is a login is the member of a role...

```
SELECT IS_SRVROLEMEMBER('sysadmin', 'DOMAIN\Joe_Bloggs');
```

A DMV is provided to review server-level role assignments...

```
SELECT *
FROM sys.server_role_members;
```

Now something a little more useful to the human eye...

```
SELECT SUSER_NAME(member_principal_id) AS username,
	   SUSER_NAME(role_principal_id) [role]
FROM sys.server_role_members;
```

We can also create [User-Defined Server-Level Roles](http://msdn.microsoft.com/en-us/library/ee677627(v=sql.110).aspx "User-Defined Server-Level Roles SQL Server 2012") in SQL Server 2012.

This example will DENY the VIEW ANY DATABASE permission. First create the role...

```
USE [master];
GO

CREATE SERVER ROLE [deny_view_any_database];
GO
```

Add any members to the role...

```
ALTER SERVER ROLE [deny_view_any_database] ADD MEMBER [DOMAIN\Joe_Bloggs];
GO
```

Deny the permission from the role...

```
use [master];
GO

DENY VIEW ANY DATABASE TO [deny_view_any_database];
GO
```
