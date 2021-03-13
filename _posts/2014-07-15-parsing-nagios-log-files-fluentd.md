---
layout: post
title: Parsing Nagios log files with fluentd
date: 2014-07-15 10:34:01.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Nagios
tags:
- fluentd
- nagios
meta:
  _edit_last: '1'
  tweetbackscheck: '1613477622'
  shorturls: a:3:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/parsing-nagios-log-files-fluentd/1926/";s:7:"tinyurl";s:26:"http://tinyurl.com/om3ar9b";s:4:"isgd";s:19:"http://is.gd/LB1CI5";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/parsing-nagios-log-files-fluentd/1926/"
---
Recently I've been experimenting with [EFK](http://docs.fluentd.org/articles/free-alternative-to-splunk-by-fluentd "ElasticSearch FluentD Kibana")&nbsp;to see how we can extract value from our machine logs. We also use [Nagios](http://www.nagios.org/ "Nagios") to monitor various services and processes within our infrastructure. The text logs produces by Nagios are not very useful in their raw form as you can see...

```
[1405413255] Auto-save of retention data completed successfully.
[1405413285] SERVICE ALERT: servername;t 3306;OK;SOFT;2;QUERY OK: 'SELECT COUNT(*) FROM t' returned 32063.000000
[1405413745] SERVICE ALERT: servername;Memory;OK;HARD;3;OK Memory 9% used. Largest process: nscd (537) = 715.14MB (18%)
[1405414075] SERVICE NOTIFICATION: nagiosadmin;servername;MySQL Uptime 3306;WARNING;notify-service-by-email;WARNING: MySQL uptime, 1105 is below threshold: 4320.
[1405414315] SERVICE ALERT: servername;PING;WARNING;SOFT;1;PING WARNING - Packet loss = 28%, RTA = 34.29 ms
[1405414325] SERVICE ALERT: servername;PING;OK;SOFT;2;PING OK - Packet loss = 0%, RTA = 33.32 ms
[1405414345] SERVICE ALERT: servername;Memory;CRITICAL;SOFT;1;CHECK_NRPE: Socket timeout after 10 seconds.
[1405414365] SERVICE NOTIFICATION: dash;servername;Service last results loaded;WARNING;notify-service-by-email;QUERY WARNING: SELECT COUNT(*) FROM t) AS t returned 0.000000
[1405414465] SERVICE ALERT: servername;Memory;CRITICAL;SOFT;2;CHECK_NRPE: Socket timeout after 10 seconds.
```

I wanted to get the service alerts in the log files into EFK. Here's how I did it. First install the [fluent-plugin-grok-parser](https://github.com/kiyoto/fluent-plugin-grok-parser "fluentd grok parser plugin") plugin. If you are using td-agent...

```
/usr/lib64/fluent/ruby/bin/fluent-gem install fluent-plugin-grok-parser
```

Or if you are using the pure ruby version...

```
gem install fluent-plugin-grok-parser
```

Next we need to create a file containing the patterns we want to match. I used the one that can be found [here](http://grokdebug.herokuapp.com/patterns "grok debugger"). There's also a useful grok debugger here if you want to test your own patterns. Click the "Nagios" link and copy and paste the next into a file; i.e. /usr/bin/scripts/nagios\_grok\_patterns.txt

Make sure td-agent can read the file...

```
chown td-agent:td-agent /usr/bin/scripts/nagios_grok_patterns.txt
```

The example here will parse a Nagios Service alert. The following log message...

```
[1405363825] SERVICE ALERT: servername;Memory;OK;SOFT;2;OK Memory 9% used. Largest process: nscd (537) = 715.14MB (18%)
```

Will be parsed by the following grok expression...

```
(?<nagios_type>SERVICE ALERT): (?<nagios_hostname>.*?);(?<nagios_service>.*?);(?<nagios_state>.*?);(?<nagios_statelevel>.*?);(?<nagios_attempt>(?:(?<![0-9.+-])(?>[+-]?(?:(?:[0-9]+(?:\.[0-9]+)?)|(?:\.[0-9]+)))));(?<nagios_message>.*)
```

and converted into the following json...

```
{
  "nagios_type": [
    [
      "SERVICE ALERT"
    ]
  ],
  "nagios_hostname": [
    [
      "servername"
    ]
  ],
  "nagios_service": [
    [
      "Memory"
    ]
  ],
  "nagios_state": [
    [
      "OK"
    ]
  ],
  "nagios_statelevel": [
    [
      "SOFT"
    ]
  ],
  "nagios_attempt": [
    [
      "2"
    ]
  ],
  "nagios_message": [
    [
      "OK Memory 9% used. Largest process: nscd (537) = 715.14MB (18%)"
    ]
  ]
}
```

The following xml should be placed into /etc/td-agent/td-agent.conf to send Nagios Service alerts to your main server. Note the **grok\_pattern** parameter uses the name of the expression in the file pointed at by **custom\_pattern\_path**.

```
<source>
  type tail
  format grok
  grok_pattern %{NAGIOS_SERVICE_ALERT}
  custom_pattern_path /usr/bin/scripts/nagios_grok_patterns.txt
  path /usr/local/nagios/var/nagios.log
  pos_file /var/log/td-agent/nagios_log.pos
  tag nagios
</source>

<match nagios>
  type record_reformer
  tag nagios.source
  source nagios
</match>

<match nagios.source>
  type forward
  <server>
    host XXX.XXX.XXX.XXX
    port 42186
  </server>
</match>
```

Restart td-agent...

```
/etc/init.d/td-agent restart
```

The td-agent log file, probably /var/log/td-agent/ts-agent.log, should contain the following message if the previous steps have been setup correctly.

```
2014-07-14 19:50:08 +0100 [info]: Expanded the pattern (?<nagios_type>SERVICE ALERT): (?<nagios_hostname>.*?);(?<nagios_service>.*?);(?<nagios_state>.*?);(?<nagios_statelevel>.*?);(?<nagios_attempt>(?:(?<![0-9.+-])(?>[+-]?(?:(?:[0-9]+(?:\.[0-9]+)?)|(?:\.[0-9]+)))));(?<nagios_message>.*) into (?<nagios_type>SERVICE ALERT): (?<nagios_hostname>.*?);(?<nagios_service>.*?);(?<nagios_state>.*?);(?<nagios_statelevel>.*?);(?<nagios_attempt>(?:(?<![0-9.+-])(?>[+-]?(?:(?:[0-9]+(?:\.[0-9]+)?)|(?:\.[0-9]+)))));(?<nagios_message>.*)
```
