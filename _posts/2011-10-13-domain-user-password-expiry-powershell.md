---
layout: post
title: Domain user password expiry with Powershell
date: 2011-10-13 12:14:17.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Password expiry
- Powershell
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461580'
  _wp_old_slug: domin-user-password-expiry-powershell
  shorturls: a:3:{s:9:"permalink";s:77:"http://www.youdidwhatwithtsql.com/domain-user-password-expiry-powershell/1372";s:7:"tinyurl";s:26:"http://tinyurl.com/3mq5xs3";s:4:"isgd";s:19:"http://is.gd/5P4fn6";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/domain-user-password-expiry-powershell/1372/"
---
I needed to figure out a method for producing alerts when a domain account is approaching the password reset date. Here it is in a few lines of Powershell...

```
# Set name here
$name = "Rhys Campbell";
$user = Get-ADUser -LDAPFilter "(Name=$name)" -Properties PasswordLastSet;
$days = $(Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge;
$expires = $user.PasswordLastSet + $days;
$days_left = $expires - $(Get-Date);
Write-Host "Password for $name expires on $expires which is in $($days_left.Days) days.";
```

This will display something along the lines of;

```
Password for Rhys Campbell expires on 11/18/2011 08:19:36 which is in 35 days.
```
