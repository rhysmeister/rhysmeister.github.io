---
layout: post
title: 'Ansible: stop / start services on random hosts'
date: 2019-01-27 18:09:36.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
- Cassandra
tags:
- Ansible
- cassandra
meta:
  _edit_last: '1'
  tweetbackscheck: '1613477834'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ansible-stop-start-services-on-random-hosts/2429/"
---
In the coming weeks I'm performing some testing of a new application on a [Cassandra](http://cassandra.apache.org/) cluster. To add a little randomness into some of the tests I thought it would be interesting to give the Cassandra service a little kick. I created a simple [Ansible](https://www.ansible.com/) playbook this afternoon that does this. A simple [Chaos Monkey](https://github.com/Netflix/chaosmonkey) if you like. Here's the basic flow of the playbook...

1. Select random host from play\_hosts.  
2. Stop service.  
3. Wait for interval.  
4. Start service.  
5. Wait for Service back up, Port?  
6. Wait for second defined interval.

These tasks are repeated n number of times as specified by the user. This playbook is interesting because it uses a couple of nifty tricks...

The first is a method to dynamically generate a list to iterate over. This is how we control the number of times we restart the service.

{% highlight yaml %}
{% raw %}
- name: Generate a list we will iterate over
    set_fact:
      restart_iterations: "{{ restart_iterations | default([]) + [item | int] }}"
    with_sequence: start=1 end="{{ max_iterations }}"
    run_once: yes
{% endraw %}
{% endhighlight %}

The second uses the [loop](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html#loop-control) construct. The **current\_iteration** variable is made available in the **tasks.yml** file

{% highlight yaml %}
{% raw %}
- name: Run main tasks file
    include_tasks: tasks.yml
    loop: "{{ restart_iterations }}"
    loop_control:
      loop_var: current_iteration
{% endraw %}
{% endhighlight %}

The playbook can optionally produce a log to make it a little easier to see what nodes it's executing on...

```
tail -f /tmp/service_restarter.log
2019-01-27 18:38:51 CET - Current iteration is 1 and is executing on cnode2
2019-01-27 18:41:18 CET - Current iteration is 2 and is executing on cnode4
2019-01-27 18:43:47 CET - Current iteration is 3 and is executing on cnode3
2019-01-27 18:46:15 CET - Current iteration is 4 and is executing on cnode3
2019-01-27 18:48:42 CET - Current iteration is 5 and is executing on cnode5
2019-01-27 18:51:07 CET - Current iteration is 6 and is executing on cnode2
2019-01-27 18:53:34 CET - Current iteration is 7 and is executing on cnode1
2019-01-27 18:56:03 CET - Current iteration is 8 and is executing on cnode4
2019-01-27 18:58:29 CET - Current iteration is 9 and is executing on cnode4
2019-01-27 19:00:55 CET - Current iteration is 10 and is executing on cnode2
```

Here's how you might execute the playbook...

{% highlight bash %}
{% raw %}
ansible-playbook -l cassandra -i inventory service_restarter.yml
{% endraw %}
{% endhighlight %}

The playbook is available over on my [github/ServiceRestarter](https://github.com/rhysmeister/ServiceRestarter).

While this playbook was designed with Cassandra in mind it should work for any service that listens on a TCP port. See the [README](https://github.com/rhysmeister/ServiceRestarter/blob/master/README.md) file for an explanation of the variables.

