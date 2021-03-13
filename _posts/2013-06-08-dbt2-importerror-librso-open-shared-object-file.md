---
layout: post
title: 'DBT2: ImportError: libR.so: cannot open shared object file'
date: 2013-06-08 12:27:53.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- DBT2
- MySQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613455364'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:87:"http://www.youdidwhatwithtsql.com/dbt2-importerror-librso-open-shared-object-file/1594/";s:7:"tinyurl";s:26:"http://tinyurl.com/oz7wlag";s:4:"isgd";s:19:"http://is.gd/0lksmB";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/dbt2-importerror-librso-open-shared-object-file/1594/"
---
Yet another error I encounter whilst running [DBT2](http://sourceforge.net/p/osdldbt/dbt2/ci/master/tree/ "DBt2 Benchmarking Suite") tests. This time it was a problem with generating the final reports.

They are generated using a Python library which uses R under the hood. This is the error.

```
Traceback (most recent call last):
  File "/usr/local/bin/dbt2-post-process", line 14, in
    import rpy2.robjects as robjects
  File "/usr/local/lib64/python2.7/site-packages/rpy2/robjects/ __init__.py", line 15, in
    import rpy2.rinterface as rinterface
  File "/usr/local/lib64/python2.7/site-packages/rpy2/rinterface/ __init__.py", line 101, in
    from rpy2.rinterface._rinterface import *
ImportError: libR.so: cannot open shared object file: No such file or directory
```

To resolve this first locate libR.so.

```
find /usr -name libR.so
```

Then add this to your LD\_LIBRARY\_PATH variable.

```
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/lib64/R/lib
```
