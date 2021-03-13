---
layout: post
title: Checking Disk alignment with Powershell
date: 2011-10-05 20:36:04.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
- SQL Server
tags:
- disk alignment
- DISKPART
- Powershell
- StartingOffset
meta:
  twittercomments: a:0:{}
  tweetcount: '0'
  tweetbackscheck: '1613461663'
  shorturls: a:3:{s:9:"permalink";s:78:"http://www.youdidwhatwithtsql.com/checking-disk-alignment-with-powershell/1362";s:7:"tinyurl";s:26:"http://tinyurl.com/6bbpue6";s:4:"isgd";s:19:"http://is.gd/wLSeM2";}
  _sg_subscribe-to-comments: perrywhittle@pezzar.plus.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/checking-disk-alignment-with-powershell/1362/"
---
<p><a href="http://itknowledgeexchange.techtarget.com/sql-server/how-much-performance-are-you-loosing-by-not-aligning-your-drives/">Disk alignment</a> has been well discussed on the web and the methods to check this always seem to use <a title="wmic and DISKPART for disgn alignment" href="http://sqlskills.com/BLOGS/PAUL/post/Using-diskpart-to-check-disk-partition-alignment.aspx">wmic or DISKPART</a>. I've always loathed wmi so here's a few lines of Powershell that achieves the same thing;</p>
<pre lang="Powershell">$sqlserver = "sqlinstance";
# Get disk partitions
$partitions = Get-WmiObject -ComputerName $sqlserver -Class Win32_DiskPartition;
$partitions | Select-Object -Property DeviceId, Name, Description, BootPartition, PrimaryPartition, Index, Size, BlockSize, StartingOffset | Format-Table -AutoSize;</pre>
<p>This will display something looking like below;</p>
<pre>DeviceId              Name                  Description             BootPartition PrimaryPartition Index          Size BlockSize StartingOffset
--------              ----                  -----------             ------------- ---------------- -----          ---- --------- --------------
Disk #2, Partition #0 Disk #2, Partition #0 Installable File System False True 0 1099523162112 512 1048576 Disk #3, Partition #0 Disk #3, Partition #0 Installable File System False True 0 536878252032 512 1048576 Disk #4, Partition #0 Disk #4, Partition #0 Installable File System False True 0 1082130432 512 65536 Disk #5, Partition #0 Disk #5, Partition #0 Installable File System False True 0 1082130432 512 65536 Disk #1, Partition #0 Disk #1, Partition #0 Installable File System False True 0 107376279552 512 1048576 Disk #0, Partition #0 Disk #0, Partition #0 Installable File System True True 0 104857600 512 1048576 Disk #0, Partition #1 Disk #0, Partition #1 Installable File System False True 1 81684070400 512 105906176 Disk #0, Partition #2 Disk #0, Partition #2 Installable File System False True 2 104857600000 512 81789976576 Disk #0, Partition #3 Disk #0, Partition #3 Installable File System False True 3 104857600000 512 186647576576

A [64K cluster size](http://msdn.microsoft.com/en-us/library/dd758814(v=sql.100).aspx) is good for SQL Server. But what about the offset? The simple calculation below can be used to check this...

**StartingOffset / BlockSize / 128** (a 64K cluster has 128 sectors assuming a 512 block size).

If this calculation spits out a number with any decimal places then you have some disk aligning to do.

**<font color="#666666"></font>**

