---
layout: post
title: Check MariaDB replication status inside Ansible
date: 2017-06-02 15:56:02.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
- Linux
tags:
- Ansible
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461807'
  tweetcount: '0'
  twittercomments: a:0:{}
  shorturls: a:2:{s:9:"permalink";s:80:"http://www.youdidwhatwithtsql.com/check-mariadb-replication-status-ansible/2303/";s:7:"tinyurl";s:27:"http://tinyurl.com/yays2vrk";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-mariadb-replication-status-ansible/2303/"
---
<p>I needed a method to check replication status inside <a href="https://www.ansible.com/" target="_blank">Ansible</a>. The method I came up with uses the <a href="http://docs.ansible.com/ansible/shell_module.html" target="_blank">shell module</a>...</p>
<pre lang="yaml">
---
- hosts: mariadb vars\_prompt: - name: "mariadb\_user" prompt: "Enter MariaDB user" - name: "mariadb\_password" prompt: "Enter MariaDB user password" tasks: - name: "Check MariaDB replication state" shell: "test 2 -eq $(mysql -u '{{ mariadb\_user }}' -p'{{ mariadb\_password }}' -e 'SHOW SLAVE STATUS' --auto-vertical-output | grep -E 'Slave\_IO\_Running|Slave\_SQL\_Running' | grep Yes | wc -l)" register: replication\_status - name: "Print replication status var" debug: var: replication\_status

This is executed like so...

```
ansible-playbook mariadb_check_repl.yml -i inventories/my_mariadb_hosts
```

The playbook will prompt for a MariaDB user and password and will output something like below...

```
PLAY [mariadb] *****************************************************************

TASK [setup] *******************************************************************
ok: [slave2]
ok: [master2]
ok: [slave1]
ok: [master1]

TASK [Check MariaDB replication state] *****************************************
changed: [master1]
changed: [master2]
changed: [slave2]
changed: [slave1]

TASK [Print replication status var] ********************************************
ok: [master1] => {
    "replication_status": {
        "changed": true,
        "cmd": "test 2 -eq $(mysql -u 'mariadb_user' -p'secret' -e 'SHOW SLAVE STATUS' --auto-vertical-output | grep -E 'Slave_IO_Running|Slave_SQL_Running' | grep Yes | wc -l)",
        "delta": "0:00:00.009477",
        "end": "2017-06-02 16:52:51.293609",
        "rc": 0,
        "start": "2017-06-02 16:52:51.284132",
        "stderr": "",
        "stdout": "",
        "stdout_lines": [],
        "warnings": []
    }
}
ok: [slave1] => {
    "replication_status": {
        "changed": true,
        "cmd": "test 2 -eq $(mysql -u 'mariadb_user' -p'secret' -e 'SHOW SLAVE STATUS' --auto-vertical-output | grep -E 'Slave_IO_Running|Slave_SQL_Running' | grep Yes | wc -l)",
        "delta": "0:00:00.017658",
        "end": "2017-06-02 16:52:51.325027",
        "rc": 0,
        "start": "2017-06-02 16:52:51.307369",
        "stderr": "",
        "stdout": "",
        "stdout_lines": [],
        "warnings": []
    }
}
ok: [master2] => {
    "replication_status": {
        "changed": true,
        "cmd": "test 2 -eq $(mysql -u 'mariadb_user' -p'secret' -e 'SHOW SLAVE STATUS' --auto-vertical-output | grep -E 'Slave_IO_Running|Slave_SQL_Running' | grep Yes | wc -l)",
        "delta": "0:00:00.015469",
        "end": "2017-06-02 16:52:51.292966",
        "rc": 0,
        "start": "2017-06-02 16:52:51.277497",
        "stderr": "",
        "stdout": "",
        "stdout_lines": [],
        "warnings": []
    }
}
ok: [slave2] => {
    "replication_status": {
        "changed": true,
        "cmd": "test 2 -eq $(mysql -u 'mariadb_user' -p'secret' -e 'SHOW SLAVE STATUS' --auto-vertical-output | grep -E 'Slave_IO_Running|Slave_SQL_Running' | grep Yes | wc -l)",
        "delta": "0:00:00.014586",
        "end": "2017-06-02 16:52:51.291047",
        "rc": 0,
        "start": "2017-06-02 16:52:51.276461",
        "stderr": "",
        "stdout": "",
        "stdout_lines": [],
        "warnings": []
    }
}

PLAY RECAP *********************************************************************
master1 : ok=3 changed=1 unreachable=0 failed=0
master2 : ok=3 changed=1 unreachable=0 failed=0
slave1 : ok=3 changed=1 unreachable=0 failed=0
slave2 : ok=3 changed=1 unreachable=0 failed=0
```

**N.B.** There is the [mysql\_replication Ansible module](http://docs.ansible.com/ansible/mysql_replication_module.html) that some may prefer to use but it requires the MySQLdb Python package to be present on the remote host.

