---
layout: post
title: Getting started with osquery on CentOS
date: 2016-09-29 18:20:26.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Linux
tags:
- Linux
- osquery
- qmi
- wql
meta:
  _edit_last: '1'
  tweetbackscheck: '1613188145'
  shorturls: a:2:{s:9:"permalink";s:62:"http://www.youdidwhatwithtsql.com/started-osquery-centos/2242/";s:7:"tinyurl";s:26:"http://tinyurl.com/htq79nc";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/started-osquery-centos/2242/"
---
<p>I recently stumbled across <a href="https://osquery.io/" target="_blank">osquery</a> which allows you to query your Linux, and OS X, servers for various bits of information. It's very similar in concept to <a href="https://msdn.microsoft.com/en-us/library/aa394605(v=vs.85).aspx" target="_blank">WQL</a> for those in the Windows world.</p>
<p>Here's my quick getting started guide for CentOS 6.X...</p>
<p>First download and install the latest rpm for your distro. You might want to check <a href="https://osquery.io/downloads/" target="_blank">osquery downloads</a> for the latest release.</p>
<pre lang="bash">wget https://osquery-packages.s3.amazonaws.com/centos6/osquery-1.8.2.rpm
sudo rpm -ivh osquery-1.8.2.rpm
</pre>
<p>You'll now have the following three executables in your path</p>
<ul>
<li>osqueryctl - bash script to manage the daemon.</li>
<li>osqueryd - the daemon.</li>
<li>osqueryi - command-line client to interactively run osquery queries, view tales (namespaces) and so on.</li>
</ul>
<p>Take a look at the example config...</p>
<pre lang="Bash">cat /usr/share/osquery/osquery.example.conf
</pre>
<p>The daemon won't start without a config file so be sure to create one first. This config file does a few thigns but will also periodcially run some queries and log them to a file. This is useful for sticking data into <a href="https://www.elastic.co/webinars/introduction-elk-stack" target="_blank">ELK</a> or <a href="https://www.splunk.com/de_de" target="_blank">splunk</a>.</p>
<pre lang="Bash">cat << EOF > /etc/osquery/osquery.conf
{
"options": {
"config_plugin": "filesystem",
"logger_plugin": "filesystem",
"logger_path": "/var/log/osquery",
"pidfile": "/var/osquery/osquery.pidfile",
"events_expiry": "3600",
"database_path": "/var/osquery/osquery.db",
"verbose": "true",
"worker_threads": "2",
"enable_monitor": "true"
},
// Define a schedule of queries:
"schedule": {
// This is a simple example query that outputs basic system information.
"system_info": {
// The exact query to run.
"query": "SELECT hostname, cpu_brand, physical_memory FROM system_info;",
// The interval in seconds to run this query, not an exact interval.
"interval": 3600
}
},
// Decorators are normal queries that append data to every query.
"decorators": {
"load": [
"SELECT uuid AS host_uuid FROM system_info;",
"SELECT user AS username FROM logged_in_users ORDER BY time DESC LIMIT 1;"
]
},
"packs": {
"osquery-monitoring": "/usr/share/osquery/packs/osquery-monitoring.conf"

}
}
EOF
</pre>
<p>Try to start the daemon...</p>
<pre lang="Bash">osqueryctl start
</pre>
<p>If you encounter <a href="https://github.com/facebook/osquery/issues/2329" target="_blank">this issue</a></p>
<pre>/usr/bin/osqueryctl: line 52: [: missing `]'
</pre>
<p>vi /usr/bin/osqueryctl</p>
<p>Change line 52 from this....</p>
<pre lang="Bash">if [ ! -e "$INIT_SCRIPT_PATH" &amp;&amp; ! -f "$SERVICE_SCRIPT_PATH" ]; then
</pre>
<p>to this</p>
<pre lang="Bash">if [ ! -e "$INIT_SCRIPT_PATH" ] &amp;&amp; [ ! -f "$SERVICE_SCRIPT_PATH" ]; then
</pre>
<p>You should no be able to start without complaint...</p>
<pre lang="Bash">osqueryctl start
</pre>
<p>Some logfiles should appear here...</p>
<pre lang="Bash">ls -lh /var/log/osquery/
</pre>
<p>Use the osquery client to explore (this is akin to the mysql client). Data is presented just like a traditional sql database...</p>
<pre>osqueryi
osquery&gt;.help
osquery&gt; select * from logged_in_users;
osquery&gt; select * from time;
osquery&gt; select * from os_version;
osquery&gt; select * from rpm_packages;
osquery&gt; select * from shell_history;
</pre>
<p>We can view the "schema" of certain tables like so...</p>
<pre>osquery&gt; .schema processes
</pre>
<pre lang="SQL">CREATE TABLE processes(`pid` BIGINT PRIMARY KEY, `name` TEXT, `path` TEXT, `cmdline` TEXT, `state` TEXT, `cwd` TEXT, `root` TEXT, `uid` BIGINT, `gid` BIGINT, `euid` BIGINT, `egid` BIGINT, `suid` BIGINT, `sgid` BIGINT, `on_disk` INTEGER, `wired_size` BIGINT, `resident_size` BIGINT, `phys_footprint` BIGINT, `user_time` BIGINT, `system_time` BIGINT, `start_time` BIGINT, `parent` BIGINT, `pgroup` BIGINT, `nice` INTEGER) WITHOUT ROWID;
</pre>
<p>We can use familar sql operators...</p>
<pre lang="SQL">SELECT * FROM file WHERE path LIKE '/etc/%';
</pre>
<pre>+-----------------------------------+------------------------+------------------------------+--------+-----+-----+------+--------+--------+------------+------------+------------+------------+-------+------------+-----------+
| path | directory | filename | inode | uid | gid | mode | device | size | block_size | atime | mtime | ctime | btime | hard_links | type |
+-----------------------------------+------------------------+------------------------------+--------+-----+-----+------+--------+--------+------------+------------+------------+------------+-------+------------+-----------+
| /etc/ConsoleKit/ | /etc/ConsoleKit | . | 398999 | 0 | 0 | 0755 | 0 | 4096 | 4096 | 1467708722 | 1414762792 | 1414762792 | 0 | 5 | directory |
| /etc/DIR_COLORS | /etc | DIR_COLORS | 398851 | 0 | 0 | 0644 | 0 | 4439 | 4096 | 1475149457 | 1405522956 | 1414762782 | 0 | 1 | regular |
| /etc/DIR_COLORS.256color | /etc | DIR_COLORS.256color | 398852 | 0 | 0 | 0644 | 0 | 5139 | 4096 | 1405522956 | 1405522956 | 1414762782 | 0 | 1 | regular |
| /etc/DIR_COLORS.lightbgcolor | /etc | DIR_COLORS.lightbgcolor | 398853 | 0 | 0 | 0644 | 0 | 4113 | 4096 | 1405522956 | 1405522956 | 1414762782 | 0 | 1 | regular |
| /etc/NetworkManager/ | /etc/NetworkManager | . | 400911 | 0 | 0 | 0755 | 0 | 4096 | 4096 | 1467708722 | 1422299768 | 1436772557 | 0 | 5 | directory |
</pre>
<p>We can even join onto other tables. This query shows Linux users and their associated groups...</p>
<pre lang="SQL">osquery> SELECT u.username,
g.groupname
FROM users u
INNER JOIN user_groups ug
ON u.uid = ug.uid
INNER JOIN groups g
ON g.gid = ug.gid;
</pre>
<pre>+---------------+---------------+
| username | groupname |
+---------------+---------------+
| root | root |
| bin | bin |
| bin | daemon |
| bin | sys |
| daemon | daemon |
| daemon | bin |
| daemon | adm |
| daemon | lp |
</pre>
<p>This query shows some details about processes listening on ports...</p>
<pre lang="SQL">osquery> SELECT p.pid, p.name, p.state, u.username, lp.*
FROM processes p
INNER JOIN listening_ports lp
ON lp.pid = p.pid
INNER JOIN users u
ON u.uid = p.uid;
</pre>
<pre>+-------+---------------+-------+-----------+-------+-------+----------+--------+--------------------------+
| pid | name | state | username | pid | port | protocol | family | address |
+-------+---------------+-------+-----------+-------+-------+----------+--------+--------------------------+
| 1318 | rpcbind | S | rpc | 1318 | 111 | 6 | 2 | 0.0.0.0 |
| 1318 | rpcbind | S | rpc | 1318 | 111 | 6 | 10 | :: |
| 1318 | rpcbind | S | rpc | 1318 | 111 | 17 | 2 | 0.0.0.0 |
| 1318 | rpcbind | S | rpc | 1318 | 645 | 17 | 2 | 0.0.0.0 |
| 1318 | rpcbind | S | rpc | 1318 | 111 | 17 | 10 | :: |
| 1318 | rpcbind | S | rpc | 1318 | 645 | 17 | 10 | :: |
</pre>
<p>Show the files, and who owns them, installed by an rpm package...</p>
<pre lang="SQL">osquery> SELECT p.name, p.version, pf.path, pf.username, pf.groupname
FROM rpm_packages p
INNER JOIN rpm_package_files pf
ON p.name = pf.package
WHERE p.name = 'MariaDB-server';
</pre>
<pre>+----------------+---------+---------------------------------------------------------+----------+-----------+
| name | version | path | username | groupname |
+----------------+---------+---------------------------------------------------------+----------+-----------
+ | MariaDB-server | 10.0.20 | /etc/init.d/mysql | root | root | | MariaDB-server | 10.0.20 | /etc/logrotate.d/mysql | root | root | | MariaDB-server | 10.0.20 | /etc/my.cnf.d | root | root | | MariaDB-server | 10.0.20 | /etc/my.cnf.d/server.cnf | root | root | | MariaDB-server | 10.0.20 | /etc/my.cnf.d/tokudb.cnf | root | root | | MariaDB-server | 10.0.20 | /usr/bin/aria\_chk | root | root |

```
osquery> .exit
```

You can see the data collected by the deamon on schedule here...

cat /var/log/osquery/osqueryd.results.log

