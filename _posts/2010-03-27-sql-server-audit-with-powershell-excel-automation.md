---
layout: post
title: SQL Server Audit with Powershell Excel Automation
date: 2010-03-27 18:57:50.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- Powershell
tags:
- Excel Automation
- Powershell
- SQL Server Database Audit
meta:
  tweetbackscheck: '1613450597'
  shorturls: a:4:{s:9:"permalink";s:87:"http://www.youdidwhatwithtsql.com/sql-server-audit-with-powershell-excel-automation/703";s:7:"tinyurl";s:26:"http://tinyurl.com/ykzjaad";s:4:"isgd";s:18:"http://is.gd/b2tXZ";s:5:"bitly";s:20:"http://bit.ly/cXM6aC";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: dendrite713@hotmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/sql-server-audit-with-powershell-excel-automation/703/"
---
Here's neat little [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script you can use to audit your [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) databases. The script is dependant on the [SQL Browser](http://msdn.microsoft.com/en-us/library/ms181087.aspx) service, to discover instances, so you will need to make sure this is running. This will allow you to audit all SQL Server instances on the localhost with details of your databases and associated information. I use [SMO](http://msdn.microsoft.com/en-us/library/ms162169.aspx) here so it should be pretty easy to customise for your own purposes. Just run the script and a nicely formatted Excel report of your databases will be produced. Enjoy!

```
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;
$smoObj = [Microsoft.SqlServer.Management.Smo.SmoApplication];

# This gets the sql server
$sql = $smoObj::EnumAvailableSqlServers($false);

# Automate Excel
$xl = New-Object -ComObject Excel.Application;
$xl.Visible = $true;
$xl = $xl.Workbooks.Add();
$Sheet = $xl.Worksheets.Item(1);

$row = 1;

foreach($sqlserver in $sql)
{
	 # headers
     $Sheet.Cells.Item($row, 1) = "Sql Server:";
     $Sheet.Cells.Item($row, 2) = $sqlserver.Name;
     $Sheet.Cells.Item($row, 1).Font.Bold = $true;
     $Sheet.Cells.Item($row, 2).Font.Bold = $true;
	$Sheet.Cells.Item($row, 3) = "";
     	$Sheet.Cells.Item($row, 4) = "Instance:";
     	$Sheet.Cells.Item($row, 5) = $sqlserver.Instance;
     	$Sheet.Cells.Item($row, 4).Font.Bold = $true;
     	$Sheet.Cells.Item($row, 5).Font.Bold = $true;
	 $Sheet.Cells.Item($row, 6) = "";
	 $Sheet.Cells.Item($row, 7) = "Version: ";
	 $Sheet.Cells.Item($row, 8) = $sqlserver.Version;
     	$Sheet.Cells.Item($row, 7).Font.Bold = $true;
     	$Sheet.Cells.Item($row, 8).Font.Bold = $true;

	 # Prettify headers
	 for($i = 1; $i -le 8; $i++)
	 {
	 	$Sheet.Cells.Item($row,$i).Interior.ColorIndex = 50;
     		$Sheet.Cells.Item($row,$i).Font.ColorIndex = 20;
	 }

	 # Create obj for this sql server
	 $srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver.Name;
	 # Get the databases on this sql server
	 $databases = $srv.Databases;

	 # Increase rowcount for formatting
	 $row += 2;

	 # Add column headers for databases
	 $Sheet.Cells.Item($row, 1) = "Database";
	 $Sheet.Cells.Item($row, 2) = "Size";
	 $Sheet.Cells.Item($row, 3) = "SpaceAvailable";
	 $Sheet.Cells.Item($row, 4) = "State";
	 $Sheet.Cells.Item($row, 5) = "Table Count";
	 $Sheet.Cells.Item($row, 6) = "Collation";
	 $Sheet.Cells.Item($row, 7) = "Compatibility Level";
	 $Sheet.Cells.Item($row, 8) = "Create Date";
	 $Sheet.Cells.Item($row, 9) = "Index Space Usage";
	 $Sheet.Cells.Item($row, 10) = "Owner";
	 $Sheet.Cells.Item($row, 11) = "Last Backup";
	 $Sheet.Cells.Item($row, 12) = "Trigger Count";
	 $Sheet.Cells.Item($row, 13) = "UDF Count";
	 for($i = 1; $i -le 13; $i++)
	 {
	 	$Sheet.Cells.Item($row,$i).Interior.ColorIndex = 35;
     		$Sheet.Cells.Item($row,$i).Font.ColorIndex = 0;
		$Sheet.Cells.Item($row, $i).Font.Bold = $true;
	 }
	 $row++;
	 # Work through each database in the collection
	 foreach($db in $databases)
	 {
	 	$Sheet.Cells.Item($row, 1) = $db.Name;
		$Sheet.Cells.Item($row, 2) = $db.Size;
		$Sheet.Cells.Item($row, 3) = $db.SpaceAvailable;
		$Sheet.Cells.Item($row, 4) = $db.State;
		$Sheet.Cells.Item($row, 5) = $db.Tables.Count;
		$Sheet.Cells.Item($row, 6) = $db.Collation;
		$Sheet.Cells.Item($row, 7) = $db.CompatibilityLevel;
		$Sheet.Cells.Item($row, 8) = $db.CreateDate;
		$Sheet.Cells.Item($row, 9) = $db.IndexSpaceUsage;
		$Sheet.Cells.Item($row, 10) = $db.Owner;
		$Sheet.Cells.Item($row, 11) = $db.LastBackupDate;
		$Sheet.Cells.Item($row, 12) = $db.Triggers.Count;
		$Sheet.Cells.Item($row, 13) = $db.UserDefinedFunctions.Count;
		for($i = 1; $i -le 13; $i++)
		{
	 		$Sheet.Cells.Item($row,$i).Interior.ColorIndex = 0;
     			$Sheet.Cells.Item($row,$i).Font.ColorIndex = 0;
		}
		$row++;
	 }

	 $row++;
}

# Apply autoformat
$Sheet.UsedRange.EntireColumn.AutoFit();
```

[![powershell excel sql server database audit]({{ site.baseurl }}/assets/2010/03/powershell_excel_sql_server_database_audit_thumb.png "powershell excel sql server database audit")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/03/powershell_excel_sql_server_database_audit.png)

