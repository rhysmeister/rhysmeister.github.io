---
layout: post
title: The Poor Mans data compare with Powershell
date: 2011-05-25 22:17:36.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Powershell
tags:
- data compare
- Powershell
meta:
  tweetbackscheck: '1613467297'
  shorturls: a:3:{s:9:"permalink";s:81:"http://www.youdidwhatwithtsql.com/the-poor-mans-data-compare-with-powershell/1096";s:7:"tinyurl";s:26:"http://tinyurl.com/3ewbea2";s:4:"isgd";s:19:"http://is.gd/1TBF4l";}
  twittercomments: a:2:{s:17:"73519175053742081";s:7:"retweet";s:17:"73498917035192320";s:7:"retweet";}
  tweetcount: '3'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/the-poor-mans-data-compare-with-powershell/1096/"
---
Each new [cmdlet](http://msdn.microsoft.com/en-us/library/ms714395(v=vs.85).aspx "Powershell cmdlet") I discover makes me fall in love with [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell "Windows Powershell") a little bit more. A while ago I discovered the [Compare-Object cmdlet](http://technet.microsoft.com/en-us/library/ee156812.aspx "Powershell Compare-Object cmdlet"). The examples given in the documentation demonstrate how to compare computer processes and text files but I was interested to see if this would work with a dataset. So I tried it.

```
-- Create two test tables with data
CREATE TABLE dbo.Table1
(
	Id INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	Value VARCHAR(10) NOT NULL
);
GO

CREATE TABLE dbo.Table2
(
	Id INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	Value VARCHAR(10) NOT NULL
);
GO

-- Insert the same data into each table
INSERT INTO dbo.Table1
(
	Id,
	Value
)
VALUES (1, 'Rhys'),
(2, 'James'),
(3, 'Campbell');
GO

INSERT INTO dbo.Table2
(
	Id,
	Value
)
VALUES (1, 'Rhys'),
(2, 'James'),
(3, 'Campbell');
GO
```

This snippet of Powershell will do a compare between the two tables data. Change the connection string to suit your test server.

```
# Configure connection string
$con = New-Object System.Data.SqlClient.SqlConnection("Data Source=localhost\sqlexpress;Integrated Security=true;Initial Catalog=test");
# Create two sql statements for the tables
$q1 = "SELECT * FROM dbo.Table1";
$q2 = "SELECT * FROM dbo.Table2";
# Create dataset objects
$resultset1 = New-Object "System.Data.DataSet" "myDs";
$resultset2 = New-Object "System.Data.DataSet" "myDs";
# Run query 1 and fill resultset1
$data_adap = new-object "System.Data.SqlClient.SqlDataAdapter" ($q1, $con);
$data_adap.Fill($resultset1) | Out-Null;
# Run query 2 and fill resultset2
$data_adap = new-object "System.Data.SqlClient.SqlDataAdapter" ($q2, $con);
$data_adap.Fill($resultset2) | Out-Null;

# Get data table (only first table will be compared).
[System.Data.DataTable]$dataset1 = $resultset1.Tables[0];
[System.Data.DataTable]$dataset2 = $resultset2.Tables[0];

# Compare tables
$diff = Compare-Object $dataset1 $dataset2;
# Are there any differences?
if($diff -eq $null)
{
	Write-Host "The resultsets are the same.";
}
else
{
	Write-Host "The resultsets are different.";
}

# Clean up
$dataset1.Dispose();
$dataset2.Dispose();
$resultset1.Dispose();
$resultset2.Dispose();
$data_adap.Dispose();
$con.Close();
$con.Dispose();
```

The script will output the following;

```
The resultsets are the same.
```

We obviously know the data is identical so that's no surprise. Run the next bit of TSQL to make the tables differ.

```
INSERT INTO dbo.Table1
(
	Id,
	Value
)
VALUES (4, 'Blah!');
GO
```

Run the script again and it will tell you the datasets differ.

```
The resultsets are different.
```

If you're not yet convinced delete the additional row we just inserted into Table1.

```
DELETE FROM dbo.Table1
WHERE Id = 4;
GO
```

Execute the script once more;

```
The resultsets are the same.
```

Isn't that great? Let's do another quick test...

```
INSERT INTO dbo.Table1
(
	Id,
	Value
)
VALUES
(
	4,
	'A Value'
);
GO
-- Different value in table 2
INSERT INTO dbo.Table2
(
	Id,
	Value
)
VALUES
(
	4,
	'Different'
);
GO
```

Now run the script again...

```
The resultsets are the same.
```

What's going on here? Let's add another difference to the datasets.

```
ALTER TABLE dbo.Table1 ADD Active BIT NOT NULL DEFAULT 0;
ALTER TABLE dbo.Table2 ADD Active BIT NOT NULL DEFAULT 1;
GO
```

```
SELECT *
FROM dbo.Table1;

SELECT *
FROM dbo.Table2;
```

[![datasets_]({{ site.baseurl }}/assets/2011/05/datasets__thumb.png "datasets\_")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/08/datasets_.png)

Now the datasets are clearly different. What does the script report?

```
The resultsets are the same.
```

Mmmm, it's still obviously incorrect. I've played around with this a bit and it seems the Compare-Object cmdlet is unable to check the contents of rows. Provided the number of rows are the same, and the data types match, then the object will be reported as the same.

So here's an enhanced script that will compare values across the two datasets. It's still using the Compare-Object cmdlet to do an initial check because it's good at telling us about datasets that have a different number of rows or data types without having to do a taxing value-by-value check of each row.

```
#trap [Exception]
#{
#	Write-Error "An exception was encountered";
#	Write-Error $_.Exception.Message;
#	Write-Error $_.Exception.StackTrace;
#	Exit;
#}

# Configure connection string
$con = New-Object System.Data.SqlClient.SqlConnection("Data Source=localhost\sqlexpress;Integrated Security=true;Initial Catalog=test");
# Create two sql statements for the tables
$q1 = "SELECT * FROM dbo.Table1";
$q2 = "SELECT * FROM dbo.Table2";
# Create dataset objects
$resultset1 = New-Object "System.Data.DataSet" "myDs";
$resultset2 = New-Object "System.Data.DataSet" "myDs";
# Run query 1 and fill resultset1
$data_adap = new-object "System.Data.SqlClient.SqlDataAdapter" ($q1, $con);
$data_adap.Fill($resultset1) | Out-Null;
# Run query 2 and fill resultset2
$data_adap = new-object "System.Data.SqlClient.SqlDataAdapter" ($q2, $con);
$data_adap.Fill($resultset2) | Out-Null;
# Get data table (only first table will be compared).
[System.Data.DataTable]$dataset1 = $resultset1.Tables[0];
[System.Data.DataTable]$dataset2 = $resultset2.Tables[0];
# Compare tables. Basic object check
$diff = Compare-Object $dataset1 $dataset2;

# Function to do a row-by-row check
function RBAR-Check ($dataset1, $dataset2)
{
	$row_index = 0;
	foreach($row in $dataset1.Rows)
	{
		$column_index = 0;
		foreach($col in $row.ItemArray)
		{
			# Get corresponding value in dataset2
			$col2 = $dataset2.Rows[$row_index][$column_index];
			if($col -ne $col2)
			{
				return $false;
			}
			$column_index += 1;
		}
		$row_index += 1;
	}
	return $true;
}

# Are there any differences?
if($diff -eq $null)
{
	Write-Host "The resultset objects look the same... Performing a detailed RBAR check...";
	$same = RBAR-Check $dataset1 $dataset2;
	if($same)
	{
		Write-Host -ForegroundColor Green "The resultsets are the same.";
	}
	else
	{
		Write-Host -ForegroundColor Red "The resultsets are not the same.";
	}
}
else
{
	Write-Host "The resultsets are different.";
}

# Clean up
$dataset1.Dispose();
$dataset2.Dispose();
$resultset1.Dispose();
$resultset2.Dispose();
$data_adap.Dispose();
$con.Close();
$con.Dispose();
```

Run the script again...

```
The resultset objects look the same... Performing a detailed RBAR check...
The resultsets are not the same.
```

Now lets make the datasets the same...

```
UPDATE dbo.Table2
SET Value = 'A Value'
WHERE Id = 4;
GO

UPDATE dbo.Table2
SET Active = 0;
GO
```

[![dataset_2]({{ site.baseurl }}/assets/2011/05/dataset_2_thumb.png "dataset\_2")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2011/08/dataset_2.png)

Run the script one final time...

```
The resultset objects look the same... Performing a detailed RBAR check...
The resultsets are the same.
```

Now the script can effectively spot the differences between two datasets. It's a shame the Compare-Object cmdlet can't fully cope with datasets, as well as it can with text files, but that's a problem solved with a little more Powershell.

I've already integrated this into our release process. I can rapidly compare all of the lookup tables in our system and spot any differences between environments with a few key presses. Once again Powershell makes life a little less taxing!

If you liked this you might also like;

[Can you send that to me in an email?](http://www.youdidwhatwithtsql.com/can-you-send-that-to-me-in-an-email/917)

[Documenting Databases with Powershell](http://www.youdidwhatwithtsql.com/guest-post-on-scripting-guys/914 "Producing database documentation with Powershell")&nbsp;

[Send Email with Powershell](http://www.youdidwhatwithtsql.com/send-email-with-powershell/889 "Send email with Powershell")

[SQL Server Audit with Powershell Excel Automation](http://www.youdidwhatwithtsql.com/sql-server-audit-with-powershell-excel-automation/703 "SQL Server Audit with Powershell and Excel")

[Discover SQL Servers via the Registry with Powershell](http://www.youdidwhatwithtsql.com/discover-sql-servers-with-powershell-via-the-registry/494 "Discover SQL Servers via the Registry with Powershell")

```

```
