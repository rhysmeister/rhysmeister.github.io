---
layout: post
title: 'SSIS: Make your output files dynamic'
date: 2010-02-06 15:35:09.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- SSIS
tags:
- SSIS
meta:
  tweetbackscheck: '1613475520'
  shorturls: a:4:{s:9:"permalink";s:73:"http://www.youdidwhatwithtsql.com/ssis-make-your-output-files-dynamic/616";s:7:"tinyurl";s:26:"http://tinyurl.com/ybjbn7y";s:4:"isgd";s:18:"http://is.gd/7ODHI";s:5:"bitly";s:20:"http://bit.ly/b0xR3e";}
  twittercomments: a:0:{}
  tweetcount: '0'
  _edit_last: '1'
  _sg_subscribe-to-comments: kjs_mp@yahoo.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssis-make-your-output-files-dynamic/616/"
---
I like making my [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) packages as dynamic as possible. Once that package has been deployed into production I want to avoid opening it up in [BIDS](http://msdn.microsoft.com/en-us/library/ms173767.aspx) if possible. I've blogged previously about using [Stored Procedures in Execute SQL Tasks](http://www.youdidwhatwithtsql.com/execute-sq-procedure-task/559) but this only gives us flexibility in terms of the where clause. We have no flexibility in terms of the columns unless we open the package up in BIDS.

I wanted to build a little more flexibility into my packages. Wouldn't it be great if we could simply modify a stored procedure to include additional columns, and these changes would be reflected in the output files, with no further work required? Here's an outline of my first steps towards achieving this.

- First create a stored procedure, that returns a resultset, in a test database. Anyone will do. Here's one I created in the [AdventureWorks](http://msdn.microsoft.com/en-us/library/ms124501.aspx) test database.

```
USE [AdventureWorks]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_test] AS
BEGIN

	SELECT *
	FROM Production.Product;

END
```

- Open up [BIDS](http://msdn.microsoft.com/en-us/library/ms173767.aspx) and create a new integration services project.
- Add an object variable like below called **resultset**.

[![ssis resultset variable]({{ site.baseurl }}/assets/2010/02/ssis_resultset_variable_thumb.png "ssis resultset variable")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssis_resultset_variable.png)

- Add an [Execute SQL Task](http://technet.microsoft.com/en-us/library/ms141003.aspx) to the designer and configure it to execute the procedure you created earlier. Configure it similarly to below, ensuring **Result Set** is set to **Full result set**.

[![ssis exececute sql task]({{ site.baseurl }}/assets/2010/02/ssis_exec_sql_task_thumb.png "ssis exececute sql task")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssis_exec_sql_task.png)

- Go to the **Result Set** tab and add a mapping to the **resultset** object variable. Configure this exactly as shown below.

[![ssis_exec_sql_task_resultset]({{ site.baseurl }}/assets/2010/02/ssis_exec_sql_task_resultset_thumb.png "ssis\_exec\_sql\_task\_resultset")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssis_exec_sql_task_resultset.png)

- Add a [Script Task](http://msdn.microsoft.com/en-us/library/ms141752.aspx) to the designer and connect the Execute SQL Task to it. Edit the Script Task and enter the **resultset** variable in the **ReadOnlyVariable** box.

[![ssis script task]({{ site.baseurl }}/assets/2010/02/ssis_script_task_thumb.png "ssis script task")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssis_script_task.png)

- Click "Edit Script" and paste the below code into [VSTA](http://blogs.msdn.com/vsta/). The only part of this code you should need to change is the path where the text file is written to.

```
' Microsoft SQL Server Integration Services Script Task
' Write scripts using Microsoft Visual Basic 2008.
' The ScriptMain is the entry point class of the script.

Imports System
Imports System.Data
Imports System.Math
Imports Microsoft.SqlServer.Dts.Runtime
Imports System.Data.OleDb
Imports System.IO

 _
 _
Partial Public Class ScriptMain
    Inherits Microsoft.SqlServer.Dts.Tasks.ScriptTask.VSTARTScriptObjectModelBase

    Enum ScriptResults
        Success = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Success
        Failure = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Failure
    End Enum

    Public Sub Main()
        '
        ' Add your code here
        '
        Dim filename As String = Format(Date.Now, "yyyy-MM-dd_hh_mm_ss") & ".csv"
        Dim fileContents As String = ""

        Dim oledb As OleDbDataAdapter = New OleDbDataAdapter()
        Dim table As DataTable = New DataTable()
        Dim rs As System.Object = Dts.Variables("resultset").Value

        oledb.Fill(table, rs)

        ' Get the column names
        For Each col In table.Columns
            fileContents &= col.ColumnName & "|"
        Next

        ' remove last pipe
        fileContents = fileContents.Substring(0, fileContents.Length - 1)
        fileContents &= Environment.NewLine

        ' For each row in the dataset
        Dim i As Integer
        For Each row As DataRow In table.Rows
            ' For each column in the row
            For i = 1 To table.Columns.Count
                fileContents &= row(i - 1).ToString() & "|"
            Next

            ' Remove last pipe and add a newline to the end of each row
            fileContents = fileContents.Substring(0, fileContents.Length - 1)
            fileContents &= Environment.NewLine

        Next

        ' write data to the text file
        ' Change the path to something appropriate
        SaveTextToFile(fileContents, "C:\Users\Rhys\Desktop\" & filename)

        Dts.TaskResult = ScriptResults.Success
    End Sub

    ' Function from http://www.freevbcode.com/ShowCode.Asp?ID=4492
    Public Function SaveTextToFile(ByVal strData As String, _
     ByVal FullPath As String, _
       Optional ByVal ErrInfo As String = "") As Boolean

        Dim bAns As Boolean = False
        Dim objReader As StreamWriter
        Try

            objReader = New StreamWriter(FullPath)
            objReader.Write(strData)
            objReader.Close()
            bAns = True
        Catch Ex As Exception
            ErrInfo = Ex.Message

        End Try
        Return bAns
    End Function

End Class
```

- Save the script and return to the designer. The final package should look something like below.

[![ssis dynamic output file package]({{ site.baseurl }}/assets/2010/02/ssis_dynamic_output_file_package_thumb.png "ssis dynamic output file package")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssis_dynamic_output_file_package.png)

- Execute the package and then check the location where your output file should be written to. Here's what the file should look like if you're using my **usp\_test** stored procedure in the AdventureWorks database.

[![AdventureWorks Output File Production.Products]({{ site.baseurl }}/assets/2010/02/AdventureWorks_Output_File_1_thumb.png "AdventureWorks Output File Production.Products")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/AdventureWorks_Output_File_1.png)

- Now comes the fun part! Modify the **usp\_test** procedure to select from a completely different table. For example;

```
USE [AdventureWorks]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_test] AS
BEGIN

	SELECT *
	FROM HumanResources.Employee;

END
```

- Ordinarily this change would break an [SSIS](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) package. Execute the package again and check the output file.

[![AdventureWorks Output File HumanResources.Employee]({{ site.baseurl }}/assets/2010/02/AdventureWorks_Output_File_2_thumb.png "AdventureWorks Output File HumanResources.Employee")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/AdventureWorks_Output_File_2.png)

- Let's try another version of **usp\_test**.

```
USE [AdventureWorks]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_test] AS
BEGIN

	SELECT 'I can change my output files simply by changing this stored procedure!', GETDATE();

END
```

- Run the package and check the new output file.

[![AdventureWorks Output File usp_test]({{ site.baseurl }}/assets/2010/02/AdventureWorks_Output_File_3_thumb.png "AdventureWorks Output File usp\_test")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/AdventureWorks_Output_File_3.png)

OK, so we now have an SSIS package, producing output files, that copes with complete modifications to stored procedures with no other changes needed. This isn't yet production ready as there are a few issues I need to resolve.

- The Script Task seems to buckle for XML data types giving an unsupported conversion error. (Use the Person.Contact table in the AdventureWorks database to view this issue).
- The package does not seem to cope with a large number of rows. Execution appears to freeze for datasets containing somewhat over 1,000 rows. (Use the Person.Address table in the AdventureWorks database to view this issue). I'm wondering if this is due to size limitation with the System.Object type.

I'll update this post one I get around to resolving these issues.

**UPDATE** - See [Part 2](http://www.youdidwhatwithtsql.com/ssis-make-your-output-file-dynamic-part-2/664) to see how I resolved these issues.

