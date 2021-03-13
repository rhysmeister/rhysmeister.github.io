---
layout: post
title: Getting started with Query Notifications with SQL Server 2008 R2
date: 2013-10-10 16:30:28.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- SQL Server
- T-SQL
tags:
- Query Notifications
- SQL Server
meta:
  _edit_last: '1'
  twittercomments: a:0:{}
  tweetbackscheck: '1613475522'
  shorturls: a:3:{s:9:"permalink";s:86:"http://www.youdidwhatwithtsql.com/started-query-notifications-sql-server-2008-r2/1676/";s:7:"tinyurl";s:26:"http://tinyurl.com/mlqfbru";s:4:"isgd";s:19:"http://is.gd/CCiLwj";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/started-query-notifications-sql-server-2008-r2/1676/"
---
I've been experimenting with [Query Notifications](http://technet.microsoft.com/en-us/library/ms130764(v=sql.105).aspx "Query Notifications SQL Server 2008 R2") in SQL Server 2008 R2. This looks like a really cool way of implementing real-time features into your applications without constantly battering your database with select statements. Instead we can request a notification for when the data has changed for a query. Here's a quick demo of the feature.

[CLR](http://msdn.microsoft.com/en-us/library/ms254498.aspx "SQL CLR") should be enabled

```
EXEC sp_configure 'show advanced options' , '1';
GO
RECONFIGURE;
GO
EXEC sp_configure 'clr enabled' , '1';
GO
RECONFIGURE;
GO
```

Create a test database to contain the query notification objects.

```
CREATE DATABASE TestQueryNotifications;
GO
```

```
-- Enable broker
ALTER DATABASE TestQueryNotifications SET ENABLE_BROKER;
```

Create a queue in the test database.

```
USE TestQueryNotifications;
CREATE QUEUE my_test_queue;
GO
```

Create a service on the queue.

```
CREATE SERVICE my_test_service ON QUEUE my_test_queue
(
	[http://schemas.microsoft.com/SQL/Notifications/PostQueryNotification]
);
GO
```

Next we create a test login and give it access to the test database.

```
-- Create a test user
CREATE LOGIN qn_test WITH PASSWORD = 'secretpassword';
-- add user to current database
CREATE USER qn_test FROM LOGIN qn_test;
```

Next we're going to create a special schema for query notifications and set it as the default for the above user. This is because of a little problem explain here; [schemas and query notifications](http://www.sqlskills.com/blogs/bobb/about-schemas-and-setting-up-query-notifications/ "Schemas and Query Notifcations").

```
CREATE SCHEMA qn_schema AUTHORIZATION qn_test;
GO
ALTER USER qn_test WITH DEFAULT_SCHEMA = qn_schema;
GO
```

Create a test table.

```
CREATE TABLE dbo.my_test_table
(
	id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
	random_text VARCHAR(200) NOT NULL,
	dt DATETIME NOT NULL DEFAULT GETDATE()
);
GO
```

Now we need to add permissions for our user.

```
-- Add read role to db for user
EXEC sp_addrolemember 'db_datareader', 'qn_test';
GO
GRANT SELECT ON dbo.my_test_table TO qn_test;
-- Grant access to the contract
GRANT REFERENCES ON CONTRACT::[http://schemas.microsoft.com/SQL/Notifications/PostQueryNotification] TO qn_test;
GRANT SUBSCRIBE QUERY NOTIFICATIONS TO qn_test;
GRANT RECEIVE ON QueryNotificationErrorsQueue TO qn_test;
GRANT SEND ON SERVICE::my_test_service to qn_test;
GRANT CREATE PROCEDURE TO qn_test;
GRANT CREATE QUEUE TO qn_test;
GRANT CREATE SERVICE TO qn_test;
```

Check the permissions.

```
EXEC sp_helprotect null, 'qn_test';
GO
```

If you're querying two (or more different databases you need to turn on the trustworthy option on each like so. For this example you don't need to bother.

```
ALTER DATABASE TestQueryNotifications SET TRUSTWORTHY ON;
ALTER DATABASE db2 SET TRUSTWORTHY ON;
GO
```

Here's a simple console app written in c# that will use the query notification we have setup. This is slightly modified code from this [forum](http://social.msdn.microsoft.com/Forums/sqlserver/en-US/fe98f30a-e556-459b-8aae-c75cf00f77a9/use-sql-notification-for-console-application-c). Assuming your SQL Server instance is listening on 'localhost' you shouldn't need to change this code. The key part of this code is&nbsp;**dependency = new SqlDependency(command, null, 60);&nbsp;**The 60 indicates the timeout for the query notification. Essentially this means the client will refresh the results if a notification has not yet been received.

```
using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;

class SqlNotificationConsole
{

    private static SqlDependency dependency;
    private static string connectionString = @"Data Source=localhost;Initial Catalog=TestQueryNotifications;User Id=qn_test;Password=secretpassword";

    static void Main(string[] args)
    {
        var connection = new SqlConnection(connectionString);
        SqlDependency.Start(connectionString);
        RefreshDataWithSqlDependency();

        //block main thread - SqlDependency thread will monitor changes
        Console.ReadLine();
        SqlDependency.Stop(connectionString);
    }

    static void RefreshDataWithSqlDependency()
    {
        try
        {
            //Remove existing dependency, if necessary
            if (dependency != null)
            {
                dependency.OnChange -= onDependencyChange;
                dependency = null;
            }

            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();

            SqlCommand command = new SqlCommand(
             "SELECT id, random_text, dt FROM dbo.my_test_table",
             connection);

            // Create a dependency (class member) and associate it with the command.
            dependency = new SqlDependency(command, null, 60);

            // Subscribe to the SqlDependency event.
            dependency.OnChange += new OnChangeEventHandler(onDependencyChange);

            // start dependency listener
            SqlDependency.Start(connectionString);

            // execute command and refresh data
            refreshData(command);

            connection.Close();
        }
        catch (SqlException ex)
        {
            throw ex;
        }
    }

    private static void onDependencyChange(Object o, SqlNotificationEventArgs args)
    {
        if ((args.Source.ToString() == "Data") || (args.Source.ToString() == "Timeout"))
        {
            Console.WriteLine("Refreshing data due to {0}", args.Source);
            RefreshDataWithSqlDependency();
        }
        else
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine("Data not refreshed due to unexpected SqlNotificationEventArgs: Source={0}, Info={1}, Type={2}", args.Source, args.Info, args.Type.ToString());
            Console.ForegroundColor = ConsoleColor.Gray;
        }
    }

    private static void refreshData(SqlCommand command)
    {
        var reader = command.ExecuteReader();
        Console.Clear();
        while (reader.Read())
        {
            Console.WriteLine("id = {0}, random_text = {1}, dt = {2}", reader[0], reader[1], reader[2]);
        }
        reader.Close();
    }
}
```

The project should contain the following references;

```
Microsoft.CSharp
System
System.Core
System.Data
System.Data.DataSetExtensions
System.Xml
System.Xml.Linq
```

Compile and run the console app then run some inserts with this TSQL;

```
INSERT INTO dbo.my_test_table
(
	random_text
)
VALUES (CONVERT(varchar(200), NEWID()));
```

You should see the data displayed by the console app after it is inserted. A refresh will also occur automatically after 60 seconds.

[![Console app query notifications]({{ site.baseurl }}/assets/2013/10/console_app_query_notifcations.png)](http://www.youdidwhatwithtsql.com/wp-content/uploads/2013/10/console_app_query_notifcations.png)  
If you alter the table you'll discover the query notification will break;

```
ALTER TABLE dbo.my_test_table ADD test_col BIT NOT NULL DEFAULT 1;
```

For real world implementation you'll want to handle this error so changes don't break your apps.

```
Data not refreshed due to unexpected SqlNotificationEventArgs: Source=Object, In
fo=Alter, Type=Change
```

The following [DMV](http://technet.microsoft.com/en-us/library/ms188754(v=sql.105).aspx "Dynamic Management Views") is useful for monitoring Query Notification subscriptions;

```
SELECT *
FROM sys.dm_qn_subscriptions;
```
