---
layout: post
title: Execute SQ... Procedure Task
date: 2010-01-19 22:04:10.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SSIS
tags:
- Execute SQL Task
- SSIS
meta:
  tweetbackscheck: '1613194087'
  shorturls: a:4:{s:9:"permalink";s:63:"http://www.youdidwhatwithtsql.com/execute-sq-procedure-task/559";s:7:"tinyurl";s:26:"http://tinyurl.com/ylaph2z";s:4:"isgd";s:18:"http://is.gd/6Cx0H";s:5:"bitly";s:20:"http://bit.ly/5MCJhf";}
  twittercomments: a:1:{s:11:"10153775806";s:7:"retweet";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/execute-sq-procedure-task/559/"
---
I've been having a bit of a debate with some colleagues today about the [Execute ~~SQL~~ Procedure Task](http://technet.microsoft.com/en-us/library/ms141003.aspx) in [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx). Is it ok to enter raw SQL queries into this task or should everything be enclosed within a [Stored Procedure](http://en.wikipedia.org/wiki/Stored_procedure)? My view...

| [![execute sql task bad]({{ site.baseurl }}/assets/2010/01/execute_sql_task_bad_thumb.png "execute sql task bad")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/execute_sql_task_bad.png) | [![red x]({{ site.baseurl }}/assets/2010/01/red_x_thumb.gif "red x")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/red_x.gif) |

| [![execute_procedure_task_good]({{ site.baseurl }}/assets/2010/01/execute_procedure_task_good_thumb.png "execute\_procedure\_task\_good")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/execute_procedure_task_good.png) | [![green tick]({{ site.baseurl }}/assets/2010/01/green_tick_thumb.jpg "green tick")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/green_tick.jpg) |

For me, any day of the week, it should always be a proc. Why on earth would you want to enter raw queries into this task? I would argue against this even for basic message logging. Enclosing your TSQL in stored procedures gives you much more flexibility. It's so much easier to make minor modifications to a proc. Would you rather have to go through the rigmarole of opening and deploying SSIS packages. Sure, I know you'll have to open the package if you introduce, or remove, new columns. But you're pretty much free to modify your WHERE without issue. Lets not forget this also allows your system to be modified by those who don't know SSIS. Perhaps you'll be able to enjoy your holiday a little better next year.

I'm even tempted to open a [Microsoft Connect](http://connect.microsoft.com/) item to fix this 'bug'. Perhaps one day I will be lucky enough to see this task available in my toolbox.

[![execute_procedure_task]({{ site.baseurl }}/assets/2010/01/execute_procedure_task_thumb.png "execute\_procedure\_task")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/execute_procedure_task.png)

