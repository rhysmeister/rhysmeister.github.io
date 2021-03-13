---
layout: post
title: 'EFK: Free Alternative to Splunk Using Fluentd'
date: 2014-07-21 15:42:40.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Big Data
- Data
- Linux
tags:
- efk
- elasticsearch
- fluentd
- kibana
- splunk
meta:
  _edit_last: '1'
  tweetbackscheck: '1613458513'
  shorturls: a:3:{s:9:"permalink";s:75:"http://www.youdidwhatwithtsql.com/efk-free-alternative-splunk-fluentd/1931/";s:7:"tinyurl";s:26:"http://tinyurl.com/nkbbdza";s:4:"isgd";s:19:"http://is.gd/ty8I3h";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/efk-free-alternative-splunk-fluentd/1931/"
---
Here is an updated version of the instructions given at&nbsp;[Free Alternative to Splunk Using Fluentd](http://docs.fluentd.org/articles/free-alternative-to-splunk-by-fluentd "EFK"). The installation was performed in [CentOS](https://www.centos.org/ "CentOS") 6.5. 1. Install ElasticSearch

```
mkdir /opt/src
cd /opt/src
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.noarch.rpm
rpm -ivh elasticsearch-1.2.1.noarch.rpm
/sbin/chkconfig --add elasticsearch
service elasticsearch start

# Move default file locations if required
mkdir /data/elasticsearch
mkdir /data/elasticsearch/data
mkdir /data/elasticsearch/tmp
mkdir /data/elasticsearch/logs
vi /etc/elasticsearch/elasticsearch.conf
chown -R elasticsearch:elasticsearch /data/elasticsearch/
service elasticsearch restart

# index status http://:9200/A/_status
# cluster health http://:9200/_cluster/health
```

2. Install Apache

```
yum install httpd
chkconfig httpd on
service httpd start
```

3. Install Kibana

```
cd /opt/src
wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz
tar xvzf kibana-3.1.0.tar.gz
mv kibana-3.1.0 kibana
mv kibana /var/www/html/
```

4. Install fluentd

```
- get script http://toolbelt.treasuredata.com/sh/install-redhat.sh
 chmod +x /usr/bin/scripts/install-redhat.sh
-- Execute script
 /usr/bin/scripts/install-redhat.sh

yum install libcurl-devel # Run if you get this error: Error installing fluent-plugin-elasticsearch:
/usr/lib64/fluent/ruby/bin/fluent-gem install fluent-plugin-elasticsearch
```

```
vi /etc/td-agent/td-agent.conf
```

```
<pre>
<source>
  type syslog
  port 42185
  tag syslog
</source>

<match syslog.**>
  type elasticsearch
  logstash_format true
  flush_interval 10s # for testing
</match>
</pre>
```

```
# Start the agent
/etc/init.d/td-agent start
```

5. Forward rsyslog to fluentd

```
vi /etc/rsyslog.conf
```

Add the text...

```
*.* @127.0.0.1:42185
```

Restart syslog and check the log for activity...

```
service rsyslog restart
# inspect the log for td-agent
tail /var/log/td-agent/td-agent.log -n 50
```

If you browse to http://hostname/kibana you shoul dbe able to get started and view syslog data coming in.

