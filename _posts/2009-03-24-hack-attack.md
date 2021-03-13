---
layout: post
title: Hack Attack
date: 2009-03-24 20:08:44.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories: []
tags: []
meta:
  tweetbackscheck: '1613296493'
  shorturls: a:7:{s:9:"permalink";s:48:"http://www.youdidwhatwithtsql.com/hack-attack/48";s:7:"tinyurl";s:25:"http://tinyurl.com/cdl4r9";s:4:"isgd";s:17:"http://is.gd/sKfp";s:5:"bitly";s:19:"http://bit.ly/xk7i1";s:5:"snipr";s:22:"http://snipr.com/g0n1z";s:5:"snurl";s:22:"http://snurl.com/g0n1z";s:7:"snipurl";s:24:"http://snipurl.com/g0n1z";}
  twittercomments: a:1:{i:1533565708;s:7:"retweet";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/hack-attack/48/"
---
Today I spotted a suspicious looking file called **login.txt** on the c drive of a customers web server. Being the ~~nosey~~ curious type I opened the file and this is what it contained...

```
Welcome!!!

This server is hacked by This_is_Joepie.
Download with fun and:
DON'T PUBLISH THIS IP ANYWHERE
DON'T REHACK THIS SERVER
DON'T SCAN THIS IP RANGE

Thnx!!!

==========================================
Bandwidth Usage: %ServerKBps KB/sec
Users Connected: %UNow
==========================================
Server Uptime: %ServerDays Days, %ServerHours Hours
==========================================”
```

I googled [This\_is\_Joepie](http://www.google.com/search?q=This_is_Joepie&ie=utf-8&oe=utf-8&aq=t) and, assuming they're the same person, this seems to be a gaming enthusiast from Holland. I went back to the c drive and ordered the files by last modified date revealing several more interesting files. The most interesting was **Servudaemon.ini**

```
[GLOBAL]
Version=3.0.0.17
RegistrationKey=6dYwuCzKYyiSYQm0Hlp0OmDivgW8pyxAM2ZMLSpgg9Ywu+psehNIYwi0Ex4bTweO33ac5V4vRxJZXk8MhblFzGyrF1z1DWbWfzZaVAWW
LocalSetupPassword=45244E5D5D024857420D585F
LocalSetupPortNo=5555
AntiHammer=1
SocketKeepAlive=1
PacketTimeOut=300
BlockAntiTimeOut=1
SocketInlineOOB=1
AntiHammerBlock=1200
AntiHammerWindow=60
SocketRcvBuffer=37376
SocketSndBuffer=37376
BlockFTPBounceAttack=1
OpenFilesUploadMode=Shared
ProcessID=1888

[DOMAINS]
Domain1=0.0.0.0||65101|FTP|1

[Domain1]
ReplyTooMany=Too many leechers....try again later m8!
SignOn=c:\login.txt
DirChangeMesFile=cdir.txt
ReplyHello=Welcome to this hacked server by Razorblade
ReplySYST=Guess
LogFileSystemMes=0
LogFileSecurityMes=0
LogFileGETs=0
LogFilePUTs=0
MaxNrUsers=15
ReplyHelp=You don't need help, right?!
ReplyNoAnon=NO ANONYMOUS ACCES!! LEAVE!!!
ReplyOffline=Server is down....
User1=master|1|0
User2=leechers|1|0
DirChangeMesFile2=cdir.txt

[USER=master|1]
Password=ts20A63ADD1C5CC3D10C6BCF25C6C7D3C8
HomeDir=c:\
AlwaysAllowLogin=1
ChangePassword=1
TimeOut=600
Maintenance=System
Access1=c:\|RWAMELCDP
Access2=f:\|RWAMELCDP
Access3=d:\|RWAMELCDP
Access4=e:\|RWAMELCDP
Access5=h:\|RWAMELCDP
Access6=g:\|RWAMELCDP
Access7=m:\|RWAMELCDP
Access8=i:\|RWAMELCDP
Access9=h:\|RWAMELCDP

[USER=leechers|1]
Password=gn27FD3D071B1D3F0D55F158DDA003B76C
HomeDir=f:\server
RelPaths=1
HideHidden=1
MaxUsersLoginPerIP=1
TimeOut=600
Access1=f:\server|RLP
```

Now I guess this person was running some kind of Warez ftp server. I couldn't locate any services running on the ports mentioned above or any dodgy looking files on the server. Do hackers clean up after themselves? The worrying thing is the the last modified date on these files was back at the start of 2002!

