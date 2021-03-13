---
layout: post
title: Column is nullable but contains no nulls
date: 2011-03-23 17:11:00.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- T-SQL
tags:
- nullable
- nulls
- TSQL
meta:
  tweetbackscheck: '1613228697'
  shorturls: a:3:{s:9:"permalink";s:79:"http://www.youdidwhatwithtsql.com/column-is-nullable-but-contains-no-nulls/1074";s:7:"tinyurl";s:26:"http://tinyurl.com/5vy5g2w";s:4:"isgd";s:19:"http://is.gd/bVCg7Z";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/column-is-nullable-but-contains-no-nulls/1074/"
---
We're currently busy reviewing some of the historical database design decisions taken in our organisation. We've noticed quite a lot of columns, that are specified as nullable, but do not actually contain any nulls. Obviously this fact makes the column a possible candidate for changing to NOT NULL.

I wanted to make this task a little easier so I knocked up a quick TSQL script using the [INFORMATION\_SCHEMA](http://msdn.microsoft.com/en-us/library/ms186778(v=SQL.90).aspx) views. This script uses these views to identify all the nullable columns and then executes a count of nulls in this column. This could potentially run a large number of resource-intensive queries so do not run this on any live system.

```
DECLARE @TABLE_SCHEMA NVARCHAR(100),
        @TABLE_NAME NVARCHAR(100),
        @COLUMN_NAME NVARCHAR(100),
        @sql NVARCHAR(1000),
        @count INTEGER;

DECLARE columnCursor CURSOR LOCAL FAST_FORWARD FOR SELECT c.TABLE_SCHEMA,
                                                          c.TABLE_NAME,
                                                          c.COLUMN_NAME
						   FROM INFORMATION_SCHEMA.COLUMNS c
                                                   INNER JOIN INFORMATION_SCHEMA.TABLES t
                                                       ON t.TABLE_CATALOG = c.TABLE_CATALOG
                                                       AND t.TABLE_SCHEMA = c.TABLE_SCHEMA
                                                       AND t.TABLE_NAME = c.TABLE_NAME
                                                   WHERE c.IS_NULLABLE = 'YES'
                                                   AND t.TABLE_TYPE = 'BASE TABLE';

OPEN columnCursor;
FETCH NEXT FROM columnCursor INTO @TABLE_SCHEMA,
                                  @TABLE_NAME,
                                  @COLUMN_NAME;

WHILE (@@FETCH_STATUS = 0)
BEGIN

                SET @sql = N'SELECT @count = COUNT(*) FROM [' + @TABLE_SCHEMA + '].[' + @TABLE_NAME + '] WHERE [' + @COLUMN_NAME + '] IS NULL';

                EXECUTE sp_executesql @query = @sql,
                                      @params = N'@count INTEGER OUTPUT',
                                      @count = @count OUTPUT;

                IF(@count = 0)
                BEGIN

                        PRINT @COLUMN_NAME + ' in ' + @TABLE_SCHEMA + '.' + @TABLE_NAME + ' is nullable but contains no nulls.';

                END;

                FETCH NEXT FROM columnCursor INTO @TABLE_SCHEMA,
                                                  @TABLE_NAME,
                                                  @COLUMN_NAME
END;

CLOSE columnCursor;
DEALLOCATE columnCursor;
```

The script will print a report of all the columns set to allow nulls that do not actually contain any. Here's what it prints out when run against the [AdventureWorks](http://msftdbprodsamples.codeplex.com/ "AdventureWorks sample database") database.

```
SalesPersonID in Sales.Store is nullable but contains no nulls.
Demographics in Sales.Store is nullable but contains no nulls.
ThumbNailPhoto in Production.ProductPhoto is nullable but contains no nulls.
ThumbnailPhotoFileName in Production.ProductPhoto is nullable but contains no nulls.
LargePhoto in Production.ProductPhoto is nullable but contains no nulls.
LargePhotoFileName in Production.ProductPhoto is nullable but contains no nulls.
Comments in Production.ProductReview is nullable but contains no nulls.
LastReceiptCost in Purchasing.ProductVendor is nullable but contains no nulls.
LastReceiptDate in Purchasing.ProductVendor is nullable but contains no nulls.
EmailAddress in Person.Contact is nullable but contains no nulls.
Phone in Person.Contact is nullable but contains no nulls.
ShipDate in Purchasing.PurchaseOrderHeader is nullable but contains no nulls.
EndDate in Production.WorkOrder is nullable but contains no nulls.
ActualStartDate in Production.WorkOrderRouting is nullable but contains no nulls.
ActualEndDate in Production.WorkOrderRouting is nullable but contains no nulls.
ActualResourceHrs in Production.WorkOrderRouting is nullable but contains no nulls.
ActualCost in Production.WorkOrderRouting is nullable but contains no nulls.
TerritoryID in Sales.Customer is nullable but contains no nulls.
ShipDate in Sales.SalesOrderHeader is nullable but contains no nulls.
AccountNumber in Sales.SalesOrderHeader is nullable but contains no nulls.
TerritoryID in Sales.SalesOrderHeader is nullable but contains no nulls.
Document in Production.Document is nullable but contains no nulls.
Diagram in Production.Illustration is nullable but contains no nulls.
Demographics in Sales.Individual is nullable but contains no nulls.
Resume in HumanResources.JobCandidate is nullable but contains no nulls.
Schema in dbo.DatabaseLog is nullable but contains no nulls.
Object in dbo.DatabaseLog is nullable but contains no nulls.
ErrorSeverity in dbo.ErrorLog is nullable but contains no nulls.
ErrorState in dbo.ErrorLog is nullable but contains no nulls.
ErrorProcedure in dbo.ErrorLog is nullable but contains no nulls.
ErrorLine in dbo.ErrorLog is nullable but contains no nulls.
```
