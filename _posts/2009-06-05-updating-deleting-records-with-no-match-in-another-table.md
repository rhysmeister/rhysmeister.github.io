---
layout: post
title: Updating & deleting records with no match in another table
date: 2009-06-05 19:48:43.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MySQL
- T-SQL
tags:
- MySQL
- T-SQL
meta:
  _edit_last: '1'
  tweetbackscheck: '1613407759'
  shorturls: a:7:{s:9:"permalink";s:94:"http://www.youdidwhatwithtsql.com/updating-deleting-records-with-no-match-in-another-table/153";s:7:"tinyurl";s:25:"http://tinyurl.com/ncpgv7";s:4:"isgd";s:18:"http://is.gd/100Sq";s:5:"bitly";s:19:"http://bit.ly/w7oOU";s:5:"snipr";s:22:"http://snipr.com/jzrtp";s:5:"snurl";s:22:"http://snurl.com/jzrtp";s:7:"snipurl";s:24:"http://snipurl.com/jzrtp";}
  twittercomments: a:18:{s:10:"4489367265";s:7:"retweet";s:10:"4488354749";s:7:"retweet";s:10:"4465123776";s:7:"retweet";s:10:"4464648382";s:7:"retweet";s:17:"35374177057775616";s:7:"retweet";s:17:"35195725721632768";s:7:"retweet";s:17:"35194706866475009";s:7:"retweet";s:17:"35188114842451970";s:7:"retweet";s:17:"35184581455904768";s:7:"retweet";s:17:"35171320396390400";s:7:"retweet";s:17:"35158354791763968";s:7:"retweet";s:17:"35135342424240128";s:7:"retweet";s:17:"35120088541708288";s:7:"retweet";s:17:"35117515638177792";s:7:"retweet";s:17:"35108673554489346";s:7:"retweet";s:17:"35108326077366272";s:7:"retweet";s:17:"35099262907846656";s:7:"retweet";s:17:"35097640739934208";s:7:"retweet";}
  tweetcount: '20'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/updating-deleting-records-with-no-match-in-another-table/153/"
