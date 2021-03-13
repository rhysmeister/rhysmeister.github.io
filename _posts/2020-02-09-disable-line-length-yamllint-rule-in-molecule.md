---
layout: post
title: Disable line-length Yamllint rule in Molecule
date: 2020-02-09 16:38:51.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
tags:
- Ansible
- molecule
- yamllint
meta:
  _edit_last: '1'
  tweetbackscheck: '1613480938'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/disable-line-length-yamllint-rule-in-molecule/2464/"
---
Just a quick post on how to disable the [yamllint](https://github.com/adrienverge/yamllint) line-length rule in [molecule](https://molecule.readthedocs.io/en/latest/) tests (I'm always forgetting).

```
....roles/mongodb_repository/tasks/main.yml
      8:81 error line too long (104 > 80 characters) (line-length)
      10:81 error line too long (81 > 80 characters) (line-length)
      27:81 error line too long (124 > 80 characters) (line-length)
      34:81 error line too long (130 > 80 characters) (line-length)
```

Disable the rule as shown below...

```
lint:
  name: yamllint
  options:
    config-data:
      line-length: disable
```
