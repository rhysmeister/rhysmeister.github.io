---
layout: post
title: Configuring oAuth for Tweet-SQL
date: 2010-06-26 16:56:48.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Tweet-SQL
tags:
- oAuth
- Tweet-SQL
meta:
  tweetbackscheck: '1613461122'
  shorturls: a:4:{s:9:"permalink";s:69:"http://www.youdidwhatwithtsql.com/configuring-oauth-for-tweet-sql/814";s:7:"tinyurl";s:26:"http://tinyurl.com/2ded7gb";s:4:"isgd";s:18:"http://is.gd/d5eq0";s:5:"bitly";s:20:"http://bit.ly/dnT7ob";}
  twittercomments: a:1:{s:17:"17216918322679808";s:3:"251";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/configuring-oauth-for-tweet-sql/814/"
---
[Twitter](http://twitter.com) are soon requiring that all applications accessing their API use [oAuth](http://oauth.net/) instead of basic authentication. This means you don’t have to provide your password to third parties when using their apps. I’ve been busy adding this to the upcoming version of [Tweet-SQL](http://www.tweet-sql.com) and here’s a quick guide to setting up oAuth.

After installing Tweet-SQL launch the configuration program by clicking Start \> All Programs \> Tweet-SQL \> Tweet-SQL Config.

[![tweet-sql configuration program]({{ site.baseurl }}/assets/2010/06/tweetsql_configuration_program_thumb.png "tweet-sql configuration program")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/06/tweetsql_configuration_program.png)

Ensure the **Authentication** drop down is set to OAuth. Enter your username in the box labelled **username**. [Tweet-SQL](http://www.tweet-sql.com) needs your username for some api calls to work. Click File \> Save Config to save this information.

[![tweet-sql config]({{ site.baseurl }}/assets/2010/06/tweetsql_config_thumb.png "tweet-sql config")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/06/tweetsql_config.png)

Next click oAuth \> Get Access Token. Tweet-SQL will launch your default web browser to contact [Twitter](http://twitter.com). Enter your login details into twitter and click **Allow**.

[![twitter oauth sign in]({{ site.baseurl }}/assets/2010/06/twitter_oauth_signin_thumb.png "twitter oauth sign in")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/06/twitter_oauth_signin.png)

Once you have granted Tweet-SQL access you will be provided with a PIN. Copy this PIN to your clipboard.

[![twitter oauth pin]({{ site.baseurl }}/assets/2010/06/twitter_oauth_pin_thumb.png "twitter oauth pin")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/06/twitter_oauth_pin.png)

Return to the Tweet-SQL configuration program and enter the PIN in the dialog box.

[![tweet-sql oauth pin]({{ site.baseurl }}/assets/2010/06/tweetsql_oauth_pin_thumb.png "tweet-sql oauth pin")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/06/tweetsql_oauth_pin.png)

Tweet-SQL will then verify the PIN with Twitter to complete the process. After a few moments a confirmation will be displayed.

[![tweet-sql oauth confirmation]({{ site.baseurl }}/assets/2010/06/tweetsql_oauth_confirmation_thumb.png "tweet-sql oauth confirmation")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/06/tweetsql_oauth_confirmation.png)

You are now ready to start using Tweet-SQL!

```
EXEC dbo.tweet_sts_update 'Dinner on the river tonight!', null;
```

You can continue using basic authentication with Twitter until **August 16th 2010**. The new version of Tweet-SQL supporting oAuth will be released within the next few weeks. Find out [more about oAuth](http://dev.twitter.com/pages/oauth_faq) and download [Tweet-SQL now](http://www.tweet-sql.com/download.php)!

