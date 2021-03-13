---
layout: post
title: 'Practical VBA Examples for the DBA: Part 2'
date: 2009-08-05 20:53:12.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- VBA
tags:
- DBA
- Excel
- VBA
- Visual Basic for Applications
meta:
  tweetbackscheck: '1613074543'
  shorturls: a:7:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/practical-vba-examples-for-the-dba-part-2/308";s:7:"tinyurl";s:25:"http://tinyurl.com/ll27z8";s:5:"bitly";s:19:"http://bit.ly/o7RWm";s:5:"snipr";s:22:"http://snipr.com/osbwg";s:5:"snurl";s:22:"http://snurl.com/osbwg";s:7:"snipurl";s:24:"http://snipurl.com/osbwg";s:4:"isgd";s:18:"http://is.gd/23LjK";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _edit_last: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/practical-vba-examples-for-the-dba-part-2/308/"
---
In a [previous post](http://www.youdidwhatwithtsql.com/practical-vba-examples-dba-part-1/268) I demonstrated how a little bit of [VBA](http://en.wikipedia.org/wiki/Visual_Basic_for_Applications) code can be used&nbsp; to build some basic user interfaces to deliver data. Continuing on with this the examples here will show how to build some basic user interfaces; Combo box (or drop down list) and a Multi-Select List. Like the previous examples these use the [AdventureWorks](http://msdn.microsoft.com/en-us/library/ms124501.aspx) sample database as a data source.

**Using VBA Combo Boxes with SQL Server**

This example will present the user with a drop down list so the user can make a selection and return the appropriate data. To get started first open up Excel.

Click the “Visual Basic” button on the Developer ribbon. N.B. If you can’t see it [enable the Developer ribbon](http://blogs.msdn.com/erikaehrli/archive/2006/06/06/ribbondevelopertab.aspx).

[![The Developer Ribbon in Excel 2007]({{ site.baseurl }}/assets/2009/08/excel_2007_developer_ribbon_thumb.png "The Developer Ribbon in Excel 2007")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/excel_2007_developer_ribbon.png)

Firstly we need to add a reference to allow Excel to interact with [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx). In the Visual Basic editor click Tools \> References and tick the box next to “Microsoft ActiveX Data Objects 2.8 Library”. You’ll get runtime errors if this step isn’t done.

[![Adding a reference to ADO in Excel.]({{ site.baseurl }}/assets/2009/08/activex_data_objects_reference_thumb.png "Adding a reference to ADO in Excel.")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/activex_data_objects_reference.png)

In the project tree right click UserForm \> Insert \> UserForm. This form should be called UserForm1 (ensure it does as we will be referencing this name in VBA code.)

[![Building simple GUIs with VBA]({{ site.baseurl }}/assets/2009/08/UserForm1_3_thumb.png "Building simple GUIs with VBA")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/UserForm1_3.png)

In the properties dialog for UserForm1 change the value for Caption to “Select a Product”. From the toolbox palette drag and drop and [ComboBox](http://www.excel-vba.com/vba-forms-3-7-combo-boxes.htm) and a [CommandButton](http://www.excel-vba.com/vba-forms-3-4-command-buttons.htm) onto the UserForm1. These components should be called **ComboBox1** and **CommandButton1**. You should end up with something that looks like this.

[![Simple form with VBA.]({{ site.baseurl }}/assets/2009/08/ComboBox1_4_thumb.png "Simple form with VBA.")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/ComboBox1_4.png)

Save your work and close the VBA editor. In the Developer ribbon click the Macros button and add a new macro called **comboBox**. Add the following code to the macro. Make sure you change the [connection string](http://www.connectionstrings.com/) for your environment.

```
Sub comboBox()

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
    Cmd1.CommandText = "SELECT Name FROM Production.Product ORDER BY Name"
    Set Results = Cmd1.Execute()

    Results.MoveFirst
    While Not Results.EOF

        ' Fill the Combo box with product names
        UserForm1.ComboBox1.AddItem Results.Fields("Name").Value
        Results.MoveNext

    Wend

    UserForm1.Show

End Sub
```

This code will select product names from Production.Product and fill the combo box before displaying the form. Go back to UserForm1 and double click the [CommandButton](http://www.excel-vba.com/vba-forms-3-4-command-buttons.htm). This will open up the VBA code editor. Here we can associated an action with the button. Paste the below code into the editor replacing any code already in there. Change the [connection string](http://www.connectionstrings.com) to point at your [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx).

```
Private Sub CommandButton1_Click()

    Dim selection As String
    ' Get the selected product escaping single quotes
    selection = Replace(UserForm1.ComboBox1.Value, "'", "''")

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
    Cmd1.CommandText = "SELECT * FROM Purchasing.PurchaseOrderDetail t1 INNER JOIN Production.Product t2 ON t1.ProductID = t2.ProductID AND t2.Name ='" & selection & "'"
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

    ' Stop running the macro
    Unload Me

End Sub
```

Save the code and return to Excel. The macro should be ready to run. Click the Macros button on the Developer ribbon. Choose **ComboBox** and click Run. If all is ok you will see the combobox populated with product names.

[![ComboBox with VBA]({{ site.baseurl }}/assets/2009/08/select_a_product_5_thumb.png "ComboBox with VBA")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/select_a_product_5.png)

Pick “Adjustable Race” and click “Choose Product”. Data should be returned in the open workbook.

[![Order information for the selected product.]({{ site.baseurl }}/assets/2009/08/returned_data_6_thumb.png "Order information for the selected product.")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/returned_data_6.png)

**Using VBA Multi-Select Lists (ListBox) with SQL Server**

<font color="#666666">This example is very similar to the previous</font> one but this time we will allow the user to select more than one product by using a Multi-Select list or [ListBox](http://msdn.microsoft.com/en-us/library/aa223123(office.11).aspx).

Follow the same process above to create a new form. This form should be called **UserForm2**. Add a [ListBox](http://msdn.microsoft.com/en-us/library/aa223123(office.11).aspx) and call it **listProducts** then add a button and call it **btnProducts**. You should end up with something looking like below;

[![ListBox in VBA]({{ site.baseurl }}/assets/2009/08/UserForm2_7_thumb.png "ListBox in VBA")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/UserForm2_7.png)

Save and return to Excel and add a new macro called **selectList**. Add the following code to the macro. Change the [connection string](http://www.connectionstrings.com) as appropriate.

```
Sub selectList()

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
    Cmd1.CommandText = "SELECT Name FROM Production.Product ORDER BY Name"
    Set Results = Cmd1.Execute()

    UserForm2.listProducts.MultiSelect = fmMultiSelectMulti
    Results.MoveFirst
    While Not Results.EOF

        UserForm2.listProducts.AddItem Results.Fields("Name").Value
        Results.MoveNext

    Wend

    UserForm2.Show
End Sub
```

This code will populate the [ListBox](http://www.excel-vba.com/vba-forms-3-8-list-boxes.htm) with product names and display the form when the macro is executed. Return to the VBA editor and double click on **btnProducts**. Add the below code and not forgetting to change the [connection string](http://www.connectionstrings.com).

```
Private Sub btnProducts_Click()

    Dim selection As String
    ' Get the selected products escaping single quotes
    'selection = Replace(UserForm2.listProducts.Value, "'", "''")
    Dim lItem As Long

    For lItem = 0 To listProducts.ListCount - 1

        If listProducts.Selected(lItem) = True Then

            selection = selection & "'" & Replace(listProducts.List(lItem), "'", "''") & "',"
        End If
    Next

    selection = Mid(selection, 1, Len(selection) - 1)

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
    Cmd1.CommandText = "SELECT * FROM Purchasing.PurchaseOrderDetail t1 INNER JOIN Production.Product t2 ON t1.ProductID = t2.ProductID AND t2.Name IN (" & selection & ")"
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

    ' Stop running the macro
    Unload Me

End Sub
```

Save and return to Excel. The macro should be ready to run. Click the Macros button on the Developer ribbon and run the macro called “selectList”.

[![VBA ListBox]({{ site.baseurl }}/assets/2009/08/select_list_8_thumb.png "VBA ListBox")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/select_list_8.png)

Select some products and “Sheet1” should be populated with the appropriate data.

[![Order information for multiple products.]({{ site.baseurl }}/assets/2009/08/Excel_data_9_thumb.png "Order information for multiple products.")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/09/Excel_data_9.png)

Hopefully this has been easy to follow. I don’t profess to be a [VBA](http://en.wikipedia.org/wiki/Visual_Basic_for_Applications) expert, or enthusiast,&nbsp; but I do see its use for quickly building interfaces around your data.

