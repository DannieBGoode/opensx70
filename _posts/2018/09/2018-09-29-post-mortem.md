---
show_avatar: true
layout: post
date: '2018-09-29 10:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin
categories: openSX70
read_time: 6
comments: 'true'
published: true
show_related_posts: 'true'
title: Duyen's Model 2 post mortem
feature_image: SX70_images/openSX70-cameraporn-5
permalink: /posts/2018/09/post-mortem
description: Whatever happenned to Duyen's Model 2 SX70?
---

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/09/20180929-Duyen-04.jpg)

Earlier in the summer I figured I try to upgrade not an Alpha, but an earlier Model 2 SX70 camera. Some of you know that this camera is an evolution of the original, but not quite an Alpha.


![Fire image]({{site.url}}/{{site.baseurl}}img/2018/09/20180929-Duyen-03.jpg)


So I had this camera labeled with DYMO (I love it) that probably used to belong to a dude named DUYEN.

As far as I know it does not have tripod hole or fixture for the strap, but it already has focusing scale, it also have flex cable and not the wires as the originally. I don't know if it does fill-in flash as the Alphas or not. But for me the main difference is in the substrate ECM (the original PCB). In there Solenoid#1 has four wires instead of 2 as the alphas. The repair manual identifies these two extra pins as S4 being S1A and S1B. 

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/09/20180929-Duyen-02.jpg)

It is important to know that the creators of the original circuit had a lot of trouble with noise and power peaks, actually there was a battle between Fairchild Semiconductor and Texas Instruments for the designed and the implementation of the circuit (read ["The battle for the SX70", by Tekla S. Perry IEEE Spectrum, May 1989](https://ieeexplore.ieee.org/document/30763) and ["Behind the lens of the SX-70" by Geral Lapidus IEEE Spectrum December 1973](https://dl.acm.org/citation.cfm?id=2241330&picked=prox&preflayout=flat), both really interesting articles)

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/09/20180929-Duyen-07.jpg)

They had to squeeze more than 400 transistors in the small ECM and that was a feat in 1973!

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/09/20180929-Duyen-06.jpg)

So they figured that they needed a lot of power to move the solenoid initially ("high power"), but once in place they could go to "low power" mode, and save resources, and elude noise. 
My theory is that the solenoid did itself the switch (by means of a resistor) and that in later Alphas they just wait a bit and went electronically to low power, and that is why the mecanically simpler Alphas had just a connection for the coil of the solenoid.

So I though, simple! just don't use S4 and simply connect the coil of the solenoid. 

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/09/20180929-Duyen-01.jpg)

And that basically I did, but not very cleanly, it was a mess, the main pins from the solenoid have like a T shape and they short-circuited with the flyback protection diode... then S4 was not really well protected, so when I powered the camera it went in smoke!! OUCH!!

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/09/20180929-Duyen-05.jpg)

You can see the mess. So now I have fixed and cleaned it up: the camera seems to work. Motor works, shutter works but it is a bit sluggish.

I don't know if I have to program "high power" in a different way, or remain (if I can afford it) all the time in high power. But of course, it could be that being an old camera, I have to remove and clean the blades (I wish I knew how, HELP!!!).

That is a problem that I have when something goes wrong (whatever): Have I done something wrong in my design? or simply is the camera broken...


{% include video id="cJJe4Ods" provider="youtube" class="full"%}


So talking about S4 brings me to the idea of a sort of "universal" PCB that would work with (most) SX70 (well I have not seen cameras with more that 7 lines), but I would to use S4, have S2 in all the different places I have seen, and, of course, incorporate the sonar header:

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/09/20180929-Duyen-08.jpg)

So next I want to experiment with a sonar camera, see how the sonar integrates (it looks like a "black box" add-on), I am specially curious about the pin in the sonar flex cable labelled "GTD" that I think it is a signal from the Sonar sub-system, telling the camera it ready to shoot. I figured it means something like "Gone The Distance" but of course I don't know that and it is pure speculation on my part. If you know what it means or have some sort of information about the sonar SX70 or GTD please contact me.

Finally I would like to move the LED to the place it sits on the sonar ECM (and that can be seen in the VF) so I can make better use of it.

I want to make a plea, for someone/anyone that has any kind of technical information, repair manual, schematics or whatever: I am willing to pay for it, trade it for a openSX70 "kit". I can keep it to myself or share publicly. Even if it is a document already public, if you have a "cleaner" or original version please contact me (I just want a good scan). I am also looking in information on original SX70 tools, or just pictures of original tools so I can try do build my own. SO PLEASE PLEASE CONTACT ME (IF YOU DON'T DO IT FOR ME, DO IT FOR DUYEN)!

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/09/20180929-Duyen-09.JPG) 

Do you see the LED????

#openSX70 #SX70 #press #Polaroid #PolaroidOriginals #OriginalPolaroids #Arduino #DIY #FilmIsNotDead #InstantPhotography #ImpossibleProject #Analog #TIP #cameraHacks #manualSX70 #SX70 #SeedStudio #SeedStudioFusion #SeedStudioPCBA #EagleCAD #Sonar #Duyen #model2 #SX70model2 #postmortem

