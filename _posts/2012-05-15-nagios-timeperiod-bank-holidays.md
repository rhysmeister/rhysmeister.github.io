---
layout: post
title: Nagios timeperiod for Bank Holidays
date: 2012-05-15 15:29:31.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Nagios
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461205'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/nagios-timeperiod-bank-holidays/1475";s:7:"tinyurl";s:26:"http://tinyurl.com/cu5feqg";s:4:"isgd";s:19:"http://is.gd/2SkKGZ";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/nagios-timeperiod-bank-holidays/1475/"
---
The Nagios configuration files come with a timeperiod example for US Public holidays but not for good old Blighty! Obviously that won't do so here's one for England & Wales (sorry Scotland!).

```
define timeperiod {
	name england-wales-holidays
	timeperiod_name england-wales-holidays
	alias England & Wales Holidays

	january 1 00:00-00:00	; New Years Day
	march 29 00:00-00:00	; Good Friday (Variable) 29 March good for 2013
	april 1 00:00-00:00	; Easter Monday (Variable) 1 April good for 2013
	monday 1 may 00:00-00:00	; May Day Bank Holiday (1st Monday in month)
	monday -1 may 00:00-00:00	; Spring Bank Holiday (Last Monday in month)
	monday -1 august	00:00-00:00	; Late Summer Bank Holiday
	december 25 00:00-00:00	; Public Holiday rolls forward if this falls on a Weekend (Good until 2016)
	december 26 00:00-00:00	; Public Holiday rolls forward if this falls on a Weekend (Good until 2015)
}
```

I never realised [Scotland](http://en.wikipedia.org/wiki/Public_holidays_in_the_United_Kingdom "Public Holidays in the United Kingdom") had such a variable system for public Holidays so have fun setting that up! Some of the holiday dates here are variable check [here](http://www.direct.gov.uk/en/employment/employees/timeoffandholidays/dg_073741 "England & Wlaes Public Holidays") for details.

