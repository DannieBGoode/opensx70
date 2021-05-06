---
show_avatar: true
layout: post
date: '2021-05-05 10:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin2
categories: openSX70
read_time: 8
comments: 'true'
published: true
show_related_posts: 'true'
title: Crack that code
feature_image: SX70_images/openSX70-cameraporn-22
permalink: /posts/2021/05/code
description: Matt Widmann's serial number article.
---
Note: this is a "reprint" of the blog entry posted by the legendary [Matt Widmann on November 11th 2017](http://2ndshotsx70.blogspot.com/2017/11/crack-that-manufacturing-code-math-time.html). I have Matts express permision to repost this.

But please keep in mind that we have already cracked the code for you. I have a [serial number calculator on my website](https://opensx70.com/calculator/). This is an ongoing project that will be continually improved. 
If you have any information about this or, for that matter, anything concerning SX70, please contact me.

Here's the post:

Crack That Code - Math Time!

I suck at math so I went to art school... That wasn't the only reason but it was right up there on my top 10 list. With that said, I've found I do need to use simple arithmetic on a daily basis in most cases but my way of dealing with numbers is very primitive and sloppy. So this is a disclaimer for the math wizards that there is most likely an easier way of coming up with some of the numbers I'll be explaining below. Feel free to chime in with any comments but be ever so gentle.

There have been several SX70 serial number calculators offered online in the past to help decipher the numbers you find on your SX70/SLR680 cameras. Unfortunately I don't think any of them work anymore (broken links?) but luckily the info needed to manually calculate the information is readily available in the original Polaroid SX70 repair manual that I reconstructed below. I was very surprised to find that it's very easy to unscramble the numbers using the chart. All you need are your numbers and if you suck at math like me, a calculator.

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/SN_chart.jpg)
 
This chart only covers Model 1,2,3, Alpha 1, A1M2, Sears Special, and SE cameras. I have a few numbers on what to look for to identify later Sonar and SLR680 models but chances are, if you're holding the camera in your hand, you already know what model you have. The big payoff here is finding out when your camera was born...
 

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/SN_image.jpg)

First, look for your manufacturing code. While facing your camera, you'll find it's located underneath the upper camera back lip, just above the film door latch. It's commonly stamped with silver lettering but oftentimes the silver is worn off and you'll need a torch light to read the stamping. If you don't see a serial number in this location, open the film door and look for a heat stamped number melted into the chassis edge. If you find a serial number in this location, you've got a grandaddy camera. :) You might see an ink stamp on the shutter frame too... that's the shutter frame ID number, not the serial number.


![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/IMG_20171111_150726.jpg)
##### First gen manufacturing code location... Gramps

Ok, I'm going to use a customer's Model 1 as an example. There are commonly 11 characters designated for the manufacturing code. On most typical Model 1s, the serial number starts with a letter and only has 10 characters. If this is the case on yours, simply add a "0" in front of the letter. So the manufacturing code on this customer's camera is 0F416094273.
![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/IMG_20171111_144726.jpg)

The numbers to pay attention to here are the first four and last two. The five numbers in between are the actual serial. So this camera's serial number is 60942.
 
So using the chart, you can solve the first four numbers. The first number is the configuration or I think simply the type of shutter the camera uses. I admit I have no idea why some of these shutters are called what they are in the chart but I'd be able to identify the part differences by doing a visual inspection. Remember that often times other parts were used and replaced during repairs.
 
