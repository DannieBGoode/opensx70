---
show_avatar: true
layout: post
date: '2018-08-15 10:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin
categories: openSX70
read_time: 5
comments: 'true'
published: true
show_related_posts: 'true'
title: (Long) overdue update
feature_image: SX70_images/openSX70-cameraporn-7
permalink: /posts/2018/08/update
description: Spreading the openSX70 word and building community
---
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/openSX70-overdue-01.JPG)

This is a long overdue update.

First of all, the hard(ware) facts.

SeeedStudio made a 10-PCBs manufacturing run of the new “Pathfinder” layout v5.5. They look awesome and seen to be in perfect working conditions. I have still to make a camera based on this boards, but “Pathfinder” itself has already been tested on a hand built board and sits happily in prototype #6. 

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/openSX70-overdue-02.JPG)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/openSX70-overdue-03.JPG)

I have also designed (should I say copied) a new USB adapter (technically an  FTDI) based on [Sparkfun’s Basic Breakout 3.3V ](https://www.sparkfun.com/products/9873) but with the openSX70 FPC cable connector,and the components from [SeeedStudio OPL library] (https://www.seeedstudio.com/opl.html). As I always do, I have done a PCB run, then hand assembled a few prototypes. Works perfectly and it is way easier to build. Maybe the board could have been a tad smaller (By the way, this makes me think that **maybe** it is feasible to have the FTDI built-in in the main PCB? Where would you put the microUSB connector?)

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/openSX70-overdue-04.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/openSX70-overdue-05.jpg)
(the new FT232RL, there is a smaller version of the chip that would fit in the main PCB)
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/openSX70-overdue-06.JPG)
(the new and the old adapter, that was a pain to hand-build!)


