---
layout: post
title: 'InfluxDB: Bash script to launch and configure two nodes'
date: 2016-12-04 15:35:20.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- DBA
tags:
- influxdb
meta:
  _edit_last: '1'
  shorturls: a:2:{s:9:"permalink";s:83:"http://www.youdidwhatwithtsql.com/influxdb-bash-script-launch-configure-nodes/2256/";s:7:"tinyurl";s:26:"http://tinyurl.com/hb52f5g";}
  tweetbackscheck: '1613470675'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/influxdb-bash-script-launch-configure-nodes/2256/"
---
<p>I've just created a quick bash script because I"m working a little with <a href="https://www.influxdata.com/" target="_blank">InfluxDB</a> at the moment. InfluxDB is a time series database written in GO.</p>
<p>The script will setup two <a href="https://www.influxdata.com/" target="_blank">influxdb</a> nodes, setup some users and download and load some sample data. It's developed on a Mac but should work in Linux (not tested yet but let me know if there's any problem). I do plan further work on this, for example adding in <a href="https://docs.influxdata.com/influxdb/v1.1/high_availability/relay/" target="_blank">InfluxDB-Relay</a>. The script is available at my <a href="https://github.com/rhysmeister/InfluxDB-Setup" target="_blank">github</a>.</p>
<p>Usage is as follows...</p>
<p>Source the script in the shell</p>
<pre lang="bash">
. influxdb_setup.sh
</pre>
<p>This makes the following functions available...</p>
<pre>
influx_kill                influx_run_q
influx_admin_user          influx_launch_nodes        influx_setup_cluster
influx_config1             influx_mkdir               influx_stress
influx_config2             influx_murder              influx_test_db_user_perms
influx_count_processes     influx_noaa_db_user_perms  influx_test_db_users
influx_create_test_db      influx_noaa_db_users
influx_curl_sample_data    influx_node1
influx_http_auth           influx_node2
influx_import_file         influx_remove_dir
</pre>
<p>You don't need to know in detail what most of these do. To setup two nodes just do...</p>
<pre lang="Bash">
influx_setup_cluster
</pre>
<p>If all goes well you should see a message like below...</p>
<pre>
Restarted influx nodes. Logon to node1 with influx -port 8086 -username admin -password $(cat "${HOME}/rhys_influxdb/admin_pwd.txt")
</pre>
<p>Logon to a node with...</p>
<pre lang="Bash">
influx -port 8086 -username admin -password $(cat "${HOME}/rhys_influxdb/admin_pwd.txt")
</pre>
<p>Execute "show databases"...</p>
<pre>
name
----
test
NOAA_water_database
_internal
</pre>
<p>Execute "show users"...</p>
<pre>
user	admin
----	-----
admin	true
test_ro	false
test_rw	false
noaa_ro	false
noaa_rw	false
</pre>
<p>N.B. Password for these users can be found in text files in $HOME/rhys_influxdb/</p>
<p>Start working with some data...</p>
<pre>
SELECT * FROM h2o_feet LIMIT 5
name: h2o_feet
time			level description	location	water_level
----			-----------------	--------	-----------
1439856000000000000 between 6 and 9 feet coyote\_creek 8.12 1439856000000000000 below 3 feet santa\_monica 2.064 1439856360000000000 between 6 and 9 feet coyote\_creek 8.005 1439856360000000000 below 3 feet santa\_monica 2.116 1439856720000000000 between 6 and 9 feet coyote\_creek 7.887

To clean everything up you can call...

```
influx_murder
```

Please notes this will kill all influxd processes and remove all data files.

