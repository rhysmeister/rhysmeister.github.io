---
layout: post
title: Ignore PEP rules with Molecule / Testinfra / flake8
date: 2019-12-19 08:00:32.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
tags:
- flake8
- molecule
- pep8
- testinfra
meta:
  _edit_last: '1'
  tweetbackscheck: '1613432687'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ignore-pep-rules-with-molecule-testinfra-flake8/2462/"
---
I'm always forgetting how to configure my [molecule.yml](https://molecule.readthedocs.io/en/stable/configuration.html) file to ignore certain [PEP8](https://www.python.org/dev/peps/pep-0008/) rules. Here's a quick example showing how to ignore the [E501](https://lintlyci.github.io/Flake8Rules/rules/E501.html) Line too long rule:

```
verifier:
  name: testinfra
  lint:
    name: flake8
    options:
      ignore: 'E501'
```
