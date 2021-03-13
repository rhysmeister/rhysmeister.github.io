---
layout: post
title: Scripting out database objects with PHP
date: 2010-04-25 15:22:44.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- DBA
- MySQL
tags:
- MySQL
meta:
  tweetbackscheck: '1613207355'
  shorturls: a:4:{s:9:"permalink";s:77:"http://www.youdidwhatwithtsql.com/scripting-out-database-objects-with-php/755";s:7:"tinyurl";s:26:"http://tinyurl.com/27msnth";s:4:"isgd";s:18:"http://is.gd/bHiUk";s:5:"bitly";s:20:"http://bit.ly/bQvQ9X";}
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/scripting-out-database-objects-with-php/755/"
---
I've recently needed to script out the create sql for various MySQL database objects. No [Powershell](http://en.wikipedia.org/wiki/Windows_PowerShell) or [SMO](http://msdn.microsoft.com/en-us/library/ms162169.aspx) to help with this so I've quickly rolled a [PHP](http://php.net) script to get this done.

```

```

This will script out all tables, views, triggers, stored procedures and functions from the specified database. One file per object in your /tmp directory (you'll need to change this if you're running on Windows). Just change the $source\_host, $source\_db, $source\_user and $source\_pwd variables to point at the database you want to script out.

```
<?php // set source and connection variables
$source_host = "localhost";
$source_db = "xxxx";
$source_user = "xxxx";
$source_pwd = "xxxx";

///////////////////////////////////////////////
// A few helper functions
///////////////////////////////////////////////
function getMySQLConnection($host, $database, $user, $pwd)
{
    $conn = mysql_connect($host, $user, $pwd) or die(mysql_error());
    mysql_select_db($database, $conn) or die(mysql_error());
    return $conn;
}

// returns a list of tables
function getTables($connection, $database)
{
    $tables = array();
    $result = mysql_query("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA = '".$database."'", $connection) or die(mysql_errno());
    while($row = mysql_fetch_row($result))
    {
        array_push($tables, $row[0]);
    }
    return $tables;
}

// returns a list of views
function getViews($connection, $database)
{
    $views = array();
    $result = mysql_query("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'VIEW' AND TABLE_SCHEMA = '".$database."'", $connection) or die(mysql_errno());
    while($row = mysql_fetch_row($result))
    {
        array_push($views, $row[0]);
    }
    return $views;
}

// returns a list of procs & functions
function getRoutines($connection, $database)
{
    $routines = array();
    $result = mysql_query("SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE TABLE_SCHEMA = '".$database."'", $connection) or die(mysql_errno());
    while($row = mysql_fetch_row($result))
    {
        array_push($routines, $row[0]);
    }
    return $routines;
}

// returns a list of triggers
function getTriggers($connection, $database)
{
    $triggers = array();
    $result = mysql_query("SELECT TRIGGER_NAME FROM INFORMATION_SCHEMA.TRIGGERS WHERE TABLE_SCHEMA = '".$database."'", $connection) or die(mysql_errno());
    while($row = mysql_fetch_row($triggers))
    {
        array_push($triggers, $row[0]);
    }
    return $triggers;
}

// writes text files
function writeTextFile($contents, $filename)
{
    $writer = fopen($filename, 'w') or die("Unable to open file");
    fwrite($writer, $contents);
    fclose($writer);
}

// Gets the sql used to create table
function getTableCreate($connection, $table)
{
    $sql = "SHOW CREATE TABLE `".$table."`";
    $result = mysql_query($sql, $connection) or die(mysql_error());
    $row = mysql_fetch_row($result);
    return $row[1];
}

// returns the sql used to create a routine
function getRoutineCreate($connection, $routine)
{
    $sql = "SHOW CREATE PROCEDURE `".$routine."`";
    $result = mysql_query($sql, $connection) or die(mysql_error());
    $row = mysql_fetch_row($result);
    return $row[1];
}

// returns the sql used to create a trigger
function getTriggerCreate($connection, $trigger)
{
    $sql = "SHOW CREATE TRIGGER `".$trigger."`";
    $result = mysql_query($sql, $connection) or die(mysql_error());
    $row = mysql_fetch_row($result);
    return $row[1];
}

/////////////////////////////////////////////////////////
// EOF FUNCTIONS
/////////////////////////////////////////////////////////

$source_connection = getMySQLConnection($source_host, $source_db, $source_user, $source_pwd);

$tables = getTables($source_connection, $source_db);

// Get the create sql for each table
// writing each one to a text file
foreach ($tables as $table)
{
    $create_sql = getTableCreate($source_connection, $table);
    $filename = "/tmp/".$table.".sql";
    writeTextFile($create_sql, $filename);
    echo "Generated create table sql for ".$table."\n";
}

$views = getViews($source_connection, $source_db);

// Create the sql for each view
foreach($views as $view)
{
    $create_sql = getTableCreate($source_connection, $view);
    $filename = "/tmp/".$view.".sql";
    writeTextFile($create_sql, $filename);
    echo "Generated create view sql for ".$view."\n";
}

$routines = getRoutines($source_connection, $source_db);

// get the create sql for each routine
foreach($routines as $routine)
{
    $create_sql = getRoutineCreate($source_connection, $routine);
    $filename = "/tmp/".$routine.".sql";
    writeTextFile($create_sql, $filename);
    echo "Generated create routine sql for ".$routine."\n";
}

$triggers = getTriggers($source_connection, $source_db);

// get the create sql for each trigger
foreach($triggers as $trigger)
{
    $create_sql = getTriggerCreate($source_connection, $trigger);
    $filename = "/tmp/trg_".$trigger.".sql";
    writeTextFile($create_sql, $filename);
    echo "Generated create trigger sql for ".$trigger."\n";
}

?>
```

![run_php_create_sql_script.gif]({{ site.baseurl }}/assets/2010/04/run_php_create_sql_script.gif)  
 ![sql_files.gif]({{ site.baseurl }}/assets/2010/04/sql_files.gif)  
 ![generated_sql_for_store_table.gif]({{ site.baseurl }}/assets/2010/04/generated_sql_for_store_table.gif)