---
Several weeks ago I posted an article about [Non-SELECT Joins in T-SQL and MySQL.](http://www.youdidwhatwithtsql.com/non-select-joins-in-t-sql-and-mysql/64) The examples only covered [INNER JOINS](http://en.wikipedia.org/wiki/Join_(SQL)#Inner_join) but sometimes we need to update, or delete, records in a table that do not have a corresponding record in another table. I’m going to illustrate the various methods for doing this in [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) and [MySQL](http://www.mysql.com/).&nbsp;&nbsp;

**SQL Server create tables and data**

```
CREATE TABLE Employee
(
	id INTEGER IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Sex CHAR(1) NOT NULL,
	Dob DATE NOT NULL,
	Position VARCHAR(30) NOT NULL DEFAULT 'Unassigned',
	Salary MONEY NOT NULL,
	SalaryAdjustment BIT NULL
);
-- Insert some Employees
INSERT INTO Employee
(
	FirstName,
	LastName,
	Sex,
	Dob,
	Position,
	Salary
)
VALUES ('Dave','Smith','M','1978-01-01','Product Director',35000.00),
('Joe','Bloggs','M','1973-03-11','CEO',100000.00),
('John','Doe','M','1956-09-29','CFO',95000.00),
('Karen','Smith','F','1980-02-03','Marketing',60000.00),
('Clare','Jones','F','1970-10-30','Accounts',30000.00),
('Fernando','Cruz','M','1978-01-01','Technical Support',30000.00),
('Steve','Campbell','M','1975-05-17','IT Manager',45000.00);
-- Create a table for Salary adjustments
CREATE TABLE SalaryAdjustment
(
	EmployeeId INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	NewSalary MONEY NOT NULL
);
-- Salary Adjustments
INSERT INTO SalaryAdjustment
(
	EmployeeId,
	NewSalary
)
VALUES
(2, 80000.00),(6, 40000.00);

-- Just a simple table containing Employee IDs
CREATE TABLE ContractRenewals
(
	EmployeeId INTEGER NOT NULL PRIMARY KEY CLUSTERED
);
-- Insert some EmployeeIds
INSERT INTO ContractRenewals (EmployeeId)
VALUES (2),(5);
```

**MySQL create tables and data**

```
CREATE TABLE Employee
(
	id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Sex CHAR(1) NOT NULL,
	Dob DATE NOT NULL,
	Position VARCHAR(30) NOT NULL DEFAULT 'Unassigned',
	Salary DECIMAL(10,2) NOT NULL,
	SalaryAdjustment TINYINT NULL
);
# Insert some Employees
INSERT INTO Employee
(
	FirstName,
	LastName,
	Sex,
	Dob,
	Position,
	Salary
)
VALUES ('Dave','Smith','M','1978-01-01','Product Director',35000.00),
('Joe','Bloggs','M','1973-03-11','CEO',100000.00),
('John','Doe','M','1956-09-29','CFO',95000.00),
('Karen','Smith','F','1980-02-03','Marketing',60000.00),
('Clare','Jones','F','1970-10-30','Accounts',30000.00),
('Fernando','Cruz','M','1978-01-01','Technical Support',30000.00),
('Steve','Campbell','M','1975-05-17','IT Manager',45000.00);
# Create a table for Salary adjustments
CREATE TABLE SalaryAdjustment
(
	EmployeeId INTEGER NOT NULL PRIMARY KEY,
	NewSalary DECIMAL(10,2) NOT NULL
);
# Salary Adjustments
INSERT INTO SalaryAdjustment
(
	EmployeeId,
	NewSalary
)
VALUES
(2, 80000.00),(6, 40000.00);
# Just a simple table containing Employee IDs
CREATE TABLE ContractRenewals
(
	EmployeeId INTEGER NOT NULL PRIMARY KEY
);
# Insert some EmployeeIds
INSERT INTO ContractRenewals (EmployeeId)
VALUES (2),(5);
```

**SQL Server: UPDATE a table with no matching row in another table**

<font color="#666666">Initially our data will look like this;</font>

[![Employee table after update]({{ site.baseurl }}/assets/2009/06/image-thumb.png "Employee table after update")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image.png)

Our task is to update the value of **Employee.SalaryAdjustment** to 0 if the employee’s ID does not exist in the **SalaryAdjustment** table. Of course we could achieve this with a simple [subquery](http://msdn.microsoft.com/en-us/library/ms189575.aspx).

```
UPDATE Employee
SET SalaryAdjustment = 0
WHERE id NOT IN (SELECT EmployeeId
		 FROM SalaryAdjustment);
```

The query is easy to understand but wouldn't perform great on large datasets. Another method would be to use to NOT EXISTS.

```
UPDATE Employee
SET SalaryAdjustment = 0
WHERE NOT EXISTS (SELECT *
		  FROM SalaryAdjustment sal
		  WHERE sal.EmployeeId = Employee.id);
```

This method should provide good performance provided there is an appropriate index to support the query. The final method uses a [LEFT JOIN](http://en.wikipedia.org/wiki/Join_(SQL)#Left_outer_join).

```
UPDATE emp
SET emp.SalaryAdjustment = 0
FROM Employee AS emp
LEFT OUTER JOIN SalaryAdjustment AS sal
	ON emp.id = sal.EmployeeId
WHERE sal.EmployeeId IS NULL;
```

After running each of these queries, not forgetting to set all **Employee.SalaryAdjustment** values back to NULL, the **Employee** table will look like this after each one;

[![Empoyee table after each update]({{ site.baseurl }}/assets/2009/06/image-thumb1.png "Empoyee table after each update")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image1.png)

**MySQL: UPDATE a table with no matching row in another table**

<font color="#666666">The first two update methods, subquery and NOT EXISTS, shown above are syntactically identical in <a href="http://www.mysql.com/" target="_blank">MySQL</a> (hooraay for <a href="http://en.wikipedia.org/wiki/SQL#Standardization" target="_blank">standards</a>!) so I won’t repeat them here. The <strong>Employee </strong>table in your <a href="http://www.mysql.com" target="_blank">MySQL</a> database will look like;</font>

[![Employee table before update]({{ site.baseurl }}/assets/2009/06/image-thumb2.png "Employee table before update")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image2.png)

```
UPDATE Employee AS emp
LEFT JOIN SalaryAdjustment AS sal
	ON sal.EmployeeId = emp.id
SET emp.SalaryAdjustment = 0
WHERE sal.EmployeeId IS NULL;
```

I commented in my [previous article](http://www.youdidwhatwithtsql.com/non-select-joins-in-t-sql-and-mysql/64) that I find the [MySQL Join](http://dev.mysql.com/doc/refman/5.0/en/join.html) syntax so much more natural. I’m still finding this to be the case. Here’s what the **Employee** table looks like after the update. You can see that it has updated all the employee records that are not found in **SalaryAdjustment**.

[![Employee table after update]({{ site.baseurl }}/assets/2009/06/image-thumb3.png "Employee table after update")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image3.png)

**SQL Server: Delete records with no matching row in another table**

When deleting records we can also take advantage of the methods above; subqueries, NOT EXISTS and a LEFT JOIN.

[![Employee table]({{ site.baseurl }}/assets/2009/06/image-thumb4.png "Employee table")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image4.png)

<font color="#666666">The <strong>ContractRenewals</strong> table contains the following data;</font>

[![ContractRenewals table]({{ site.baseurl }}/assets/2009/06/image-thumb5.png "ContractRenewals table")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image5.png)

We want to remove all the records in **Employee** that aren’t matched in **ContractRenewals.**

**Using a subquery:**

```
DELETE
FROM Employee
WHERE id NOT IN (SELECT EmployeeId
		 FROM ContractRenewals);
```

**Using NOT EXISTS:**

```
DELETE
FROM Employee
WHERE NOT EXISTS (SELECT *
		  FROM ContractRenewals
		  WHERE ContractRenewals.EmployeeId = Employee.Id);
```

**Using a LEFT JOIN:**

```
DELETE Employee
FROM Employee AS emp
LEFT OUTER JOIN ContractRenewals AS ren
	ON ren.EmployeeId = emp.id
WHERE ren.EmployeeId IS NULL;
```

Running each of these queries will produce the same end result. The **Employee** table should contain the following data;

[![Employee table after delete]({{ site.baseurl }}/assets/2009/06/image-thumb6.png "Employee table after delete")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image6.png)

**MySQL: Delete records with no matching row in another table**

<font color="#666666">Again, as the subquery and NOT EXISTS, methods are syntactically identical in <a href="http://www.mysql.com" target="_blank">MySQL</a> I will only show the LEFT JOIN method here;</font>

[![Employee table before delete]({{ site.baseurl }}/assets/2009/06/image-thumb2.png "Employee table before delete")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image2.png)

```
DELETE emp
FROM Employee AS emp
LEFT OUTER JOIN ContractRenewals AS ren
	ON ren.EmployeeId = emp.id
WHERE ren.EmployeeId IS NULL;
```

[![Employee table after delete]({{ site.baseurl }}/assets/2009/06/image-thumb7.png "Employee table after delete")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/06/image7.png)