The first number (not stamped so it's designated as "0") tells us this camera has a "hybrid" shutter (still researching what that actually defines).
 
"F" tells us the month. A=January, B=February, C=March etc. It's important to note that the letter "I" is excluded most likely to avoid confusion when the numbers are read. So in this case, the camera was manufactured in June.
 
The number after the letter is the year. So this was manufactured in 1974,
 
Then after the year is the model number. As I mentioned before, if you're physically holding the camera in your hands, chances are you already know what model it is. This is indeed a Model 1.
 
Ok, here's where the math comes in and as I mentioned, there's probably an easier way to find the numbers. The last two digits designate the shift code and aren't the actual date of manufacture. You need to use a mathematical formula (crap) to decipher the day the camera was manufactured and what shift it was when the camera rolled off the assembly line.

Here's a quick formula I use is to solve for y (the actual date). z can only be either 0 (C shift), 1 (B Shift), or 2 (A Shift).

                                 73 + z
								 
                              -----------  = y (must be a whole number)
							  
                                 3

I usually work backwards and see if 73 + 0, 1, or 2 is divisible by three resulting in a whole number. Only one of the numbers will be and that's your date! So here, the camera was manufactured on the 24th day on the A Shift.

##### **This camera is a Model 1 with the "hybrid" shutter configuration. The serial number is 60942 and it was manufactured on June 25th 1974 during the A-Shift.**
 
I need to towel off after that. As I mentioned earlier, this is easy for cameras up to a certain date. But what about Sonar and SLR680 cameras? Ok... here's where I might be guessing on some numbers so please use this as a guide only. Once you know the general periods of manufacturing, finding the dates should be easy for other models. Especially when you get into the 80s.
Model 1, 2 , and 3 were manufactured from 1972 to 1976

Alpha 1s (including A1M2s and variants) were manufactured from 1976 to 1978

Sonar cameras (including variants) were manufactured from 1978-1981/2

SLR680s were manufactured from 1982-1989

Typically, Sonar Onesteps have a configuration number of "5" (first digit) and "4" for the model number (fourth digit). If you have a Sonar model with the year number designated as 0, 1, or 2, we already know the Sonar models weren't released until the late 70s so these numbers show the camera was manufactured in 1980, 81, or 82. Here's a random customer camera with the numbers 5M847021458. Imma break it down (my Eazy-E reference for the day)... 

 - "5" is the configuration

 - "M" is December

 - "8" is 1978

 - "4" is the model designation

 - "70241" is the serial number

 - "58" is the 20th day on the A Shift

All the numbers apply for SLR680s. All third digits will refer to the 1980s. I have an SLR680 in front of me with a manufacturing code of 8K522976691. 

The first number on 680s is commonly "8" but I've seen "7" as well. 

 - "K" is October. 

 - "5" is 1985. 

Here there's a "2" for the model number... this is where it can get confusing as on the traditional chart, 2 would indicate it's a Model 2 or a variant. I thought it might indicate that it's an SE but this isn't. Still investigating.

 - "29766" is the serial number

 - "91" is the 31st day on the A shift

The numbers apply for very early Model 1s as well. Pictured earlier above is my very own grandaddy SX70 with the manufacture code of FM2020475CC. I'm not entirely sure of the "F" being the first digit but I'm taking a huge guess that it might stand for "Fairchild" (Fairchild Semiconductor) or that it's the first generation shutter design. But the rest of the numbers work out properly... As for the "CC", I'm not really sure either.

 - "M" is December

 - "2" is 1972

 - "0" is Model 1

 - "204" is the serial number

 - "75" is the 25th day on the C Shift... Merry Christmas!!!
_______________________________
 
There are always exceptions to these numbers. Some numbers are handwritten... I'm thinking because they were either serviced or had a replacement part. Sometimes the number is removed completely due to repair or it simply fell off. There are even additional numbers added that could indicate refurbish and resell from Polaroid, etc. All the info above info is a guide. 
 
That's enough writing... If anyone cares to add any info regarding manufacturing codes, numbers, or any stuff like that, please feel free to drop me a line... I'll be drinking a beer. Happy Saturday! :)

Matt Widmann

ADDENDUM

I intend to improve and make my calculator as inclusive as possible.

I am analizing all the information I have, there are many variants, repair cameras, refurbished... So it's complicated, but we will get there.

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/image00190.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/Manual-new200.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/conversion_serial.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/alpha-serial.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/model3.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/6th-inhibit.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/6th-inhibit-2.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/9-4-1976.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/RIB-168.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/RIB-136-2.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2021/05/RIB-136-1.jpg)










