---
show_avatar: true
layout: post
date: '2018-11-08 14:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin2
categories: openSX70
read_time: 5
comments: 'true'
published: true
show_related_posts: 'true'
title: New Alpha PCBs and more
feature_image: SX70_images/openSX70-cameraporn-13
permalink: /posts/2018/11/alpha
description: making new PCBs, codename Alpha, and much more
---
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/11/2018-11-08-new-pcbs-1.jpg)

I have ordered a bunch of new PCBs. The most important one is the new main PCB nicknamed "Alpha", which is more or less the same as Pathfinder but with the new light sensor: a photodiode.

I am still [doing tests](https://opensx70.com/posts/2018/09/lightmeter-struggle) with the different photodiodes that I ordered. But since they all have the same shape and footprint, I have been able to manufacture the boards ahead of time.

There are a bunch of improvements, but all really minor. Perhaps the most important one is (aside the photodiode, that is) the new LED placement. Actually is a dual color 0603 LED. 
That LED is placed so that (hopefully) it will be visible on the VF with one of the VF assemblies that have the prism (used for low light indication in later sonars). I, of course can use it for that or for other purposes.
Also having two colors (maybe three?) I will probably be able to do some cool stuff.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/11/2018-11-08-new-pcbs-2.jpg)

I have also manufactured a new slightly different uDongle. With the [help of Clément](https://opensx70.com/posts/2018/10/dongle1) I have done a more case-friendly design. 
I have my reservations in the sense that it has more through hole components, not ideal for manufacturing, but I like that the switches are bigger.
It also has holes to fix to the case and a few other improvements.

I always say that have this crazy idea of replicating the original Polaroid tools. Well, this is not exactly that, but I thought it would be cool to have a jig to test the PCB, substrates, ECM or whatever you call them.
Not only openSX70 PCBs but also the original ones.

I have done this board, still an early prototype:

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/11/2018-11-08-new-pcbs-4.jpg)

The idea is to use pogo-pins to build [something like this](https://hackernoon.com/take-your-pogo-jig-to-the-next-level-c016b483d6fc). We will see what happens.

The final notable PCB that I have order I don't have much faith. It is basically an all-in one to at least test the idea of [Marco](https://www.youtube.com/channel/UC_1Wc6fdIxr3wctK2bDTLkw). That I call it the Marcongle.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/about-a-dongle-01.jpg)
This is Marcos idea and drawing.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/11/2018-11-08-new-pcbs-3.jpg)
This is the PCB.

It is a circuit that has both the USB adaptor and the dongle in one. The best part is that you don't have to "use" the flash connector, as everything "goes" on the same FPC cable. That relies on a modification of the main PCB (ergo, IF it works it will only be compatible with "Alpha" PCBs).

I don't like it (not the concept but this implementation) because it is bigger that my "target size" of 20mm x 45mm. But it's just a test.

So hopefully early next week I receive from guys from [JLCPCB](https://jlcpcb.com/) all this goodies. Will keep you posted.

