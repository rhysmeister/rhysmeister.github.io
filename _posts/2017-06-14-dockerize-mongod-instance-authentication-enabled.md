---
layout: post
title: A dockerized mongod instance with authentication enabled
date: 2017-06-14 14:56:51.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MongoDB
tags:
- Docker
- mongodb
meta:
  _edit_last: '1'
  tweetbackscheck: '1613276411'
  shorturls: a:2:{s:9:"permalink";s:88:"http://www.youdidwhatwithtsql.com/dockerize-mongod-instance-authentication-enabled/2307/";s:7:"tinyurl";s:27:"http://tinyurl.com/yaphyjb4";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/dockerize-mongod-instance-authentication-enabled/2307/"
---
Here's just a quick walkthrough showing how to create a [dockerized](https://www.docker.com/) instance of a standalone [MongoDB](https://www.mongodb.com/) instance.

First, from within a terminal, create a folder to hold the Dockerfile...

```
mkdir Docker_MongoDB_Image
cd Docker_MongoDB_Image
touch Dockerfile
```

Edit the Dockerfile...

```
vi Dockerfile
```

Enter the following text. You may wish to modify the file slightly. For example; if you need to set any of the proxy values or the MongoDB admin password.

```
FROM centos
#ENV http_proxy XXXXXXXXXXXXXXXXXX
#ENV https_proxy XXXXXXXXXXXXXXX

MAINTAINER Rhys Campbell no_mail@no_mail.cc

RUN echo $'[mongodb-org-3.4] \n\
name=MongoDB Repository \n\
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/ \n\
gpgcheck=1 \n\
enabled=1 \n\
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc ' > /etc/yum.repos.d/mongodb-org-3.4.repo

RUN yum clean all && yum install -y mongodb-org-server mongodb-org-shell mongodb-org-tools
RUN mkdir -p /data/db && chown -R mongod:mongod /data/db
RUN /usr/bin/mongod -f /etc/mongod.conf && sleep 5 && mongo admin --eval "db.createUser({user:\"admin\",pwd:\"secret\",roles:[{role:\"root\",db:\"admin\"}]}); db.shutdownServer()"
RUN echo $'security: \n\
  authorization: enabled \n ' >> /etc/mongod.conf
RUN sed -i 's/^ bindIp: 127\.0\.0\.1/ bindIp: \[127\.0\.0\.1,0\.0\.0\.0\]/' /etc/mongod.conf
RUN sed -i 's/^ fork: true/ fork: false/' /etc/mongod.conf
RUN chown mongod:mongod /etc/mongod.conf
RUN cat /etc/mongod.conf

EXPOSE 27017

ENTRYPOINT /usr/bin/mongod -f /etc/mongod.conf
```

Build the image from within the current dirfectory...

```
docker build -t mongod-instance . --no-cache
```

Run the image and map to the 27017 port...

```
docker run -p 27017:27017 --name mongod-instance -t mongod-instance
```

Inspect the mapped port with...

```
docker ps
```

The output should look something like this...

```
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
5e7e4a069f4a mongod-instance "/bin/sh -c '/usr/..." 2 hours ago Up 2 hours 0.0.0.0:27017->27017/tcp mongod-instance
```

We can view the docker ip address with this command...

```
docker-machine ls
```

Output looks like this...

```
NAME ACTIVE DRIVER STATE URL SWARM DOCKER ERRORS
default * virtualbox Running tcp://192.168.99.100:2376 v17.05.0-ce
```

You can connect to the dockerized mongod instance with this command...

```
mongo admin -u admin -p --port 27017 --host 192.168.99.100
```

When you are done with the instance it can be destroyed with...

```
docker stop mongod-instance
docker rm mongod-instance
```

**Update** : I've added this to my [Docker Hub account](https://hub.docker.com/r/rhyscampbell/mongod/) so you can grab the image directly from there.

