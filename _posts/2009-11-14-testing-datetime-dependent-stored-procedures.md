---
layout: post
title: Testing datetime dependent Stored Procedures
date: 2009-11-14 14:24:28.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- sql server 2005
- SQL Server 2008
- TSQL
meta:
  shorturls: a:4:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/testing-datetime-dependent-stored-procedures/433";s:7:"tinyurl";s:26:"http://tinyurl.com/yjd26bo";s:4:"isgd";s:18:"http://is.gd/4UQTR";s:5:"bitly";s:19:"http://bit.ly/eqYSC";}
  tweetbackscheck: '1613461975'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/testing-datetime-dependent-stored-procedures/433/"
---
This week I was tasked with testing a stored procedure that was meant to output data on certain days. This was over a 120 day period, so I wanted to find some automated way of doing this, rather than changing the server date manually for each execution. The method I came up with involves the use of [xp\_cmdshell](http://msdn.microsoft.com/en-us/library/ms175046.aspx) to execute the [date command](http://en.wikipedia.org/wiki/List_of_DOS_commands#time_and_date). Here's an illustration of what I came up with.

First create this stored procedure. This will just check to see if it's Saturday and output "Yes" if it is.

```
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Rhys Campbell
-- Create date: 2009-11-14
-- Description:	Outputs "Yes" if it is Saturday
-- otherwise "No"
-- =============================================
CREATE PROCEDURE usp_isItSaturday
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @isItSaturday VARCHAR(3);

    	SET @isItSaturday = CASE
				WHEN DATEPART(dw, GETDATE()) = 7 THEN 'Yes'
				ELSE
					'No'
			    END;
	SELECT GETDATE(), @isItSaturday;

END
GO
```

The script below will change the date by one day, then execute usp\_isItSaturday, in sequence up to the end of 2009. I had to introduce the [WAITFOR](http://msdn.microsoft.com/en-us/library/ms187331.aspx) delay because [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) seems to take a few seconds to register the date change. The script will simply loop until the day changes before executing the store procedure.

```
-- Enable xp_cmdshell
EXEC master.dbo.sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

DECLARE @command VARCHAR(4000),
		@date VARCHAR(10),
		@starting DATETIME,
		@day INTEGER;

SET @starting = GETDATE();

WHILE (@starting <= '2009-12-31T00:00:00')
BEGIN

	SET @date = CAST(DATEPART(d, @starting) AS VARCHAR(2)) + '/' + CAST(DATEPART(m, @starting) AS VARCHAR(2)) + '/' + CAST(DATEPART(YYYY, @starting) AS VARCHAR(4));
	-- Get the day for tracking when the date change has taken effect
	SET @day = DATEPART(d, @starting);
	SET @command = 'date ' + @date;
	EXEC xp_cmdshell @command, no_output;

	-- SQL Server takes a while to pickup the date change
	-- Loop around until the day has changed before executing the proc
	WHILE(@day <> DATEPART(d, GETDATE()))
	BEGIN
		WAITFOR DELAY '00:00:01';
	END

	-- Call the procedure with the changed date
	EXEC dbo.usp_isItSaturday;
	-- Increment date by 1 day
	SET @starting = DATEADD(d, 1, @starting);

END

-- Disable xp_cmdshell
EXEC master.dbo.sp_configure 'xp_cmdshell', 0;
RECONFIGURE;
```

Here's a sample of the output. You can see it has correctly identified the days that are Saturday.

[![usp_isItSaturday]({{ site.baseurl }}/assets/2009/11/usp_isItSaturday_thumb.png "usp\_isItSaturday")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/11/usp_isItSaturday.png)

