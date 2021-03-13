---
layout: post
title: The 'DataSourceView' with 'ID' = 'Adventure Works DW2008' doesn't exist in
  the collection.
date: 2010-02-15 21:58:08.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SSAS
tags: []
meta:
  tweetbackscheck: '1613461466'
  shorturls: a:4:{s:9:"permalink";s:118:"http://www.youdidwhatwithtsql.com/the-datasourceview-with-id-adventure-works-dw2008-doesnt-exist-in-the-collection/647";s:7:"tinyurl";s:26:"http://tinyurl.com/yljcecm";s:4:"isgd";s:18:"http://is.gd/8tPw0";s:5:"bitly";s:20:"http://bit.ly/d1ALKr";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/the-datasourceview-with-id-adventure-works-dw2008-doesnt-exist-in-the-collection/647/"
---
One of [my goals for this year](http://www.youdidwhatwithtsql.com/goals-for-2010/514) has been to learn more about [SQL Server Analysis Services](http://msdn.microsoft.com/en-us/library/ms175609(SQL.90).aspx). So I've bought myself a (very fat) book on the subject and have started to work my way through it. A few days ago I built the first example cube in Chapter two. Coming back to it this evening, I opened the project in [BIDS](http://msdn.microsoft.com/en-us/library/ms173767.aspx), and was presented with the following error in the cube designer.

![ssas designer data source view collection error]({{ site.baseurl }}/assets/2010/02/ssas_designer_data_source_view_error_thumb.png "ssas designer data source view collection error")

I recalled renaming the [DataSource View](http://technet.microsoft.com/en-us/library/ms174600.aspx), and have experienced similar issues with renaming objects in [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx), so I decided to check out the properties of the DataSourceView.

[![ssas data source view]({{ site.baseurl }}/assets/2010/02/ssas_data_source_view_thumb.png "ssas data source view")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssas_data_source_view.png)

Mmmm, the ObjectId here has a '1' on the end which implies to me it has been copied and pasted from an original. This info appears to be read only here so I decided to dive into the cubes xml. The xml of a cube can be viewed by right-clicking on it in [Solution Explorer](http://msdn.microsoft.com/en-us/library/26k97dbc(VS.80).aspx) and choosing "View Code".

[![ssas_cube_xml]({{ site.baseurl }}/assets/2010/02/ssas_cube_xml_thumb.png "ssas\_cube\_xml")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssas_cube_xml.png)

I found one reference to **Adventure Works DW2008** in this XML between **\<DataSourceViewId\>** tags. I changed this to the Id of **Adventure Works DW2008 1** as below.

[![ssas_cube_xml2]({{ site.baseurl }}/assets/2010/02/ssas_cube_xml2_thumb.png "ssas\_cube\_xml2")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssas_cube_xml2.png)

I then saved the project and went back to the cube designer.

[![ssas designer data source view error fixed]({{ site.baseurl }}/assets/2010/02/ssas_designer_data_source_view_error_fixed_thumb.png "ssas designer data source view error fixed")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssas_designer_data_source_view_error_fixed.png)

Excellent. I have repaired my broken cube! Now on with Chapter three!

