---
layout: post
title: Staged service restart with Ansible
date: 2017-09-16 13:13:12.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
- Cassandra
- DBA
tags:
- Ansible
- cassandra
- Linux
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  shorturls: a:2:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/staged-service-restart-ansible/2337/";s:7:"tinyurl";s:27:"http://tinyurl.com/y7fca9s6";}
  _edit_last: '1'
  tweetbackscheck: '1613450349'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/staged-service-restart-ansible/2337/"
---
I've been working on a small project to create a [Cassandra Cluster for Development](https://github.com/rhysmeister/CassandraCluster) purposes. I'm using Vagrant and Ansible to deploy a 5-node [Cassandra](http://cassandra.apache.org/) Cluster and node #5 would always fail to join the cluster.

I checked /var/log/cassandra/cassandra.log and this is what I found;

```
INFO [InternalResponseStage:1] 2017-09-09 18:49:07,673 ColumnFamilyStore.java:406 - Initializing system_auth.roles
INFO [main] 2017-09-09 18:49:08,666 StorageService.java:1439 - JOINING: waiting for schema information to complete
ERROR [main] 2017-09-09 18:49:09,687 MigrationManager.java:172 - Migration task failed to complete
ERROR [main] 2017-09-09 18:49:10,688 MigrationManager.java:172 - Migration task failed to complete
INFO [main] 2017-09-09 18:49:12,952 StorageService.java:1439 - JOINING: schema complete, ready to bootstrap
INFO [main] 2017-09-09 18:49:12,952 StorageService.java:1439 - JOINING: waiting for pending range calculation
INFO [main] 2017-09-09 18:49:12,952 StorageService.java:1439 - JOINING: calculation complete, ready to bootstrap
Exception (java.lang.UnsupportedOperationException) encountered during startup: Other bootstrapping/leaving/moving nodes detected, cannot bootstrap while cassandra.consistent.rangemovement is true
java.lang.UnsupportedOperationException: Other bootstrapping/leaving/moving nodes detected, cannot bootstrap while cassandra.consistent.rangemovement is true
	at org.apache.cassandra.service.StorageService.joinTokenRing(StorageService.java:902)
	at org.apache.cassandra.service.StorageService.initServer(StorageService.java:681)
	at org.apache.cassandra.service.StorageService.initServer(StorageService.java:612)
	at org.apache.cassandra.service.CassandraDaemon.setup(CassandraDaemon.java:393)
	at org.apache.cassandra.service.CassandraDaemon.activate(CassandraDaemon.java:600)
	at org.apache.cassandra.service.CassandraDaemon.main(CassandraDaemon.java:689)
ERROR [main] 2017-09-09 18:49:12,960 CassandraDaemon.java:706 - Exception encountered during startup
java.lang.UnsupportedOperationException: Other bootstrapping/leaving/moving nodes detected, cannot bootstrap while cassandra.consistent.rangemovement is true
	at org.apache.cassandra.service.StorageService.joinTokenRing(StorageService.java:902) ~[apache-cassandra-3.11.0.jar:3.11.0]
	at org.apache.cassandra.service.StorageService.initServer(StorageService.java:681) ~[apache-cassandra-3.11.0.jar:3.11.0]
	at org.apache.cassandra.service.StorageService.initServer(StorageService.java:612) ~[apache-cassandra-3.11.0.jar:3.11.0]
	at org.apache.cassandra.service.CassandraDaemon.setup(CassandraDaemon.java:393) [apache-cassandra-3.11.0.jar:3.11.0]
	at org.apache.cassandra.service.CassandraDaemon.activate(CassandraDaemon.java:600) [apache-cassandra-3.11.0.jar:3.11.0]
	at org.apache.cassandra.service.CassandraDaemon.main(CassandraDaemon.java:689) [apache-cassandra-3.11.0.jar:3.11.0]
INFO [StorageServiceShutdownHook] 2017-09-09 18:49:12,988 HintsService.java:220 - Paused hints dispatch
WARN [StorageServiceShutdownHook] 2017-09-09 18:49:12,989 Gossiper.java:1538 - No local state, state is in silent shutdown, or node hasn't joined, not announcing shutdown
INFO [StorageServiceShutdownHook] 2017-09-09 18:49:12,989 MessagingService.java:984 - Waiting for messaging service to quiesce
INFO [ACCEPT-/192.168.44.105] 2017-09-09 18:49:13,002 MessagingService.java:1338 - MessagingService has terminated the accept() thread
INFO [StorageServiceShutdownHook] 2017-09-09 18:49:13,360 HintsService.java:220 - Paused hints dispatch
```

With the section of interest being;

```
Exception (java.lang.UnsupportedOperationException) encountered during startup: Other bootstrapping/leaving/moving nodes detected, cannot bootstrap while cassandra.consistent.rangemovement is true
java.lang.UnsupportedOperationException: Other bootstrapping/leaving/moving nodes detected, cannot bootstrap while cassandra.consistent.rangemovement is true
```

When I manually started the service it would join the cluster with no issues. There was clearly a timing issue here preventing the final node from joining the cassandra ring. I thought the solution might lie in using the [serial ansible keyword](http://docs.ansible.com/ansible/latest/playbooks_delegation.html#rolling-update-batch-size) but this is only applicable to the play, not the task level, and it didn't have the level of control I wanted.

I found some discussion of the issue, on the [ansible github](https://github.com/ansible/ansible/issues/12170), and adapted a workaround to include a sleep between each cassandra service start.

{% highlight yaml %}
{% raw %}
- name: Staged Cassandra Service Start
    run_once: true
    with_items: "{{ play_hosts }}"
    delegate_to: "{{ item }}"
    shell: "sleep 60 && /usr/sbin/service cassandra start"
    when: deploy_mode == True
{% endraw %}
{% endhighlight %}

This makes clever use of the [delegate\_to](http://docs.ansible.com/ansible/latest/playbooks_delegation.html#delegation) to execute a sleep and service restart on each host. This staged execution of the cassandra service start allowed all nodes to join the ring successfully.

