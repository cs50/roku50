ROKU50 Instructions and Walkthrough
http://www.roku.com/

First and foremost, please go to the Roku website and sign up as a developer. Next, download the Roku SDK if you would like to peruse their documentation and sample code. This guide is mainly for CS50 video.

Contents:
1. Intro
2. List of Directories
3. XML/Video Guide
4. Subtitles/Meta-Data Tags 
5. Details/Pictures
6. Installing
7. Conclusions

1. Intro

Roku streams channels to the TV, and this sample code makes a video player to stream CS50 lectures, seminars, and much more. This guide outlines how to modify the video output as well as other design components with Roku's videoplayer capabilities. 

2. List of Directories (skippable)

The roku50 folder contains the artwork, images, meta-data, source, and xml folders (artwork and images are redundant and can be the same folder - you just have to do the proper linking in the xml...but more on that later). There are also 3 other files; this README, the manifest file, and the Makefile. 

	Artwork/images contains any pictures/banner-related content you would like to have, including the video icon photos and the main app icon. 

	Meta-data contains php parsers and xml input files from the CDN. 

	Source contains all the brightScript files that compose the bulk of setting up the app itself. 

	The Makefile and the manifest file are for configuration. The ReadMe, in my opinion, is the most important file (jk). 

3. XML/Video Guide

Roku is very picky about how it handles videos. In this guide, the videos all live on CS50's limelight server, and the xml happens to live on my cloud account (cloud.cs50.net/~jessechen21/roku50). 

The the main xml file is called categories.xml. The overall structure is as follows; a big overarching category (in this case the year number) contains several category leafs. Each category leaf is interpreted as the sections of the navbar once you pick a year. Then the videos that appear underneath come directly from the feed attribute. 

In these nodes, one can alter the titles and descriptions relatively freely. The feed however must adhere to a particular xml format. The links in the category leafs must be xml files living on some server (in this example). 

Let's take a look at lectures_2011.xml. The format must be as follows (you can add attributes, as mentioned later);

<feed>
	<resultLength>#</resultLength>
	<endIndex>#</endIndex>
	<item>
	</item>
	<item>
	</item>
</feed>

Where each item is a different video. Each <item> must have the specific tags as interpreted in 
showFeed.brs in the source folder. Let's go there next. 

The two main files that handle the video are categoryFeed.brs and showFeed.brs. In categoryFeed.brs you have to change the conn.UrlPrefix and conn.UrlCategoryFeed to link to the categories.xml file on your server. Additionally you could potentially alter the contents of this file should you desire to change the layout of your categories.xml and thereby the layout of the video UI, but that is beyond the scope of this guide. 

ShowFeed.brs on the other hand deals mainly with the xml that you linked to with the "feed" attribute back in categories.xml (attribute of a categoryLeaf). We'll come back to this later for adding attributes of your choice to the video output, but for now let's take a closer look at the feed xml. 

The sample ones provided are all in the xml folder. In the item tag one can change the preview photo links. Then comes title, contentId, subtitleUrl, contentType, contentQuality, streamFormat, streamQuality, streamBitrate, streamUrl, synopsis, genre, and runtime. Change these as needed. The streamUrl is the link to the video itself that lives on your server and likely the most important part. 

4. Subtitles/Meta-Data Tags

Roku supports many additional attributes. If you're curious, look at their Component Reference in their SDK. This mainly involves adding the tag to the feed xml - for example, <subtitleUrl>http://mywebsite.com/myxmlfile.xml</subtitleUrl> and making the corresponding change in showFeed.brs. 

In showFeed.brs, to display the subtitles all we had to do was to initialize the string in the function init_show_feed_item() and then write a line in parse_show_feed to correctly grab it from the xml (many other examples there). 

5. Details/Pictures

The link for the cover photo for the app itself is located in the manifest file. Incidentally this is where you can change the title of the app and its subtitle. 

The big banner at the top after you enter the app can be set in appMain.brs. The place to link is at the bottom, in initTheme(). Here you can adjust features such as the background color (see documentation for other options).

Please note that the cover photo/banner have requirements for specific dimensions (see the documentation).

Previews for the photos are simply images living on your server that you linked to in the video xml files.The required dimensions aren't specified, but dimensions that I've found to work are 254x191 png image files. 

6. Installing

Make sure the format is the same as my folder. The Makefile should be similar (in here, you can change your AppName that is presumably used elsewhere. not important), and reusable. 

To install it to your roku device, first go to settings and find your IP address. 

Then in the command line navigate to your folder containing the Makefile, and execute "export ROKU_DEV_TARGET=my.ip.address.goes.here". Then execute "make" and "make install" in two steps. 

After a duration the app should appear. 

7. Conclusions

You can use my code to toy around with the Roku. It's very finnicky. It has been known to bite. 

Good luck!

-CS50 Staff 