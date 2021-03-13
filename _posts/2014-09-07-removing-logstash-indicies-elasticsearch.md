---
layout: post
title: Removing logstash indicies from elasticsearch‏
date: 2014-09-07 13:39:58.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Big Data
tags:
- elasticsearch
- fluentd
- kibana
- logstash
meta:
  _edit_last: '1'
  tweetbackscheck: '1613459789'
  shorturls: a:3:{s:9:"permalink";s:80:"http://www.youdidwhatwithtsql.com/removing-logstash-indicies-elasticsearch/1963/";s:7:"tinyurl";s:26:"http://tinyurl.com/qdbmed7";s:4:"isgd";s:19:"http://is.gd/LkRFxK";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/removing-logstash-indicies-elasticsearch/1963/"
---
I've been playing with [EFK](http://www.youdidwhatwithtsql.com/efk-free-alternative-splunk-fluentd/1931/ "EFK Alternative to Splunk") and [elasticsearch](http://www.elasticsearch.org/ "elasticsearch") ended up eating all of the RAM on my test system. I discovered this was due to it attempting to cache all these indexes. Since this is a test system I'm not too bothered about having a long history here so I wrote this bash script to remove logstash indexes from elasticsearch, compress and archive them. This has the effect of reducing the memory pressure and a better working system. Explanatory comments are included.

```
#!/bin/bash

#######################################
# Author: Rhys Campbell #
# Created: 2014-08-06 #
# Description: Removes indicies with #
# a modified date > N days from ES #
# memory and archives them using lzma #
# compression. #
#######################################
INDICIES_PREFIX="logstash"; # Indicies name prefix
INDICIES_ROOT="/data/elasticsearch/data/elasticsearch/nodes/0/indices/$INDICIES_PREFIX"; # Daily indicies root
DAYS=5; # Days of indexes to keep
ARCHIVE="/data/elasticsearch/data/elasticsearch/nodes/0/indices/archive"; # archive location
ES_URL="http://hostname:9200/";

logger -t elasticsearch "Begining archiving of elasticsearch indicies.";

for DIR in `find /data/elasticsearch/data/elasticsearch/nodes/0/indices/logstash* -maxdepth 0 -mtime +"$DAYS"`;
do
 # Remove index from elasticsearch
INDEX_NAME=`basename "$DIR"`;
REMOVAL_URL="$ES_URL$INDEX_NAME/_close";
#curl -XPOST "$REMOVAL_URL"; # Uncomment this line. Wordpess balks on this for some reason
EXIT=$?;
    if ["$EXIT" -ne 0]; then
        logger -t elasticsearch "ERROR: Removal of elasticsearch index at $REMOVAL_URL failed Exit Code = $EXIT.";
        exit $EXIT;
    else
        logger -t elasticsearch "Successfully removed $REMOVAL_URL from elasticsearch.";
    fi;
    # Now archive the directory
    tar cvf "$DIR".lzma "$DIR" --lzma --remove-files;
    EXIT=$?;
    if ["$EXIT" -ne 0]; then
        logger -t elasticsearch "ERROR: lzma compression of elasticsearch index file encountered an error. Exit Code = $EXIT.";
        exit $EXIT;
    else
        logger -t elasticsearch "Compressed elasticsearch index $INDEX_NAME successfully.";
    fi;
    mv "$DIR".lzma "$ARCHIVE";
    EXIT=$?;
    if ["$EXIT" -ne 0]; then
        logger -t elasticsearch "ERROR: Could not move $DIR.lzma to archive location $ARCHIVE. Exit Code = $EXIT.";
        exit $EXIT;
    else
        logger -t elasticsearch "Removal and archiving of the elasticsearch index $INDEX_NAME completed successfully.";
    fi;

done

logger -t elasticsearch "Completed archiving of elasticsearch indicies.";
```
