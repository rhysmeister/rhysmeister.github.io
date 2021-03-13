---
layout: post
title: How to tell if you're in a docker container
date: 2020-02-27 12:12:32.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- devops
tags:
- Docker
meta:
  _edit_last: '1'
  tweetbackscheck: '1613480464'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/how-to-tell-if-youre-in-a-docker-container/2466/"
---
Sometimes you need to know if you're inside a docker container from the shell. Here's how you can do that..

First spin up a container..

```
docker run -ti --rm ubuntu
```

You can perform a cat on the cgroups section of your process in [/proc](https://www.tldp.org/LDP/Linux-Filesystem-Hierarchy/html/proc.html). N.B. self means the calling process...

```
cat /proc/self/cgroup
```

In a docker container this will output something like...

```
14:name=systemd:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
12:pids:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
11:hugetlb:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
10:net_prio:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
9:perf_event:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
8:net_cls:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
7:freezer:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
6:devices:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
5:memory:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
4:blkio:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
3:cpuacct:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
2:cpu:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
1:cpuset:/docker/9a1abca96b85398a4fae1409a355628bd55a24d6ef0571788c04254763fe8ef6
```

For comparison this is output from a non-dockerised VM...

```
12:rdma:/
11:perf_event:/
10:devices:/user.slice
9:cpuset:/
8:memory:/user.slice
7:cpu,cpuacct:/user.slice
6:hugetlb:/
5:pids:/user.slice/user-1001.slice
4:blkio:/user.slice
3:net_cls,net_prio:/
2:freezer:/
1:name=systemd:/user.slice/user-1001.slice/session-c6.scope
```

We could grep this namespace as follows...

```
grep :/docker /proc/self/cgroup | wc -l
```

I'm not sure if there's a specific number of entries, that all docker containers have, in fact I believe it can vary. Until I know better I think unless this returns 0 I will assume I'm in a docker container.

