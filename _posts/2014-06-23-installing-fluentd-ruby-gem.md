---
layout: post
title: Installing Fluentd Using Ruby Gem
date: 2014-06-23 15:07:58.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Linux
tags:
- fluentd
- ruby gem
meta:
  _edit_last: '1'
  tweetbackscheck: '1613083290'
  shorturls: a:3:{s:9:"permalink";s:67:"http://www.youdidwhatwithtsql.com/installing-fluentd-ruby-gem/1911/";s:7:"tinyurl";s:26:"http://tinyurl.com/ktxoy44";s:4:"isgd";s:19:"http://is.gd/2Vd1rw";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/installing-fluentd-ruby-gem/1911/"
---
Here's just a little update of the process found here, [Installing Fluentd using Ruby Gem](http://docs.fluentd.org/articles/install-by-gem "Fluentd Ruby Gem Installation") on [OpenSuSE](http://www.opensuse.org/en/ "OpenSuSE Linux") 12.1

```
zypper install ruby
zypper install ruby-devel
gem install fluentd --no-ri --no-rdoc
cd /etc
fluentd1.9 --setup ./fluent
vi /etc/fluent/fluent.conf # config file, there's some forwarding server configured here that you may want to alter or remove
gem install fluent-plugin-record-reformer # a couple of useful plugins
gem install fluent-plugin-grep
fluentd1.9 -c /etc//fluent/fluent.conf -vv & # Test fluentd
```

To make fluentd execute on startup, place the following commands in /etc/init.d/fluent, i.e.

```
#!/bin/bash

/usr/bin/fluentd1.9 -c /etc/fluent/fluent.conf
```

# Then make executable and register with the system to start on boot

```
chmod +x /etc/init.d/fluent
/usr/sbin/innserv fluent
```
