---
layout: post
title: MySQL Fulltext search primer
date: 2009-07-06 12:28:02.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MySQL
tags:
- Fulltext
- MySQL
meta:
  tweetbackscheck: '1613249765'
  shorturls: a:7:{s:9:"permalink";s:66:"http://www.youdidwhatwithtsql.com/mysql-fulltext-search-primer/224";s:7:"tinyurl";s:25:"http://tinyurl.com/owvpgu";s:4:"isgd";s:18:"http://is.gd/1oLcp";s:5:"bitly";s:19:"http://bit.ly/D2HvC";s:5:"snipr";s:22:"http://snipr.com/m73vt";s:5:"snurl";s:22:"http://snurl.com/m73vt";s:7:"snipurl";s:24:"http://snipurl.com/m73vt";}
  twittercomments: a:1:{s:10:"2869102949";s:7:"retweet";}
  tweetcount: '1'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/mysql-fulltext-search-primer/224/"
---
[MySQL](http://www.mysql.com)&nbsp;[fulltext](http://dev.mysql.com/doc/refman/5.1/en/fulltext-search.html) indexing can be a useful addition to a website requiring some better searching capabilities. Many blogging platforms based on [MySQL](http://www.mysql.com), like [wordpress](http://www.wordpress.org), will be using [fulltext](http://dev.mysql.com/doc/refman/5.1/en/fulltext-search.html) indexes for their search features. While not as powerful as something like [Lucene](http://lucene.apache.org/) it certainly is a lot simpler to setup. [Fulltext](http://dev.mysql.com/doc/refman/5.1/en/fulltext-search.html) indexes can only be created on [MyISAM](http://en.wikipedia.org/wiki/MyISAM) tables so that means no [transactions](http://en.wikipedia.org/wiki/Database_transaction), [foreign keys](http://en.wikipedia.org/wiki/Foreign_key) or row-locking. You can check out [further restrictions](http://dev.mysql.com/doc/refman/5.1/en/fulltext-restrictions.html) in the documentation.

Here’s a quick demonstration to help you get started with [MySQL Fulltext search](http://dev.mysql.com/doc/refman/5.1/en/fulltext-search.html). First create the following table.

```
# Create a table to contain the poems
CREATE TABLE poems
(
	id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	author VARCHAR(50) NOT NULL,
	title VARCHAR(100) NOT NULL,
	poem TEXT NOT NULL
) Engine = MyISAM;
```

Insert some test data into the table;

```
# Insert some data
INSERT INTO poems
(
	author,
	title,
	poem
)
VALUES
(
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
),
(
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
),
(
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
),
(
	'Christopher Marlowe',
	'Come Live With Me',
	'Come live with me, and be my love;
And we will all the pleasures prove
That valleys, groves, hills, and fields,
Woods or steepy mountain yields.'
),
(
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
In the knot there''s no untying.');
```

Now we need to create the [fulltext](http://dev.mysql.com/doc/refman/5.1/en/fulltext-search.html) indexes;

```
# Create fulltext indexes on title and poem
CREATE FULLTEXT INDEX idx_ft_title ON poems (title);
CREATE FULLTEXT INDEX idx_ft_poem ON poems (poem);
```

Alternatively we could have used the following syntax to achieve the same as above.

```
# Fulltext indexes with alter table syntax
ALTER TABLE poems ADD FULLTEXT (title);
ALTER TABLE poems ADD FULLTEXT (poem);
```

Now we are ready to starting performing searches with our [fulltext](http://dev.mysql.com/doc/refman/5.1/en/fulltext-search.html) indexes;

```
SELECT *
FROM poems
WHERE MATCH(title) AGAINST('I love you');
```

[![Fulltext search with MySQL]({{ site.baseurl }}/assets/2009/07/image_thumb.png "Fulltext search with MySQL")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image.png)

You may have noticed that the search has returned the row with id 5 even though it doesn’t contain ‘I’ or ‘You’ in the title. This is because these words are categorised as [stopwords](http://dev.mysql.com/doc/refman/5.1/en/fulltext-stopwords.html) and are effectively ignored.

You can obtain, and order by, the relevance that [MySQL](http://www.mysql.com) deems for each result. Which is obviously useful for displaying the results in relevance order.

```
SELECT *, MATCH(title) AGAINST('I love you') AS relevance
FROM poems
WHERE MATCH(title) AGAINST('I love you')
ORDER BY relevance DESC;
```

[![Fulltext search with relevance in MySQL]({{ site.baseurl }}/assets/2009/07/image_thumb1.png "Fulltext search with relevance in MySQL")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image1.png)

You are also able to create fulltext indexes covering multiple columns;

```
# Fulltext index on multiple columns
CREATE FULLTEXT INDEX idx_ft_title_poem ON poems (title, poem);

SELECT *, MATCH(title, poem) AGAINST('Come live') AS relevance
FROM poems
WHERE MATCH(title, poem) AGAINST('come live')
ORDER BY relevance DESC;
```

[![MySQL fulltext search over multiple columns]({{ site.baseurl }}/assets/2009/07/image_thumb2.png "MySQL fulltext search over multiple columns")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image2.png)

We’ve just scratched the surface here so be sure to checkout the documentation for more of what [MySQL fulltext search](http://dev.mysql.com/doc/refman/5.1/en/fulltext-search.html) can do.

