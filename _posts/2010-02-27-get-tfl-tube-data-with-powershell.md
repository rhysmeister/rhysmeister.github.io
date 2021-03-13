---
layout: post
title: Get TFL Tube data with Powershell
date: 2010-02-27 19:18:24.000000000 +01:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Data
- Powershell
tags:
- Data
- data.gov.uk
- London Datastore
- Powershell
meta:
  tweetbackscheck: '1613443886'
  tweetcount: '0'
  twittercomments: a:0:{}
  shorturls: a:4:{s:9:"permalink";s:71:"http://www.youdidwhatwithtsql.com/get-tfl-tube-data-with-powershell/689";s:7:"tinyurl";s:26:"http://tinyurl.com/yz6vd8x";s:4:"isgd";s:18:"http://is.gd/9kINZ";s:5:"bitly";s:20:"http://bit.ly/b1HS4w";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/get-tfl-tube-data-with-powershell/689/"
---
The [London Datastore](http://data.london.gov.uk/) has loads of datasets available that we can use for free. One of the datasets available is a list of [TFL Station Locations](http://data.london.gov.uk/datastore/package/tfl-station-locations). The station location feed is a geo-coded KML feed of most of London Underground, DLR and London Overground stations. Here's [Powershell](http://www.microsoft.com/windowsserver2003/technologies/management/powershell/default.mspx) script that will extract this data from a url and write it to a pipe-delimited file ready for import into the database of your choice.

```
$xml = New-Object XML
$url = "http://www.tfl.gov.uk/tfl/syndication/feeds/stations.kml"
$csvFile = "$env:UserProfile\Desktop\tfl_tubes.csv";

# Empty file if it already exists
Set-Content -Path $csvFile $null;
# Add headers to file
Add-Content -Path $csvFile "Station|Address|Coordinates";

# Load the xml
$xml.Load($url);
$stations = $xml.kml.Document.Placemark;

foreach($station in $stations)
{
	$name = $station.name;
	$description = $station.description;
	$coordinates = $station.Point.coordinates
	# This data needs cleaning a bit
	$name = $name.Trim();
	$description = $description.Trim();
	$coordinates = $coordinates.Trim();
	# Ad line to the csv file
	Add-Content -Path $csvFile "$name|$description|$coordinates";
}
```

After running the script check your desktop for a file called **tfl\_tubes.csv** which should look something like below.

[![TFL Station Locations csv data file]({{ site.baseurl }}/assets/2010/02/tfl_tubes_thumb.png "TFL Station Locations csv data file")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2010/02/tfl_tubes.png)

