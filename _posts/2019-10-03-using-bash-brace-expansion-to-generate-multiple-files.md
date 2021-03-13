---
layout: post
title: Using Bash brace expansion to generate multiple files
date: 2019-10-03 09:14:35.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613441405'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/using-bash-brace-expansion-to-generate-multiple-files/2457/"
---
I needed to generate a whole bunch of files, with identical content, for a recent task. You might automatically think of using a loop for such a task but there's a much simpler method using [brace expansion](https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html) in the shell.

I wanted to generate files in the following format...

```
rhys-tmp01.txt
rhys-tmp02.txt
rhys-tmp03.txt
...
rhys-tmp91..txt
rhys-tmp92.txt
```

This is achievable with a simple one-liner once we have created the source file **rhys-tmp01.txt** :

```
tee rhys-tmp{02..92}.txt < rhys-tmp01.txt
```

Note that this uses zero-padding and this won't work in old versions of bash (probably needs to be at least version 4).

