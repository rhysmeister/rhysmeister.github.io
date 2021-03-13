---
layout: post
title: 'The blame game: Who deleted that file? Working with auditd'
date: 2017-02-02 12:27:48.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- Linux
tags:
- audit
- blame
- Linux
- redhat
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461550'
  shorturls: a:2:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/blame-game-deleted-file-working-auditd/2267/";s:7:"tinyurl";s:26:"http://tinyurl.com/jrsa2o9";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/blame-game-deleted-file-working-auditd/2267/"
---
<p>I've recently had an issue where a file was disappearing that I couldn't explain. Without something to blame it on I search for a method to log change to file and quickly found <a href="https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html">audit</a>. Audit is quite extensive and can capture a vast array of information. I'm only interested in monitoring a specific file here. This is for <a href="http://www.redhat.com">Redhat</a> based systems.</p>
<p>First you'll need to install / configure audit if it's not already;</p>
<pre lang="Bash">yum install audit
</pre>
<p>Check the service is running...</p>
<pre lang="Bash">service auditd status
</pre>
<p>Let's create a dummy file to monitor...</p>
<pre lang="Bash">echo "Please don't delete me\!" > /path/to/file/rhys.txt;
</pre>
<p>Add a rule to audit for the file. This adds a rule to watch the specified file with the tag *whodeletedmyfile*.</p>
<pre lang="Bash">auditctl -w /path/to/file/rhys.txt -k whodeletedmyfile
</pre>
<p>You can search for any records with;</p>
<pre lang="Bash">ausearch -i -k whodeletedmyfile
</pre>
<p>The following information will be logged after you add the rule;</p>
<pre>----
type=CONFIG_CHANGE msg=audit(02/02/2017 13:09:59.967:226727) : auid=user@domain.local ses=12425 op="add rule" key=whodeletedmyfile list=exit res=yes
</pre>
<p>Now let's delete the file and search the audit log again;</p>
<pre lang="Bash">rm /path/to/file/rhys.txt &amp;&amp; ausearch -i -k whodeletedmyfile
</pre>
<p>We'll see the following information;</p>
<pre>----
type=CONFIG_CHANGE msg=audit(02/02/2017 13:09:59.967:226727) : auid=user@domain.local ses=12425 op="add rule" key=whodeletedmyfile list=exit res=yes
----
type=PATH msg=audit(02/02/2017 13:10:26.939:226735) : item=1 name=/path/to/file/rhys.txt inode=42 dev=fd:04 mode=file,644 ouid=root ogid=root rdev=00:00 nametype=DELETE type=PATH msg=audit(02/02/2017 13:10:26.939:226735) : item=0 name=/path/to/file/ inode=28 dev=fd:04 mode=dir,700 ouid=user@domain.local ogid=user@domain.local rdev=00:00 nametype=PARENT type=CWD msg=audit(02/02/2017 13:10:26.939:226735) : cwd=/root type=SYSCALL msg=audit(02/02/2017 13:10:26.939:226735) : arch=x86\_64 syscall=unlinkat success=yes exit=0 a0=0xffffffffffffff9c a1=0xf9a0c0 a2=0x0 a3=0x0 items=2 ppid=27157 pid=27604 auid=user@domain.local uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=pts0 ses=12425 comm=rm exe=/bin/rm key=whodeletedmyfile

The final command shows us the rm command has been executed on the file by user@domain.local (See auid) who has sudoed to root first.

You can remove the watch on the file with;

```
auditctl -W /path/to/file/rhys.txt -k whodeletedmyfile
```

You can list the configured watches with...

```
auditctl -l
```
