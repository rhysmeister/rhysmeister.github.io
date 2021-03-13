---
layout: post
title: 'MySQL 5.7: root password is not in mysqld.log'
date: 2017-09-02 19:57:37.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
- DBA
- MySQL
tags:
- Ansible
- MySQL
- mysql_install_db
- mysqld --initialize
meta:
  tweetcount: '0'
  twittercomments: a:0:{}
  _edit_last: '1'
  tweetbackscheck: '1613440507'
  shorturls: a:2:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/mysql-57-root-password-mysqldlog/2334/";s:7:"tinyurl";s:27:"http://tinyurl.com/ydcalmjm";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-57-root-password-mysqldlog/2334/"
---
I came across [this issue](https://stackoverflow.com/questions/43902473/mysql-root-password-not-in-mysqld-log) today when working on an [ansible](https://www.ansible.com)playbook with [MySQL 5.7](https://dev.mysql.com/downloads/mysql/5.7.html#downloads). Old habits die hard and I was still trying to use [mysql\_install\_db](https://dev.mysql.com/doc/refman/5.7/en/mysql-install-db.html)&nbsp;to initialise my instance. It seems a few others have been [doing the same](https://dba.stackexchange.com/questions/127537/setting-root-password-in-fresh-mysql-5-7-installation). The effect of using mysql\_install\_db in more recent version of MySQL is that we end up not knowing the root password. This is now set to a random value rather than being blank/unset. Nothing is logged to the mysqld.log file unless you use mysqld --initialize first;

Instead of using mysql\_install\_db we should be doing something like this;

```
- name: Init MySQL
    command: mysqld --initialize --datadir=/var/lib/mysql
    args:
      creates: /var/lib/mysql/mysql/user.frm
    become_user: mysql
```

Now when searching for the root password we will find something in the error log;

```
sudo cat /var/log/mysqld.log | grep "temporary password"
```

```
2017-09-02T15:16:32.318530Z 1 [Note] A temporary password is generated for root@localhost: XXXXXXXX
```

We can login to the instance with the root user using this password;

```
mysql> show databases;
ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.
```

But we are clearly limited in what we can do. We are unable to read any tables or even view the databases. We must reset the password first. This bash one-liner will do that;

```
mysql -u root -p$(cat /var/log/mysqld.log | grep "temporary password" | rev | cut -d " " -f 1 | rev) -e "SET PASSWORD FOR root@localhost = 'BigSecret'" --connect-expired-password;
```

We can put this into an ansible task to continue with our automation;

```
- name: Reset the root@localhost password
    shell: mysql -u root -p$(cat /var/log/mysqld.log | grep "temporary password" | rev | cut -d " " -f 1 | rev) -e "SET PASSWORD FOR root@localhost = 'BigSecret'" --connect-expired-password && touch /home/vagrant/root_pw_reset.success;
    args:
      creates: /home/vagrant/root_pw_reset.success
```

I'd recommend you put the bash line into a script and use the [copy module](http://docs.ansible.com/ansible/latest/copy_module.html) to copy it to your host before executing it. It looks a whole lot tidier that way. Happy automating!

