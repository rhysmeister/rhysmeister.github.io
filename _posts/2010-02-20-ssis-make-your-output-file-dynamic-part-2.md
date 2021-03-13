---
layout: post
title: 'SSIS: Make your output files dynamic part 2'
date: 2010-02-20 19:55:10.000000000 +01:00
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
  tweetbackscheck: '1613432090'
  shorturls: a:4:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/ssis-make-your-output-file-dynamic-part-2/664";s:7:"tinyurl";s:26:"http://tinyurl.com/y8ajthy";s:4:"isgd";s:18:"http://is.gd/8OxXO";s:5:"bitly";s:20:"http://bit.ly/dxKls6";}
  twittercomments: a:1:{s:10:"9124826080";s:7:"retweet";}
  tweetcount: '1'
  _edit_last: '1'
  _sg_subscribe-to-comments: carlescb@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/ssis-make-your-output-file-dynamic-part-2/664/"
---
A few weeks ago I blogged about my attempts to make [dynamic output files in ssis](http://www.youdidwhatwithtsql.com/ssis-make-your-output-files-dynamic/616). The idea here was to make an [ssis](http://www.microsoft.com/sqlserver/2005/en/us/integration-services.aspx) package, producing a text file output, that would cope with complete changes to the data source. If you wanted to add a column all you needed to do was change the stored procedure definition that the data was derived from. While this was functional it did have a couple of issues.

- The Script Task seems to buckle for XML data types giving an unsupported conversion error. (Use the Person.Contact table in the AdventureWorks database to view this issue). 
- The package does not seem to cope with a large number of rows. Execution appears to freeze for datasets containing somewhat over 1,000 rows. (Use the Person.Address table in the AdventureWorks database to view this issue). I’m wondering if this is due to size limitation with the System.Object type. 

Here's quick run through of how I resolved the issues. The basic idea was to do all of the data access in VB.Net rather than using an [Execute SQL Task](http://technet.microsoft.com/en-us/library/ms141003.aspx) to store a resultset in a System.Object variable.

Open [BIDS](http://msdn.microsoft.com/en-us/library/ms173767.aspx) and create a new Integration Services Project.

First add a string variable to the project as illustrated below.

[![ssis filename variable]({{ site.baseurl }}/assets/2010/02/ssis_filename_variable_thumb.png "ssis filename variable")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssis_filename_variable.png)

Set the [EvaluateAsExpression](http://msdn.microsoft.com/en-us/library/microsoft.sqlserver.dts.runtime.variable.evaluateasexpression.aspx) property to true and enter the following expression.

```
(DT_WSTR,4)YEAR(GETDATE()) + "_"
    + RIGHT("0" + (DT_WSTR,2)MONTH(GETDATE()), 2) + "_"
    + RIGHT("0" + (DT_WSTR,2)DAY( GETDATE()), 2) + "_"
    + RIGHT("0" + (DT_WSTR,2)DATEPART("hh", GETDATE()), 2) + "_" + RIGHT("0" + (DT_WSTR,2)DATEPART("mi", GETDATE()), 2) + "_" + RIGHT("0" + (DT_WSTR,2)DATEPART("ss", GETDATE()), 2) + ".txt"
```

This will provide us with a datetime stamped filename looking similar to **2010\_02\_20\_15\_40\_36.txt**.

Next add another string variable called **query** and enter a statement to execute a stored procedure that returns a resultset. Any one will do as the package should be agnostic to the results.

[![ssis query variable]({{ site.baseurl }}/assets/2010/02/ssis_query_variable_thumb.png "ssis query variable")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssis_query_variable.png)

I'm using the below stored procedure running against the [AdventureWorks](http://msdn.microsoft.com/en-us/library/ms124501.aspx) sample database.

```
USE [AdventureWorks]
GO
/******Object: StoredProcedure [dbo].[usp_test] Script Date: 02/20/2010 15:48:49******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Rhys Campbell
-- Create date: 2010-02-20
-- Description:	Test proc
-- =============================================
ALTER PROCEDURE [dbo].[usp_test]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    	-- Insert statements for procedure here
	SELECT *
	FROM Person.Contact;

END
```

Next add an [ADO.NET Connection Manager](http://msdn.microsoft.com/en-us/library/ms141676.aspx) to the project pointing this at the database containing your stored procedure. Rename the connection manager to **DBConnection** as we will be referencing this by name in code later.

Drop a Script Task onto the designer and edit its properties. Add the **filename** and **query** variables to the [ReadOnlyVariables](http://msdn.microsoft.com/en-us/library/microsoft.sqlserver.dts.pipeline.scriptcomponent.readonlyvariables.aspx) property.

[![ssis script_task properties]({{ site.baseurl }}/assets/2010/02/ssis_script_task_properties_thumb.png "ssis script\_task properties")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssis_script_task_properties.png)

Set the script language to **Microsoft Visual Basic 2008** and then click "Edit Script". Paste the below code into the editor.

```
Imports System
Imports System.Data
Imports System.Math
Imports Microsoft.SqlServer.Dts.Runtime

<system.addin.addin version:="1.0" publisher:="" description:=""> _
<system.clscompliantattribute> _
Partial Public Class ScriptMain
	Inherits Microsoft.SqlServer.Dts.Tasks.ScriptTask.VSTARTScriptObjectModelBase

	Enum ScriptResults
		Success = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Success
		Failure = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Failure
	End Enum

    Public Sub Main()

        ' Get the datetime stamped filename
        Dim filename As String = Dts.Variables("filename").Value.ToString
        ' Get the user desktop directory. We'll write the output file to here
        ' You probably want to use some other location for production purposes
        Dim userProfileDir As String = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory).ToString

        ' Get the Connection string. Must be called "DBConnection"
        Dim connStr As String = Me.Dts.Connections.Item("DBConnection").ConnectionString.ToString

        ' Get the query set in the ssis variables
        Dim query As String = Dts.Variables("query").Value.ToString

        ' Setup DB access stuff
        Dim con As SqlClient.SqlConnection = New SqlClient.SqlConnection(connStr)
        Dim comm As SqlClient.SqlCommand = New SqlClient.SqlCommand(query, con)
        Dim reader As SqlClient.SqlDataReader

        ' Open the connection
        con.Open()

        ' Get results
        reader = comm.ExecuteReader()

        ' temp variable to hold lines
        Dim line As String = ""

        ' Get the column names from the resultset
        For index As Integer = 0 To (reader.FieldCount - 1)
            line &amp;= reader.GetName(index) &amp; "|"
        Next

        ' remove last pipe
        line = line.Substring(0, line.Length - 1)

        ' write the column headers to the text file
        appendToTextFile(userProfileDir &amp; "\" &amp; filename, line)

        ' Write each row in the resultset to the text file
        While reader.Read()

            line = ""
            ' Add each column value to line
            For index As Integer = 0 To (reader.FieldCount - 1)
                ' Removing any pipes and newline to avoid screwing up our file
                line &amp;= reader.GetValue(index).ToString.Replace("|", "").Replace(ControlChars.CrLf, vbNullString) &amp; "|"
            Next

            ' remove last pipe and add a new line
            line = line.Substring(0, line.Length - 1)

            ' write the line to the output file
            appendToTextFile(userProfileDir &amp; "\" &amp; filename, line)

        End While

        ' clean up
        con.Close()
        comm = Nothing
        reader = Nothing
        con = Nothing

        Dts.TaskResult = ScriptResults.Success

    End Sub
    Public Sub appendToTextFile(ByVal file As String, ByVal line As String)

        ' Create a writer object that appends to a text file if it exists
        Dim objWriter As New System.IO.StreamWriter(file, True)
        objWriter.WriteLine(line)
        objWriter.Close()
        objWriter = Nothing

    End Sub

End Class</system.clscompliantattribute></system.addin.addin>
```

Now execute the package and check your desktop for the output file. My output file looked like below.

[![ssis output file]({{ site.baseurl }}/assets/2010/02/ssis_output_file_thumb.png "ssis output file")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssis_output_file.png)

Now alter your stored procedure so it returns a different resultset. Here's another one I used in the AdventureWorks database.

```
USE [AdventureWorks]
GO
/******Object: StoredProcedure [dbo].[usp_test] Script Date: 02/20/2010 19:20:55******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Rhys Campbell
-- Create date: 2010-02-20
-- Description:	Test proc
-- =============================================
ALTER PROCEDURE [dbo].[usp_test]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM Person.Address;

END
```

Run the package again and you should find another output file on your desktop.

[![ssis output file 2]({{ site.baseurl }}/assets/2010/02/ssis_output_file_2_thumb.png "ssis output file 2")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/ssis_output_file_2.png)

I've not thoroughly tested this code but it appears my initial issues have been resolved. This method does take significantly longer to write the output file than the traditional data flow method. This shouldn't be a huge issue for the purposes I'm thinking of using it in so I should be soon deploying this into a production environment.

