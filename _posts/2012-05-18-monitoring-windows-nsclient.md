---
layout: post
title: Monitoring Windows with NSClient++
date: 2012-05-18 14:59:49.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Nagios
tags:
- monitoring
- nagios
- nsclient++
- nscp
meta:
  _sg_subscribe-to-comments: milos0505@gmail.com
  _edit_last: '1'
  tweetbackscheck: '1613460890'
  shorturls: a:3:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/monitoring-windows-nsclient/1479";s:7:"tinyurl";s:26:"http://tinyurl.com/8y24fae";s:4:"isgd";s:19:"http://is.gd/D3jQKc";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/monitoring-windows-nsclient/1479/"
---
I've been playing with [Nagios](http://www.nagios.org/ "Nagios") recently and have been using [NSClient++](http://www.nsclient.org/nscp/ "NSClient++ for Nagios") to monitor Windows machines. In some places the documentation wasn't too great so I thought I'd outline some service checks I've got working here. The service definitions here would normally be defined on the Nagios host not on the Windows box itself.

**Check Windows Memory Usage with NSClient++**

Warn if memory usage reaches 85%, critical if 90%.

```
define service {
        use generic-service
        host_name windoze
        service_description Memory Usage
        check_command check_nt!MEMUSE!-w 85 -c 90
        servicegroups windows
}
```

**Check Windows Disk Usage with NSClient++**

Warn if the disk is 85% full, critical at 90%. It seems there's no way to check all disks at once. You have to setup a check for each one separately.

```
define service {
        use generic-service
        host_name windoze
        service_description C:\ Drive Space
        check_command check_nt!USEDDISKSPACE!-l c -w 85 -c 90
        servicegroups windows
}
```

**Check Windows Service is running with NSClient++**

This will alert if the MSSQLSERVER service is not running.

```
define service {
        use generic-service
        host_name windoze
        service_description SQL Server Engine
        check_command check_nt!SERVICESTATE!-d SHOWALL -l MSSQLSERVER
        servicegroups sql-server
}
```

**Check a Windows Executable is running with NSClient++**

This will check that the process sqlservr.exe is running.

```
define service {
        use generic-service
        host_name windoze
        service_description Process Check Test
        check_command check_nt!PROCSTATE!-d SHOWALL -l sqlservr.exe=started
        servicegroups windows
}
```

**Check SQL Server CPU Time with NSClient++**

This check accesses Windows performance counters. Documentation on this wasn't great. Consult the list of counters in perfmon.exe for what's available. Two backslahes are needed.

```
define service {
        use generic-service
        host_name windoze
        service_description Perf CPU Counter Test
        check_command check_nt!COUNTER!-l "\\Process(sqlservr)\\% Processor Time","CPU Time for sqlservr is %.f.0 %%","Processor Time"
        servicegroups windows
}
```

**&nbsp;Check SQL Server Memory Working Set with NSClient++**

Virtually the same setup as the previous check. Just a different counter is accessed to return the memory used by SQL Server.

```
define service {
        use generic-service
        host_name windoze
        service_description Perf Mem Counter Test
        check_command check_nt!COUNTER! -d SHOWALL -l "\\Process(sqlservr)\\Working Set","Mem Working Set for sqlservr is %.f.0","Working Set"
        servicegroups windows
}
```

**Check SQL Server User Connections with NSClient++**

Another performance monitor counter check. This one returns the number of user connections to the SQL Server instance.

```
define service {
        use generic-service
        host_name windoze
        service_description SQL Server User Connections
        check_command check_nt!COUNTER!-d SHOWALL -l "\\SQLServer:General Statistics\\User Connections","Number of Users: %.f",Users
        servicegroups sql-server
}
```
