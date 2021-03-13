---
layout: post
title: Check the SQL Server Service Account Can Write the SPN
date: 2012-03-07 18:30:07.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
- SQL Server
tags: []
meta:
  _edit_last: '1'
  tweetbackscheck: '1613461881'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/check-sql-server-service-account-write-spn/1456";s:7:"tinyurl";s:26:"http://tinyurl.com/7cdrpxu";s:4:"isgd";s:19:"http://is.gd/DMEoQq";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/check-sql-server-service-account-write-spn/1456/"
---
I don't have access, like many DBAs, to the inner bowels of Active Directory. &nbsp;While I'm more than happy for it to stay this way I still want to check that certain things have been setup correctly and haven't been "cleaned-up" by a security ~~nazi~~ &nbsp;focused domain administrator.

One such situation arose recently with [Service&nbsp;Principal&nbsp;Names](http://msdn.microsoft.com/en-us/library/windows/desktop/ms677949(v=vs.85).aspx "Service Principal Names"). SPNs are used&nbsp;predominately&nbsp;with impersonation and delegation. There's a good [explanation on SPNs here](http://msmvps.com/blogs/ad/archive/2010/06/04/what-are-service-principle-names-spns.aspx "Service Principal Names").

The account SQL Server runs under requires the "Read/Write servicePrincipalName" permission. If for some reason this is removed, and you restart SQL Server, client using the SPN will no longer function.

Luckily this can be easily checked with [Quest's Powershell cmdlets for Active Directory](http://www.quest.com/powershell/activeroles-server.aspx "Active Directory Powershell cmdlets"). Once these are installed you can simply do...

```
Get-QADPermission -Identity Domain\SqlServiceAcc | Where-Object {$_.RightsDisplay -eq "Read/Writ
e servicePrincipalName" -and $_.AccessControlType -eq "Allow"} | SELECT * | Format-List;
```

The output should look something like below. You may want to hold off rebooting your SQL Server if the ReadProperty/WriteProperty values are missing.

```
NativeAce : System.DirectoryServices.ActiveDirectoryAccessRule
TargetObject : Domain\SqlServiceAcc
Account : NT AUTHORITY\SELF
TransitiveAccount : NT AUTHORITY\SELF
AccountName : NT AUTHORITY\SELF
AccessControlType : Allow
Rights : ReadProperty, WriteProperty
RightsDisplay : Read/Write servicePrincipalName
Source : NotInherited
ExtendedRight :
ValidatedWrite :
Property : CN=Service-Principal-Name,CN=Schema,CN=Configuration,DC=domain,DC=co,DC=uk
PropertySet :
ApplyTo : ThisObjectOnly
ApplyToDisplay : This object only
ApplyToType :
ChildType :
```
