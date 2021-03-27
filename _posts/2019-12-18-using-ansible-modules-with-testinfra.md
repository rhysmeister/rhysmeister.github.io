---
layout: post
title: Using Ansible Modules with Testinfra
date: 2019-12-18 12:55:20.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ansible
tags:
- Ansible
- molecule
- testinfra
meta:
  _edit_last: '1'
  tweetbackscheck: '1613456045'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/using-ansible-modules-with-testinfra/2459/"
---
I've been looking at improving the quality of the testing I do with [Molecule](https://molecule.readthedocs.io/en/stable/) and [Testinfra](https://testinfra.readthedocs.io/en/latest/). Simple checks like service.is\_running or package.is\_installed have their place but they're pretty limited as to what assurances they provide us. Part of the issue I have is that some tests need a fair bit of setup to make them worthwhile. Attempting to tackle that with raw Python might be a little bit tricky. A better approach is to use the [Ansible module](https://testinfra.readthedocs.io/en/latest/modules.html#ansible) available within TestInfra. We can call an ansible module with the following Python code:

{% highlight python %}
{% raw %}
ansible = host.ansible(module name,
                       module arguments,
                       check mode,
                       become)
{% endraw %}
{% endhighlight %}


Some of the stuff I do involves Nagios Plugins that parse log files for interesting content. I can test the the plugin is doing what it's supposed to by setting log file content and then running the plugin and checking the output. Here's an example of that...

{% highlight python %}
{% raw %}
def test_nagios_plugin_test(host):
    with host.sudo():
        cmd = host.run("rm -f /var/log/mylogfile.log")
        assert cmd.rc == 0

    with host.sudo("reaper"):
        ansible = host.ansible("copy",
                               "src=dummy_log_content.log dest=/var/log/mylogfile.log",
                               check=False,
                               become=True)
        assert ansible['changed'] == True

    with host.sudo("nrpe"):
        cmd = host.run("/usr/lib64/nagios/plugins/check_logfile_custom")
        assert cmd.rc == 0
        assert cmd.stdout.strip() == "OK: All looks good in /var/log/mylogfile.log"
{% endraw %}
{% endhighlight %}

The dummy\_log\_content.log is placed into the roles molecule/default/files directory. By providing a range of dummy log files I can ensure the Nagios Plugin is working as expected.

