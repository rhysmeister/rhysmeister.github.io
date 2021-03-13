---
layout: post
title: 'Practical VBA Examples for the DBA: Part 1'
date: 2009-07-20 10:00:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- VBA
tags:
- VBA
- Visual Basic for Applications
meta:
  _edit_last: '1'
  tweetbackscheck: '1613208190'
  shorturls: a:7:{s:9:"permalink";s:40:"http://www.youdidwhatwithtsql.com/?p=268";s:7:"tinyurl";s:25:"http://tinyurl.com/lzpodk";s:4:"isgd";s:18:"http://is.gd/1ElW9";s:5:"bitly";s:20:"http://bit.ly/2AESRu";s:5:"snipr";s:22:"http://snipr.com/njc50";s:5:"snurl";s:22:"http://snurl.com/njc50";s:7:"snipurl";s:24:"http://snipurl.com/njc50";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _sg_subscribe-to-comments: jewellsean@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/practical-vba-examples-dba-part-1/268/"
---
I’ve never been a huge fan of [VBA](http://en.wikipedia.org/wiki/Visual_Basic_for_Applications) but it can be very useful for quickly providing interfaces to your databases. The examples here use [Macros](http://office.microsoft.com/en-us/excel/CH101001571033.aspx) in [Excel 2007](http://office.microsoft.com/en-us/excel/FX100487621033.aspx) to execute stored procedures on [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) and provide data back to the user. These examples use the [AdventureWorks](http://www.microsoft.com/downloads/details.aspx?familyid=e719ecf7-9f46-4312-af89-6ad8702e4e6e) sample database.

**Execute a Stored Procedure with VBA**

<font color="#666666">This example will execute a stored procedure that returns a resultset. The data returned will be copied to the active worksheet. First create the below stored procedure in your <a href="http://msdn.microsoft.com/en-us/library/ms124501.aspx" target="_blank">AdventureWorks</a> database.</font>

```
USE [AdventureWorks]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_test]
AS

	SELECT [ProductID]
      ,[Name]
      ,[ProductNumber]
      ,[MakeFlag]
      ,[FinishedGoodsFlag]
      ,[Color]
      ,[SafetyStockLevel]
      ,[ReorderPoint]
      ,[StandardCost]
      ,[ListPrice]
      ,[Size]
      ,[SizeUnitMeasureCode]
      ,[WeightUnitMeasureCode]
      ,[Weight]
      ,[DaysToManufacture]
      ,[ProductLine]
      ,[Class]
      ,[Style]
      ,[ProductSubcategoryID]
      ,[ProductModelID]
      ,[SellStartDate]
      ,[SellEndDate]
      ,[DiscontinuedDate]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks].[Production].[Product]
```

Open up a new workbook in Excel. Next you need to add a new macro. Click the “Macros” button on the developer ribbon. N.B. You may need to [enable the Developer ribbon](http://blogs.msdn.com/erikaehrli/archive/2006/06/06/ribbondevelopertab.aspx).

[![Developer ribbon in Excel 2007]({{ site.baseurl }}/assets/2009/07/image_thumb13.png "Developer ribbon in Excel 2007")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image13.png)

Give the macro a name and click ‘Create’.

[![Creating a macro in Excel 2007]({{ site.baseurl }}/assets/2009/07/image_thumb14.png "Creating a macro in Excel 2007")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image14.png)

You will then be taken to the [VBA](http://en.wikipedia.org/wiki/Visual_Basic_for_Applications) editor. Paste in the entire code below replacing what is already there. Note you will need to change the value for **server** in the connection string. The connection string also assumes you are using [Windows Authentication](http://technet.microsoft.com/en-us/library/ms144284(SQL.90).aspx).

```
Sub execute_proc()

    ' Setup connection string
    Dim connStr As String
    connStr = "driver={sql server};server=localhost\sql2005;"
    connStr = connStr & "Database=AdventureWorks;TrustedConnection=True;"

    ' Setup the connection to the database
    Dim connection As ADODB.connection
    Set connection = New ADODB.connection
    connection.connectionString = connStr
    ' Open the connection
    connection.Open

    ' Open recordset.
    Set Cmd1 = New ADODB.Command
    Cmd1.ActiveConnection = connection
    Cmd1.CommandText = "usp_test"
    Cmd1.CommandType = adCmdStoredProc
    Set Results = Cmd1.Execute()

    ' Clear the data from the active worksheet
    Cells.Select
    Cells.ClearContents

    ' Add column headers to the sheet
    headers = Results.Fields.Count
    For iCol = 1 To headers
        Cells(1, iCol).Value = Results.Fields(iCol - 1).Name
    Next

    ' Copy the resultset to the active worksheet
    Cells(2, 1).CopyFromRecordset Results

End Sub
```

Click Tools \> References and scroll down the list and check “Microsoft ActiveX Data Objects 2.8 Library”.

[![Add a reference in Excel to the Microsoft ActiveX Data Object 2.8 Library]({{ site.baseurl }}/assets/2009/07/image_thumb15.png "Add a reference in Excel to the Microsoft ActiveX Data Object 2.8 Library")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image15.png)

Click File \> Close and Return to Microsoft Excel. Click the macro button on the developer ribbon. Click the run button to execute the macro.

[![Running a macro in Excel 2007]({{ site.baseurl }}/assets/2009/07/image_thumb16.png "Running a macro in Excel 2007")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image16.png)

If you receive the below error then you haven’t correctly added the reference mentioned above. Go back and re-add it.

[![Error you will get if there is no reference to the Microsoft ActiveX Data Objects 2.8 Library]({{ site.baseurl }}/assets/2009/07/image_thumb17.png "Error you will get if there is no reference to the Microsoft ActiveX Data Objects 2.8 Library")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image17.png)

If all has gone well the macro should pull some data from the [AdventureWorks](http://www.microsoft.com/downloads/details.aspx?familyid=e719ecf7-9f46-4312-af89-6ad8702e4e6e) database into the current worksheet.

[![Data pulled from the AdventureWorks database with an Excel macro]({{ site.baseurl }}/assets/2009/07/image_thumb18.png "Data pulled from the AdventureWorks database with an Excel macro")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image18.png)

**Execute a Stored Procedure with Parameters and VBA**

This example is very similar to above except this time we will execute a stored procedure that accepts an integer parameter. This parameter will be provided by the user entering a value in a popup input box.&nbsp; Create the below stored procedure in your [AdventureWorks](http://msdn.microsoft.com/en-us/library/ms124501.aspx) database.

```
USE [AdventureWorks]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_test2]
	@ProductId INTEGER
AS

	SELECT [ProductID]
      ,[Name]
      ,[ProductNumber]
      ,[MakeFlag]
      ,[FinishedGoodsFlag]
      ,[Color]
      ,[SafetyStockLevel]
      ,[ReorderPoint]
      ,[StandardCost]
      ,[ListPrice]
      ,[Size]
      ,[SizeUnitMeasureCode]
      ,[WeightUnitMeasureCode]
      ,[Weight]
      ,[DaysToManufacture]
      ,[ProductLine]
      ,[Class]
      ,[Style]
      ,[ProductSubcategoryID]
      ,[ProductModelID]
      ,[SellStartDate]
      ,[SellEndDate]
      ,[DiscontinuedDate]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks].[Production].[Product]
  WHERE [ProductID] = @ProductId;
```

Follow the same procedure above for creating a macro but add the below code. Ensure the value for **server** is changed in the connection string.

```
Sub usp_test2()

    Dim temp As String
    Dim ProductId As Integer

    Do
        temp = InputBox("Enter a ProductId")
        ' Bizarrely have to check for cancel!
        If StrPtr(strwholeNo) = False Then
            Exit Sub
        End If
    Loop Until IsNumeric(temp)

    'Convert the input to an integer
    ProductId = CInt(temp)

    ' Setup connection string
    Dim connStr As String
    connStr = "driver={sql server};server=localhost\sql2005;"
    connStr = connStr & "Database=AdventureWorks;TrustedConnection=True;"

    ' Setup the connection to the database
    Dim connection As ADODB.connection
    Set connection = New ADODB.connection
    connection.connectionString = connStr
    ' Open the connection
    connection.Open

    ' Open recordset.
    Set Cmd1 = New ADODB.Command
    Cmd1.ActiveConnection = connection
    Cmd1.CommandText = "usp_test2 " & CStr(ProductId)
    Set Results = Cmd1.Execute()

    ' Clear the data from the active worksheet
    Cells.Select
    Cells.ClearContents

    ' Add column headers to the sheet
    headers = Results.Fields.Count
    For iCol = 1 To headers
        Cells(1, iCol).Value = Results.Fields(iCol - 1).Name
    Next

    ' Copy the resultset to the active worksheet
    Cells(2, 1).CopyFromRecordset Results

End Sub
```

A second macro called ‘usp\_test2’ will appear in the Run macro dialog. Click run to execute it.

[![Running a stored procedure that accepts parameters with VBA]({{ site.baseurl }}/assets/2009/07/image_thumb19.png "Running a stored procedure that accepts parameters with VBA")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image19.png)

You will be asked to enter a ProductId.

[![Provide an integer value for the procedure]({{ site.baseurl }}/assets/2009/07/image_thumb20.png "Provide an integer value for the procedure")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image20.png)

Enter a 1 and click ‘OK’. The procedure should run and return one row of data.

[![image]({{ site.baseurl }}/assets/2009/07/image_thumb21.png "image")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image21.png)

In a future article I’ll be demonstrating the use of the VBA GUI editor to create some simple user interfaces to provide better interactivity with your data.

