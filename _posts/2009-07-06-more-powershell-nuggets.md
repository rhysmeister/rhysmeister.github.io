---
layout: post
title: More Powershell Nuggets
date: 2009-07-06 15:47:57.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- Powershell
- Powershell Scripting
- Shell
meta:
  tweetbackscheck: '1613463875'
  shorturls: a:7:{s:9:"permalink";s:61:"http://www.youdidwhatwithtsql.com/more-powershell-nuggets/239";s:7:"tinyurl";s:25:"http://tinyurl.com/lkx8dx";s:4:"isgd";s:18:"http://is.gd/1oUKl";s:5:"bitly";s:19:"http://bit.ly/41fhq";s:5:"snipr";s:22:"http://snipr.com/m82bq";s:5:"snurl";s:22:"http://snurl.com/m82bq";s:7:"snipurl";s:24:"http://snipurl.com/m82bq";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: kevin.taylor@uk.bnpparibas.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/more-powershell-nuggets/239/"
---
In a [previous post](http://www.youdidwhatwithtsql.com/powershell-nuggets/72) I provided a few small [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) code blocks suitable for beginners to digest. Here are a few more that anyone starting with [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) might like to experiment with.

**A simple For Loop in Powershell**

<font color="#666666">Here’s just a simple for loop in Powershell.</font>

```
# A simple for loop
for($i = 0; $i -le 10; $i++)
{
	Write-Host "Loop = $i";
}
```

[![For Loop in Powershell]({{ site.baseurl }}/assets/2009/07/image_thumb3.png "For Loop in Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image3.png)

**<font color="#666666"></font>**

**A simple For Loop using an array in Powershell**

<font color="#666666">Like all modern scripting languages, <a href="http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx" target="_blank">Powershell</a> offers us an easy way to iterate over arrays.</font>

```
# Setup an array
$array = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

# A foreach loop using an array
foreach($item in $array)
{
	Write-Host 'Array item =' $item
}
```

[![Iterating over an array with Powershell]({{ site.baseurl }}/assets/2009/07/image_thumb4.png "Iterating over an array with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image4.png)

**Iterate recursively through a directory structure with Powershell**

This nugget iterates through the user profile folder structure, **C:\Users\Rhys** on my laptop, and reports if each txt file encountered is less than 100 bytes or greater than 100 bytes.

```
$dir = dir -Recurse $Env:USERPROFILE *.txt;
foreach($file in $dir)
{
	$bytes = $file.Length;
	if($bytes -lt 100)
	{
		Write-Host -ForegroundColor Green "$file < 100 bytes.";
	}
	else
	{
		Write-Host -ForegroundColor Cyan "$file >= 100 bytes.";
	}
}
```

[![Directory recursion with Powershell]({{ site.baseurl }}/assets/2009/07/image_thumb5.png "Directory recursion with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image5.png)

**Find all .mdf and .ldf files on your C:\ drive with Powershell**

<font color="#666666">These two simple lines will search through your <strong>C:\</strong> drive looking for .mdf and .ldf files. You can easily search for different files by changing the extensions specified in the –<strong>Include </strong>switch.</font>

```
# Find all mdf and ldf files in C:\ on Local machine
$textFiles = Get-ChildItem -Path C:\ -Recurse * -Include "*.mdf", "*.ldf";
$textFiles | Format-Table -AutoSize -Property Name, Length;
```

[![Find files by extension with Powershell]({{ site.baseurl }}/assets/2009/07/image_thumb6.png "Find files by extension with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image6.png)

**Find all .mdf and .ldf files on a remote Computer with Powershell**

This example is similar in function to the last one, except we’re using [WMI](http://msdn.microsoft.com/en-us/library/aa394572(VS.85).aspx) here to query remote computers. The **-ComputerName** switch specifies the computer we wish to query and the **-Filter** switch specifies the extensions we wish to search for.

```
# Find all mdf and ldf files on a remote host
$dbFiles = Get-WmiObject -Class CIM_DataFile -Filter "Extension = 'mdf' OR Extension = 'ldf'" -ComputerName "localhost";
$dbFiles | ForEach-Object { Write-Host $_.Name; }
```

[![Find files on remote computers with Powershell]({{ site.baseurl }}/assets/2009/07/image_thumb7.png "Find files on remote computers with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image7.png)

**Query Processes on local and remote Computers with Powershell**

<font color="#666666">Just a few lines of code in <a href="http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx" target="_blank">Powershell</a> allow you to do some pretty powerful things. Beginners should definitely check out the <a href="http://technet.microsoft.com/en-us/library/dd315295.aspx" target="_blank">Get-WmiObject</a> cmdlet and see how useful it is. The first line of code here creates an instance of the Win32_Process class. <strong>ComputerName</strong> specifies the computer you wish to query. The <strong>Filter </strong>flag contains the criteria by which we wish to filter the data. This is just like the WHERE clause in SQL. The second line simply takes the output and formats it nicely including only the columns we specify.</font>

```
$Processes = Get-WmiObject -Class Win32_Process -ComputerName 'localhost' -Filter "PageFileUsage > 0 AND Name Like '%s%'";
$Processes | Format-Table -AutoSize -Property Name, ProcessId, ThreadCount, PageFileUsage, PeakPageFileUsage, PeakVirtualSize, PeakWorkingSetSize;
```

[![Query Processes on local and remote computers with Powershell]({{ site.baseurl }}/assets/2009/07/image_thumb8.png "Query Processes on local and remote computers with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image8.png)

**Kill a Process on a remote Computer with Powershell**

<font color="#666666">The script is setup to kill <strong>calc.exe </strong>on <strong>localhost </strong>but it can be changed to run for any computer, or process, that you have appropriate permissions for. To test this script make sure you have <strong>calc.exe </strong>running.</font>

```
# Kill a process on a remote machine
$computer = "localhost";
$processToKill = "calc.exe";
$process = Get-WmiObject -Class Win32_Process -Filter "Name = '$processToKill'" -ComputerName $computer;
if($process -eq $null)
{	# If null then the process may not be running
	Write-Host -ForegroundColor Red "Couldn't get process $processToKill on $computer";
	sleep(10);
	exit;
}
else
{
	Write-Host "Attempting to Kill $processToKill on $computer";
}
# Kill the process and get exit status 0 = OK
$status = $process.InvokeMethod("Terminate", $null);
switch($status)
{
	0 { Write-Host -ForegroundColor Green "Killed $processToKill on $computer"};
	default { Write-Host -ForegroundColor Red "Error, couldn't kill $processToKill on $computer"};

};
```

[![Kill processes on remote computers with Powershell]({{ site.baseurl }}/assets/2009/07/image_thumb9.png "Kill processes on remote computers with Powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image9.png)

