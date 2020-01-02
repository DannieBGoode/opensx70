---
show_avatar: true
layout: post
date: '2019-12-31 10:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin2
categories: openSX70
read_time: 5
comments: 'true'
published: true
show_related_posts: 'true'
title: 2019 Roundup and new year’s resolutions
feature_image: SX70_images/openSX70-cameraporn-15
permalink: /posts/2019/12/resolutions
description: 2019 roundup and new year’s resolutions
---
## zero

![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/michael-postcard1.jpg)

An unexpected Xmas card has appeared in my mailbox from Poland! It is really nice, thank you Michał for your support of the project!
![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/michael-postcard2.jpg)

## one

As I have [mentioned in a post](https://opensx70.com/posts/2019/01/jig) I love the original SX70-specific tools, and I am looking for a set, if you have one Iam willing to buy it from you. Please let me know.
But I also want to design my own custom tools. One of my favorite side projects is the “test jig” which is initially a breakout board to quickly test all kinds of sx70 pcbs.
Now thanks to Hannes, aka Optoflow, I am closer to archiving this.He has designed this beauty that I hope to be able to test soon and that looks incredible on the renders.
Teamwork.
![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/optoflow-gig-1.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/optoflow-gig-2.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/optoflow-gig-3.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/optoflow-gig-4.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/optoflow-gig-5.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/optoflow-gig-6.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/optoflow-gig-8.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/optoflow-gig-9.jpg)

## two

AnalogueWorks has delivered the document that I can use to design an set of electronics that fit in his beautiful design. It’s going to be a origami-type ensemble with two pcbs, a mother pcb, probably 1mm thick with all SMD components, including the main components such as the DS2408 and the optocoupler, and the PC flash socket in the form of 2.5mm jack. And a slot. Where the daughter card, vertical flash bar connector and the LED and switches. All through hole parts. As I have said before, choosing the parts is very important, and in this case we want reliable switches and components that are not going to become obsolete within a reasonable amount of time.
Since I have a beautiful 3D printed prototype of the new design, once I have the PCBs I will be (hopefully)be able to assemble the first working AnalogueWorks dongle.

![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/Ensamblaje1 EXPLODED x Joaquin.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/Ensamblaje1 EXPLODED x Joaquin2.jpg)

I hope to place the order with PCBWAY before the Chinese new year. Thank you PCBWAY for your support.

![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/dongle-V.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/dongle-H.jpg)

## three

Thanks to Jayce that has graciously sent me two prisms from sonar viewfinder Santi is trying to replicate by doing a silicone mold. This by no means high priority, but I feel that the information on the viewfinder would be nice. [Made a great effort to locate the DUAL LED on the PCB as close as possible to the location on the sonar PCBs](https://opensx70.com/posts/2018/11/led-story). 
Being such a small part it is yet to be seen if its possible, but, if someone can do it is him. Watch this space. 

![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/jayce-decker.jpg)

## four

The sonar schematic. Part of my effort is understanding the original camera how it worked. We understand that most of the chips are ASICs, that is, custom logic components design for the specific purpose. Initially there was a race between Fairchild camera (part of Fairchild Semiconductor) and Texas Instruments. In the end TI won as explained in “The battle for the SX-70 electronics”. In “Behind the lens of the sx-70” is explained the different modules, the flash control, the motor control, the light sensor and integration, and the main module. It would be nice to find replacement parts for say the MCC motor controller and maybe some day reverse engineer the actual chips, maybe, just maybe the plastic can be stripped and the silicone photographed... or do some hardware emulation with an FPGA. Long term stuff...
I am intrigued by the interaction between the red button switches S1F and S1T with the FFA mysterious FT pad... maybe the FFA inhibits picture taking when it detects a flashbar and no “good” bulbs to prevent from wasting a film unit...

![Fire image]({{site.url}}/{{site.baseurl}}img/2019/12/sonar-schematic_raw.jpg)

## five

I will probably manufacture also a few of the new Erwin pcbs and maybe some sonars. Have to decide if I do TSL237T and TCS3200 as well. That with the boards to test the new dongle... and then some.

## NEW YEAR RESOLUTIONS

The top priority for the future is the AnalogueWorks dongle, once the electronics are working building a few prototypes and start seriously testing with real photographers in the real world. I hope to design the pcbs in such a way that an all-metal CNCd enclosure is a possibility, as Dr. Land said, if something is worth doing, it is worth doing in excess...

My main resolution is improving the Arduino code...

We will also have to think about setting up a business structure, and getting hold on some cash to fund the project. This is a no-compromise project and things have to be done right: we will have nothing but the best.

Finally as I always say if you want to get hold on an openSX70 kit or camera, hang in there and don’t ask... BUT if you want to help with the project let me know with a concrete proposal of what you can do or how you can help. And a BIG thank you to all helping in different fashions the project. I really appreciate it!
