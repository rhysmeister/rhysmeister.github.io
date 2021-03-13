---
layout: post
title: 'SSIS: Don''t run the process on a bank Holiday'
date: 2009-11-21 20:45:13.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SSIS
tags:
- Bank Holidays
- SQL Server 2008
- SSIS
meta:
  tweetbackscheck: '1613479719'
  shorturls: a:4:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/ssis-dont-run-the-process-on-a-bank-holiday/452";s:7:"tinyurl";s:26:"http://tinyurl.com/yc5wsak";s:4:"isgd";s:18:"http://is.gd/50yWE";s:5:"bitly";s:20:"http://bit.ly/7k71gD";}
  twittercomments: a:15:{s:17:"37059345707433984";s:7:"retweet";s:17:"36945615858434048";s:7:"retweet";s:17:"36933107642933248";s:7:"retweet";s:17:"36932628334518272";s:7:"retweet";s:17:"36899793833828352";s:7:"retweet";s:17:"36718026506113024";s:7:"retweet";s:17:"36709941557334016";s:7:"retweet";s:17:"36396130761703424";s:7:"retweet";s:17:"36381370498424832";s:7:"retweet";s:17:"36259432421662720";s:7:"retweet";s:17:"36252764564754432";s:7:"retweet";s:17:"36207820181340160";s:7:"retweet";s:17:"35975871433015296";s:7:"retweet";s:17:"35956532629876736";s:7:"retweet";s:17:"35952042279309312";s:7:"retweet";}
  tweetcount: '15'
  _edit_last: '1'
  _sg_subscribe-to-comments: aavellax@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssis-dont-run-the-process-on-a-bank-holiday/452/"
