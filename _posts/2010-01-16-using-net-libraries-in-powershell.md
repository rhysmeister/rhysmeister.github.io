---
layout: post
title: Using .Net libraries in Powershell
date: 2010-01-16 16:50:44.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- ".Net"
- Powershell
- Powershell Scripting
meta:
  tweetbackscheck: '1613477249'
  twittercomments: a:0:{}
  shorturls: a:4:{s:9:"permalink";s:71:"http://www.youdidwhatwithtsql.com/using-net-libraries-in-powershell/538";s:7:"tinyurl";s:26:"http://tinyurl.com/yfx2z46";s:4:"isgd";s:18:"http://is.gd/6ob9d";s:5:"bitly";s:20:"http://bit.ly/8RazdK";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/using-net-libraries-in-powershell/538/"
---
One of the great things about [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) is its ability to take advantage of the [.Net platform](http://www.microsoft.com/NET/). If Powershell can't do it you bet there's a .Net library that can. Not only is this great for extending your scripts but I also like to use Powershell to test some of my classes. Rather than fire up RAM hungry Visual Studio I can just script out a few tests in [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx).

Here's quick script you can modify to compile a .cs file to produce a library for Powershell to load. This gives me the flexibility to quickly test individual classes from a project. The class I was testing here is just a wrapper around the functions of [DotNetZip](http://www.codeplex.com/DotNetZip). A reference is included, just remove this if your class doesn't need it. At the end of the script the .dll file will be loaded and its methods will be listed by a call to [Get-Member](http://technet.microsoft.com/en-us/library/ee176854.aspx).

```
# Your c# class we want to compile as a library to test
$csharp_file = "`"C:\Users\Rhys\Documents\Visual Studio 2008\Projects\ETLBuddy\ETLBuddy\Zipper.cs`"";
# Path to csc compiler
$compiler = "$env:windir\Microsoft.NET\Framework\v3.5\csc.exe";
$cmd = "$compiler /target:library $csharp_file "
# Add any external library you're referencing, empty string if none
$reference="C:\Users\Rhys\Desktop\Ionic.Zip.dll";

# Add reference if needed
if($reference -ne "")
{
	$cmd += " /r:`"$reference`"";
}

# Invoke-Expression tells ps to evaluate the string as a command
# otherwise it would just print it out
Invoke-Expression $cmd;

# Now load the dll
$dll = Get-Location;
$dll = $dll.ToString();
$dll = $dll + "\" + $csharp_file.Substring($csharp_file.LastIndexOf("\") + 1) -replace(".cs", ".dll") -replace("`"", "");

[Reflection.Assembly]::LoadFile($dll -replace(".cs", ".dll"));

# Create a new object from the loaded dll
$obj = New-Object "com.etlbuddy.ETLBuddy.Zipper";
$obj | Get-Member;
```

From the output here you can see there are two methods called **Zip** and **Unzip**.

[![powershell .net library methods]({{ site.baseurl }}/assets/2010/01/powershell_net_library_thumb.png "powershell .net library methods")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/powershell_net_library.png)

Now I have a dll I can put to work in my Powershell Scripts! Once this is done it's really quite simple to get started.

```
# Load the Zipper dll
# Needed to run gacutil /i "C:\Users\Rhys\Desktop\Ionic.Zip.dll" so this would work
[Reflection.Assembly]::LoadFile("C:\Users\Rhys\Documents\powershell\Zipper.dll") | Out-Null;

# Create a new zip object
$obj = New-Object "com.etlbuddy.ETLBuddy.Zipper";

# Zip a copy of a library
$obj.Zip("C:\Users\Rhys\Documents\powershell\Zipper.dll");
```

After execution I have a new zip file in my Powershell working directory.

[![file zipped by powershell]({{ site.baseurl }}/assets/2010/01/file_zipped_by_powershell_thumb.png "file zipped by powershell")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/01/file_zipped_by_powershell.png)

That's really all there is to begin using an external library in your Powershell scripts. For further info checkout [How to create an object in Powershell](http://blogs.msdn.com/powershell/archive/2009/03/11/how-to-create-an-object-in-powershell.aspx).

