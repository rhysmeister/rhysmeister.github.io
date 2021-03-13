---
layout: post
title: RPM Query on multiple servers with Python & Fabric
date: 2016-08-26 12:39:57.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Python
tags:
- fabric
- python
- sysadmin
meta:
  tweetbackscheck: '1613400437'
  shorturls: a:2:{s:9:"permalink";s:88:"http://www.youdidwhatwithtsql.com/rpm-query-on-multiple-servers-with-python-fabric/2218/";s:7:"tinyurl";s:26:"http://tinyurl.com/zawqg23";}
  _wp_old_slug: rpm-query-on-multiple-server-with-python-fabric
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/rpm-query-on-multiple-servers-with-python-fabric/2218/"
---
I’ve been playing a bit with [fabric](http://www.fabfile.org/) to make some of my system administration and deployment tasks easier. As the number of servers I manage increases I need to get smarter at managing them. Fabric fills that gap nicely.

Here’s a short script I’ve been using to find what packages are missing on individual servers in a group. This script will run an rpm query on a group of hosts, before comparing which packages are installed and those that are missing.

**fabfile.py**

```
from fabric.api import run, warn_only, env, hide, execute, task, runs_once

execfile("env_hosts.py")

env.hosts = HOST_GROUP

@task
def compare_packages(query):
        host_packages = []
        output = run('rpm -qa | grep -i ' + query)
        for line in output.splitlines():
                host_packages.append(line)
        return host_packages

@task
@runs_once
def rpm_query(query):
        output = execute(compare_packages, query)
        unique_list = set()
        for host in output.keys():
                for item in output[host]:
                        unique_list.add(item)
        print "On {:<2} servers there are {:<2} unique packages matching your query".format(len(env.hosts), len(unique_list))
        for host in output.keys():
                host_package_count = len(output[host])
                # what packages is this host missing?
                if len(unique_list.difference(set(output[host]))) > 0:
                        msg = ", ".join(unique_list.difference(set(output[host])))
                else:
                        msg = "None"
                print "{:<15} Installed packages: {:<2} Missing packages: {:<20}".format(host, host_package_count, msg)
        print "Packages: " + ", ".join(unique_list)
```

**env\_hosts.py**

The env\_hosts.py file should look something like this.

```
HOST_GROUP = ["mariadb1", "mariadb2", "mariadb3", "mariadb4", "mariadb5"]
```

This script is then called from the command line

```
fab rpm_query:query=mariadb -p 'XXXXXXXXXXXX' --hide everything
```

This command-line will essentially run...

```
rpm -qa mariadb
```

on each host and then compare the output. Below is an example of this output...

```
On 5 servers there are 7 unique packages matching your query
mariadb1 Installed packages: 7 Missing packages: None
mariadb2 Installed packages: 7 Missing packages: None
mariadb3 Installed packages: 7 Missing packages: None
mariadb4 Installed packages: 6 Missing packages: MariaDB-cassandra-engine-10.0.26-1.el6.x86_64
mariadb5 Installed packages: 7 Missing packages: None
Packages: MariaDB-compat-10.0.26-1.el6.x86_64, MariaDB-client-10.0.26-1.el6.x86_64, MariaDB-cassandra-engine-10.0.26-1.el6.x86_64, MariaDB-server-10.0.26-1.el6.x86_64, MariaDB-connect-engine-10.0.26-1.el6.x86_64, MariaDB-shared-10.0.26-1.el6.x86_64, MariaDB-common-10.0.26-1.el6.x86_64

Done.
Disconnecting from mariadb1... done.
Disconnecting from mariadb2... done.
Disconnecting from mariadb3... done.
Disconnecting from mariadb4... done.
Disconnecting from mariadb5... done.
```

Here we can see the unique list of packages that match the query. We can also see mariadb4 is missing the package **MariaDB-cassandra-engine-10.0.26-1.el6.x86\_64**.

