---
layout: post
title: A simple MariaDB deployment with Ansible
date: 2017-06-16 15:07:20.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
- DBA
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613478824'
  tweetcount: '0'
  twittercomments: a:0:{}
  shorturls: a:2:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/simple-mariadb-deployment-ansible/2311/";s:7:"tinyurl";s:27:"http://tinyurl.com/y9zdses9";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/simple-mariadb-deployment-ansible/2311/"
---
<p>Here's a simple <a href="http://docs.ansible.com/ansible/playbooks.html" target="_blank">Ansible Playbook</a> to create a basic <a href="https://mariadb.org/" target="_blank">MariaDB</a> deployment.</p>
<p>The basic steps the playbook will attempt are:</p>
<ul>
<li>Install a few libraries</li>
<li>Setup Repos</li>
<li>Install MariaDB packages</li>
<li>Install Percona software</li>
<li>Create MariaDB directories</li>
<li>Copy my.cnf to server (note this is a template file and not supplied here)</li>
<li>Run mysql_install_db if needed</li>
<li>Start MariaDB</li>
<li>Set root password</li>
<li>Delete anonymous users</li>
<li>Create myapp database and user</li>
</ul>
<p>Note: some steps will only execute if a root password has not been set. These are identifiable by the following line:</p>
<pre lang="yaml">
when: is_root_password_set.rc == 0
</pre>
<p>This is the playbook in full:</p>

{% highlight yaml %}
{% raw %}
---
- hosts: database
  become: true

  tasks:

  - name: Install Utility software
    apt: name={{item}} state=latest update_cache=yes
    with_items:
      - software-properties-common
      - python-mysqldb

    - name: Add apt key
      command: apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db

    - name: Add MariaDB Repo
      apt_repository:
        filename: MariaDB-10.2
        repo: deb [arch=amd64,i386] http://mirror.rackspeed.de/mariadb.org/repo/10.2/ubuntu trusty main
        state: present

    - name: Get Key for Percona Repo
      command: apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

    - name: Add Percona Tools Repo
      apt_repository:
        filename: Percona
        repo: deb http://repo.percona.com/apt trusty main
        state: present

    - name: Install MariaDB Packages
      apt: name={{item}} state=installed default_release=trusty update_cache=yes
      with_items:
        - mariadb-client
        - mariadb-common
        - mariadb-server

    - name: Install Percona Software
      apt: name={{item}} state=latest force=yes
      with_items:
        - percona-toolkit
        - percona-xtrabackup
        - percona-nagios-plugins

    - name: Create MariaDB Directories
      file: path=/data/{{item}} state=directory owner=mysql group=mysql recurse=yes
      with_items:
        - db
        - log

    - name: Write new configuration file
      template:
        src: /home/vagrant/ansible/templates/mysql/my.cnf
        dest: /etc/mysql/my.cnf
        owner: mysql
        group: mysql
        mode: '0600'
        backup: yes

    - name: Count files in /data/db
      find:
        path=/data/db
        patterns='\*'
      register: db_files

    - name: Run mysql_install_db only if /data/db is empty
      command: mysql_install_db --datadir=/data/db
      when: db_files.matched|int == 0

    - name: Start MariaDB
      service:
        name=mysql
        state=started

    - name: Is root password set?
      command: mysql -u root --execute "SELECT NOW()"
      register: is_root_password_set
      ignore_errors: yes

    - name: Delete anonymous users
      mysql_user:
        user=""
        state="absent"
      when: is_root_password_set.rc == 0

    - name: Generate mysql root password
      shell: tr -d -c "a-zA-Z0-9" \< /dev/urandom | head -c 10
      register: mysql_root_password
      when: is_root_password_set.rc == 0

    - name: Set root password
      mysql_user:
        user=root
        password="{{mysql_root_password.stdout}}"
        host=localhost
      when: is_root_password_set.rc == 0

    - name: Set root password for other hosts
      mysql_user:
        user=root
        password="{{mysql\_root\_password.stdout}}"
        host="{{item}}"
        login_user="root"
        login_host="localhost"
        login_password="{{mysql_root_password.stdout}}"
      when: is_root_password_set.rc == 0
      with_items: - "127.0.0.1" - "::1"

    - name: Inform user of mysql root password
      debug:
        msg: "MariaDB root password was set to {{mysql_root_password.stdout}}"
      when: is_root_password\set.rc == 0

    - name: Create myapp database
      mysql_db:
        name: myapp
        login_user: root
        login_password: "{{mysql_root_password.stdout}}"
        login_host: localhost
        state: present
      when: is_root_password_set.rc == 0

    - name: Generate myapp\_rw password
      shell: tr -d -c "a-zA-Z0-9" < /dev/urandom | head -c 10
      register: mysql_myapp_rw_password
      when: is_root_password_set.rc == 0

    - name: Create user for myapp db
      mysql_user:
        name: myapp_rw
        password: "{{mysql_myapp_rw_password}}"
        priv: myapp.*:SELECT,INSERT,UPDATE,DELETE
        login_user:
        root login_password: "{{mysql_root_password.stdout}}"
        state: present
      when: is_root_password_set.rc == 0
{% endraw %}
{% endhighlight%}

```
PLAY [database] *********************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [db01]

TASK [Install Utility software] *****************************************************************************************************************************
changed: [db01] => (item=[u'software-properties-common', u'python-mysqldb'])

TASK [Add apt key] ******************************************************************************************************************************************
changed: [db01]

TASK [Add MariaDB Repo] *************************************************************************************************************************************
changed: [db01]

TASK [Get Key for Percona Repo] *****************************************************************************************************************************
changed: [db01]

TASK [Add Percona Tools Repo] *******************************************************************************************************************************
changed: [db01]

TASK [Install MariaDB Packages] *****************************************************************************************************************************
changed: [db01] => (item=[u'mariadb-client', u'mariadb-common', u'mariadb-server'])

TASK [Install Percona Software] *****************************************************************************************************************************
changed: [db01] => (item=[u'percona-toolkit', u'percona-xtrabackup', u'percona-nagios-plugins'])

TASK [Create MariaDB Directories] ***************************************************************************************************************************
changed: [db01] => (item=db)
changed: [db01] => (item=log)

TASK [Write new configuration file] *************************************************************************************************************************
changed: [db01]

TASK [Count files in /data/db] ******************************************************************************************************************************
ok: [db01]

TASK [Run mysql_install_db only if /data/db is empty] *******************************************************************************************************
changed: [db01]

TASK [Start MariaDB] ****************************************************************************************************************************************
ok: [db01]

TASK [Is root password set?] ********************************************************************************************************************************
changed: [db01]

TASK [Delete anonymous users] *******************************************************************************************************************************
ok: [db01]

TASK [Generate mysql root password] *************************************************************************************************************************
changed: [db01]

TASK [Set root password] ************************************************************************************************************************************
changed: [db01]

TASK [Set root password for other hosts] ********************************************************************************************************************
changed: [db01] => (item=127.0.0.1)
changed: [db01] => (item=::1)

TASK [Inform user of mysql root password] *******************************************************************************************************************
ok: [db01] => {
    "changed": false,
    "msg": "MariaDB root password was set to zr2MuEXUBD"
}

TASK [Create myapp database] ********************************************************************************************************************************
changed: [db01]

TASK [Generate myapp_rw password] ***************************************************************************************************************************
changed: [db01]

TASK [Create user for myapp db] *****************************************************************************************************************************
changed: [db01]

PLAY RECAP **************************************************************************************************************************************************
db01 : ok=22 changed=17 unreachable=0 failed=0
```
