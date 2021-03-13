---
layout: post
title: Preparing the NCDC Weather Data for Hadoop
date: 2013-01-12 11:55:41.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Big Data
tags:
- Hadoop
meta:
  _edit_last: '1'
  shorturls: a:3:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/preparing-ncdc-weather-data-hadoop/1526";s:7:"tinyurl";s:26:"http://tinyurl.com/a5wfpaz";s:4:"isgd";s:19:"http://is.gd/FwjMZN";}
  tweetbackscheck: '1613469322'
  _wp_old_slug: preparing-the-ncdc-weather-data-for-hadoop
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: tesnick@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/preparing-ncdc-weather-data-hadoop/1526/"
---
I'm exploring Hadoop with the book&nbsp;[Hadoop: The Definitive Guide](http://www.amazon.co.uk/dp/1449311520/ref=asc_df_144931152011446553?smid=A3P5ROKL5A1OLE&tag=hydra0b-21&linkCode=asn&creative=22206&creativeASIN=1449311520&hvpos=1o1&hvexid=&hvnetw=g&hvrand=1819299685757675364&hvpone=&hvptwo=&hvqmt=). Appendix A shows how to download [NCDC](http://www.ncdc.noaa.gov/) Weather data from [S3](http://en.wikipedia.org/wiki/Amazon_S3) and put it into Hadoop. I didn't want to download from S3 or load the entire dataset so here's what I did instead.

Here's a little bash script I used to download the data. You might want to do this if you want more up-to-date data, or if you only want to work with a subset. If you only want data for a certain year just append that year to the url in **$source\_url**.

```
#!/bin/bash

source_url="ftp://ftp3.ncdc.noaa.gov/pub/data/noaa/";
download_to="~/ncdc_data";

if [! -d "$download_to"]; then
    mkdir "$download_to";
fi

wget -r -c --progress=bar --no-parent -P "$download_to" "$source_url";
```

I've modified the script from the Hadoop book to work with local files. I'm just working with files from 2012. Modify the url in **target** if you want something different.

```
#!/usr/bin/env bash

# NCDC Weather file to load into hadoop
target="/home/rhys/ncdc_data/ftp3.ncdc.noaa.gov/pub/data/noaa/2012";

# Un-gzip each station file and concat into one file
echo "reporter:status:Un-gzipping $target" >&2
for file in $target/* do
    gunzip -c $file >> $target.all
    echo "reporter:status:Processed $file" >&2
done

# Put gzipped version into HDFS
echo "reporter:status:Gzipping $target and putting in HDFS" >&2
gzip -c $target.all | $HADOOP_INSTALL/bin/hadoop fs -put - gz/$target.gz
```

The script will unzip all the files, combine them, you should see output similar to this.

```
reporter:status:Processed /home/rhys/ncdc_data/ftp3.ncdc.noaa.gov/pub/data/noaa/2012/999999-94996-2012.gz
reporter:status:Processed /home/rhys/ncdc_data/ftp3.ncdc.noaa.gov/pub/data/noaa/2012/999999-96404-2012.gz
reporter:status:Processed /home/rhys/ncdc_data/ftp3.ncdc.noaa.gov/pub/data/noaa/2012/999999-99999-2012.gz
```

When it's finished combining all the files it will store the data in Hadoop.

```
reporter:status:Gzipping /home/rhys/ncdc_data/ftp3.ncdc.noaa.gov/pub/data/noaa/2012 and putting in HDFS 13/01/11 21:37:52
INFO util.NativeCodeLoader: Loaded the native-hadoop library
```

Once the process has completed you should be able to confirm the storage of your data in Hadoop with the following command;

```
rhys@linux-g1rx:~/hadoop_scripts> hadoop fs -ls gz/home/rhys/ncdc_data/ftp3.ncdc.noaa.gov/pub/data/noaa/2012.gz
```

```
Found 1 items
-rwxrwxrwx 1 rhys users 4870924294 2013-01-11 23:11 /home/rhys/hadoop_scripts/gz/home/rhys/ncdc_data/ftp3.ncdc.noaa.gov/pub/data/noaa/2012.gz
```

Now I have data in Hadoop it's time to start writing [MapReduc](http://en.wikipedia.org/wiki/Map)e jobs!

