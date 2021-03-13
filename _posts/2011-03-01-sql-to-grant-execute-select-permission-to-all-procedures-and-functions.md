---
layout: post
title: SQL to Grant EXECUTE & SELECT permission to all Procedures and Functions
date: 2011-03-01 21:14:00.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- Permissions
- Table-Valued functions
meta:
  tweetbackscheck: '1613358771'
  shorturls: a:3:{s:9:"permalink";s:109:"http://www.youdidwhatwithtsql.com/sql-to-grant-execute-select-permission-to-all-procedures-and-functions/1071";s:7:"tinyurl";s:26:"http://tinyurl.com/66yblfo";s:4:"isgd";s:19:"http://is.gd/ga32Sz";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/sql-to-grant-execute-select-permission-to-all-procedures-and-functions/1071/"
---
I was Googling around the other day for a bit of [TSQL](http://en.wikipedia.org/wiki/Transact-SQL "Transact-SQL") to quickly grant a user permission to use all procedures and functions and came across the [following post](http://www.logiclabz.com/sql-server/sql-to-grant-execute-permission-to-all-procedures-and-functions.aspx). We have a few [table -valued functions](http://msdn.microsoft.com/en-us/library/ms191165.aspx "Table-Valued Functions") in our system so this script buckled with the following error;

```
Msg 4606, Level 16, State 1, Line 1
Granted or revoked privilege EXECUTE is not compatible with object.
```

The SELECT permission must be granted on this object rather than EXECUTE as for scalar functions. Here's an improvement on the script I found that will cater to this need.

```
SELECT 'GRANT ' + CASE(ROUTINE_TYPE)
                       WHEN 'PROCEDURE' THEN 'EXECUTE '
                       WHEN 'FUNCTION' THEN CASE(DATA_TYPE)
                                             WHEN 'TABLE' THEN 'SELECT '
                                             ELSE 'EXECUTE '
                                            END
                  END
                                + 'ON [' + ROUTINE_SCHEMA + '].[' + ROUTINE_NAME + '] TO [user];'
FROM INFORMATION_SCHEMA.ROUTINES
WHERE OBJECTPROPERTY(OBJECT_ID(ROUTINE_NAME),'IsMSShipped') = 0;
```

Here's some sample TSQL created when executed against the [AdventureWorks](http://msftdbprodsamples.codeplex.com/ "AdventureWorks sample database") database.

```
GRANT EXECUTE ON [dbo].[uspPrintError] TO [user];
GRANT EXECUTE ON [dbo].[uspLogError] TO [user];
GRANT EXECUTE ON [dbo].[ufnLeadingZeros] TO [user];
GRANT EXECUTE ON [dbo].[ufnGetAccountingStartDate] TO [user];
GRANT EXECUTE ON [dbo].[ufnGetAccountingEndDate] TO [user];
GRANT SELECT ON [dbo].[ufnGetContactInformation] TO [user];
GRANT EXECUTE ON [dbo].[ufnGetProductDealerPrice] TO [user];
GRANT EXECUTE ON [dbo].[ufnGetProductListPrice] TO [user];
GRANT EXECUTE ON [dbo].[ufnGetProductStandardCost] TO [user];
GRANT EXECUTE ON [dbo].[ufnGetStock] TO [user];
GRANT EXECUTE ON [dbo].[ufnGetDocumentStatusText] TO [user];
GRANT EXECUTE ON [dbo].[ufnGetPurchaseOrderStatusText] TO [user];
GRANT EXECUTE ON [dbo].[ufnGetSalesOrderStatusText] TO [user];
GRANT EXECUTE ON [dbo].[uspGetBillOfMaterials] TO [user];
GRANT EXECUTE ON [dbo].[uspGetEmployeeManagers] TO [user];
GRANT EXECUTE ON [dbo].[uspGetManagerEmployees] TO [user];
GRANT EXECUTE ON [dbo].[uspGetWhereUsedProductID] TO [user];
```
