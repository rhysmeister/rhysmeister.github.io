---
layout: post
title: Install PyLint on Python 2.7
date: 2022-06-25 13:18:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - pylint
  - python
tags:
  - pylint
  - python
---
When installing [pylint](https://pypi.org/project/pylint/) with Python 2.7 you may encounter the following problem...

```
Collecting pylint
  Downloading https://files.pythonhosted.org/packages/d9/99/2958da59c0203fe40670bcbce52043b4db4e74ef0db14ab59d5b66c0ba6c/pylint-2.14.3.tar.gz (393kB)
  Running setup.py (path:/tmp/pip-build-VElRHY/pylint/setup.py) egg_info for package pylint produced metadata for project name unknown. Fix your #egg=pylint fragments.
Installing collected packages: unknown
  Running setup.py install for unknown: started
    Running setup.py install for unknown: finished with status 'done'
Successfully installed unknown-0.0.0
You are using pip version 8.1.2, however version 22.1.2 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
```

Note the package name of "unknown" in the output. Python 2.7 is no longer supported by newer versions of PyLint (from V2) and its dependencies. If you're not in the position to update Python then the following fix should work...

```
pip install 'pylint==1.9.*' 'configparser==4.0.*' 'isort==4.3.*' 'lazy-object-proxy==1.6.*'
```
