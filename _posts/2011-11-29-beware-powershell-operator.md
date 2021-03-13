---
layout: post
title: Beware the Powershell -Contains operator
date: 2011-11-29 12:20:00.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- contains
- Powershell
meta:
  _edit_last: '1'
  tweetbackscheck: '1613460801'
  _wp_old_slug: beware-the-powershell-contains-operator
  shorturls: a:3:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/beware-powershell-operator/1403";s:7:"tinyurl";s:26:"http://tinyurl.com/ckc5ayk";s:4:"isgd";s:19:"http://is.gd/TXuh6X";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: goran.vrhovec@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/beware-powershell-operator/1403/"
---
Many of us tend to jump quickly, into a new programming or scripting language, applying knowledge we've learned elsewhere to the current task at hand. Broadly speaking this works well but these always a little [gotcha](http://en.wikipedia.org/wiki/Gotcha_(programming) "Gotcha") to trip you up!

A good example is the Powershell -contains operator. It's not like .Net [String.Contains](http://msdn.microsoft.com/en-us/library/dy85x1sa.aspx ".Net String.Contains method") method as you might first think.

```
$var = "Rhys Campbell";
$var -contains "Rhys";
```

The result of this is **false**. Why? Because the **-contains** operator in Powershell is used for testing for [items in an array](http://technet.microsoft.com/en-us/library/ee692798.aspx "Powershell -contains operator").

```
$var = "Rhys Campbell", "Joe Bloggs";
$var -contains "Rhys Campbell";
```

Will return **true** , but;

```
$var -contains "Rhys*";
```

Will return **false** as wildcards will not work as we assume they will. For wildcard matching we can use the **-match** operator.

```
$var = "Rhys Campbell";
$var -match "Rhys";
```

This will return **true** when matching simple strings or the matching items from an array of strings. Now I'm going to try and remember what [assumption is the mother of](http://www.youtube.com/watch?v=wg4trPZFUwc) (NSFW, contains cussing).

