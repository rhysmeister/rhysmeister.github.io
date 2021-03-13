---
layout: post
title: Powershell Nuggets
date: 2009-04-22 19:48:56.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Bash
- Powershell
- Powershell Scripting
- Server Management
- Shell
meta:
  tweetbackscheck: '1612952637'
  shorturls: a:7:{s:9:"permalink";s:55:"http://www.youdidwhatwithtsql.com/powershell-nuggets/72";s:7:"tinyurl";s:25:"http://tinyurl.com/d9vwc2";s:4:"isgd";s:17:"http://is.gd/xhVZ";s:5:"bitly";s:19:"http://bit.ly/I1pZo";s:5:"snipr";s:22:"http://snipr.com/hhvpa";s:5:"snurl";s:22:"http://snurl.com/hhvpa";s:7:"snipurl";s:24:"http://snipurl.com/hhvpa";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/powershell-nuggets/72/"
---
Here are a few [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) nuggets for beginners to digest.

First thing that might trip you up is the [Execution Policy](http://myitforum.com/cs2/blogs/dhite/archive/2006/09/08/Configuring-PowerShell-Execution-Policies.aspx) built into [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx). I’ve turned this off on my development machine but it’s obviously advised to have it enabled on production machines. That aside, it’s easy to turn off…

[![Powershell Execution Policy]({{ site.baseurl }}/assets/2009/04/image-thumb3.png "Powershell Execution Policy")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/image3.png)

If you’re using [Vista](http://www.microsoft.com/windows/windows-vista/default.aspx) you may need to run Powershell in [Administrator mode](http://support.microsoft.com/kb/922708) to allow the required registry change. To make my environment a little more user friendly I’ve setup a [Powershell Profile](http://www.microsoft.com/technet/scriptcenter/topics/winpsh/manual/profile.mspx) with the following code

```
cd C:\Users\Rhys\Documents\powershell
function prompt {"PS: $(get-date)>"}
```

This changes the current working directory to my scripts folder and keeps the prompt reasonably short.

**Write text files with Powershell**

Just look how easy it is to write text files in [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx).

```
$text = "abcdefghijklmnopqrstuvwxyz1234567890"

# Method 1: Write file using set-content.
# Just pipe the contents of the variable
$text | set-content -encoding ascii alphabet.txt

# Method 2: Use out-file to append the for loop index to a file
for($i = 0; $i -lt 10; $i++)
{
	$i | out-file -filePath "forLoop.txt" -encoding ascii -append
}
```

After executing this you should have 2 new .txt files in your working directory.

**List & Count Files by Extension with Powershell**

This script will list filenames and their sizes before displaying a total count of those files. Just change the extension in the script if you want to work with different file types.

```
#####################################################
# Filename: DirectoryTextFiles.ps1 #
# Author: Rhys Campbell #
# Description: Lists all .txt files in the current #
# directory, with their length in bytes, and #
# displays a total count of .txt files. #
# Date: 2009-04-22 #
#####################################################

$count = 0;

$files = dir *.txt

foreach($file in $files)
{
	$count++;
	$filename = $file.name
	$fileLength = $file.Length
	echo "The text file $filename is $fileLength bytes.";
}

echo "===================================================="
echo "Total text files in this directory = $count";
```

**Get the Twitter Public Timeline with Powershell**

One line of code is all is takes with [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx)!

```
([xml](new-object net.webclient).DownloadString("http://twitter.com/statuses/public_timeline.rss")).rss.channel.item | format-table title,link
```

[![The Twitter Public Timeline in Powershell]({{ site.baseurl }}/assets/2009/04/image-thumb4.png "The Twitter Public Timeline in Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/image4.png)

**Ping multiple computers with Powershell**

```
###############################################
# Filename: ComputerPinger.ps1 #
# Author: Rhys Campbell #
# Description: Pings multiple computers #
# supplied in the $args array. #
# Date: 2009-04-16 #
###############################################

# Simple ping for each computer
# supplied in the $args array
foreach($computer in $args)
{
	ping $computer;
}
```

**Count Databases On Multiple Servers**

Those of you that are still with me get to see the exciting stuff. This script will count databases, and see if [SQLAGENT](http://msdn.microsoft.com/en-us/library/ms189237.aspx) is running, on multiple servers. Just specify each server on the command line. This script uses Windows authentication so bear this in mind for each of your servers. It’s with examples like this that I hope you start to see the power and possibilities of [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx).

```
################################################################################
# Filename: MultiHostDatabaseCount.ps1 #
# Description: #
# Author: Rhys Campbell #
# Date: 2009-04-15 #
# Usage: FullPathToFile\MultiHostDatabaseCount.ps1 server1 server2 server3 etc #
################################################################################

trap
{
	"Eek! An exception occured."
	write-error $("TRAPPED: " + $_.Exception.GetType().FullName);
	write-error $("TRAPPED: " + $_.Exception.Message);
	# Terminate the script on error
	exit
}

# Loop through each server name supplied in the $args array
foreach($arg in $args)
{
	# Connection string
	$connectionString = "Server=$arg;Database=master;Trusted_Connection=True;"
	# setup the connection object
	$SqlConn = New-Object -Typename System.Data.SqlClient.SqlConnection
	$SqlConn.ConnectionString = $connectionString
	# Open the connection
	$SqlConn.open();
	$cmd = "SELECT COUNT(*) AS cnt FROM sys.databases";
	# Create the sql command object
	$SqlCmd = New-Object System.Data.SqlClient.SqlCommand $cmd, $SqlConn
	# Run the query
	$result = $SqlCmd.ExecuteReader()
	# Move pointer to the first row
	$result.Read() > $null
	# Get db count
	$dbCount = $result[0]
	# Close the connection
	$SqlConn.close()
	# Reopen the connection
	$SqlConn.open()
	# New command to get SQLAGENT state
	$cmd = "xp_servicecontrol 'querystate', 'SQLSERVERAGENT'"
	# Create the sql command object
	$SqlCmd = New-Object System.Data.SqlClient.SqlCommand $cmd, $SqlConn
	# Run the query
	$result2 = $SqlCmd.ExecuteReader()
	# Move pointer to the first row
	$result2.Read() > $null
	# Get db count
	$SQLAGENT = $result2[0]
	# Print out the database count for the host
	echo "$arg hosts $dbCount databases. The SQLAGENT Service is $SQLAGENT"
	# Clean up
	$SqlConn.close()
}
```

[![SQL DBA Duties with Powershell]({{ site.baseurl }}/assets/2009/04/image-thumb5.png "SQL DBA Duties with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/04/image5.png)

I hope to check out the huge range of [Powershell Extensions](http://www.codeplex.com/site/search?projectSearchText=powershell) and [Tools](http://www.robvanderwoude.com/powershelltools.php ) available to do some really cool things. I’ve had a quick play with [Quest Software](http://www.quest.com/)’s [PowerGUI](http://www.powergui.org). This looks pretty good but I try to stay away from fancy tools until I’ve learned the basics of a language well. I’m looking forward to working with [Powershell scripting](http://www.microsoft.com/technet/scriptcenter/hubs/msh.mspx). I see some great possibilities for…

- Multiple SQL Server & MySQL management. Check multiple servers in one script! Check backups, disk space, virtually anything!
- Adhoc access to many data sources; including text files, rss feeds, databases, Active Directory.&nbsp; 
- Producing troubleshooting scripts for less experienced support staff. 

&nbsp;

```

```
