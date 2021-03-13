---
layout: post
title: Software Deployment with PsExec
date: 2009-03-02 15:01:07.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Technical Timesavers
tags:
- dll files
- psexec
- software deployment
- sysinternals
meta:
  _edit_last: '1'
  tweetbackscheck: '1613464386'
  shorturls: a:7:{s:9:"permalink";s:68:"http://www.youdidwhatwithtsql.com/software-deployment-with-psexec/31";s:4:"isgd";s:17:"http://is.gd/qv1j";s:5:"bitly";s:19:"http://bit.ly/YH1DH";s:5:"snipr";s:22:"http://snipr.com/f57cf";s:5:"snurl";s:22:"http://snurl.com/f57cf";s:7:"snipurl";s:24:"http://snipurl.com/f57cf";s:7:"tinyurl";s:25:"http://tinyurl.com/ae5tsc";}
  twittercomments: a:1:{i:1270925096;s:2:"79";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/software-deployment-with-psexec/31/"
---
This isn't related to SQL in any way but I'd thought I'd present it here as it has proven to be an excellent solution to a problem I was facing at work.

I'm currently working for a software house helping out with upgrades of customer systems. I got thrown a few .dll files and was informed these needed to be deployed and registered on all PC's running our application. Now some of these sites are pretty large and some of them lack any sort of IT or technical person. I thought an automated solution was in order.

I thought I'd take a look at the [Sysinternals](http://technet.microsoft.com/en-us/sysinternals/default.aspx) site to see if any tools fitted the bill. Anyone working in a Windows Environment needs to check out this set of tools as there are many potential arse saving goodies. Among the sysnternals set of tools I found [psexec](http://technet.microsoft.com/en-us/sysinternals/bb897553.aspx) which allows you to execute processes on remote machines.

First I needed a list of PC's in the domain. The vb script below I have sourced from this [site](http://lazynetworkadmin.com/index.php?option=com_content&task=view&id=38&Itemid=6), I've just added a&nbsp; field to the [WQL](http://en.wikipedia.org/wiki/WQL) query and modified the "table" name we will select from. You need to modify this to fit your domain, for example if your domain was youdidwhatwithtsql.com then change the LDAP url to LDAP://DC=youdidwhatwithtsql,DC=com, if it was domain.local then it would be LDAP://DC=domain,DC=local.

```
'This script will list all computers on your domain
'Created by C.E. Harden August 16 2006

Const ADS_SCOPE_SUBTREE = 2
Const OPEN_FILE_FOR_WRITING = 2
Const ForReading = 1

Wscript.Echo "The output will be written to C:\Computers.txt"

strFile = "Computers.txt"
strWritePath = "C:\" & strFile
strDirectory = "C:\"

Set objFSO1 = CreateObject("Scripting.FileSystemObject")

If objFSO1.FileExists(strWritePath) Then
    Set objFolder = objFSO1.GetFile(strWritePath)

Else
    Set objFile = objFSO1.CreateTextFile(strDirectory & strFile)
    objFile = ""

End If

Set fso = CreateObject("Scripting.FileSystemObject")
Set textFile = fso.OpenTextFile(strWritePath, OPEN_FILE_FOR_WRITING)

Set objConnection = CreateObject("ADODB.Connection")
Set objCommand = CreateObject("ADODB.Command")
objConnection.Provider = "ADsDSOObject"
objConnection.Open "Active Directory Provider"

Set objCOmmand.ActiveConnection = objConnection
objCommand.CommandText = _
    "Select Name, OperatingSystem Location from 'LDAP://DC=youdidwhatwithtsql,DC=com' " _
        & "Where objectClass='computer'"
objCommand.Properties("Page Size") = 1000
objCommand.Properties("Searchscope") = ADS_SCOPE_SUBTREE
Set objRecordSet = objCommand.Execute
objRecordSet.MoveFirst

Do Until objRecordSet.EOF
    'Wscript.Echo "Computer Name: " & objRecordSet.Fields("Name").Value
    textFile.WriteLine(objRecordSet.Fields("Name").Value)
    objRecordSet.MoveNext
Loop

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objArgs = Wscript.Arguments
Set objTextFile = objFSO.OpenTextFile(strWritePath, ForReading)

Do Until objTextFile.AtEndOfStream
    strReg = objTextFile.Readline
Loop

WScript.Echo "All done!"
```

Save this in notepad with a .vbs extension and execute it by double clicking

![VB Script writes output to c:\Computers.txt]({{ site.baseurl }}/assets/2009/03/3323633138_4755d635ef.jpg?v=0 "VB Script writes output to c:\Computers.txt")

Click 'OK' and then the script will finish in a few moments (or a bit longer if you have lots of computers in your domain).

![vbs script is finished]({{ site.baseurl }}/assets/2009/03/3322819373_c09fc6977d.jpg?v=0 "vbs script is finished")

I added the OS name because I wanted to strip out any servers from the list. Next I removed all unneeded columns, using Excel, so I was just left with a list of computer names..

PC1  
PC2  
PC3...

Next create a folder in the root of c:\ called psexec and place your edited version of Computers.txt inside. Next download the [PsTools Suite](http://download.sysinternals.com/Files/PsTools.zip), unzip the archive and place a copy of psexec.exe into c:\psexec. Finally we need a batch file containing the commands we want to execute on each of our domain computers. For this example the actual commands in the batch file are unimportant so change these to suit your particular problem. In my real-life use I renamed some local files, copied a few .dll files from a network share and registered them on each domain computer. For this example the following command will output a some text with the computer name, datetime and the username who ran the command.

```
echo I ran on %COMPUTERNAME% at %DATE%:%TIME% by %USERNAME%
```

Copy your commands into a text file called commands.bat and place it into c:\psexec. Finally we are ready to use psexec to execute the commands, in our batch file, on all of the computers specified in Computers.txt.

```
C:\PSEXEC\psexec.exe @C:\PSEXEC\Computers.txt -u RHYS-PC\Rhys -c C:\PSEXEC\commands.bat > C:\PSEXEC\output.txt
```

The **C:\PSEXEC\psexec.exe** is obviously to run the psexec executable. The **@C:\PSEXEC\Computers.txt** will feed the process our list of computer names. The **-u** switch should be changed to a domain administrator, or another user with appropriate rights to each machine. The **-c** switch includes the path to the command.bat file. This will be copied to, and executed on, each machine listed in **Computers.txt**.Finally we use **\> C:\PSEXEC\output.txt** to redirect the ouput to a text file.

Run your modified command as appropriate. You may get a license agreement for psexec appearing, just click ok, then you'll have to enter the password for the user specified in the command. [Psexec](http://technet.microsoft.com/en-us/sysinternals/bb897553.aspx) should work through the list of computers and attempt to run the batch file on each and return an exit code.

[![PsExec running in a DOS prompt]({{ site.baseurl }}/assets/2009/03/3322997567_323edd2c31.jpg?v=0 "Runnng psexec")](http://www.flickr.com/photos/89266657@N00/3322997567/ "moz-screenshot-3.jpg")

The following was outputted in this example...

```
Password:
C:\Windows\system32>echo I ran on RHYS-PC at 02/03/2009:20:25:49.36 by Rhys
I ran on RHYS-PC at 02/03/2009:20:25:49.36 by Rhys

\\RHYS-PC:
```

This example is fairly lightweight to keep the concept simple but hopefully it's enough to illustrate the great power of a simple tool like [PsExec](http://technet.microsoft.com/en-us/sysinternals/bb897553.aspx). I'm sure in my own situation this has saved many hours of time and kept some customers smiling.

Blogged with the [Flock Browser](http://www.flock.com/blogged-with-flock "Flock Browser")
