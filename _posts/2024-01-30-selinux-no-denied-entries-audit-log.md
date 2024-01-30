---
layout: post
title: Why doesn't SELinux log a denied message?
date: 2024-01-30 17:46:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - selinux
  - linux
tags:
  - selinux
  - linux
---
If you're wondering why SELinux is not printing a "denied" message in /var/log/audit/audit.log it's probably because somebody wanted to hide it! Yes, it's possible to prevent an SELinux module from logging a denied message. Disable this behaviour by executing the following command:

```bash
semodule --disable_dontaudit --build
```

Re-enable again with:

```bash
semodule --build
```

For more consult the [semodule man page](https://www.linux.org/docs/man8/semodule.html)