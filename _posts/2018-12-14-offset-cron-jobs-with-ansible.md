---
layout: post
title: Offset cron jobs with Ansible
date: 2018-12-14 13:26:02.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
- Linux
tags:
- Ansible
- cron
meta:
  tweetbackscheck: '1613429628'
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/offset-cron-jobs-with-ansible/2414/"
---
Sometimes I want to run the same cronjob on a few hosts but I might want to offset them slightly if I'm accessing any shared resources. Here's an easy way to do that, for a small number of hosts, using [Ansible](https://www.ansible.com/)...

{% highlight yaml %}
- name: Ensure cron exists
  cron:
    name: Test Job
    minute: "{{ play_hosts.index(inventory_hostname) }}-59/5"
    job: /usr/local/bin/myscript.sh >> /var/log/log.log
    user: web
{% endhighlight %}

This would create a job, every 5 minutes, with a one minute offset compared to the previous host. So assuming four hosts we'd end up with the following cron job schedules;

| hostname | cron schedule | Will run at minutes past the hour |
| --- | --- | --- |
| host1 | 0-59/5 \* \* \* \* | 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55 |
| host2 | 1-59/5 \* \* \* \* | 1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56 |
| host2 | 2-59/5 \* \* \* \* | 2, 7, 12, 17, 22, 27, 32, 37, 42, 47, 52, 57 |
| host4 | 3-59/5 \* \* \* \* | 3, 8, 13, 18, 23, 28, 33, 38, 43, 48, 53, 58 |

For larger number of hosts it would probably be better to group hosts and run the offset via that.

