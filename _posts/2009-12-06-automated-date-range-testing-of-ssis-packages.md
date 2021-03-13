---
layout: post
title: Automated Date Range Testing of SSIS Packages
date: 2009-12-06 19:40:52.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SSIS
tags:
- Powershell
- SQL Server
- SSIS
meta:
  tweetbackscheck: '1613432720'
  shorturls: a:4:{s:9:"permalink";s:83:"http://www.youdidwhatwithtsql.com/automated-date-range-testing-of-ssis-packages/466";s:7:"tinyurl";s:26:"http://tinyurl.com/yanlsjs";s:4:"isgd";s:18:"http://is.gd/5eeNl";s:5:"bitly";s:20:"http://bit.ly/6xl6uu";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/automated-date-range-testing-of-ssis-packages/466/"
---
I'm currently building a lot of [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) packages that are primarily date driven. Many of these involve periods of 100 days, to several years, so I wanted to automate the testing of these packages. I'd previously automated the [testing of stored procedures over date ranges](http://www.youdidwhatwithtsql.com/testing-datetime-dependent-stored-procedures/433) but wanted a solution for testing the system as a whole. The solution I came up with involves the use of [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx). Essentially this script increments the date, by one day, before executing a package with [dtexec](http://msdn.microsoft.com/en-us/library/ms162810.aspx).

First lets create a simple [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) package that the Powershell script will call. Open [BIDS](http://msdn.microsoft.com/en-us/library/ms173767.aspx) and create a new project. Add a string variable to the project called **sql\_date** like below.

[![sql_date variable]({{ site.baseurl }}/assets/2009/12/sql_datevariable_thumb.png "sql\_date variable")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/sql_datevariable.png)

We're going to use this variable to get the date as [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) recognises it so we know it's the same as the system date. During my testing I discovered that SQL Server would take a few seconds pickup a system date change. Obviously this could distort your results so we need to ensure these are the same.

Next add an [Execute SQL Task](http://technet.microsoft.com/en-us/library/ms141003.aspx), from the toolbox, onto the designer. Call it "Get SQL Server Date". Add a connection to the SQL Server your package will be executing against and change the **ResultSet** property to "Single Row". Add the following TSQL to **SQLStatement**.

```
SELECT CONVERT(VARCHAR, GETDATE(), 103);
```

[![execute_sql_task_date]({{ site.baseurl }}/assets/2009/12/execute_sql_task_date_thumb.png "execute\_sql\_task\_date")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/execute_sql_task_date.png)

Next add a [Script Task](http://msdn.microsoft.com/en-us/library/ms141752.aspx) onto the designer and call it **MsgBoxDate**. Right click the task, click edit, add **sql\_date** to **ReadOnlyVariables** on the script tab.

[![script_task]({{ site.baseurl }}/assets/2009/12/script_task_thumb.png "script\_task")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/script_task.png)

Click "Design Script" and add the below code into the ide.

```
Imports System
Imports System.Data
Imports System.Math
Imports Microsoft.SqlServer.Dts.Runtime

Public Class ScriptMain

    Public Sub Main()
        Dim sql_date As String = Dts.Variables("sql_date").Value.ToString
        Dim msg As String = "SQL Server Date = " & sql_date & Environment.NewLine & "System Date = " & Format(Date.Now, "dd/MM/yyyy")
        MsgBox(msg)
        Dts.TaskResult = Dts.Results.Success
    End Sub

End Class
```

Connect the tasks together with a precedence constraint. The package should look something like below.

[![date_package]({{ site.baseurl }}/assets/2009/12/date_package_thumb.png "date\_package")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/date_package.png)

Return to the SSIS Designer, click File \> Save Copy of Package.dtsx As. Save this package in the file system and remember the path as you'll need it later. Below is the [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script that will change the current day, by one day, and then execute the package we just made. The while loop will verify that SQL Server has picked up the system date change before executing the package. Change the settings for **$sqlserver** and the package path for [dtexec](http://msdn.microsoft.com/en-us/library/ms162810.aspx) as appropriate. The **$days** variable should be changed to the number of days you want to run the package for. In this example it's just ten. The script will set your systems date back once it has successfully completed..

```
# SQL server and database settings
$sqlserver = "localhost\sql2005";
$database = "master";
# Record the current date so we can set it back at the end of the script
# You may need to change this depending on your regional settings
$date = Get-Date -Format "dd/MM/yyyy";

# Connection string used for verifying sql server has registered the date change
$connection_string = ("Data Source=$sqlserver;Initial Catalog=$database;Integrated Security=SSPI")
$days = 10;

# Setup the database connection
$conn = New-Object System.Data.SqlClient.SqlConnection($connection_string);
$conn.Open();
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT DATEPART(dd, GETDATE())";

for($i = 0; $i -lt $days; $i++)
{
	# Change the date by one day
	Set-Date (Get-Date).AddDays(1);
	# SQL Server can take a few seconds to register the change
	# so we need to loop until the day matches before
	# executing our ssis package
	$reader = $cmd.ExecuteReader();
	$reader.Read();
	$sql_day = $reader.GetValue(0);
	$reader.Close();
	while(($sql_day) -ne [DateTime]::Now.Day)
	{
		Start-Sleep -Seconds 2;
		# Check the sql day again
		$reader = $cmd.ExecuteReader();
		$reader.Read();
		$sql_day = $reader.GetValue(0);
		$reader.Close();
	}
	# Execute the package for this date
	dtexec /f "C:\Users\Rhys\Desktop\Package.dtsx"
}

# Clean up
$reader.Close();
$conn.Close();

# Put the date back with the current time
$time = [DateTime]::Now.TimeOfDay;
Set-Date "$date $time";
```

The script will work through each day displaying a message box for each iteration.

[![start_date]({{ site.baseurl }}/assets/2009/12/start_date_thumb.png "start\_date")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/start_date.png)

[![end_date]({{ site.baseurl }}/assets/2009/12/end_date_thumb.png "end\_date")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/12/end_date.png)

Obviously this particular package needs human intervention to get it to complete. Your real-life packages wouldn't have this limitation so this script could be used to test over a large date range. Hopefully this script will allow me to get out of the office a bit earlier when I need to test my packages!

