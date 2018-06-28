---
show_avatar: true
layout: post
date: '2018-03-03 22:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin
categories: openSX70
read_time: 5
comments: 'true'
published: true
show_related_posts: 'true'
title: Aladdin ready to fly!
feature_image: SX70_images/openSX70-cameraporn-2
permalink: /posts/2018/02/aladdin-demo
description: 'ALADDIN CAMERA'
---
{% include video id="K0BoFDWtoEE" provider="youtube" class="full"%}

I have finally built what I think is a working camera. In the video you can see the programming/debugging flat cable and the dongle. I also have a quick and dirty cheat sheet. Please note that the values in ms don’t really mean anything since there’s an initial delay that I don’t take into account. In this video I test different speeds, I do a multiple exposures shot, and a long press for a timer delay. Note that the led is increasingly blinking, you can see also dark slide ejection and red led when the pack is empty.
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/aladdin-camera-01.jpg)

Please note that through the USB adapter you can program and debug as any Arduino board (328P 2.8V 8mhz).
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/aladdin-camera-02.jpg)

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/aladdin-camera-03.jpg)

Before I insert film I would like to write in the EEPROM memory (permanent) all the information from the light meter as to have information for the auto exposure feature.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/aladdin-camera-04.jpg)
