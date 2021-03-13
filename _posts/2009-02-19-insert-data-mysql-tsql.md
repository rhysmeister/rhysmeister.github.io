---
layout: post
title: Insert data into MySQL with T-SQL
date: 2009-02-19 16:03:07.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- Add new tag
- data integration
- MySQL
- SQL Server
- sql server 2005
- TSQL
- xml documents
meta:
  _edit_last: '1'
  s2mail: ''
  _headspace_page_title: Insert data into MySQL with TSQL
  _headspace_description: Inserting data from SQL Server into MySQL is relatively
    simple involving just a little setup and a few TSQL tricks. If you use MySQL systems
    with SQL Server you will be able to use some of its great features for your MySQL
    specific tasks.
  shorturls: a:7:{s:9:"permalink";s:58:"http://www.youdidwhatwithtsql.com/insert-data-mysql-tsql/4";s:7:"tinyurl";s:25:"http://tinyurl.com/cwq4e4";s:4:"isgd";s:17:"http://is.gd/oLHI";s:5:"bitly";s:20:"http://bit.ly/2XdH5h";s:5:"snipr";s:22:"http://snipr.com/ehdf5";s:5:"snurl";s:22:"http://snurl.com/ehdf5";s:7:"snipurl";s:24:"http://snipurl.com/ehdf5";}
  tweetbackscheck: '1613450686'
  twittercomments: a:4:{i:1240829952;s:2:"77";s:17:"35911392024465410";s:7:"retweet";s:17:"35898105534619648";s:7:"retweet";s:17:"35547893725143040";s:7:"retweet";}
  tweetcount: '4'
  _sg_subscribe-to-comments: nwgralexander@gmail.com
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/insert-data-mysql-tsql/4/"
---
One of the killer features of SQL Server is the ability to retrieve data from almost any source. Want to query MySQL, Access databases, text files, Active Directory, Exchange mailboxes or XML documents? All this is possible with SQL Server and is relatively simple to do so and all without resorting to [SSIS](http://msdn.microsoft.com/en-us/library/ms141026(SQL.90).aspx). Getting data into SQL Server, from outside sources, is well documented but pushing it out into other DBMSs, like MySQL, is not. This example will demonstrate how you can use SQL Server to get data from an XML file into MYSQL with just a [Linked Server](http://msdn.microsoft.com/en-us/library/ms188279.aspx)and a bit of TSQL.

**Setup**

For this exercise you will need the following pieces of software installed on the same computer. Ensure all these pieces of software are installed and configured correctly before proceeding further.

_SQL Server 2005_ - [http://www.microsoft.com/Sqlserver/2005/en/us/express.aspx](http://www.microsoft.com/Sqlserver/2005/en/us/express.aspx)  
_MySQL_ – [http://www.mysql.com](http://www.mysql.com) (5.0.51b-community-nt)  
_MySQL ODBC 3.51 Driver_ - [http://dev.mysql.com/downloads/connector/odbc/3.51.html](http://dev.mysql.com/downloads/connector/odbc/3.51.html)

**MySQL Database Setup**

Run this SQL script against your MySQL database to create the required objects. You will also need to [create a Mysql user](http://dev.mysql.com/doc/refman/5.1/en/create-user.html) for this database so it can be used in a [DSN](http://en.wikipedia.org/wiki/Database_Source_Name). The database created will contain two tables called _customers_ and _customer\_contacts_.

```
-- Create a MySQL database
CREATE DATABASE MyCRM;
-- Select MySQL for use
USE MyCRM;
-- Create a table for customers
CREATE TABLE customers
(
	id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	business_name VARCHAR(100) NOT NULL,
	address1 VARCHAR(100) NOT NULL,
	address2 VARCHAR(100) NULL,
	city VARCHAR(50) NOT NULL,
	postcode VARCHAR(8) NOT NULL,
	telephone VARCHAR(30) NULL,
	website VARCHAR(100) NULL,
	email VARCHAR(100) NULL
) ENGINE = InnoDB;
-- Create a table for customer contacts
CREATE TABLE customer_contacts
(
	id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	customer_id INTEGER UNSIGNED NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	telephone VARCHAR(30) NOT NULL,
	mobile VARCHAR(30) NOT NULL,
	email VARCHAR(100) NULL,
	`comment` VARCHAR(1000)
) ENGINE = InnoDB;
-- Add a foreign key
ALTER TABLE customer_contacts ADD CONSTRAINT fk_customer_id
FOREIGN KEY (customer_id) REFERENCES customers (id);
```

**Linked Server Setup**

[Linked Servers](http://msdn.microsoft.com/en-us/library/aa213778(SQL.80).aspx) allow commands to be executed against other data sources from within SQL Server. First configure a data source that the linked server will use.

**Add a System DSN**

Setup may vary slightly by OS. These instructions refer to Vista.

Start \> Control Panel \> Administrative Tools \> Data Sources (ODBC) \> System DSN.  
Add a new DSN using the MySQL ODBC 3.51 Driver.

[caption id="attachment\_5" align="alignnone" width="590" caption="System DSN Configuration in Vista"] ![System DSN Configuration in Vista]({{ site.baseurl }}/assets/2009/02/system_dsn.jpg "system\_dsn")[/caption]

Configure your System DSN like above and click "Test" to ensure it functions. Next we need to login to your SQL Server 2005 instance to add a Linked Server which will be using the above MySQL database.

Run the following TSQL to create the linked server…

```
EXEC master.dbo.sp_addlinkedserver @server = N'MYSQL', @srvproduct=N'MySQL', @provider=N'MSDASQL', @datasrc=N'MYSQL';

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'MYSQL',@useself=N'False',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL;
```

To ensure the Linked Server is running correctly run the following TSQL

```
SELECT *
FROM OPENQUERY(MYSQL, 'SELECT * FROM customers');
```

An empty resultset should be displayed giving you the customer table columns.

[caption id="attachment\_6" align="alignnone" width="533" caption="TSQL to test the linked server"] ![TSQL to test the linked server]({{ site.baseurl }}/assets/2009/02/linked_server_test.jpg "linked\_server\_test")[/caption]

The configuration of the Linked Server is now complete and we are ready to begin inserting data into MySQL from our SQL Server instance. The TSQL script will be explained section by section before being represented in whole.

First we declare a few variables that we will be using in our script. **@xml** will contain our xml data, **@handle** will be used to reference the XML document created by SQL Server, and **@customer\_id** is a value we will retrieve from MySQL after inserting a record. The **@xml** variable is populated with some XML containing a single customer record with two customer\_contact records.

```
DECLARE @xml VARCHAR(MAX),
		@handle INT,
		@customer_id INT;

-- The XML document containg a single customer
-- with two contacts
SET @xml = '<customer>
				<business_name>ACME Ltd</business_name>
				<address1>100 Saffron Hill</address1>
				<address2>Farringdon Road</address2>
				<city>London</city>
				<postcode>EC1N 8FH</postcode>
				<telephone>0123456789</telephone>
				<website>http://www.acmeltd.com</website>
				<email>info@acmeltd.com</email>
				<customer_contact>
					<first_name>Rhys</first_name>
					<last_name>Campbell</last_name>
					<telephone>0123456789</telephone>
					<mobile>0123456789</mobile>
					<email>rhys@acmltd.com</email>
					<comment>Owner</comment>
				</customer_contact>
				<customer_contact>
					<first_name>Joe</first_name>
					<last_name>Bloggs</last_name>
					<telephone>0123456789</telephone>
					<mobile>0123456789</mobile>
					<email>joe@acmeltd.com</email>
					<comment>Employee</comment>
				</customer_contact>
			</customer>';
```

Next [prepare](http://msdn.microsoft.com/en-us/library/aa260385(SQL.80).aspx) an internal representation of the XML document so it can be used by SQL Server.

```
-- Prepare the xml document
EXEC sp_xml_preparedocument @handle OUTPUT, @xml;
```

SQL Server can now select data from the XML document and consume the data in other operations. First we will insert the customer record into the MySQL customers table. This part of the script introduces the [OPENXML](http://msdn.microsoft.com/en-us/library/aa276847(SQL.80).aspx) rowset provider. The [OPENQUERY](http://msdn.microsoft.com/en-us/library/ms188427.aspx) function needs to read the metadata for the table it is inserting into. The WHERE clause, that will never be true, is included so an empty resultset is returned and performance is maintained as the table grows. (Yes, otherwise you will return data from MySQL to SQL Server that will not be used).

```
-- Insert the customer record
INSERT INTO OPENQUERY(MYSQL, 'SELECT business_name,
									 address1,
									 address2,
									 city,
									 postcode,
									 telephone,
									 website,
									 email
							  FROM customers WHERE 1 != 1')
SELECT business_name,
	   address1,
	   address2,
	   city,
	   postcode,
	   telephone,
	   website,
	   email
FROM OPENXML(@handle, '/customer', 2)
WITH
(
	business_name VARCHAR(100),
	address1 VARCHAR(100),
	address2 VARCHAR(100),
	city VARCHAR(50),
	postcode VARCHAR(8),
	telephone VARCHAR(30),
	website VARCHAR(100),
	email VARCHAR(100)
);
```

We need to add two records to the customer\_contacts table so we need the customer id value we have just created. The [LAST\_INSERT\_ID()](http://dev.mysql.com/doc/refman/5.0/en/information-functions.html#function_last-insert-id) MySQL function used below is similar to the [@@IDENTITY](http://msdn.microsoft.com/en-us/library/ms187342.aspx) function.

```
-- Get the id for the created customer
SET @customer_id = (SELECT *
					FROM OPENQUERY(MYSQL, 'SELECT LAST_INSERT_ID()'));
```

Once the @customer\_id variable has been set we are able to insert the two customer\_contacts records.

```
-- Insert the contact records
INSERT INTO OPENQUERY(MYSQL, 'SELECT customer_id,
									 first_name,
									 last_name,
									 telephone,
									 mobile,
									 email,
									 comment
							  FROM customer_contacts WHERE 1 != 1')
SELECT @customer_id,
	   first_name,
	   last_name,
	   telephone,
	   mobile,
	   email,
	   comment
FROM OPENXML(@handle, '/customer/customer_contact', 2)
WITH
(
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	telephone VARCHAR(30),
	mobile VARCHAR(30),
	email VARCHAR(100),
	comment TEXT
);
```

Finally we need to free up the resources consumed by the XML document by [removing](http://msdn.microsoft.com/en-us/library/aa260386(SQL.80).aspx) it.

```
-- Remove the xml document
EXEC sp_xml_removedocument @handle;
```

That's it! Now there should be one record in the customer table and two records in the customer\_contacts table. SQL Server Management Studio should display something like...

[caption id="attachment\_7" align="alignnone" width="533" caption="SSMS After TSQL Script"] ![SSMS After TSQL Script]({{ site.baseurl }}/assets/2009/02/after_insert.jpg "after\_insert")[/caption]

The script is repeated here in full so you can copy and paste this into SSMS.

```
DECLARE @xml VARCHAR(MAX),
		@handle INT,
		@customer_id INT;

-- The XML document containg a single customer
-- with two contacts
SET @xml = '<customer>
				<business_name>ACME Ltd</business_name>
				<address1>100 Saffron Hill</address1>
				<address2>Farringdon Road</address2>
				<city>London</city>
				<postcode>EC1N 8FH</postcode>
				<telephone>0123456789</telephone>
				<website>http://www.acmeltd.com</website>
				<email>info@acmeltd.com</email>
				<customer_contact>
					<first_name>Rhys</first_name>
					<last_name>Campbell</last_name>
					<telephone>0123456789</telephone>
					<mobile>0123456789</mobile>
					<email>rhys@acmltd.com</email>
					<comment>Owner</comment>
				</customer_contact>
				<customer_contact>
					<first_name>Joe</first_name>
					<last_name>Bloggs</last_name>
					<telephone>0123456789</telephone>
					<mobile>0123456789</mobile>
					<email>joe@acmeltd.com</email>
					<comment>Employee</comment>
				</customer_contact>
			</customer>';

-- Prepare the xml document
EXEC sp_xml_preparedocument @handle OUTPUT, @xml;

-- Insert the customer record
INSERT INTO OPENQUERY(MYSQL, 'SELECT business_name,
									 address1,
									 address2,
									 city,
									 postcode,
									 telephone,
									 website,
									 email
							  FROM customers WHERE 1 != 1')
SELECT business_name,
	   address1,
	   address2,
	   city,
	   postcode,
	   telephone,
	   website,
	   email
FROM OPENXML(@handle, '/customer', 2)
WITH
(
	business_name VARCHAR(100),
	address1 VARCHAR(100),
	address2 VARCHAR(100),
	city VARCHAR(50),
	postcode VARCHAR(8),
	telephone VARCHAR(30),
	website VARCHAR(100),
	email VARCHAR(100)
);

-- Get the id for the created customer
SET @customer_id = (SELECT *
					FROM OPENQUERY(MYSQL, 'SELECT LAST_INSERT_ID()'));

-- Insert the contact records
INSERT INTO OPENQUERY(MYSQL, 'SELECT customer_id,
									 first_name,
									 last_name,
									 telephone,
									 mobile,
									 email,
									 comment
							  FROM customer_contacts WHERE 1 != 1')
SELECT @customer_id,
	   first_name,
	   last_name,
	   telephone,
	   mobile,
	   email,
	   comment
FROM OPENXML(@handle, '/customer/customer_contact', 2)
WITH
(
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	telephone VARCHAR(30),
	mobile VARCHAR(30),
	email VARCHAR(100),
	comment TEXT
);

-- Remove the xml document
EXEC sp_xml_removedocument @handle;
```

This solution will be the perfect fit for SQL Server based systems where it is not appropriate to add another layer of complexity like SSIS. The ease at which SQL Server deals with multiple data sources places it in an ideal position to become a data broker between systems and techniques like above make it a snap!

