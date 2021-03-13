---
layout: post
title: '"could not open session" error in docker container'
date: 2019-03-17 14:42:52.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- devops
tags:
- Ansible
- devops
- Docker
meta:
  _edit_last: '1'
  tweetbackscheck: '1613297433'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/could-not-open-session-error-in-docker-container/2434/"
---
I received the following error, attempting to cat a log file, inside a docker contain when troubleshooting another issue...

```
TASK [setup_cassandra : shell] *************************************************
changed: [testhost] => {"changed": true, "cmd": "cat /var/log/cassandra/*", "delta": "0:00:00.004140", "end": "2019-03-16 18:48:28.684133", "rc": 0, "start": "2019-03-16 18:48:28.679993", "stderr": "", "stderr_lines": [], "stdout": "could not open session", "stdout_lines": ["could not open session"]}
```

A bit of googling suggested the use of the [--privileged flag](https://docs.docker.com/engine/reference/commandline/run/) of the docker command. I was using the ansible-test tool, which invokes docker, so the equivalent flag was --docker-privileged

```
test/runner/ansible-test integration -v cassandra_backup --docker centos6 --docker-privileged
```

This flag then allowed me to continue with my troubleshooting.

