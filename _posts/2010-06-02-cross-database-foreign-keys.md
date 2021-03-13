---
layout: post
title: Cross database foreign keys?
date: 2010-06-02 20:43:21.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
- T-SQL
tags:
- cross datasbase
- Foreign keys
meta:
  tweetcount: '1'
  twittercomments: a:1:{s:11:"15274326667";s:7:"retweet";}
  tweetbackscheck: '1613464384'
  shorturls: a:4:{s:9:"permalink";s:65:"http://www.youdidwhatwithtsql.com/cross-database-foreign-keys/784";s:7:"tinyurl";s:26:"http://tinyurl.com/26wzdhx";s:4:"isgd";s:18:"http://is.gd/cA3G4";s:5:"bitly";s:20:"http://bit.ly/cylG9H";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/cross-database-foreign-keys/784/"
---
Colleague: “_Can you have foreign keys referencing other databases?”_

Me: “_Erm… I don’t know, but it I’ll find out.”_

I’ve always thought tables with these relationships should exist in the same database so I’ve never attempted this. But I don’t like not knowing things so I set to find out. The answer, as it often seems to be, is “_it depends!”_

**Q1: Does MySQL support cross-database foreign keys?**

First lets create some test databases and tables. The table called **test1** will reference a table called **test2** in another database.

```
CREATE DATABASE test1;
CREATE DATABASE test2;

USE test1;

CREATE TABLE test1
(
	idnum INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	fk_id INT NOT NULL
) ENGINE = INNODB;

USE test2;

CREATE TABLE test2
(
	idnum INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	fk_id INT NOT NULL,
	FOREIGN KEY fk_idnum (fk_id) REFERENCES test1.test1(idnum)
) ENGINE = INNODB;
```

OK, MySQL seemed to parse that without complaint. Now lets try to insert a record into table **test2**.

```
USE test2;

INSERT INTO test2
(
	fk_id
)
VALUES
(
	1
);
```

We get an error which shows the constraint is working as you would expect.

```
# Error Code : 1452
# Cannot add or update a child row: a foreign key constraint fails (`test2`.`test2`, CONSTRAINT `test2_ibfk_1` FOREIGN KEY (`fk_id`) REFERENCES `test1`.`test1` (`idnum`)
```

Insert some data into both tables now.

```
USE test1;

INSERT INTO test1
(
	fk_id
)
VALUES
(
	1
);

USE test2;

INSERT INTO test2
(
	fk_id
)
VALUES
(
	1
);

SELECT *
FROM test2.test2
UNION ALL
SELECT *
FROM test1.test1;
```

What happens if we try to drop the **test1** database?

```
DROP DATABASE test1;
```

```
# Error Code : 1217
# Cannot delete or update a parent row: a foreign key constraint fail
```

To drop both the databases we need to drop them in the below sequence

```
# Clean up
DROP DATABASE test2;
DROP DATABASE test1;
```

**A1: Yes! MySQL does support cross-database foreign key references. \***

\* Assuming the [storage engine](http://dev.mysql.com/doc/refman/5.0/en/storage-engines.html) in use supports foreign keys.

**<font color="#666666">Q2: Does SQL Server support cross-database foreign keys?</font>**

```
CREATE DATABASE test1;
CREATE DATABASE test2;

USE test1;

CREATE TABLE test1
(
	idnum INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	fk_id INT NOT NULL
);

USE test2;

CREATE TABLE test2
(
	idnum INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	fk_id INT NOT NULL,
	FOREIGN KEY (fk_id) REFERENCES test1.dbo.test1(idnum)
);
```

```
Msg 1763, Level 16, State 0, Line 1
Cross-database foreign key references are not supported. Foreign key 'test1.dbo.test1'.
Msg 1750, Level 16, State 0, Line 1
Could not create constraint. See previous errors.
```

**<font color="#666666">A2: No! SQL Server does not support cross-database foreign key references.</font>**

[Chris Rock](http://en.wikiquote.org/wiki/Chris_Rock) once said _“You can drive a car with your feet if you want to, that don't make it a good \*\*\*\*\*\*\* idea!”._ That’s kind of how I feel about cross-database foreign keys. Just because you can, doesn’t mean you should! I’d be inclined to have no foreign key relationship if we’re spitting up data for performance reasons. Otherwise I’d put both tables in the same database where they logically belong.

