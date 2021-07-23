---
layout: post
title: 'Ansible: Find files newer than another'
date: 2018-06-25 15:19:12.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
tags:
- Ansible
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461505'
  shorturls: a:2:{s:9:"permalink";s:77:"http://www.youdidwhatwithtsql.com/ansible-find-files-newer-than-another/2384/";s:7:"tinyurl";s:27:"http://tinyurl.com/yajvnqfn";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ansible-find-files-newer-than-another/2384/"
---
<p>I needed to figure out a way of identifying files newer than another one in <a href="https://www.ansible.com/" target="_blank" rel="noopener">Ansible</a>. Here's an outline of the solution I came up with.</p>
<p>First we need to create a bunch of directories and folder, with modified mtime values, that we can work with.</p>
{% highlight bash %}
{% raw %}
mkdir dir1;
mkdir dir2;
# Set the time on this dir to 3 days ago
touch -t $(date -v-3d +'%Y%m%d%H%M') dir1;

# create a bunch of files in dir2 and modify the dates
touch -t $(date -v-7d +'%Y%m%d%H%M') dir2/file1.txt;
touch -t $(date -v-6d +'%Y%m%d%H%M') dir2/file2.txt;
touch -t $(date -v-5d +'%Y%m%d%H%M') dir2/file3.txt;
touch -t $(date -v-4d +'%Y%m%d%H%M') dir2/file4.txt;
touch -t $(date -v-3d +'%Y%m%d%H%M') dir2/file5.txt;
touch -t $(date -v-2d +'%Y%m%d%H%M') dir2/file6.txt;
touch -t $(date -v-1d +'%Y%m%d%H%M') dir2/file7.txt;
touch dir2/file8.txt;
{% endraw %}
{% endhighlight %}

<p>Let's check the mtime value on our files...</p>
<pre lang="Bash">stat -x dir2/*.txt | egrep 'File:|Modify:'
</pre>
<pre>  File: "dir2/file1.txt"
Modify: Mon Jun 18 13:29:00 2018
  File: "dir2/file2.txt"
Modify: Tue Jun 19 13:29:00 2018
  File: "dir2/file3.txt"
Modify: Wed Jun 20 13:29:00 2018
  File: "dir2/file4.txt"
Modify: Thu Jun 21 13:29:00 2018
  File: "dir2/file5.txt"
Modify: Fri Jun 22 13:29:00 2018
  File: "dir2/file6.txt"
Modify: Sat Jun 23 13:29:00 2018
  File: "dir2/file7.txt"
Modify: Sun Jun 24 13:29:00 2018
  File: "dir2/file8.txt"
Modify: Mon Jun 25 13:29:33 2018
</pre>
<p>If we want to return files in dir2 than are newer than dir1, which has an mtime of Fri Jun 22 13:29:00 2018, then we would expect to return file6.txt, file7.txt and file8.txt. Here's the playbook that will do just that;</p>
{% highlight yaml %}
{% raw %}
---
  - hosts: localhost
    become: no
    tasks:

      - name: Get the mtime of the snapshot for later use
        stat:
          path: dir1/
        register: snapshot_stat
        failed_when: snapshot_stat.stat.exists == False

      - set_fact:
          myage: {{ ansible_date_time.epoch|int - snapshot_stat.stat.mtime|int}}

      - debug:
          msg: "{{ myage }}"

      - name: Find files newer than the snapshot_dir mtime
        find:
          paths: dir2/
          age: "-{{ myage }}"
          age_stamp: mtime
          file_type: file
        register: found_files

     - debug:
         var: found_files
{% endraw %}
{% endhighlight %}

Not the myage variable above has a minus in front of it. This is makes it return files newer than this 'age'. The documentation page for the [find module](https://docs.ansible.com/ansible/devel/modules/find_module.html) described the age parameter as follows;

"Select files whose age is equal to or greater than the specified time. Use a negative age to find files equal to or less than the specified time. You can choose seconds, minutes, hours, days, or weeks by specifying the first letter of any of those words (e.g., "1w")."

I found this explanation to be a little confusing with the mixed up semantics between age and time. Basically specifying a value of '1d' would return all files older than 1 day, while '-1d' would return all files less than a day old.
