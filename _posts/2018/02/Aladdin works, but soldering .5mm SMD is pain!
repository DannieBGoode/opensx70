---
show_avatar: true
layout: post
date: '2018-02-02 12:06 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin
categories: opensx70
read_time: 5
comments: 'true'
published: true
show_related_posts: 'true'
title: "Aladdin" works, but soldering SMD is a pain !!!
description: The new "Aladdin" PCBs Blink, but trouble soldering the components.
feature_image: SX70_images/openSX70-cameraporn-2
permalink: /posts/2018/01/aladdin-works
---
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/02/aladdin-blink-01.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/02/aladdin-blink-02.jpg)

So I finally got the time to start testing Aladdin. 

Soldering the FPC is **A ROYAL PAIN** I could do it (sort of) on my second trial. But then I couldn't solder the light meter cheap.
The conclusion is that .5mm pitch SMD electronic components are not at a human scale.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/02/aladdin-blink-03.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/02/aladdin-blink-04.jpg)

My adapter to program to the Atmega with the custom 2.8V/8Mhz bootloader was a total success. 
That is needed because the Minipro programmer only supports the 28-pin DIP Atmegas328p, and my adapter was a TQFP "universal" pin-to-pin adapter.
So I made a board to map the 32-pin Atmega to the 28-pin DIP Atmega.

So finally I tested with Blink, and, after double-checking the FPC connector it loaded and worked!!

{% include video id="h3YENcGoehY" provider="youtube" class="full"%} 

Here is the complete board with the cable, and the FTDI. 

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/02/aladdin-blink-05.jpg)

When I build the openSX70, while testing and debugging the software the FPC will show through the camera, so I can easily connect the FTDI and upload some new software.

Finally I have been able to re-work the dongle to include the regulator to bring the power down to 2.8V as previously reported. It is not nice, but I hope it works!

I hope tomorrow I can do much more software and hardware tests.


