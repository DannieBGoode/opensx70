---
show_avatar: true
layout: post
date: '2018-08-28 10:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin
categories: openSX70
read_time: 9
comments: 'true'
published: true
show_related_posts: 'true'
title: Prototype#7 & Seeed!
feature_image: SX70_images/openSX70-cameraporn-5
permalink: /posts/2018/08/prototype7	
description: SeeedStudio does it again.
---
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/open_SX70-PCBA_Mosfet-05.jpg)

So finally I have prototype#7 working!!

When I had the new PCBs from SeedStudioFusion, I tested all that I could test before assembling the camera: and it worked.

Then I assumed all was good. BIG MISTAKE!

As the saying goes, fool me once shame on you, fool me twice shame on me! Well... not exactly, turns out that the first time they f---ed up they gave a generous coupon, so this time the PCBs were almost free.

But still.
  
I mean I have already sent two boards to people, I was so eager to share them... What are they going to think? 

I build prototype#7 out of a beautiful chrome Alpha SX70, when tested it and the shutter fails of course I assumed that the 50 year old camera was to blame. Even thought I had tested the basic operation of the candidate camera... I might have missed something. 

So I go to Menorca thinking it is me or the camera to blame! Prototype#7 was on the back of my mind...

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/open_SX70-PCBA_Mosfet-04.jpg)

So first thing I do on returning is troubleshoot prototype#7. I power solenoid#1 directly with 5.8V from the lab power supply: works perfectly: so by now I am begining to think that there is nothing wrong with the camera. 

Next I should replace the mosFET chip in the PCB by the specified one.

I had indicated in the BOM file (Bill of Materials) that the mosFET apropriate for the solenoids (both) is [AO3404](http://www.aosmd.com/pdfs/datasheet/AO3404.pdf). Nothing fancy really.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/open_SX70-PCBA_Mosfet-01.jpg)

I remembered that the last time Seeed had replaced that for another one, it was different and I didn't like it was bigger but it worked: (x4NX 11)

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/open_SX70-PCBA_Mosfet-02.jpg)

So I wrote them a note with my order:

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/open_SX70-PCBA_Mosfet-06.jpg)

But they replaced the mosFET for a different one: X4RX 13

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/open_SX70-PCBA_Mosfet-03.jpg)

And it seems this mosFET is not optimal (so to speak) for the SX70.

They sent me a mail with questions about some components and their placement and I had a good feeling this time, but not really.

By the way, I have only replaced the mosFET for solenoid#1, so I wonder if flash will work correctly or I should also replace the mosFET for solenoid#2. I probably should!

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/open_SX70-PCBA_Mosfet-07.jpg)

I am not going to say what I think (!!!!!), let only be known that it shouldn't be so difficult to manufacture a PCB. In fact I have also manufactured the much simpler FTDI boards and they seem to work perfectly!

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/open_SX70-PCBA_Mosfet-08.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/open_SX70-PCBA_Mosfet-09.jpg)


Now that I have complained to them, lets see what they have to say.

#openSX70 #SX70 #press #Polaroid #PolaroidOriginals #OriginalPolaroids #Arduino #DIY #FilmIsNotDead #InstantPhotography #ImpossibleProject #Analog #TIP #cameraHacks #manualSX70 #SX70 #SeedStudio #SeedStudioFusion #SeedStudioPCBA #EagleCAD #Fantasia

