---
layout: post
title: Multiple Twitter accounts with Tweet-SQL
date: 2011-05-04 21:13:01.000000000 +02:00
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
- twitter
meta:
  tweetbackscheck: '1613275572'
  shorturls: a:3:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/multiple-twitter-accounts-with-tweet-sql/1082";s:7:"tinyurl";s:26:"http://tinyurl.com/3fbdakz";s:4:"isgd";s:19:"http://is.gd/ZFM2DF";}
  twittercomments: a:1:{s:17:"69750545316970496";s:7:"retweet";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/multiple-twitter-accounts-with-tweet-sql/1082/"
---
Since [Twitter](http://twitter.com) made the switch to use [oAuth](http://oauth.net) the single most requested feature for [Tweet-SQL](http://www.tweet-sql.com "Tweet-SQL - Twitter app for SQL Server") has been for better handling of multiple twitter accounts. While it was possible to use multiple accounts, with no restriction, you had to go through the oAuth process every time you wanted to change usernames. Obviously this won't do so I've improved this in the next version of [Tweet-SQL](http://www.tweet-sql.com).

Firstly, assuming you've already gone through the [oAuth process for Tweet-SQL](http://www.youdidwhatwithtsql.com/configuring-oauth-for-tweet-sql/814 "Tweet-SQL - How to use oAuth") once we need to copy the current active account. Just run the below TSQL in [SSMS](http://en.wikipedia.org/wiki/SQL_Server_Management_Studio) against the database you have installed the software in.

```
EXEC dbo.tweet_cfg_copy_oauth_account;
```

This will copy the Twitter account details from the registry to a table called **dbo.tweet\_oauth\_accounts**. This account remains active for Tweet-SQL.

Next we need to authorise the additional account with the Tweet-SQL configuration program. Launch the tool, change the **username** field to the new account screen name, click File \> Save Config.

[![tweet-sql_configuration_program]({{ site.baseurl }}/assets/2011/05/tweet-sql_configuration_program_thumb.png "tweet-sql\_configuration\_program")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Multiple-Twitter-accounts-with-Tweet-SQL_11F86/tweet-sql_configuration_program.png)

Click oAuth \> Get Access Token to begin the oAuth process. The following dialog will appear. Click 'Yes'. Provided you have executed the **dbo.tweet\_cfg\_copy\_oauth\_account** procedure the old account details will be saved.

[![tweet-sql_popup_dialog]({{ site.baseurl }}/assets/2011/05/tweet-sql_popup_dialog_thumb.png "tweet-sql\_popup\_dialog")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Multiple-Twitter-accounts-with-Tweet-SQL_11F86/tweet-sql_popup_dialog.png)

In a few moments your browser will launch and you will be prompted to login to Twitter. Login with the appropriate account, authorise [Tweet-SQL](http://www.tweet-sql.com "Tweet-SQL - Export twitter data to SQL Server") and copy the pin.

[![twitter_oauth_pin]({{ site.baseurl }}/assets/2011/05/twitter_oauth_pin_thumb.png "twitter\_oauth\_pin")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Multiple-Twitter-accounts-with-Tweet-SQL_11F86/twitter_oauth_pin.png)

Return to the Tweet-SQL configuration program and paste the pin into the dialog box.

[![tweet-sql_oauth_pin_dialog]({{ site.baseurl }}/assets/2011/05/tweet-sql_oauth_pin_dialog_thumb.png "tweet-sql\_oauth\_pin\_dialog")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Multiple-Twitter-accounts-with-Tweet-SQL_11F86/tweet-sql_oauth_pin_dialog.png)

Click 'OK' and a success dialog should appear.

[![tweet-sql_oauth_successful]({{ site.baseurl }}/assets/2011/05/tweet-sql_oauth_successful_thumb.png "tweet-sql\_oauth\_successful")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Multiple-Twitter-accounts-with-Tweet-SQL_11F86/tweet-sql_oauth_successful.png)

Return to SSMS and run the below TSQL to add the new account to the **dbo.tweet\_oauth\_accounts** table

```
EXEC dbo.tweet_cfg_copy_oauth_account;
```

Now you should have two accounts available for [Tweet-SQL](http://www.tweet-sql.com).

```
SELECT twitter_username
FROM dbo.tweet_oauth_accounts;
```

[![tweet-sql_oauth_two_accounts]({{ site.baseurl }}/assets/2011/05/tweet-sql_oauth_two_accounts_thumb.png "tweet-sql\_oauth\_two\_accounts")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/Multiple-Twitter-accounts-with-Tweet-SQL_11F86/tweet-sql_oauth_two_accounts.png)

To select a particular twitter account we run....

```
EXEC dbo.tweet_cfg_change_oauth_account 'rhyscampbell';
```

Then we can post a status from this account;

```
EXEC dbo.tweet_sts_update 'Sending a test status...', null;
```

Then to change accounts...

```
EXEC dbo.tweet_cfg_change_oauth_account 'tweetsql';
EXEC dbo.tweet_sts_update 'Testing the new multiple account support for oAuth in Tweet-SQL.', null;
```

Change back once more...

```
EXEC dbo.tweet_cfg_change_oauth_account 'rhyscampbell';
EXEC dbo.tweet_sts_update 'Sending another test status...!', null;
```

That's it! There's no limits to the number of accounts this method will support, 2 or 2, 000! The next version of [Tweet-SQL](http://www.tweet-sql.com) will be released in the coming weeks. In the meantime have some fun with the [current version](http://www.tweet-sql.com/dl.php "Tweet-SQL download Page").

