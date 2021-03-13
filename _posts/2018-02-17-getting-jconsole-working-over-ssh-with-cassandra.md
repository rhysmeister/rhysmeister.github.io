---
layout: post
title: Getting JConsole working over ssh with Cassandra
date: 2018-02-17 18:58:36.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Cassandra
- DBA
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613444387'
  shorturls: a:2:{s:9:"permalink";s:88:"http://www.youdidwhatwithtsql.com/getting-jconsole-working-over-ssh-with-cassandra/2352/";s:7:"tinyurl";s:27:"http://tinyurl.com/ycdc5265";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/getting-jconsole-working-over-ssh-with-cassandra/2352/"
---
I've been working with Cassandra recently and wanted to start using [JConsole](https://docs.oracle.com/javase/8/docs/technotes/guides/management/jconsole.html). JConsole exposes some pretty useful information about Cassandra and the Java environment in which it runs. It operates over [JMX](http://www.oracle.com/technetwork/articles/java/javamanagement-140525.html)&nbsp;and by default it only accepts connections from the localhost. Since we don't run GUIs on our servers and we didn't want to open up the JMX service to remote connections we needed to do a little wizardry to connect. First I thought of tunneling over ssh;

```
ssh -N -L 7199:localhost:7199 remotehost
```

This is a pretty standard way to connect a service that only listens for connections from the localhost. However this would not work at all. After much troubleshooting I came across [a solution](https://stackoverflow.com/questions/15093376/jconsole-over-ssh-local-port-forwarding).

The solution was to connect via a SOCKS proxy;

```
ssh -fN -D 7199 remotehost
```

This essentially setup up a proxy, running on port 7199 (this can be anything, it does not have to match the JMX port), to the remote node (cassandra in this case). Then we can connect with JConsole like so...

```
jconsole -J-DsocksProxyHost=localhost -J-DsocksProxyPort=7199 service:jmx:rmi:///jndi/rmi://localhost:7199/jmxrmi -J-DsocksNonProxyHosts=
```

This allows JConsole to connect to the JMX service running on the remote Cassandra node;

[caption id="attachment\_2353" align="alignnone" width="1800"] ![]({{ site.baseurl }}/assets/2018/02/JConsole.png) JConsole connectted via JMX to a remote Cassandra Node with a SOCKS proxy[/caption]

