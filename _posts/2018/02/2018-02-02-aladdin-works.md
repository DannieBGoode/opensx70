---
show_avatar: true
layout: post
date: '2018-02-02 23:40 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin
categories: opensx70
read_time: 5
comments: 'true'
published: true
show_related_posts: 'true'
title: First tests with Aladdin!
feature_image: SX70_images/openSX70-cameraporn-5
permalink: /posts/2018/02/aladdin-works
description: '"Aladdin" works, but soldering SMD is a pain !!!'
---
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/02/aladdin-blink-1.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/02/aladdin-blink-2.jpg)

Finally got the time to start testing Aladdin. 

Soldering the FPC is **A ROYAL PAIN** I could do it (sort of) on my second trial. But then I couldn't solder the light meter cheap.
The conclusion is that .5mm pitch SMD electronic components are not at a human scale.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/02/aladdin-blink-3.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/02/aladdin-blink-4.jpg)

My adapter to program to the Atmega with the custom 2.8V/8Mhz bootloader was a total success. 
That is needed because the Minipro programmer only supports the 28-pin DIP Atmegas328p, and my adapter was a TQFP "universal" pin-to-pin adapter.
So I made a board to map the 32-pin Atmega to the 28-pin DIP Atmega.

As always I started by testing by uploading Blink, and, after double-checking the FPC connector it loaded and worked!!

{% include video id="h3YENcGoehY" provider="youtube" class="full"%} 

Here is the complete board with the cable, and the FTDI. 

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/02/aladdin-blink-5.jpg)

When I build the openSX70, while testing and debugging the software the FPC will show through the camera, so I can easily connect the FTDI and upload some new software.

Finally I have been able to re-work the dongle to include the regulator to bring the power down to 2.8V as previously reported. It is not nice, but I hope it works!

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/02/aladdin-blink-6.jpg)


I hope tomorrow I can do much more software and hardware tests.
