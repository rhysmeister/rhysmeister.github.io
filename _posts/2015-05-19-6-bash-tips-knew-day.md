---
layout: post
title: 6 Useful Bash tips I wish I knew from day zero
date: 2015-05-19 10:10:14.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Bash
- Linux
tags:
- Bash
- Linux
- terminal
meta:
  _edit_last: '1'
  tweetbackscheck: '1613478403'
  shorturls: a:3:{s:9:"permalink";s:60:"http://www.youdidwhatwithtsql.com/6-bash-tips-knew-day/2095/";s:7:"tinyurl";s:26:"http://tinyurl.com/ogfo68h";s:4:"isgd";s:19:"http://is.gd/nPI4dG";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/6-bash-tips-knew-day/2095/"
---
Here's a few bash commands tricks I wished I'd been shown when I first picked up the shell. Please share any additional favorites you have.

**Repeat the last command with sudo**

How often do you type...

```
yum install long-list packages-devel
```

Only to be told...

```
You need to be root to perform this command.
```

Execute&nbsp;the following to install your packages...

```
sudo !!
```

The !! points to the&nbsp;previous command executed in the shell.

**Save a readonly file in vi/vim**

How many times have you opened a file in vi/vim, made lots of changes, only to be told it's read-only when you attempt to save? Enter this in command mode to get around this...

```
:w !sudo tee
```

There's a good explanation of this [here](http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work).

**alias**

It can be time-consuming to search through your command history. Setup an [alias](http://linuxcommand.org/lc3_man_pages/aliash.html) instead.

```
alias shortcut="cmd -with=1 --lots=2 --of=3 -options=4 | piped -a -b -c"
```

The cmd with lots of options can now be executed as...

```
shortcut
```

Much simpler! Add these to your .bash\_profile file to make them available permanently.

**Clear your terminal window**

I used to use [clear](http://linux.die.net/man/1/clear) for this. But this just shimmies everything upwards. Use..

```
reset
```

To actually clear the terminal screen.

**Display output to a screen and save to a file**

For a long time I was copying and pasting terminal output to save into text files. Then I discovered [tee](http://unixhelp.ed.ac.uk/CGI/man-cgi?tee). Do this instead...

```
ls -lh | tee output.txt
```

**Command-line calculator**

For simple calculations on the command-line you can use [bc](http://linux.die.net/man/1/bc).

```
echo "2 * 2" | bc
```

Outputs...

```
4
```
