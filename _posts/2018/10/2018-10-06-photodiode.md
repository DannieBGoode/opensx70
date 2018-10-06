---
show_avatar: true
layout: post
date: '2018-10-06 10:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin
categories: openSX70
read_time: 6
comments: 'true'
published: true
show_related_posts: 'true'
title: Looking for a new light sensor
feature_image: SX70_images/openSX70-cameraporn-12
permalink: /posts/2018/10/photodiode
description: Making openSX70 camera automatic!
---
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/new-light-meter-osram.JPG)
From the very beginning I have been [stating all the characteristics](https://opensx70.com/FAQ/) that (reallistically) I would like the openSX70 SX70 camera to have. And yes, one of theres has always been "AUTO" mode, actually dongleless auto mode. That means that the camera would work as a "normal" SX70 but with a deep secret inside. Also, I suspect that a modern sensor would make this auto mode much better, and, of, course, it would be either 600 or 100 ISO.

Of course, that are not the only ones. There are a few more, but those are not realistic.

But unfortunately this goal (AUTO) has become quite hard to accomplish.
As many of you already know, I have been having a lot of trouble with the light sensor I installed in the camera. 
It was a BH1750, which is a very advance very good I2C light sensor. Problems I had started with the wrong placement in PCB to actually soldering it myself on the prototype (very very small). Also when doing a manufacturing run SeeedStudio Fusion actually put the component upside down, and that, is not good.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/BH1750-relocation-photodiode.jpg)


But the main problem has nothing to do with all of that. The main problems are actually two: first that because of the way the SX70 is build I get too little light and my readings are incosistent. Also because of the actual area where the sensor is (very very small) I get even less light. The second reason being that the chip is a bit slow. Perfect in other kind of applications but not in here that I need to know fast the amount of light.

So I needed something else, something faster, something simpler, and something with a much larger sensor to pick up light, something close to the original sensor.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/original-pcb-bottom.jpg)

So I have ordered a bunch of photodiodes from Mouser like [Vishay's VBPW34S](https://www2.mouser.com/datasheet/2/427/vbpw34s-244735.pdf) and will start to make tests as soon I get them and find the time. I also ordered some from Osram with the same package. 




They all have a large sensor, similar to SX70's orginal.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/new-light-meter-dimensions-OSRAM.jpg)
(Osram's dimmensions)

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/new-light-meter-dimensions.JPG)
(Vishay's dimmensions)

As a quick update, I am working in part two of my OpenSX70/Arduino for Dummies. I will try to explain in layman's words how **I understand** that the camera works. 
I am also seeking help in manufacturing the boards, maybe closer to home, don't know. I also think that I have found someone that can help/teach me, about the project, and electronics in general. I hope I can afford that.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/alpha-pcb.jpg)

Work is underway in the new (transitional) PCB that I have nicknamed "ALPHA" (layout 6 evolution of Pathfinder). 

That will have the new light sensor (the photodiode) if my tests are successful, and also will have an extra connection to the flat cable that goes to the USB adapter: 1-wire. That means that a dongle NOT CONNECTED to the flash would be a possibility (My I am getting ahead of myself, this is going to be a full in-depth review of all the possible dongle designs that are in progress).

I call it transitional just because I have this (crazy) goal of a universal PCB that works on early cameras up to sonars. BUT THAT IS A LONG WAY OFF, so don't ask. For the moment I only "officially" "support" Alphas non Sonar.

Finally "ALPHA" will probably have the possibility of placing a LED like it is placed in some sonars for low light indication. That way a "hybrid" camera (alpha but with the sonar VF) could be theorically made. So I can send turn it on and off from the Arduino code. Maybe a dual LED, say red and green.

As I always say, if you have any technical documentation or paper about the camera that I DON'T HAVE, or repair manual, or tool or whatever, I am willing to trade for goodies.
If you can help with my "AUTO" endevour please contact me.
I have been getting some mails of people asking for help, or for me to repair their camera, or thinking that the openSX70 PCB might be a fix for their camera: PLEASE DON'T DO THAT. If you have a broken camera, part or whatever, consider donating it to the project. I support all the expenses of the project and any help is greatly appreciated.




