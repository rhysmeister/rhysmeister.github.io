---
layout: post
title: Compiling Hadoop example MaxTemperature.java
date: 2013-01-27 14:22:17.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Big Data
tags:
- Hadoop
meta:
  shorturls: a:3:{s:9:"permalink";s:83:"http://www.youdidwhatwithtsql.com/compiling-hadoop-example-maxtemperature-java/1534";s:7:"tinyurl";s:26:"http://tinyurl.com/b84a3zl";s:4:"isgd";s:19:"http://is.gd/pbHQty";}
  tweetbackscheck: '1613462004'
  twittercomments: a:0:{}
  tweetcount: '0'
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/compiling-hadoop-example-maxtemperature-java/1534/"
---
I'm working through some of the examples in this [Hadoop book](http://hadoopbook.com/). I'm a little rusty on compiling java programs and had a little trouble with this one so I'm documenting it here for anyone else how might be having issues.

Firstly, I tried compiling the examples like this;

```
javac MaxTemperature.java
```

That wasn't too successful;

```
MaxTemperature.java:3: error: package org.apache.hadoop.fs does not exist
import org.apache.hadoop.fs.Path;
                           ^
MaxTemperature.java:4: error: package org.apache.hadoop.io does not exist
import org.apache.hadoop.io.IntWritable;
                           ^
MaxTemperature.java:5: error: package org.apache.hadoop.io does not exist
import org.apache.hadoop.io.Text;
                           ^
MaxTemperature.java:6: error: package org.apache.hadoop.mapreduce does not exist
import org.apache.hadoop.mapreduce.Job;
                                  ^
MaxTemperature.java:7: error: package org.apache.hadoop.mapreduce.lib.input does not exist
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
                                            ^
MaxTemperature.java:8: error: package org.apache.hadoop.mapreduce.lib.output does not exist
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
                                             ^
MaxTemperature.java:18: error: cannot find symbol
    Job job = new Job();
    ^
  symbol: class Job
  location: class MaxTemperature
MaxTemperature.java:18: error: cannot find symbol
    Job job = new Job();
                  ^
  symbol: class Job
  location: class MaxTemperature
MaxTemperature.java:22: error: cannot find symbol
    FileInputFormat.addInputPath(job, new Path(args[0]));
                                          ^
  symbol: class Path
  location: class MaxTemperature
MaxTemperature.java:22: error: cannot find symbol
    FileInputFormat.addInputPath(job, new Path(args[0]));
    ^
  symbol: variable FileInputFormat
  location: class MaxTemperature
MaxTemperature.java:23: error: cannot find symbol
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
                                            ^
  symbol: class Path
  location: class MaxTemperature
MaxTemperature.java:23: error: cannot find symbol
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    ^
  symbol: variable FileOutputFormat
  location: class MaxTemperature
MaxTemperature.java:28: error: cannot find symbol
    job.setOutputKeyClass(Text.class);
                          ^
  symbol: class Text
  location: class MaxTemperature
MaxTemperature.java:29: error: cannot find symbol
    job.setOutputValueClass(IntWritable.class);
                            ^
  symbol: class IntWritable
  location: class MaxTemperature
14 errors
```

After a little messing about I found the correct procedure. When executing these commands you must be in the MaxTemperature project directory. First compile the MaxTemperatureMapper.java file. The classpath should contain the path to the hadoop-core-1.0.4.jar file.

```
javac -verbose -classpath /home/rhys/hadoop-1.0.4/hadoop-core-1.0.4.jar MaxTemperatureMapper.java
```

Next we can compile the MaxTemperature.java file. This time the classpath contain the path to the hadoop-core-1.0.4.jar file as well as the MaxTemperatire project directory where we compiled MaxTemperatureMapper.java

```
javac -classpath /home/rhys/hadoop-1.0.4/hadoop-core-1.0.4.jar:/home/rhys/Downloads/hadoop-book-master/ch02/src/main/java  MaxTemperature.java
```

That should compile, if so we can then run the job with the provided sample data;

```
hadoop MaxTemperature ../../../../input/ncdc/sample.txt output
```

You should see output similar to below;

