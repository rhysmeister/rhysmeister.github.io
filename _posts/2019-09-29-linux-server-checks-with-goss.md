---
layout: post
title: Linux Server checks with Goss
date: 2019-09-29 09:45:25.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- devops
- Nagios
tags:
- goss
- nagios
meta:
  _edit_last: '1'
  tweetbackscheck: '1613424371'
  _wp_old_date: '2019-08-15'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/linux-server-checks-with-goss/2451/"
---
I've been playing a little with [goss](https://github.com/aelsabbahy/goss) recently. Goss is similar to [TestInfra](https://testinfra.readthedocs.io/en/latest/) in that it allows you to write tests to validate your infrastructure. Goss uses yaml to specify the expected state rather than python code unittests like Testinfra. It also has a couple of other interesting features making it stand out from the crowd...

The first is a test auto-generation feature. Have a service you want to monitor? Simply run this...

```
goss autoadd nagios
```

Goss will autodiscover various things about that service. Here's what it found out about the [Nagios](https://www.nagios.org/) service....

```
package:
  nagios:
    installed: true
    versions:
    - 4.4.3
service:
  nagios:
    enabled: true
    running: true
user:
  nagios:
    exists: true
    uid: 999
    gid: 998
    groups:
    - nagios
    home: /var/spool/nagios
    shell: /sbin/nologin
group:
  nagios:
    exists: true
    gid: 998
process:
  nagios:
    running: true
```

The state of the nagios service can then be validated with...

```
goss validate
```

```
.............

Total Duration: 0.037s
Count: 13, Failed: 0, Skipped: 0
```

We can also setup a http health endpoint...

```
goss serve &
```

```
2019/08/14 15:05:42 Starting to listen on: :8080
```

When we hit the endpoint the tests are executed...

```
curl http://localhost:8080/healthz
```

```
2019/08/14 15:06:48 127.0.0.1:42792: requesting health probe
2019/08/14 15:06:48 127.0.0.1:42792: Stale cache, running tests
.............

Total Duration: 0.036s
Count: 13, Failed: 0, Skipped: 0
```

We can also run the tests as a Nagios check...

```
goss validate --format nagios
```

```
GOSS OK - Count: 13, Failed: 0, Skipped: 0, Duration: 0.032s
```

Note the execution speeds above. Goss outperforms python-based testing tools like TestInfra by a significant margin.

