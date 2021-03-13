---
layout: post
title: Breaking my Non-Equi Join cherry
date: 2010-02-17 21:56:16.000000000 +01:00
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
- non-equi joins
- T-SQL
meta:
  tweetbackscheck: '1613478679'
  shorturls: a:4:{s:9:"permalink";s:70:"http://www.youdidwhatwithtsql.com/breaking-my-non-equi-join-cherry/652";s:7:"tinyurl";s:26:"http://tinyurl.com/yzfh2vh";s:4:"isgd";s:18:"http://is.gd/8BIPO";s:5:"bitly";s:20:"http://bit.ly/8XEUAq";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/breaking-my-non-equi-join-cherry/652/"
---
There's few SQL techniques you seem to keep in the cupboard gathering dust. I don't think I've ever needed to use [RIGHT JOIN](http://en.wikipedia.org/wiki/Join_(SQL)#Right_outer_joins) outside of the classroom. I can recall using [FULL OUTER JOIN](http://en.wikipedia.org/wiki/Join_(SQL)#Full_outer_join), just once, to show an employer how not-in-sync their "integrated system" was. Today I broke my professional [Non-Equi JOIN](http://www.orafaq.com/wiki/Nonequi_join) cherry!

I basically had one table of appointments and another table providing appointment banding by a date range.&nbsp; The banding wasn't consistent, spanning weeks and months,&nbsp; so there was no possibility of using an equi-join or doing anything with datetime arithmetic. Perhaps that non-equi join thing I remember reading in the textbook will do?

Here's a quick run-through of a similar situation. Create some tables and insert some test data. (This first example is in [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) 2005)

```
CREATE TABLE dbo.Appointments
(
	AppointId INTEGER IDENTITY (1,1) NOT NULL PRIMARY KEY CLUSTERED,
	AppointmentDateTime DATETIME NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Reason VARCHAR(50) NULL
);
GO

CREATE TABLE AppointmentBands
(
	AppointBandId INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
	StartDateTime DATETIME NOT NULL,
	EndDateTime DATETIME NOT NULL
);
GO

-- Insert Test Data
INSERT INTO dbo.Appointments
(
	AppointmentDateTime,
	FirstName,
	LastName,
	Reason
)
SELECT '2010-02-18T17:00:00',
	   'Rhys',
	   'Campbell',
	   'Eye Test'
UNION ALL
SELECT '2010-02-23T12:00:00',
	   'John',
	   'Smith',
	   'Ear Test'
UNION ALL
SELECT '2010-02-28T14:00:00',
	   'Frank',
	   'Zappa',
	   'Eye Test';
GO

INSERT INTO dbo.AppointmentBands
(
	StartDateTime,
	EndDateTime
)
SELECT '2010-02-18T00:00:00',
	   '2010-02-22T23:59:59'
UNION ALL
SELECT '2010-02-23T00:00:00',
	   '2010-02-27T23:59:59'
UNION ALL
SELECT '2010-02-28T00:00:00',
	   '2010-03-01T23:59:59';
```

I needed to identify which appointment band each record belonged to. It's a trivial example here, but the real life situation involved hundreds of thousands of appointments and a few thousand appointment bands. The solution involved using a [BETWEEN](http://msdn.microsoft.com/en-us/library/ms187922.aspx) in the join clause.

```
SELECT app.*, band.AppointBandId
FROM dbo.Appointments app
INNER JOIN dbo.AppointmentBands band
	ON app.AppointmentDateTime BETWEEN band.StartDateTime AND band.EndDateTime;
```

[![appointments non equi join]({{ site.baseurl }}/assets/2010/02/appointments_non_equi_join_thumb.png "appointments non equi join")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/appointments_non_equi_join.png)

Such a simple, elegant, single query solution. Perhaps we need to dust these things off from time-to-time?

Here's the same example, a'la [MySQL](http://www.mysql.com)

```
CREATE TABLE Appointments
(
	AppointId INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
	AppointmentDateTime DATETIME NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Reason VARCHAR(50) NULL
);

CREATE TABLE AppointmentBands
(
	AppointBandId INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
	StartDateTime DATETIME NOT NULL,
	EndDateTime DATETIME NOT NULL
);

-- Insert Test Data
INSERT INTO Appointments
(
	AppointmentDateTime,
	FirstName,
	LastName,
	Reason
)
SELECT '2010-02-18T17:00:00',
	   'Rhys',
	   'Campbell',
	   'Eye Test'
UNION ALL
SELECT '2010-02-23T12:00:00',
	   'John',
	   'Smith',
	   'Ear Test'
UNION ALL
SELECT '2010-02-28T14:00:00',
	   'Frank',
	   'Zappa',
	   'Eye Test';

INSERT INTO AppointmentBands
(
	StartDateTime,
	EndDateTime
)
SELECT '2010-02-18T00:00:00',
	   '2010-02-22T23:59:59'
UNION ALL
SELECT '2010-02-23T00:00:00',
	   '2010-02-27T23:59:59'
UNION ALL
SELECT '2010-02-28T00:00:00',
	   '2010-03-01T23:59:59';
```

```
SELECT app.*, band.AppointBandId
FROM Appointments app
INNER JOIN AppointmentBands band
	ON app.AppointmentDateTime BETWEEN band.StartDateTime AND band.EndDateTime;
```

[![MySQL non equi join]({{ site.baseurl }}/assets/2010/02/MySQL_non_equi_join_thumb.png "MySQL non equi join")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/MySQL_non_equi_join.png)