---
Sadly, as people don't make sense, we have to make compromises in our systems and processes. I recently had a requirement, in an [SSIS](http://msdn.microsoft.com/en-us/library/ms141026.aspx) package, to be able to identify which days were Bank Holidays and take a different course of action, e.g. not run the main process. Here's an illustration of the approach I took using a simple lookup table, containing holiday dates, and SSIS [precedence constraints](http://technet.microsoft.com/en-us/library/ms141261.aspx).

The TSQL ([SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) 2008) below will create a table called **BankHolidays** and populate the table with public holidays up to the end of 2010. The Bank Holiday dates have been taken from the [DirectGov](http://www.direct.gov.uk/en/Governmentcitizensandrights/LivingintheUK/DG_073741) site and are for England & Wales only. Depending on your requirements you may want to consider dates, like Christmas, that fall on a weekend. These technically aren't Bank Holidays so haven't been included here, but you may wish to add them if you don't want to run on these days.

```
-- Create a table to contain Bank Holidays
CREATE TABLE dbo.BankHolidays
(
	BankHoliday DATE NOT NULL PRIMARY KEY CLUSTERED,
	ActiVe BIT NOT NULL DEFAULT 1
);
GO

INSERT INTO dbo.BankHolidays
(
	BankHoliday
)
VALUES
(
	'2009-12-25'
),
(
	'2009-12-28'
),
(
	'2010-01-01'
),
(
	'2010-04-02'
),
(
	'2010-04-05'
),
(
	'2010-05-03'
),
(
	'2010-05-31'
),
(
	'2010-08-30'
),
(
	'2010-12-27'
),
(
	'2010-12-28'
);
GO
```

Note the **Active** flag in the table. This is just in case we need to deactivate a Bank Holiday for some some reason. Added flexibility is always useful.

Launch [BIDS](http://msdn.microsoft.com/en-us/library/ms173767.aspx) and create a new [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) project. The first thing we need to do is add a variable called **BankHoliday**. We will use this in determining whether the day is a Bank Holiday or not. Add an Int32 variable in the [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) variables window, as illustrated below.

[![ssis bank holiday variable]({{ site.baseurl }}/assets/2009/11/ssis_bank_holiday_variable_thumb.png "ssis bank holiday variable")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/ssis_bank_holiday_variable.png)

Add an [OLE DB connection](http://msdn.microsoft.com/en-us/library/ms141013.aspx) that points at the database containing the **BankHolidays** table. Drop an [Execute SQL task](http://technet.microsoft.com/en-us/library/ms141003.aspx) from the toolbox onto the design canvas. Right click the task and click edit to configure the task properties. Add the OLE DB connection manager to **Connection** and the below TSQL to **SQLStatement**.

```
SELECT COUNT(*)
FROM dbo.BankHolidays
WHERE BankHoliday = CONVERT(DATE, GETDATE())
AND Active = 1;
```

**ResultSet** should be changed to "Single row".

[![Execute SQL Task Bank Holidays]({{ site.baseurl }}/assets/2009/11/Execute_SQL_Task_Bank_Holidays_thumb.png "Execute SQL Task Bank Holidays")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/Execute_SQL_Task_Bank_Holidays.png)

**UPDATE:** (Thanks to Dr Drew in the comments for pointing this omission out.)

Click on the **Result Set** tab and map the variable **BankHoliday** as shown below. This variable mapping will be used to determine if the execution date is a bank holiday.

[![]({{ site.baseurl }}/assets/2009/11/resultset_mapping_bank_holiday-300x254.png "resultset mapping bankholiday variable")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/resultset_mapping_bank_holiday.png)

Now drop two [Script Task](http://msdn.microsoft.com/en-us/library/ms141752.aspx) components onto the design canvas and connect them from the Execute SQL Task. Call one "Display "Not Bank Holiday" message" and the other "Display "It's a Bank Holiday" message". This should look something like this.

[![ssis design canvas]({{ site.baseurl }}/assets/2009/11/ssis_design_canvas_thumb.png "ssis design canvas")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/ssis_design_canvas.png)

Next we need to edit the constraints connecting our Script tasks to implement the logic to determine if it is a Bank Holiday or not. Right click the constraint connecting the script task called "Display "Not Bank Holiday" message" and choose Edit. Change "Evaluation Operation" to 'Expression and Constraint' and enter the following expression into the appropriate text box; @BankHoliday == 0. Finally click the radio button labelled "Logical OR". This should look like this...

[![Bank_Holiday_Constraint_1]({{ site.baseurl }}/assets/2009/11/Bank_Holiday_Constraint_1_thumb.png "Bank\_Holiday\_Constraint\_1")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/Bank_Holiday_Constraint_1.png)

Click OK to save your changes. Now we need to edit the constraint connected to the Script Task called "Display "It's a Bank Holiday" message". The setup here is exactly the same except for the Expression which should be entered as @BankHoliday == 1.

[![Bank_Holiday_Constraint_2]({{ site.baseurl }}/assets/2009/11/Bank_Holiday_Constraint_2_thumb.png "Bank\_Holiday\_Constraint\_2")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/Bank_Holiday_Constraint_2.png)

By now your design canvas should look something like below.

[![ssis_design_canvas_2]({{ site.baseurl }}/assets/2009/11/ssis_design_canvas_2_thumb.png "ssis\_design\_canvas\_2")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/ssis_design_canvas_2.png)

Finally we're just going to add a little code to each script task to display a message box. In the script task called "Display "Not Bank Holiday" message" click edit, go to the script tab, and click the "Design Script button". Add the below code.

```
Imports System
Imports System.Data
Imports System.Math
Imports Microsoft.SqlServer.Dts.Runtime

Public Class ScriptMain

    Public Sub Main()
        MsgBox("Hi, today is not a Bank Holiday, get back to work!")
        Dts.TaskResult = Dts.Results.Success
    End Sub

End Class
```

In the script task called "Display "It's a Bank Holiday" message" add the below code.

```
Imports System
Imports System.Data
Imports System.Math
Imports Microsoft.SqlServer.Dts.Runtime

Public Class ScriptMain

	Public Sub Main()
        MsgBox("Hi, today is a Bank Holiday, put your feet up!")
		Dts.TaskResult = Dts.Results.Success
	End Sub

End Class
```

Now we should be ready to execute the package. Click run and you should see the following message (assuming it's not a bank holiday!).

[![not_a_bank_holiday]({{ site.baseurl }}/assets/2009/11/not_a_bank_holiday_thumb.png "not\_a\_bank\_holiday")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/not_a_bank_holiday.png)

Now, either wait until a bank holiday occurs, or change the date on your computer to one contained in the **BankHolidays** table. I changed mine to 2009-12-28 and here's what I saw when I executed the package.

[![bank_holiday]({{ site.baseurl }}/assets/2009/11/bank_holiday_thumb.png "bank\_holiday")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/bank_holiday.png)

