---
layout: post
title: 'SSIS: Failed to load XML from package file'
date: 2013-09-03 09:28:04.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SSIS
tags:
- bids
- SSIS
meta:
  _edit_last: '1'
  tweetbackscheck: '1613456211'
  shorturls: a:3:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/ssis-failed-load-xml-package-file/1665/";s:7:"tinyurl";s:26:"http://tinyurl.com/lpp5abn";s:4:"isgd";s:19:"http://is.gd/A4BYUO";}
  _wp_old_slug: failed-load-xml-package-file
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssis-failed-load-xml-package-file/1665/"
---
I recently came across this error in one of our SSIS packages.

```
Description: Failed to load XML from package file
"C:\Path\To\Package.dtsx" due to error 0xC00CE508
"An invalid character was found in text content. Line 426, Column 104". This happens when loading a
package and the file cannot be opened or loaded correctly into an XML document.
This can be the result of either providing an incorrect file name to the LoadPackage method or the XML file
specified having an incorrect format. End Error Could not load package
"C:\Path\To\Package.dts" because of error 0xC00CE508.
```

I opened the package in a text editor and this was at line 426

```
Execute SQL Task; Microsoft Corporation; Microsoft SQL Server v9; © 2004 Microsoft Corporation; All Rights Reserved;http://www.microsoft.com/sql/support/default.asp;1
```

The dodgy character at column 104 was the copyright symbol. I think perhaps the package was opened up in notepad and saved screwing up the encoding. I opened the package in [BIDS](http://technet.microsoft.com/en-us/library/ms173767(v=sql.105).aspx "Business Intelligence Development Studio") and re-saved it. Looking at the line again I could see it had changed. The package could execute successfully after this.

