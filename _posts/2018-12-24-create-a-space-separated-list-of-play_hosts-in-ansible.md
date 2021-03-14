---
layout: post
title: Create a space-separated list of play_hosts in Ansible
date: 2018-12-24 19:43:56.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613477658'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/create-a-space-separated-list-of-play_hosts-in-ansible/2417/"
---
Sometimes I need a list of hosts as a string when working with Ansible. [Pacemaker clustering](https://clusterlabs.org/) is one example. Here's a snippet of Ansible that does this..

{% highlight yaml %}
- name: Setup list of cluster hosts
      set_fact:
        host_list: {% raw %}"{{ host_list }}{{ (play_hosts.index(item) == 0) | ternary('',' ') }}{{ item }}"{% endraw %}
      loop: {% raw %}"{{ play_hosts }}"{% endraw %}
      run_once: yes
{% endhighlight %}

This play will produce the following output;

```
ok: [cnode1] => {
    "host_list": "cnode1 cnode2 cnode4 cnode3"
}
```

If you need a different separator just change the second parameter in the [ternary function](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html#id8). The below example produces a comma-separated list of play\_hosts...

{% highlight yaml %}
- name: Setup list of cluster hosts
      set_fact:
        host_list: {% raw %}"{{ host_list }}{{ (play_hosts.index(item) == 0) | ternary('',',') }}{{ item }}"{% endraw %}
      loop: {% raw %}"{{ play_hosts }}"{% endraw %}
      run_once: yes
{% endhighlight %}

```
ok: [cnode1] => {
    "host_list": "cnode1,cnode2,cnode4,cnode3"
}
```
