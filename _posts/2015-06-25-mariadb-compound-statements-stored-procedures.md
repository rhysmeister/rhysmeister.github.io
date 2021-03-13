---
layout: post
title: MariaDB Compound Statements Outside Stored Procedures
date: 2015-06-25 15:40:37.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MariaDB
tags:
- mariadb
meta:
  _edit_last: '1'
  tweetbackscheck: '1613371598'
  twittercomments: a:0:{}
  shorturls: a:3:{s:9:"permalink";s:85:"http://www.youdidwhatwithtsql.com/mariadb-compound-statements-stored-procedures/2107/";s:7:"tinyurl";s:26:"http://tinyurl.com/q5me66f";s:4:"isgd";s:19:"http://is.gd/jiiuzh";}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mariadb-compound-statements-stored-procedures/2107/"
---
It's always been a small annoyance that the&nbsp;[MySQL](https://www.mysql.com/) / [MariaDB](https://mariadb.org/) flavour of SQL wouldn't allow you to use if else&nbsp;logic or loops outside of a stored procedure or trigger. There were ways around &nbsp;this but it's not as nice if you're coming from [TSQL](https://msdn.microsoft.com/en-us/library/ms365303.aspx). This is rectified in [MariaDB from 10.1.1](https://mariadb.com/kb/en/mariadb/using-compound-statements-outside-of-stored-programs/).

One thing that is worth noting, which perhaps the manual doesn't make totally clear, is that you should use the [DELIMITER](https://mariadb.com/kb/en/mariadb/delimiters-in-the-mysql-client/) statement in your SQL code. This is just the same as when writing stored procedures. You get syntax error if you don't do this.

```
DELIMITER |
BEGIN NOT ATOMIC

/* SQL CODE HERE
*/

END; |

DELIMITER ;
```

Here are a few examples;

**UPDATE:&nbsp;** Please note that the source code plugin strips the pipe characters from the code after you click "View Code"

**WHILE LOOP**

```
DELIMITER |

BEGIN NOT ATOMIC
	DECLARE i INTEGER;
	SET i = 1;

	WHILE i < 10 DO

		SELECT i;
		SELECT SLEEP(i);
		SET i = i + 1;

	END WHILE;

END; |

DELIMITER ;
```

**IF STATEMENT**

```
DELIMITER |

BEGIN NOT ATOMIC

	IF 1 = 1 THEN
		SELECT 'Hello, World!';
	END IF;

END; |

DELIMITER ;
```

**CASE STATEMENT**

```
DELIMITER |

BEGIN NOT ATOMIC

	CASE(@@port)
		WHEN 3306 THEN
		SELECT 'Running on the default port.';
	ELSE
		SELECT 'You are not running on the default port.';
	END CASE;

END; |

DELIMITER ;
```

**ITERATE LOOP WITH IF ELSE**

```
DELIMITER |

BEGIN NOT ATOMIC

	DECLARE i INTEGER DEFAULT 0;

	my_loop: LOOP
		SET i = i + 1;
		SELECT i * i;
		IF i < 10 THEN
			ITERATE my_loop;
		ELSE
			LEAVE my_loop;
		END IF;
	END LOOP my_loop;
END; |

DELIMITER ;
```
