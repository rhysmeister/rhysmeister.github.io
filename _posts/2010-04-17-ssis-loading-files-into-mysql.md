---
layout: post
title: 'SSIS: Loading files into MySQL'
date: 2010-04-17 15:01:01.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MySQL
- SSIS
tags:
- MySQL
- SSIS
meta:
  tweetbackscheck: '1613464371'
  shorturls: a:4:{s:9:"permalink";s:67:"http://www.youdidwhatwithtsql.com/ssis-loading-files-into-mysql/745";s:7:"tinyurl";s:26:"http://tinyurl.com/y24os3y";s:4:"isgd";s:18:"http://is.gd/bx5gE";s:5:"bitly";s:20:"http://bit.ly/ddVnqv";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: stefano.polo@kaplan.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssis-loading-files-into-mysql/745/"
---
Getting data out of [MySQL](http://www.mysql.com) with [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) is a snap. Putting data into MySQL has been a different matter. I've always done this in the past with a [hodgepodge](http://en.wikipedia.org/wiki/Hodge-podge) of [ODBC](http://en.wikipedia.org/wiki/Open_Database_Connectivity), [Linked Servers](http://msdn.microsoft.com/en-us/library/ms188279.aspx), [OPENQUERY](http://msdn.microsoft.com/en-us/library/ms188427.aspx) and the [Script Task](http://msdn.microsoft.com/en-us/library/ms141752.aspx). All of these work well but they're just not as convenient as loading files with the [OLED Destination](http://msdn.microsoft.com/en-us/library/ms141237.aspx).

I recently attempted to use the ADO.NET Destination to load files into MySQL without luck. I [tweeted](http://twitter.com/rhyscampbell/status/12211827588) about this and Todd McDermid ([blog](http://toddmcdermid.blogspot.com/) | [twitter](http://twitter.com/Todd_McDermid)) kindly pointed me at a blog post about [writing data to MySQL with SSIS](http://blogs.msdn.com/mattm/archive/2009/01/07/writing-to-a-mysql-database-from-ssis.aspx). This works well but I am having difficulties with data conversions. The author of the blog post, [Matt Mason](http://blogs.msdn.com/user/Profile.aspx?UserID=54640), posted a follow up article with the various options of [SSIS / MySQL interaction](http://blogs.msdn.com/mattm/archive/2009/03/02/how-do-i-do-update-and-delete-if-i-don-t-have-an-oledb-provider.aspx). All of these involve pushing data into MySQL but I though why not get it to pull data. Here's an outline of this approach.

First create the following table in a MySQL database. This is a clone of the HumanResources.Employees table from the [AdventureWorks](http://msdn.microsoft.com/en-us/library/ms124501.aspx) sample database. We will be doing a simple extract-truncate-load of the table into MySQL from SQL Server.

```
# Create MySQL replica table of the HumanResources.Employee from the AdventureWorks database
CREATE TABLE `HumanResourcesEmployee`
(
	`EmployeeID` INT PRIMARY KEY NOT NULL,
	`NationalIDNumber` VARCHAR(15) NOT NULL,
	`ContactID` INT NOT NULL,
	`LoginID` VARCHAR(256) NOT NULL,
	`ManagerID` INT NULL,
	`Title` VARCHAR(50) NOT NULL,
	`BirthDate` DATETIME NOT NULL,
	`MaritalStatus` CHAR(1) NOT NULL,
	`Gender` CHAR(1) NOT NULL,
	`HireDate` DATETIME NOT NULL,
	`SalariedFlag` VARCHAR(5),
	`VacationHours` SMALLINT,
	`SickLeaveHours` SMALLINT,
	`CurrentFlag` VARCHAR(5),
	`rowguid` VARCHAR(40),
	`ModifiedDate` DATETIME
);
```

Next create a new Integration Services project in [BIDS](http://msdn.microsoft.com/en-us/library/ms173767.aspx). Add a [Data Flow Task](http://msdn.microsoft.com/en-us/library/ms141122.aspx) to the project and call it "Extract Employees from SQL Server"

[![data flow task]({{ site.baseurl }}/assets/2010/04/data_flow_task_thumb.png "data flow task")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/data_flow_task.png)

This will export the contents of the HumanResources.Employees table and write it to a flat file. Edit the task and add an OLE Source and configure it as illustrated below. The OLEDB connection manager should point at your [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) instance hosting the AdventureWorks database.

[![oledb source employees]({{ site.baseurl }}/assets/2010/04/oledb_source_employees_thumb.png "oledb source employees")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/oledb_source_employees.png)

Next add a [Flat File Destination](http://msdn.microsoft.com/en-us/library/ms141668.aspx) and name it "Write Employees File" then connect the OLEDB Source to it. Configure the connection manager as illustrated below. The important things to note here are the fact I'm writing the file to **E:\Employees.txt** and it is pipe delimited. You may need to alter these according to your setup.

[![flat file connection manager]({{ site.baseurl }}/assets/2010/04/flat_file_connection_manager_thumb.png "flat file connection manager")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/flat_file_connection_manager.png)

[![flat file connection manager delimiter]({{ site.baseurl }}/assets/2010/04/flat_file_connection_manager_delimiter_thumb.png "flat file connection manager delimiter")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/flat_file_connection_manager_delimiter.png)

The dataflow should now look something like below.

[![final data flow]({{ site.baseurl }}/assets/2010/04/final_data_flow_thumb.png "final data flow")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/final_data_flow.png)

Go back to the Control Flow pane and add an [Execute SQL Task](http://technet.microsoft.com/en-us/library/ms141003.aspx) to the canvas. Call this task "TRUNCATE TABLE HumanResourcesEmployee". Edit the task and configure it like below. You need to add a ADO.NET connection manager which references an [ODBC connection to your MySQL database](http://dev.mysql.com/doc/refman/4.1/en/connector-odbc-configuration-dsn-windows.html). You'll need the [MySQL ODBC Driver](http://dev.mysql.com/downloads/connector/odbc/5.1.html) for this.

[![execute sql task employees]({{ site.baseurl }}/assets/2010/04/execute_sql_task_employees_thumb.png "execute sql task employees")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/execute_sql_task_employees.png)

My ODBC connection looks like below.

[![mysql odbc dsn connection]({{ site.baseurl }}/assets/2010/04/mysql_odbc_dsn_connection_thumb.png "mysql odbc dsn connection")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/mysql_odbc_dsn_connection.png)

Add another Execute SQL Task and call it "Load new Employees file into MySQL". Connect up the tasks in sequence.

[![data flow ssis mysql]({{ site.baseurl }}/assets/2010/04/data_flow_ssis_mysql_thumb.png "data flow ssis mysql")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/data_flow_ssis_mysql.png)

Edit "Load new Employees file into MySQL", add the ADO.NET connection to MySQL and enter the below SQL. You will need to change the file path and delimiter character if you have changed them.

```
LOAD DATA LOCAL INFILE 'E:\\Employees.txt' # Column order MUST match the table
INTO TABLE HumanResourcesEmployee
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n' # Windows line terminator
IGNORE 1 LINES; # Ignore column header line
```

[![execute sql task employees mysql]({{ site.baseurl }}/assets/2010/04/execute_sql_task_employees_mysql_thumb.png "execute sql task employees mysql")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/execute_sql_task_employees_mysql.png)

I originally attempted to enclose this in a store procedure as this provides more flexibility but MySQL gave the following error.

```
LOAD DATA is not allowed in stored procedures
```

MySQL prevents you from using [LOAD DATA INFILE](http://dev.mysql.com/doc/refman/5.1/en/load-data.html) inside stored procedures (my major beef with MySQL is what you can and cannot do inside stored procedures) so we have no choice but to enter it in the SQLStatement pane. Execute the package and if all goes well the Employees.txt file will be loaded into MySQL.

[![execute_ssis_mysql_load]({{ site.baseurl }}/assets/2010/04/execute_ssis_mysql_load_thumb.png "execute\_ssis\_mysql\_load")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/execute_ssis_mysql_load.png)

[![employees loaded into mysql ssis]({{ site.baseurl }}/assets/2010/04/employees_loaded_into_mysql_ssis_thumb.png "employees loaded into mysql ssis")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/04/employees_loaded_into_mysql_ssis.png)

I've not yet used this in production so use with caution, but it's simple to setup and fast. One thing to note for this load is that MySQL has replaced backslashes with hyphens in the **LoginId** column so it would be sensible to check all data conversions.

