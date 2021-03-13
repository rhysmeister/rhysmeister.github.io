---
layout: post
title: Use restview to to make the Ansible rst documentation browsable
date: 2019-01-10 14:51:06.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
tags:
- Ansible
- ansible-doc
- EX407
- exam
- restview
meta:
  _edit_last: '1'
  tweetbackscheck: '1613480361'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/use-restview-to-to-make-the-ansible-rst-documentation-browsable/2419/"
---
The [ansible-doc](https://linux.die.net/man/1/ansible-doc) package not only installs the command line tool but also some quite detailed [Ansible](https://www.ansible.com/) documentation in rst format. It would be nice if it was browsable in a html format. Here's how that can happen (Redhat/CentOS)

First install pip and [restview](https://pypi.org/project/restview/)...

```
sudo yum install python-pip
sudo pip install restview
```

This will allow all hosts on your network to access the documentation at http://hostname:33333 if your firewall allows it.

```
restview /usr/share/doc/ansible-doc-2.7.5/rst/ --listen 33333 --allowed-hosts * &
```

Alternatively, if you're on a desktop computer, use the following to launch a browser...

```
restview /usr/share/doc/ansible-doc-2.7.5/rst/ --browser
```

**Hint** : This might be useful for those taking the [EX407 Ansible Exam](https://www.redhat.com/en/services/training/ex407-red-hat-certified-specialist-in-ansible-automation-exam) assuming you can install these packages. Having this at your fingertips could prove to be very useful should something like how to structure a jinja2 template slip your mind.

There are a few rendering issues, resulting in broken links, but nevertheless there's a lot of very useful information. I'll update this if I get around to finding a solution for that (probably a restview alternative).&nbsp; Here's a few screenshots showing what's provided...

[![ansible documentation]({{ site.baseurl }}/assets/2019/01/Screenshot-2019-01-10-at-15.42.46.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2019/01/Screenshot-2019-01-10-at-15.42.46.png) [![ansible documentation]({{ site.baseurl }}/assets/2019/01/Screenshot-2019-01-10-at-15.44.02.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2019/01/Screenshot-2019-01-10-at-15.44.02.png) [![ansible documentation]({{ site.baseurl }}/assets/2019/01/Screenshot-2019-01-10-at-15.45.15.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2019/01/Screenshot-2019-01-10-at-15.45.15.png) [![ansible documentation]({{ site.baseurl }}/assets/2019/01/Screenshot-2019-01-10-at-15.46.06.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2019/01/Screenshot-2019-01-10-at-15.46.06.png)

**UPDATE:** I took the Ansible exam and I now know this isn't really needed. Ample easily used documentation is provided.

