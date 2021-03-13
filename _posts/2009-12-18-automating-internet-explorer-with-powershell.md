---
layout: post
title: Automating Internet Explorer with Powershell
date: 2009-12-18 16:03:30.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- automating internet explorer
- completely pointless
- Powershell
meta:
  shorturls: a:4:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/automating-internet-explorer-with-powershell/467";s:7:"tinyurl";s:26:"http://tinyurl.com/ydslxsn";s:4:"isgd";s:18:"http://is.gd/5swIG";s:5:"bitly";s:20:"http://bit.ly/7FZgnq";}
  tweetbackscheck: '1613481789'
  twittercomments: a:1:{s:11:"28820021909";s:3:"241";}
  tweetcount: '1'
  _edit_last: '1'
  _sg_subscribe-to-comments: ilian_pzk@abv.bg
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/automating-internet-explorer-with-powershell/467/"
---
Ashamed of the amount of time you spend on [Twitter](http://twitter.com)? Want to know how to automate Internet Explorer with [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx)? Once again [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) comes to the rescue! Here's an illustration I came up with to post tweets on your twitter account from a text file.

Create a text file called **tweets.txt** and place it into your user profile directory (this will be something like **C:\Users\\<username\>** on Vista and Windows 7 or **C:\Documents and Settings\\<username\>** on Windows XP). Here's what I placed in mine;

```
Getting my head down with a little Powershell to automate IE.
Heavy snow expected over South East England tonight. Black sludge in London to follow.
Must get myself a nice warm hat.
Last Friday before Xmas. Farringdon will be rammed tonight with the usual Fabric crowd.
Going downstairs for a swim.
```

Next you need to modify a few variables in the Powershell script below.

**$username\_or\_email** - Your twitter username or account email address.

**$password** - Your twitter password.

**$sleep** - The interval you want between tweets.

```
# Author: Rhys Campbell
# Date: 18/12/2009
# Powershell script to automate Internet Explorer
# to post tweets to your Twitter account

# Twitter login name or email
$username_or_email = "xxxxxxxxxxxxxxxx";
# Your twitter password
$password = "xxxxxxxxxxxx";
$url = "http://twitter.com/login";

# txt file containing 1 tweet per line
$tweets = Get-Content "$env:USERPROFILE\tweets.txt";
#Interval between tweets
$sleep = 60;

# This is just an attempt to handle the situation where you are already logged into twitter
trap [Exception]
{
	# This will happen if you're already logged in
	if($_.Exception.Message -eq "Property 'value' cannot be found on this object; make sure it exists and is settable." -Or $_.Exception.Message -eq "You cannot call a method on a null-valued expression.")
	{
		# Try and skip this error
		continue;
	}
	else
	{
		# Fail for other Exceptions
		Write-Host -ForegroundColor Red $_.Exception.Message;
	}
}

# Create an ie com object
$ie = New-Object -com internetexplorer.application;
$ie.visible = $true;
$ie.navigate($url);
# Wait for the page to load
while ($ie.Busy -eq $true)
{
	Start-Sleep -Milliseconds 1000;
}

# Login to twitter
Write-Host -ForegroundColor Green "Attempting to login to Twitter.";
# Add login details
$ie.Document.getElementById("username_or_email").value = $username_or_email;
$ie.Document.getElementById("session[password]").value = $password;
# Click the submit button
$ie.Document.getElementById("signin_submit").Click();
# Wait for the page to load
while ($ie.Busy -eq $true)
{
	Start-Sleep -Milliseconds 1000;
}

# Loop through each tweet in the txt file
foreach($tweet in $tweets)
{
	$ie.Document.getElementById("status").value = $tweet;
	$ie.Document.getElementById("status_update_form").Submit();
	Write-Host -ForegroundColor Green "Tweeted; $tweet.";
	Start-Sleep -Seconds $sleep;
	# Check to see if ie is still busy and sleep if so
	while ($ie.Busy -eq $true)
	{
		Start-Sleep -Milliseconds 1000;
	}
}
```

Execute the Powershell script and get tweeting! Here's my output from a test run;

```
Attempting to login to Twitter.
Tweeted; Getting my head down with a little Powershell to automate IE..
Tweeted; Heavy snow expected over South East England tonight. Black sludge in London to follow..
Tweeted; Must get myself a nice warm hat..
Tweeted; Last Friday before Xmas. Farringdon will be rammed tonight with the usual Fabric crowd..
Tweeted; Going downstairs for a swim..
```

Please be aware that changes Twitter make to their site may break this script so it may not function for long without changes. If you want to know more about working with IE and Powershell check out this [link](http://blogs.technet.com/heyscriptingguy/archive/tags/Windows+PowerShell/Internet+Explorer/default.aspx) and follow [@ScriptingGuys](http://twitter.com/ScriptingGuys) on twitter.

