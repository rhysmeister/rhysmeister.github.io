---
layout: post
title: Automate ssh-copy-id with numbered hosts
date: 2018-09-27 16:05:08.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- Linux
tags: []
meta:
  _edit_last: '1'
  shorturls: a:2:{s:9:"permalink";s:80:"http://www.youdidwhatwithtsql.com/automate-ssh-copy-id-with-numbered-hosts/2400/";s:7:"tinyurl";s:27:"http://tinyurl.com/y8tbnoj9";}
  twittercomments: a:0:{}
  tweetcount: '0'
  tweetbackscheck: '1613461786'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/automate-ssh-copy-id-with-numbered-hosts/2400/"
---
Here's a script I use to automate [ssh-copy-id](https://www.ssh.com/ssh/copy-id) when I need to add a series of hosts using a incremental node number. For example...

prod-db-server001  
prod-db-server002  
prod-db-server003

and so on. The script uses [expect](https://linux.die.net/man/1/expect) to perform its work. To adjust this for your own purposes you simply need to change the SSH\_USER variable, the number of hosts in the for loop and of course the hostname scheme. Once you execute the script you'll enter your password once and ssh-copy-id will be performed for all the hosts in sequence.

```
#!/bin/bash

set -x;

export SSH_USER="admin"
read -s PASSWORD
export PASSWORD

for node in {1..91}; do
        if (( $node <= 9 )); then
                export HOST=hostname00${node}.domain.ch
        else
                export HOST=hostname0${node}.domain.ch
        fi;

    expect -c '
    set SSH_USER $env(SSH_USER)
    set HOST $env(HOST)
    set PASSWORD $env(PASSWORD)
    spawn ssh-copy-id $SSH_USER@$HOST
    expect {
        "continue" {
            send "yes\n";
            exp_continue
        }
        "assword:" {
            send "$PASSWORD\n";
        }
    }
    expect eof'

    echo "Done $HOST"
done;
```
