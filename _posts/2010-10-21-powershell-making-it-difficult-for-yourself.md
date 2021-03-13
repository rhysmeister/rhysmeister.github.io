---
layout: post
title: Powershell… Making it difficult for yourself!
date: 2010-10-21 21:58:31.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
meta:
  tweetbackscheck: '1613417767'
  shorturls: a:4:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/powershell-making-it-difficult-for-yourself/885";s:7:"tinyurl";s:26:"http://tinyurl.com/2a8muzv";s:4:"isgd";s:18:"http://is.gd/gbLYa";s:5:"bitly";s:20:"http://bit.ly/bb6GFa";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershell-making-it-difficult-for-yourself/885/"
---
Today I was reading the post [Powershell is Really Easy… If you know what you’re doing](http://scarydba.wordpress.com/2010/10/18/powershell-is-really-easy-if-you-know-what-youre-doing/) and it really struck a chord with me.

A few days ago I discovered the [ConvertTo-HTML](http://technet.microsoft.com/en-us/library/ee156817.aspx) cmdlet that can easily convert Powershell objects into formatted html pages. As I’ve written a few scripts producing html output, by sticking together a whole bunch of html tags, this was a real treat!

This simple one-liner will produce a html page from the output of the [Get-Service](http://technet.microsoft.com/en-us/library/ee176858.aspx) cmdlet.

```
Get-Service | ConvertTo-Html | Out-File C:\Users\Rhys\Desktop\services.html;
```

[![ConvertTo-HTML Output from Get-Service]({{ site.baseurl }}/assets/2010/10/ConvertToHTML_Output_thumb.png "ConvertTo-HTML Output from Get-Service")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/10/ConvertToHTML_Output.png)

As usual Powershell gives us loads of options to use with this cmdlet. We can specify a css file uri, title tags and if objects should be formatted as a list or a table. I do a lot of formatting, that the cmdlet can’t accommodate, in my html reports so I like using the –Fragment parameter which will output the html for a table only. This allows me to produce some fairly fancy looking reports by adding custom html.

```
Get-Service | Select-Object -First 1 | ConvertTo-Html -Fragment;
```

This spits out html like below…

```
<table>
<colgroup>
<col/>
<col/>
<col/>
<col/>
<col/>
<col/>
<col/>
<col/>
<col/>
<col/>
<col/>
<col/>
<col/>
<col/>
<col/>
</colgroup>
<tr><th>Name</th><th>RequiredServices</th><th>CanPauseAndContinue</th><th>CanShutdown</th><th>CanStop</th><th>DisplayName</th><th>DependentServices</th><th>MachineName
</th><th>ServiceName</th><th>ServicesDependedOn</th><th>ServiceHandle</th><th>Status</th><th>ServiceType</th><th>Site</th><th>Container</th></tr>
<tr><td>ACDaemon</td><td>System.ServiceProcess.ServiceController[]</td><td>False</td><td>False</td><td>False</td><td>ArcSoft Connect Daemon</td><td>System.ServiceProce
ss.ServiceController[]</td><td>.</td><td>ACDaemon</td><td>System.ServiceProcess.ServiceController[]</td><td>SafeServiceHandle</td><td>Stopped</td><td>Win32OwnProcess</
td><td></td><td></td></tr>
</table>
```

So generally it’s much easier than cobbling together html tags yourself. I guess the lesson here is that I often tend to pick and run with something a bit prematurely. I should probably spend more time reading the documentation and learning a ~~little~~ lot more about what is available. Time for me to get digging into [One Cmdlet at a time](http://www.jonathanmedd.net/2010/09/powershell-2-0-one-cmdlet-at-a-time-available-as-pdf-download.html).

