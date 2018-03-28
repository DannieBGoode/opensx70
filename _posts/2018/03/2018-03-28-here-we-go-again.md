---
show_avatar: true
layout: post
date: '2018-06-03 28:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin
categories: opensx70
read_time: 4
comments: 'true'
published: true
show_related_posts: 'true'
title: Here we go again!
feature_image: SX70_images/openSX70-cameraporn-5
permalink: /posts/2018/03/here-we-go-again
description: Up to date on the openSX70
---
#{% include video id="MU2MqRjvjZs" provider="youtube" class="full"%}
I have a new board and camera prototype #2. This is my pre-production board since I intent to do a mini manufacturing run at SeeedFusion PCBA. This new board is more or less the same as Aladdin with a few cosmetic changes and an ICSP header. 

![Fire image]({{site.url}}/{{site.baseurl}}img/about/20180318_Lens_and_Bellows_assembled_PCB_600DPI.jpg)

Now I normally use the FTDI USB connection to program the camera. But to do that I neew to have the bootloader on the Atmega328p chip. Since I am hand-building the boards I can easily do that with an adapter.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/2018-03-28-here-we-go-again-05.jpg)

But since I am going to do a small manufacture run at SeeedFusion of ten boards, I need another method of programming the chip ONCE it is on the board. Here comes in place the ICSP.

The ICSP needs a "proper" progammer to program the chip but I didn't want to put more connectors on the boards. 
My ICSP header is not to solder the pins but to use an adapter I have made with pogo pins (they have a spring and compress). I build this into a regular clothes pin.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/2018-03-28-here-we-go-again-01.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/2018-03-28-here-we-go-again-02.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/2018-03-28-here-we-go-again-03.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/2018-03-28-here-we-go-again-04.jpg)

I have build prototype #2 out of an alpha camera with a hand build "Len's & Bellows" PCB and everything seems to work fine.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/2018-03-28-here-we-go-again-05.jpg)

So today I ordered ten professionally manufactured boards from SeeedFusion. I will have them in 25 days aproximately. 

I will hand-build a few UDs (Ugly Dongles) for the field tests.

Since I have never ever had a PCB board manufactured and assembled, this is going to be a long wait.



