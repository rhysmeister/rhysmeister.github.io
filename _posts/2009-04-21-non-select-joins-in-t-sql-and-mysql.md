---
layout: post
title: Non-SELECT Joins in T-SQL and MySQL
date: 2009-04-21 20:23:13.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MySQL
- T-SQL
tags:
- JOIN
- MySQL
- Non-SELECT JOINS
- SQL
- T-SQL
meta:
  tweetbackscheck: '1613316549'
  shorturls: a:7:{s:9:"permalink";s:72:"http://www.youdidwhatwithtsql.com/non-select-joins-in-t-sql-and-mysql/64";s:7:"tinyurl";s:25:"http://tinyurl.com/dnfxrl";s:4:"isgd";s:17:"http://is.gd/vQ24";s:5:"bitly";s:19:"http://bit.ly/pMR8j";s:5:"snipr";s:22:"http://snipr.com/h5gvx";s:5:"snurl";s:22:"http://snurl.com/h5gvx";s:7:"snipurl";s:24:"http://snipurl.com/h5gvx";}
  twittercomments: a:1:{i:1578292062;s:2:"83";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/non-select-joins-in-t-sql-and-mysql/64/"
---
I read a great article, by [Pinal Dave](http://blog.sqlauthority.com/), on [SQL Joins](http://blog.sqlauthority.com/2009/04/13/sql-server-introduction-to-joins-basic-of-joins/ )&nbsp; this week. I thought I’d add something for Non-SELECT joins as I’ve noticed a few developers missing these in their armoury. It doesn’t help that there is no standard so every database implements this differently. This is one of the few occasions where you will hear me rant about [MySQL](http://www.mysql.com) over [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx). The way you express Non-SELECT joins in [MySQL](http://www.mysql.com) just seems far more natural to me.

You’ll need both [MySQL](http://dev.mysql.com/downloads/mysql/5.1.html) and [SQL Server 2008 Express](http://www.microsoft.com/express/sql/download/) to follow this demo. I’ll be providing a simple script to create tables, and populate with data, for both systems. Then I’ll compare how Non-SELECT Joins are performed in each system. So get prepared to switch between environments.

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
	Salary MONEY NOT NULL
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
CREATE TABLE Leavers
(
	EmployeeId INTEGER NOT NULL PRIMARY KEY CLUSTERED
);
-- Insert some EmployeeIds
INSERT INTO Leavers (EmployeeId)
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
	Salary DECIMAL(10,2) NOT NULL
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
CREATE TABLE Leavers
(
	EmployeeId INTEGER NOT NULL PRIMARY KEY
);
# Insert some EmployeeIds
INSERT INTO Leavers (EmployeeId)
VALUES (2),(5);
```

**SQL Server: UPDATE from another table with a JOIN**

This SQL updates the records in **Employee** that are matched in the **SalaryAdjustment** table. While it’s second nature to me now I do recall thinking this was confusing once.

```
-- Update the Employee table with SalaryAdjustment
UPDATE emp
SET emp.Salary = NewSalary
FROM Employee emp
INNER JOIN SalaryAdjustment adj ON emp.id = adj.EmployeeId;
```

**MySQL: UPDATE from another table with a JOIN**

Learning Non-SELECT Joins in [MySQL](http://www.mysql.com) really was a breath of fresh air to me. This statement does the same as the SQL Server equivalent above. Doesn't this look so more natural?

```
# Update the Employee table with SalaryAdjustment
UPDATE Employee, SalaryAdjustment
SET Employee.Salary = SalaryAdjustment.NewSalary
WHERE Employee.id = SalaryAdjustment.EmployeeId;
```

**SQL Server: DELETE from another table with a JOIN**

<font color="#666666">The statement will delete the records in <strong>Employee</strong> that are matched by the <strong>Leavers</strong> table. I’ve seen people act nervous about what this will actually delete!</font>

```
-- Delete the Employees found in Leavers
DELETE FROM Employee
FROM Employee
INNER JOIN Leavers ON Employee.id = Leavers.EmployeeId;
```

**MySQL: DELETE from another table with a JOIN**

This statement does the same as the SQL Server equivalent above. Again, I find this syntax just so more natural to work with.

```
# Delete the Employees found in Leavers
DELETE FROM Employee
USING Employee, Leavers
WHERE Employee.id = Leavers.EmployeeId;
```

I hope these simple examples have been fun to follow and informative. Using these JOINs in your UPDATE and DELETE statements can be so much more performance pleasing, when compared to sub-selects, so they are worth knowing.