```
13/01/27 15:08:16 INFO util.NativeCodeLoader: Loaded the native-hadoop library
13/01/27 15:08:16 WARN mapred.JobClient: Use GenericOptionsParser for parsing the arguments. Applications should implement Tool for the same.
13/01/27 15:08:16 WARN mapred.JobClient: No job jar file set.  User classes may not be found. See JobConf(Class) or JobConf#setJar(String).
13/01/27 15:08:16 INFO input.FileInputFormat: Total input paths to process : 1
13/01/27 15:08:16 WARN snappy.LoadSnappy: Snappy native library not loaded
13/01/27 15:08:17 INFO mapred.JobClient: Running job: job_local_0001
13/01/27 15:08:18 INFO util.ProcessTree: setsid exited with exit code 0
13/01/27 15:08:18 INFO mapred.Task:  Using ResourceCalculatorPlugin : org.apache.hadoop.util.LinuxResourceCalculatorPlugin@71780051
13/01/27 15:08:18 INFO mapred.MapTask: io.sort.mb = 100
13/01/27 15:08:19 INFO mapred.JobClient:  map 0% reduce 0%
13/01/27 15:08:20 INFO mapred.MapTask: data buffer = 79691776/99614720
13/01/27 15:08:20 INFO mapred.MapTask: record buffer = 262144/327680
13/01/27 15:08:20 INFO mapred.MapTask: Starting flush of map output
13/01/27 15:08:20 INFO mapred.MapTask: Finished spill 0
13/01/27 15:08:20 INFO mapred.Task: Task:attempt_local_0001_m_000000_0 is done. And is in the process of commiting
13/01/27 15:08:21 INFO mapred.LocalJobRunner:
13/01/27 15:08:21 INFO mapred.Task: Task 'attempt_local_0001_m_000000_0' done.
13/01/27 15:08:21 INFO mapred.Task:  Using ResourceCalculatorPlugin : org.apache.hadoop.util.LinuxResourceCalculatorPlugin@114f6322
13/01/27 15:08:21 INFO mapred.LocalJobRunner:
13/01/27 15:08:21 INFO mapred.Merger: Merging 1 sorted segments
13/01/27 15:08:21 INFO mapred.Merger: Down to the last merge-pass, with 1 segments left of total size: 57 bytes
13/01/27 15:08:21 INFO mapred.LocalJobRunner:
13/01/27 15:08:21 INFO mapred.Task: Task:attempt_local_0001_r_000000_0 is done. And is in the process of commiting
13/01/27 15:08:21 INFO mapred.LocalJobRunner:
13/01/27 15:08:21 INFO mapred.Task: Task attempt_local_0001_r_000000_0 is allowed to commit now
13/01/27 15:08:21 INFO output.FileOutputCommitter: Saved output of task 'attempt_local_0001_r_000000_0' to output
13/01/27 15:08:22 INFO mapred.JobClient:  map 100% reduce 0%
13/01/27 15:08:24 INFO mapred.LocalJobRunner: reduce > reduce
13/01/27 15:08:24 INFO mapred.Task: Task 'attempt_local_0001_r_000000_0' done.
13/01/27 15:08:25 INFO mapred.JobClient:  map 100% reduce 100%
13/01/27 15:08:25 INFO mapred.JobClient: Job complete: job_local_0001
13/01/27 15:08:25 INFO mapred.JobClient: Counters: 20
13/01/27 15:08:25 INFO mapred.JobClient:   File Output Format Counters
13/01/27 15:08:25 INFO mapred.JobClient:     Bytes Written=29
13/01/27 15:08:25 INFO mapred.JobClient:   FileSystemCounters
13/01/27 15:08:25 INFO mapred.JobClient:     FILE_BYTES_READ=1493
13/01/27 15:08:25 INFO mapred.JobClient:     FILE_BYTES_WRITTEN=63627
13/01/27 15:08:25 INFO mapred.JobClient:   File Input Format Counters
13/01/27 15:08:25 INFO mapred.JobClient:     Bytes Read=529
13/01/27 15:08:25 INFO mapred.JobClient:   Map-Reduce Framework
13/01/27 15:08:25 INFO mapred.JobClient:     Reduce input groups=2
13/01/27 15:08:25 INFO mapred.JobClient:     Map output materialized bytes=61
13/01/27 15:08:25 INFO mapred.JobClient:     Combine output records=0
13/01/27 15:08:25 INFO mapred.JobClient:     Map input records=5
13/01/27 15:08:25 INFO mapred.JobClient:     Reduce shuffle bytes=0
13/01/27 15:08:25 INFO mapred.JobClient:     Physical memory (bytes) snapshot=0
13/01/27 15:08:25 INFO mapred.JobClient:     Reduce output records=2
13/01/27 15:08:25 INFO mapred.JobClient:     Spilled Records=10
13/01/27 15:08:25 INFO mapred.JobClient:     Map output bytes=45
13/01/27 15:08:25 INFO mapred.JobClient:     CPU time spent (ms)=0
13/01/27 15:08:25 INFO mapred.JobClient:     Total committed heap usage (bytes)=230694912
13/01/27 15:08:25 INFO mapred.JobClient:     Virtual memory (bytes) snapshot=0
13/01/27 15:08:25 INFO mapred.JobClient:     Combine input records=0
13/01/27 15:08:25 INFO mapred.JobClient:     Map output records=5
13/01/27 15:08:25 INFO mapred.JobClient:     SPLIT_RAW_BYTES=131
13/01/27 15:08:25 INFO mapred.JobClient:     Reduce input records=5
```
