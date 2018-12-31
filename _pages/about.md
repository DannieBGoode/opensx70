---
layout: page
title: About
permalink: /about/
feature_image: openSX70-about-banner2
published: true
---
## About the project (constantly updated): quick up-to-date

In early 2017 I created the openSX70 closed group in Facebook.

![Fire image]({{site.url}}/{{site.baseurl}}img/about/opensx70-early-prototype.jpg)

I wanted to replace the Apollo-era PCB "brain" on the [SX70 Polaroid camera](https://en.wikipedia.org/wiki/Polaroid_SX-70) with a modern Arduino-based easy to program PCB.
That would allow to add "manual control" to the camera and many more cool things.

[Here](https://github.com/openSX70/Press/raw/master/openSX70%20press%20release%20(2018).pdf) is the FAQ/official press release pdf. [All press materials in Github](https://github.com/openSX70/Press).

![Fire image]({{site.url}}/{{site.baseurl}}img/about/openSX70-camera-about.jpg)

It was not something that had not being done before, at least two commercial projects existed. But nothing existed as open source and arduino-based.

The project is open source for non commercial uses, under Creative Commons "[Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/)" is free and open for hobbyist NON-COMMERCIAL USE.


My plan was that, it would create a "community effect" and that many people would volunteer to help, sharing their skills. 
Specially electronics, and coding. It has not really happened (yet!).

So I got all the Repair Manuals I could find on the camera, trying to understand how it works. Fortunately it is quite simple: a couple of switches mechanically activated, a motor, and two solenoids.

{% include video id="wtaUpBm4dGA" provider="youtube" class="full"%}
(basic camera operation in slow motion controlled by arduino)

So from there I tried, using of the shelf components and arduino boards to "make" a camera. That first camera I knicknamed FrankenSX70

{% include video id="fh34zWHXtr0" provider="youtube" class="full"%}
(simple shutter test)

![Fire image]({{site.url}}/{{site.baseurl}}img/about/FrankenSX70_camera.jpg)


With that camera I was able to take my first picture & double exposures!
![Fire image]({{site.url}}/{{site.baseurl}}img/about/FrankenSX70-pics-01.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/about/FrankenSX70-pics-03.jpg)


So I figured I could design the board myself (How hard can it be?) So I started with the great [Fritzing software](http://fritzing.org/home/)

![Fire image]({{site.url}}/{{site.baseurl}}img/about/Fritzing_openSX70.jpg)
The openSX70 pcb as a work-in-progress in Fritzing.


But then I found out that the professional [EAGLE CAD](https://www.autodesk.com/products/eagle/free-download) could be used free so a switch to it and kept with design. 
Keep in mind that I had never used EAGLE nor design a PCB, also that the openSX70 was not a simple "my first board design":

- custon outline that had to exactly fit in the camera

- SMD components (where do I start?)

- Very limited real state

For me, the initial openSX70 design would be a two part thing. 
The "main" PCB inside the camera. And the "control" dongle that you connected through the camera flash socket.
The flash was a challenge: the way it was originally design to use the flashbars only three cables ran straigt from the PCB to the socket.
So I had to:

- be able to operate flashbars and electronic flash

- control de "manual" options of the camera

- fire an external flash via a PC-compatible socket

- have a information LED

![Fire image]({{site.url}}/{{site.baseurl}}img/about/openSX70-dongle-protoboard.jpg)
(Dongle prototype)


![Fire image]({{site.url}}/{{site.baseurl}}img/about/openSX70-dongle-early-PCB.jpg)
(early dongle PCB)

[GitHub repository](https://github.com/openSX70/openSX70-dongle-PCB)


The central part of the project is the main SX70 PCB.

![Fire image]({{site.url}}/{{site.baseurl}}img/about/openSX70-board-evolution.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/20180318_Lens_and_Bellows_PCB-01.jpg)

**[GitHub repository](https://github.com/openSX70/openSX70-PCB)**

As of today the red main PCB "chocolate" is working although with some flaws.
First I ran "Blink" to test the board as an arduino.

{% include video id="W_ey8Kvrcyg" provider="youtube" class="full"%}

Then I tested the full camera operation
{% include video id="Ncl8JmikNtM" provider="youtube" class="full"%}


The board has both an "optinal" piezzo buzzer and a BH1750 light meter:

{% include video id="UIXy1mgVUgY" provider="youtube" class="full"%}

I started with a 3.3V regulator, to run the Atmega328p, initially at 16Mhz, then at 8mhz. Finally I run at 2.5V.
The next generation board "Aladdin" and "Aladdin-FPC" are on the way this will hope will allow me to finally make my first working openSX70 camera!
[Aladin Gerber file](https://jlcpcb.com/quote/gerberview/384a1219-f09c-47bd-b12d-b0953c882ebe_1_0_2.html)

Full test of the Aladdin board:

{% include video id="8JmWiM2eW5M" provider="youtube" class="full"%}

The Aladdin Prototype #1 camera tests:

{% include video id="Musl6fOJ3OI" provider="youtube" class="full"%}

The new pre-industrial production 5.2 "Len's and Bellow's" PCB fully assembled prototype ready camera Prototype #2:

![Fire image]({{site.url}}/{{site.baseurl}}img/about/20180318_Lens_and_Bellows_assembled_PCB_600DPI.jpg)

After a mishap with the SEEEDFUSION PCBA service where they placed the BH1750 upside down I got a coupon from them to rebuild the boards. Nevertheless I have build a prototype (3.5) and it seems to work ok. Now I have designed a new board "Pathfinder". I have corrected a few errors that I had detected in "Len's & Bellows" particularly the BH1750 placement.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/05/opensx70-pathfinder-02.jpg)

The second try of the PCBA service from SeeedStudio was also a disaster, they replaced the mosfet for a part that did not work properly on the camera. Thankfully they refunded us.

The latest PCB design codenamed ALPHA uses a totally new component as a light sensor, the Osram SFH2430 photodiode. This will hopefully allow us to build the first openSX70 camera with AUTO exposure mode. 

As an easter egg it has a dual led placed in a location that makes it visible in a sonar viewfinder.

In early 2019 a beta program was started.


## About openSX70 website!
This intends to be your home for all things SX70 and the home of all sorts of modifications and hacks on the SX70, but more specifically the home of the openSX70 project.

It doesn't have to be all technical mumbo-jumbo, you can post about your new skin, your new accessory or how you use your camera to take better pictures...
What is allowed/not allowed in the group?
Of course we don't want spam, but we welcome ads and news about products if they mean an improvement on the SX70, say a new skin, a modification on a camera, an accessory vintage or new for the camera.
We welcome input from our members. Anything constructive is appreciated.
You can post your with/of SX70 photos if they have relation with a hack, mod or improvement, or made by a special camera, say with manual option.
On my part I wish that people with different skills collaborate to improve our projects.
I want to mention a few projects that I have in mind, the openSX70 camera (also setting up the openSX70.com page), the SX70-600 film conversions, and switches, making/reproducing old tools at affordable prices for members, creating improving the original repair manuals...
But I want to make clear two things: it is not at all about my personal projects, and that we support and admire all similar commercial or non-commercial  projects. We feel that what is good for the SX70 is good for all of us, so please share.
If you think you can help, please post, if you have a hack or a tip, please post, if you know how to repair a certain fault, please post.
Please note that I am not an SX70 repairman and probably don't know how to fix your camera aside from the obvious, I am neither a programmer nor know much of electronics aside from the basic stuff. But I definitely try.
So please, please, share your projects and contribute with your skills. And remember:
It is not what your Polaroid can do for you as for what YOU can do for your Polaroid!

As a legal reminder please note that the code and files is under Creative Commons "Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)" is free and open for hobbyist NON-COMMERCIAL USE.

[https://creativecommons.org/licenses/by-nc/4.0/](https://creativecommons.org/licenses/by-nc/4.0/)
