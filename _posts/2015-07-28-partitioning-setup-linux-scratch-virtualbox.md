---
layout: post
title: Partitioning setup for Linux from Scratch in VirtualBox
date: 2015-07-28 20:50:44.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Linux
- Linux from Scratch
tags:
- fdisk
- LFS
- Linux
- Linux From Scratch
meta:
  _edit_last: '1'
  tweetbackscheck: '1613460455'
  shorturls: a:3:{s:9:"permalink";s:83:"http://www.youdidwhatwithtsql.com/partitioning-setup-linux-scratch-virtualbox/2121/";s:7:"tinyurl";s:26:"http://tinyurl.com/nphvzzt";s:4:"isgd";s:19:"http://is.gd/WyGQMv";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/partitioning-setup-linux-scratch-virtualbox/2121/"
---
I've finally taken the plunge and committed, to untarring and compiling, a bucket load of source code to complete [Linux from Scratch](http://www.linuxfromscratch.org/). I'll be documenting some of my setup here. I'm far from an expert, that's why I'm doing this, but if you have any constructive criticism I'd be glad to hear it. I'm using [VirtualBox](https://www.virtualbox.org/) and an installation of [CentOS](https://www.centos.org/) to build LFS.

The first task I'll be undertaking is partitioning a disk ready for my LFS setup. I've designed my partition setup based on the advice in the LFS manual: [Creating a New Partition](http://www.linuxfromscratch.org/lfs/view/stable/chapter02/creatingpartition.html).

| Partition | Size (GB/MB) | On Primary |
| --- | --- | --- |
| / (root partition) | 10GB | 1 |
| /home | 10GB | 1 |
| /usr | 5GB | 1 |
| /opt | 10GB | 1 |
| /swap | 2GB | 0 |
| /boot | 100M | 0 |

\* The On Primary = 1 means the partition will be hosted on the first, larger, partition we create.

**Add a VirtualBox HDD**

First add [VirtualBox hard disk](https://www.virtualbox.org/manual/ch05.html). I added a 50GB drive in VB for this to give me plenty of space for my LFS installation.

[![Linux From Scratch VirtualBox Disk]({{ site.baseurl }}/assets/2015/07/LFS-300x237.jpg)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2015/07/LFS.jpg)

**Identify the new device**

Boot up the host OS, CentOS 7 in my case, and open a command prompt once logged in. The command [lsblk](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s1-sysinfo-filesystems.html) can be used to quickly identify the new device. From the output we can easily identify the disk as&nbsp; **sdb**. It is 50GB and contain no partitions.

```
linux> lsblk
NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda 8:0 0 50G 0 disk
├─sda1 8:1 0 500M 0 part /boot
└─sda2 8:2 0 49.5G 0 part
  ├─centos-swap 253:0 0 2G 0 lvm [SWAP]
  └─centos-root 253:1 0 47.5G 0 lvm /
sdb 8:16 0 50G 0 disk
sr0 11:0 1 1024M 0 rom
```

**Create a large Primary Partition**

First we will create a single large partition. This partition will be the logical container for the above partition mark above as&nbsp; **On primary = 1.** We will be using [fdisk](http://tldp.org/HOWTO/Partition/fdisk_partitioning.html) for this. You'll need to run fdisk as the root user.

```
fdisk /dev/sdb
```

```
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0xdf241aa7.

Command (m for help):
```

Enter 'n' to create a new partition.  
Enter 'e' for partition type.  
Enter '1' for partition number.  
Accept the default for first sector.  
Enter '+40G' for the last sector.

This partition does not yet exist, we have to tell fdisk to writes changes before that happens. However you can have a look at what will be done by entering the command 'p'...

```
Device Boot Start End Blocks Id System
/dev/sdb1 2048 83888127 41943040 5 Extended
```

Now we will add the four logical partitions inside the one above...

Enter 'n' to create a new partition.  
Enter 'l' for logicial.  
Accept the default for first sector.  
For last sector enter '+10G'

Enter 'n' to create a new partition.  
Enter 'l' for logicial.  
Accept the default for first sector.  
For last sector enter '+10G'

Enter 'n' to create a new partition.  
Enter 'l' for logicial.  
Accept the default for first sector.  
For last sector enter '+5G'

Enter 'n' to create a new partition.  
Enter 'l' for logicial.  
Accept the default for first sector.  
For last sector enter '+10G'

Enter the 'p' command to print out the partition table

```
Device Boot Start End Blocks Id System
/dev/sdb1 2048 83888127 41943040 5 Extended
/dev/sdb5 4096 20975615 10485760 83 Linux
/dev/sdb6 20977664 41949183 10485760 83 Linux
/dev/sdb7 41951232 52436991 5242880 83 Linux
/dev/sdb8 52439040 73410559 10485760 83 Linux
```

Finally we will add partitions for the swap and boot partitions. While still in fdisk...

Enter 'n' to create a new partition.  
Enter 'p' for primary.  
Accept the default for first sector and partition number.  
For last sector enter '+2G'

Enter 'n' to create a new partition.  
Enter 'p' for primary.  
Accept the default for first sector and partition number.  
For last sector enter '+100M'

Enter 'p to print the output. You should have something like below.

```
Device Boot Start End Blocks Id System
/dev/sdb1 2048 83888127 41943040 5 Extended
/dev/sdb2 83888128 88082431 2097152 83 Linux
/dev/sdb3 88082432 88287231 102400 83 Linux
/dev/sdb5 4096 20975615 10485760 83 Linux
/dev/sdb6 20977664 41949183 10485760 83 Linux
/dev/sdb7 41951232 52436991 5242880 83 Linux
/dev/sdb8 52439040 73410559 10485760 83 Linux
```

Finally enter 'w' to write the changes to disk and exit. You can use lsblk again to get a more human friendly view of the partition sizes.

```
NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda 8:0 0 50G 0 disk
├─sda1 8:1 0 500M 0 part /boot
└─sda2 8:2 0 49.5G 0 part
  ├─centos-swap 253:0 0 2G 0 lvm [SWAP]
  └─centos-root 253:1 0 47.5G 0 lvm /
sdb 8:16 0 50G 0 disk
├─sdb1 8:17 0 1K 0 part
├─sdb2 8:18 0 2G 0 part
├─sdb3 8:19 0 100M 0 part
├─sdb5 8:21 0 10G 0 part
├─sdb6 8:22 0 10G 0 part
├─sdb7 8:23 0 5G 0 part
└─sdb8 8:24 0 10G 0 part
sr0 11:0 1 1024M 0 rom
```

**Format the partitions and give them each a table**

From the output of lsblk you can match up the devices using their sizes and give them a label.

```
sudo mkfs -v -t ext4 /dev/sdb7 -L usr
sudo mkfs -v -t ext4 /dev/sdb3 -L boot
sudo mkfs -v -t ext4 /dev/sdb5 -L root
sudo mkfs -v -t ext4 /dev/sdb6 -L home
sudo mkfs -v -t ext4 /dev/sdb8 -L opt
sudo mkswap /dev/sdb2 -L swap
```

**Mount the partitions**

Next create some folders to mount the partitions on....

```
mkdir /mnt/lfs
chown -R rhys:users /mnt/lfs
export LFS=/mnt/lfs
mount -v -t ext4 /dev/sdb5 $LFS
mkdir /mnt/lfs/usr
mount -v -t ext4 /dev/sdb7 $LFS/usr
mkdir /mnt/lfs/home
mount -v -t ext4 /dev/sdb6 $LFS/home
mkdir /mnt/lfs/opt
mount -v -t ext4 /dev/sdb8 $LFS/opt
mkdir /mnt/lfs/boot
mount -v -t ext4 /dev/sdb3 $LFS/boot
swapon /dev/sdb2
```

You can view the new mounts with..

```
linux> df -h
...
dev/sdb5 9.8G 37M 9.2G 1% /mnt/lfs
/dev/sdb7 4.8G 20M 4.6G 1% /mnt/lfs/usr
/dev/sdb6 9.8G 37M 9.2G 1% /mnt/lfs/home
/dev/sdb8 9.8G 37M 9.2G 1% /mnt/lfs/opt
/dev/sdb3 93M 1.6M 85M 2% /mnt/lfs/boot
...
```

You may receive a warning about these mounts...

```
You just mounted an file system that supports labels which does not
contain labels, onto an SELinux box. It is likely that confined
applications will generate AVC messages and not be allowed access to
this file system. For more details see restorecon(8) and mount(8).
```

Fix this with...

```
linux> restorecon -R /mnt
```

**Making the mounts persistent**

You can copy the output from [/etc/mtab](https://en.wikipedia.org/wiki/Mtab) and add an edited version to your [/etc/fstab](https://en.wikipedia.org/wiki/Fstab) file to make these mounts persistent.

These mounts should probably be owned by the [lfs user](http://www.linuxfromscratch.org/lfs/view/6.5/chapter04/addinguser.html). I'll update this section with more detail when I decide precisely what to do.

