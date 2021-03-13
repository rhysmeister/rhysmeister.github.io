---
layout: post
title: Send email with Powershell
date: 2010-10-27 20:03:18.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Email
- Powershell
- Powershell Scripting
meta:
  tweetbackscheck: '1613450988'
  shorturls: a:4:{s:9:"permalink";s:64:"http://www.youdidwhatwithtsql.com/send-email-with-powershell/889";s:7:"tinyurl";s:26:"http://tinyurl.com/283j2t6";s:4:"isgd";s:18:"http://is.gd/gmRfD";s:5:"bitly";s:20:"http://bit.ly/94ySWR";}
  twittercomments: a:2:{s:11:"28925609587";s:7:"retweet";s:11:"28924046113";s:7:"retweet";}
  tweetcount: '2'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/send-email-with-powershell/889/"
---
There’s two methods I often use for sending email in my [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell) scripts. The first uses the [Send-MailMessage](http://technet.microsoft.com/en-us/library/dd347693.aspx) cmdlet and the second resorts to using the .Net Framework. Why do I use two methods? Well….

```
Send-MailMessage -To 'me@here.com' -From 'sender@here.com' -Subject 'Test Message' -Body 'This is a test message.' -SmtpServer 'smtp.server.com';
```

The [Send-MailMessage](http://technet.microsoft.com/en-us/library/dd347693.aspx) cmdlet is powerful and easy to use but it’s lacking one important switch. If you’re using a smtp server on a port other than the default (25) then you cannot use this cmdlet to send emails. There’s no switch available to change the port used to send email. Here’s how I get around it.

```
$smtpClient = New-Object System.Net.Mail.SmtpClient;
$smtpClient.Host = 'smtp.server.com';
$smtpClient.Port = 8025;
$smtpClient.Send('email@email.com','email@email.com','Test Message', 'This is a test message.');
```

Powershell’s ability to hook into the .Net framework allows us to get around any limitation existing in the built in [cmdlets](http://msdn.microsoft.com/en-us/library/ms714395(VS.85).aspx). However, I’m still rooting for a –Port switch in the next version of Powershell!

