---
layout: post
title: ssh-copy-id automation with a list of hosts
date: 2018-11-09 13:21:26.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- Linux
tags:
- ssh
- ssh-copy-id
meta:
  _edit_last: '1'
  twittercomments: a:0:{}
  shorturls: a:2:{s:9:"permalink";s:83:"http://www.youdidwhatwithtsql.com/ssh-copy-id-automation-with-a-list-of-hosts/2412/";s:7:"tinyurl";s:27:"http://tinyurl.com/y9rkpyre";}
  tweetbackscheck: '1613417729'
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssh-copy-id-automation-with-a-list-of-hosts/2412/"
---
Here's another version of my [ssh-copy-id script](http://www.youdidwhatwithtsql.com/automate-ssh-copy-id-with-numbered-hosts/2400/) this time using a text file containing a list of hosts. The hosts file should contain a single host per line.

```
#!/bin/bash

export SSH_USER="user"
read -s PASSWORD
export PASSWORD

while read HOST; do
            export HOST;
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
done < "$1"
```

Execute the script and pass the path to the text file as a parameter. i.e.

```
./auto_ssh.sh /path/to/host/list.txt;
```
