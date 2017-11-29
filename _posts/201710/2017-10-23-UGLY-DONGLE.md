---
title: The Ugly Dongle Prototype
description: Status report of the OpenSX70 November 25th 2017
date: 2017-10-23T00:00:00.000Z
layout: post
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin
show_avatar: true
read_time: 34
feature_image: SX70_images/openSX70-cameraporn-2
show_related_posts: false
square_related: recommend-wolf
permalink: /posts/2017/10/post-20171023/
comments: true
categories: opensx70
published: true
---

I have managed to have a working prototype of the UPCD (ugly prototype control dongle). It connects to the camera via the flash socket yet the flash is usable when removed and exchanged for a flashbar or a MiNT flash.
The UPCD comprises a rotary selector of 16 (or 10) positions, two switches, one LED and a flash connector(its a 2.5 jack) that can easily be connected to a flash or studio flash. 

I was thinking aside from the usual B, T and usual speeds options (1sec, 1/15/, 1/30, 1/60, 1/125, 1/180, to have a “mirror position” in that position when you press the button the mirror comes down but doesn’t take the picture. You have to then choose a speed and press again. That way you could avoid vibrations in some situations. 

![Fire image]({{site.url}}/{{site.baseurl}}img/201710/DONGLE-A.jpeg)
![Fire image]({{site.url}}/{{site.baseurl}}img/201710/DONGLE-B.jpeg)

I was thinking also a PC-flash option for 1/30 and another for 1/60, but I don’t know if this is going to be necessary, maybe just for f.8. I could understand that sometimes you might want the shutter to open at smaller apertures as in normal SX70 photography and sometimes you want full f.8 no matter what.

Of the two-position switches one would be to choose between double/multiple exposure or normal operation and the other switch I have no idea and am open for suggestions.

I have implemented a 10 seconds timer delay by keeping the button pressed for a while. So there’s no need to use a switch for that.