So now I am waiting for the [SeeedStudio Fusion PCBA](https://www.seeedstudio.io/fusion_pcb.html?gclid=CjwKCAjw-8nbBRBnEiwAqWt1zb2orzd40EwAcPHtnMeq8YB7A6jVtEwk_yOW9iN8oRn-xeKNQSU8ORoCMJ8QAvD_BwE) boards to come from China, fingers crossed this time, although the circuit is simple enough and there should be no problems...

On the (electronic) hardware front I have been thinking the following. First that maybe the fancy BH1750 lightmeter is not the best choice for the project: I don't need proper Lux metering, in fact it is wasted altogether, all the filters and stuff make the reading relative. But besides that, it is too slow, and I have been removing the outer cover  filter to get more light. But that is just too much, I am going to ask Peter to help find a simpler and more practical and faster sensor. Maybe with a form factor similar to the original. My first directive is to be non-destructive... 

The second hardware idea is to put the LED in a similar position as in the Sonar substrates. That way, and hypotetically, a franken camera could be build with the sonar VF as have the LED "info" inside the VF. Just a though. Can't stop thinking about the new PCBs, never happy with what I got.

Second, on the "spread the word" front.

I have had mixed experiences. I have very few kits and I am giving (the ones I send) all away. They are hard to come by for now, since some of the parts I have to hand assemble and that sucks. Not the main PCBs but (up to now hopefully) the the FTDI USB adapter and of course the uDongle. I don't want to "manufacture" the uDongles because I feel they're something experimental and temporary. Some of you know that I want a "proper" dongle in a nice "age apropiate" enclosure. I feel it is a nice challenge to do and accessory that looks like, maybe, just maybe, could have been manufactured by Polaroid. That is of course very pretentious on my part, but hey.
But going back to the spread the word part, and having set that the kits are "expensive" and not only in the monetary way. I have sent a few kits to a few selected people. With different luck.
First I want to thank [Clemént Grojean](https://www.instagram.com/clementgrosjean/) for all he has done, organizing the ["Polaroid Festival"]("Polaroid Festival") in Paris, and setting that as a platform to launch the openSX70 project: it was awesome man. I only wished I could have attended personally and not through Skype.

I also want to thank Marco from AnalogThings, his on-going support to he project through his [YouTube channel](https://www.youtube.com/channel/UC_1Wc6fdIxr3wctK2bDTLkw) and also in [Discord](https://discordapp.com/channels/446176201552298028/451810250971152384""openSX70").. is greatly appreciated. I hope to do with him a "live" build of an openSX70 camera.

On the other hand I have sent kits (and a camera) to people that are too busy and have heard nothing since. I am sure they will appreciate when they find the time, like the awesome [Supersense](https://the.supersense.com/), that ran a great piece on the project. Unfortunately I sent them a kit and have never heard again from them, but of course they have the perfect "excuse" as it is [not easy to make packfilm again](https://the.supersense.com/blogs/news/tagged/savepackfilm). Thank you Doc, you have an admirer in me!

I also want to talk about [Matt Day}(http://www.mattdayphoto.com/) and [what has happend to him](https://www.gofundme.com/help-matt-day-and-family). If you don't have already donated please make it now. Fortunately he seems to be much better now. I have know him from his great [YouTube channel](https://www.youtube.com/channel/UCopwCE5bVtffQif8IFkbUuw) from which I have learned so much.

Finally my mublings, so to speak. When I started this crazy "thing" I run I was expecting something totally different, but what I have found is perhaps better than that I had hope for. Let me explain, and this is the awful truth, I know nothing of electronics. But I figured that if I "started" "something" smarter people than I would join me in figuring it all out. It has not happen, and don't get me wrong, I have met incredible very smart people, but have not been able to generate a "wave" effect. Maybe the "electronics" crowd doesn't care about SX70 and the photographer's crowd don't understand much about electronics (it figures!!). What I have found, is that I had it in me, at least trying to do it on my own. I can say that I have taught myself electronics, but with the little help (maybe a lot) from my friend Peter (he **knows** electronics and programming) I could do it. Yes, my first design PCBs were crap, but I kept on trying until something "acceptable" came along. Same with the software. I learned to use the awesome [EagleCAD](https://www.autodesk.com/products/eagle/free-download) (its free version is great!)
But at the end of the day I feel like Mickey in the [Sorcerer's apprentice from Fantasia](https://www.youtube.com/watch?v=Rrm8usaH0sM), up to my neck in water! Haha, who knows. Maybe it's just too much for me.
Some people might thing that I am in this for the "big bucks", believe me, I am not. I have spent a decent amount of change in the project, and don't regret it. In the begining I had two ideas, stuff I had in my "bucket list" so to speak: a Kickstarter and an open source project. I dismissed the K right away. I don't like it anymore. So there was the open project.
That was nice, it only worries that someone else might take advange of the openness so to speak, but in the end who cares. Yes I hope that there is a buck to be made I get my share, at least I break even, but at this moment in time for me is more important the "good vibe" I get, the wonderful people I have found along the way...

So what now? As I have said "customer support" is just not my thing. But again I can understand that some people would like to "play" with openSX70. I don't totally discard making DIY kits for "enthusiasts" even in this early phase (Pioneer kit??) but in the end I feel that the openSX70 has to be built by someone that knows what they are doing, that makes things easier for all of us, they are the wizzards, and they have the "secret knowledge". I intend to keep my pledge to be as affordable as possible, it all depends on how many PCBs  we manufacture, and it changes with quantity a **LOT**. But that is only the main PCB, then whoever fits them, fixes and cares of the cameras, should make a living as usual, and we should nurture these wonderful people. Maybe there is a bussiness model in the design of the Dongle? I don't know and I want to take it easy...

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/08/openSX70-overdue-07.jpg)


It feels alone here sometimes... but maybe, just maybe there will be amazing news soon... keep tuning to this channel!


#openSX70 #SX70 #press #Polaroid #PolaroidOriginals #OriginalPolaroids #Arduino #DIY #FilmIsNotDead #InstantPhotography #ImpossibleProject #Analog #TIP #cameraHacks #manualSX70 #SX70 #SeedStudio #SeedStudioFusion #SeedStudioPCBA #EagleCAD #Fantasia

