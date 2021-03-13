---
layout: post
title: SQL Server Fulltext Search Primer
date: 2009-07-09 16:10:50.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- T-SQL
tags:
- Fulltext
- SQL Server
- T-SQL
meta:
  tweetbackscheck: '1613028285'
  twittercomments: a:1:{s:10:"2552812059";s:7:"retweet";}
  shorturls: a:7:{s:9:"permalink";s:71:"http://www.youdidwhatwithtsql.com/sql-server-fulltext-search-primer/248";s:7:"tinyurl";s:25:"http://tinyurl.com/ng6l9m";s:4:"isgd";s:18:"http://is.gd/1somZ";s:5:"bitly";s:19:"http://bit.ly/YK62S";s:5:"snipr";s:22:"http://snipr.com/mfwcc";s:5:"snurl";s:22:"http://snurl.com/mfwcc";s:7:"snipurl";s:24:"http://snipurl.com/mfwcc";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/sql-server-fulltext-search-primer/248/"
---
Previously I wrote an article about [fulltext searching with MySQL](http://www.youdidwhatwithtsql.com/mysql-fulltext-search-primer/224) and thought I’d redo the same article but for [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) users. Depending of which side of the [database wars](http://www.sqlmag.com/Article/ArticleID/21431/sql_server_21431.html) you’re on [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) has either a more advanced or complicated way of doing things. Here’s a very brief introduction to the fulltext search features in [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx).

First the fulltext search service needs to be enabled for the database.

```
-- Enable fulltext searching on the database
USE database1;
GO
EXEC sp_fulltext_database 'enable';
GO
-- Create a fulltext catalog
CREATE FULLTEXT CATALOG ft_catalog_database1
GO
```

If your [fulltext index](http://msdn.microsoft.com/en-us/library/ms187317.aspx) is going to be large, or very frequently searched, you may want to [research options](http://msdn.microsoft.com/en-us/library/ms187317.aspx) to put the catalog on a different disk.

Create a table to hold some test data.

```
-- Create a table to contain the poems
CREATE TABLE poems
(
	id INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
	author VARCHAR(50) NOT NULL,
	title VARCHAR(100) NOT NULL,
	poem TEXT NOT NULL
);
```

Insert some dummy data.

```
-- Insert some data
INSERT INTO poems
(
	author,
	title,
	poem
)
SELECT

	'Johann Wolfgang von Goethe',
	'Night Thoughts',
	'Stars, you are unfortunate, I pity you,
Beautiful as you are, shining in your glory,
Who guide seafaring men through stress and peril
And have no recompense from gods or mortals,
Love you do not, nor do you know what love is.
Hours that are aeons urgently conducting
Your figures in a dance through the vast heaven,
What journey have you ended in this moment,
Since lingering in the arms of my beloved
I lost all memory of you and midnight.'
UNION ALL
SELECT
	'Nikki Giovanni',
	'I Love You',
	'I love you
because the Earth turns round the sun
because the North wind blows north
sometimes
because the Pope is Catholic
and most Rabbis Jewish
because winters flow into springs
and the air clears after a storm'
UNION ALL
SELECT
	'Lord Byron',
	'She Walks In Beauty',
	'She walks in beauty, like the night
Of cloudless climes and starry skies;
And all that''s best of dark and bright
Meet in her aspect and her eyes:
Thus mellow''d to that tender light
Which heaven to gaudy day denies.

One shade more, one ray less,
Had half impair''d the nameless grace
Which waves in every raven tress,
Or softly lightens o''er her face;
Where thoughts serenely sweet express
How pure, how dear their dwelling place.

And on that cheek, and o''er that brow
So soft, so calm, yet eloquent,
The smiles that win, the tints that glow,
But tell of days in goodness spent,
A mind at peace with all below,
A heart whose love is innocent!'
UNION ALL
SELECT
	'Christopher Marlowe',
	'Come Live With Me',
	'Come live with me, and be my love;
And we will all the pleasures prove
That valleys, groves, hills, and fields,
Woods or steepy mountain yields.'
UNION ALL
SELECT
	'Thomas Campbell',
	'Freedom and Love',
	'How delicious is the winning
Of a kiss at love''s beginning,
When two mutual hearts are sighing
For the knot there''s no untying!

Yet remember, ''midst your wooing
Love has bliss, but Love has ruing;
Other smiles may make you fickle,
Tears for other charms may trickle.

Love he comes and Love he tarries
Just as fate or fancy carries;
Longest stays, when sorest chidden;
Laughs and flies, when press''d and bidden.

Bind the sea to slumber stilly,
Bind its odour to the lily,
Bind the aspen ne''er to quiver,
Then bind Love to last for ever.

Love''s a fire that needs renewal
Of fresh beauty for its fuel;
Love''s wing moults when caged and captured,
Only free, he soars enraptured.

Can you keep the bees from ranging,
Or the ringdove''s neck from changing?
No! nor fetter''d Love from dying
In the knot there''s no untying.';
```

Now we need to create the [fulltext](http://msdn.microsoft.com/en-us/library/ms187317.aspx) index;

```
-- Create a fulltext index on title and poem
CREATE FULLTEXT INDEX ON database1.dbo.poems
(
	title
	Language 0X0,
	poem
	Language 0X0
)
KEY INDEX PK __poems__ 00551192 ON ft_catalog_database1
WITH CHANGE_TRACKING AUTO;
```

The fulltext index requires a unique non-nullable index to be specified on its creation. Check your primary key name in SSMS and change the above [TSQL](http://msdn.microsoft.com/en-us/library/ms189826(SQL.90).aspx) as appropriate (after KEY INDEX).

[![Check Primary Key name in SSMS]({{ site.baseurl }}/assets/2009/07/image_thumb10.png "Check Primary Key name in SSMS")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image10.png)

You will receive the following warning after the index is created;

```
Warning: Table or indexed view 'Documents' has full-text indexed columns that are of type image, text, or ntext. Full-text change tracking cannot track WRITETEXT or UPDATETEXT operations performed on these columns.
```

Standard UPDATE and INSERT changes are reflected in the fulltext catalog but changes with [WRITETEXT](http://msdn.microsoft.com/en-us/library/ms186838.aspx) or [UPDATETEXT](http://msdn.microsoft.com/en-us/library/ms189466.aspx) are not. If you’re not using these then you can ignore the warning. Otherwise this would involve some form of manual [update to the fulltext catalog](http://msdn.microsoft.com/en-us/library/aa214782(SQL.80).aspx) after using [WRITETEXT](http://msdn.microsoft.com/en-us/library/ms186838.aspx) / [UPDATETEXT](http://msdn.microsoft.com/en-us/library/ms189466.aspx). Now the fulltext index is ready to use.

```
SELECT *
FROM poems
WHERE CONTAINS(title, '"I love you"');
```

[![Fulltext search results in SSMS]({{ site.baseurl }}/assets/2009/07/image_thumb11.png "Fulltext search results in SSMS")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image11.png)

You can also order by relevance;

```
SELECT *
FROM CONTAINSTABLE(dbo.poems, *, '"I love you"') AS t1
JOIN dbo.poems AS t2
	ON t1.[KEY] = t2.id
ORDER BY t1.[RANK] DESC;
```

Note the asterisk in the [CONTAINSTABLE](http://technet.microsoft.com/en-us/library/ms189760.aspx) clause. This means search all columns in the fulltext index.

[![Fulltext search results with rank in SSMS]({{ site.baseurl }}/assets/2009/07/image_thumb12.png "Fulltext search results with rank in SSMS")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image12.png)

TSQL has two predicates and two functions we can use with fulltext searching. The table\* below details these. Be sure to investigate these to make the most of your fulltext catalogs.

| **Keyword** | **Meaning** | **Returns** |
| CONTAINS | Supports complex syntax to search for a word or phrase using Boolean operators, prefix terms | Simple Boolean predicate |
| CONTAINSTABLE | Supports CONTAINS syntax and returns document IDs and rank scores for matches | Table containing document IDs and rank scores |
| FREETEXT | Automatically performs thesaurus expansions and replacements in a simplified syntax | Simple Boolean predicate |
| FREETEXTTABLE | Supports FREETEXT syntax and returns document IDs and rank scores for matches | Table containing document IDs and rank scores |

\* _source: [http://en.wikipedia.org/wiki/SQL\_Server\_Full\_Text\_Search](http://en.wikipedia.org/wiki/SQL_Server_Full_Text_Search "http://en.wikipedia.org/wiki/SQL\_Server\_Full\_Text\_Search")_

I’ve just scratched the surface, of what you can do with fulltext searches in [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx). Be sure to check out the concepts around [Noise words](http://msdn.microsoft.com/en-us/library/ms142551(SQL.90).aspx), usage of the [Thesaurus](http://msdn.microsoft.com/en-us/library/ms142491(SQL.90).aspx) and [word-breakers](http://msdn.microsoft.com/en-us/library/ms142509(SQL.90).aspx) to make the most of your fulltext searches.

