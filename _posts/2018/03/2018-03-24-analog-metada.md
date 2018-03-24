---
show_avatar: true
layout: post
date: '2018-03-24 10:30 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin
categories: opensx70
read_time: 5
comments: 'true'
published: true
show_related_posts: 'true'
title: Analog Metadata
feature_image: SX70_images/openSX70-cameraporn-13
permalink: /posts/2018/03/analog-metadata
description: 'Analog Metadata, the new Arduino Software'
---
{% include video id="Musl6fOJ3OI" provider="youtube" class="full"%}

I have been working both on the hardware (will post later) and on the software. In the video I test the "functions" of the openSX70 camera. Please bear in mind that all is configurable, and, if you don't like the LED blinking so much you can turn it off...
I test different (while connected to the Arduino console on the macbook) shutter speeds, mirror delay, B and T use, multiple exposures, timer delay, and then dumping the info.

The "reason" for storing this "analog metadata" is to gather information to implement the auto function. This way I can know the (real) lightmeter (well, I'll have to write this by hand) and the internal lightmeter value. So I can correlate somehow.

Bear with me because the video is a bit long (2'13'').

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/prototype-one-04.JPG)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/prototype-one-01.JPG)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/prototype-one-02.JPG)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/03/prototype-one-03.JPG)
