---
layout: post
title: Encryption with TSQL
date: 2011-08-03 14:42:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- Encryption
- TSQL
meta:
  shorturls: a:3:{s:9:"permalink";s:59:"http://www.youdidwhatwithtsql.com/encryption-with-tsql/1285";s:7:"tinyurl";s:26:"http://tinyurl.com/3fzaxx7";s:4:"isgd";s:19:"http://is.gd/qMr43z";}
  tweetbackscheck: '1613197892'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/encryption-with-tsql/1285/"
---
SQL Server has a bunch of [encryption functionality](http://technet.microsoft.com/en-us/library/bb510663.aspx) at its disposal. The [EncryptByPassphrase](http://technet.microsoft.com/en-us/library/ms190357.aspx "EncryptByPassphrase TSQL Function") allows us to quickly encrypt data using a password. This function uses the [Triple DES](http://en.wikipedia.org/wiki/Triple_DES "Triple DES") algorithm to protect data from prying eyes. To encrypt a section of text we supply a password and the text to the function;

```
SELECT ENCRYPTBYPASSPHRASE('secret', 'My very secret text');
```

This returns an encrypted version of our text.

```
0x01000000409190B7ABDB55FE3724888C854ADBF33DA0BDF6F8AD0DCB0DC76746A2122D515B96DA4DCEF14FFA
```

Of course there is also a [DecryptByPassphrase](http://technet.microsoft.com/en-us/library/ms188910.aspx "DecryptByPassphrase TSQL function") we can use to decrypt the data.

```
SELECT DECRYPTBYPASSPHRASE('secret', 0x010000006CF61B39AAF0030FDCED9942BEEEE946CB4EDB0AF2C0CDBCFB0B0882A7B32B4975974D20C8A3C82D);
```

```
0x4D792076657279207365637265742074657874
```

What? That's not our original text. What's going on here? This is our original text it's just in [VARBINARY](http://msdn.microsoft.com/en-us/library/ms188362.aspx "VARBINARY TSQL Function") format. Cast it to a char data type to make it human readable;

```
SELECT CONVERT(VARCHAR(100), DECRYPTBYPASSPHRASE('secret', 0x010000006CF61B39AAF0030FDCED9942BEEEE946CB4EDB0AF2C0CDBCFB0B0882A7B32B4975974D20C8A3C82D));
```

[![tsql encryption]({{ site.baseurl }}/assets/2011/08/tsql_encryption_thumb.png "tsql encryption")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/The-ENCRYPTBYPASSPHRASE-TSQL-Function_CC34/tsql_encryption.png)

