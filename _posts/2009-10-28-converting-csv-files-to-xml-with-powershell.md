---
layout: post
title: Converting CSV FileS to XML with Powershell
date: 2009-10-28 21:34:57.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- csv
- Data
- Powershell
- Powershell Scripting
- xml
meta:
  tweetbackscheck: '1613466935'
  twittercomments: a:0:{}
  shorturls: a:4:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/converting-csv-files-to-xml-with-powershell/408";s:7:"tinyurl";s:26:"http://tinyurl.com/yzooy9n";s:4:"isgd";s:18:"http://is.gd/4GkJP";s:5:"bitly";s:20:"http://bit.ly/45m4iZ";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/converting-csv-files-to-xml-with-powershell/408/"
---
[Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) is a pretty cool tool for many things including working with data. It’s just such a great time saver if you have to deal with multiple files or need to change them into different formats. Here’s how easy it is to turn a csv file into well-formed xml.

```
# csv file to convert
$csv = "C:\Users\Rhys\Desktop\csv\file1.csv";
# xml file to create
$xml = "C:\Users\Rhys\Desktop\csv\file1.xml";

Import-Csv -Path $csv | Export-Clixml -Path $xml;
```

This will produce xml looking something like this.

\<?XML:NAMESPACE PREFIX = [default] http://schemas.microsoft.com/powershell/2004/04 NS = "http://schemas.microsoft.com/powershell/2004/04" /\>\<?XML:NAMESPACE PREFIX = [default] http://schemas.microsoft.com/powershell/2004/04 NS = "http://schemas.microsoft.com/powershell/2004/04" /\>\<objs xmlns="http://schemas.microsoft.com/powershell/2004/04" version="1.1.0.1"\>  
 \<obj refid="0"\>  
 \<tn refid="0"\>  
 \<t\>System.Management.Automation.PSCustomObject\</t\>  
 \<t\>System.Object\</t\>  
 \</tn\>  
 \<ms\>  
 \<s n="FirstName"\>Rhys\</s\>  
 \<s n="LastName"\>Campbell\</s\>  
 \<s n="Age"\>29\</s\>  
 \</ms\>  
 \</obj\>  
 \<obj refid="1"\>  
 \<tnref refid="0"\>\</tnref\>  
 \<ms\>  
 \<s n="FirstName"\>Joe\</s\>  
 \<s n="LastName"\>Bloggs\</s\>  
 \<s n="Age"\>40\</s\>  
 \</ms\>  
 \</obj\>  
 \<obj refid="2"\>  
 \<tnref refid="0"\>\</tnref\>  
 \<ms\>  
 \<s n="FirstName"\>Steve\</s\>  
 \<s n="LastName"\>Smith\</s\>  
 \<s n="Age"\>35\</s\>  
 \</ms\>  
 \</obj\>  
\</objs\>

With the inclusion of the [Get-ChildItem cmdlet](http://www.microsoft.com/technet/scriptcenter/topics/msh/cmdlets/get-childitem.mspx) we can merge multiple csv files into a single xml file with just a few lines of code.

```
# Folder of csv files
$csvFiles = Get-ChildItem -Path "C:\Users\Rhys\Desktop\csv\*" -Include *.csv;

# Process each csv file. Need to be the same structure
foreach($file in $csvFiles)
{
	$csvContent += Import-Csv -Path $file;
}

# Export the imported data as one xml file
$csvContent | Export-Clixml -Path C:\Users\Rhys\Desktop\csv\merged.xml;
```

Turning this back into a csv file is a simple [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) one-liner!

```
# Turn this back into csv
Import-Clixml -Path C:\Users\Rhys\Desktop\csv\merged.xml | Export-Csv -Path C:\Users\Rhys\Desktop\csv\BackToCsv.csv -NoTypeInformation;
```

Check out my other data related Powershell posts; [splitting csv files with Powershell](http://www.youdidwhatwithtsql.com/splitting-csv-files-with-powershell/374), [merging csv files with Powershell](http://www.youdidwhatwithtsql.com/merging-csv-files-with-powershell/330) and [trimming whitespace with Powershell](http://www.youdidwhatwithtsql.com/trimming-whitespace-with-powershell/388).

