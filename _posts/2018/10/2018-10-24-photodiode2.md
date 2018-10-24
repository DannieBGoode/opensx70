---
show_avatar: true
layout: post
date: '2018-10-24 10:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin2
categories: openSX70
read_time: 6
comments: 'true'
published: true
show_related_posts: 'true'
title: My lightmeter struggle
feature_image: SX70_images/openSX70-cameraporn-5
permalink: /posts/2018/09/post
description: Working on implementing the best auto mode for any SX70 camera
---
![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/light-meter-tests-08.jpg)

Most of you know my "struggle" so to speak with the light meter on the openSX70 camera.
I chose to use the so-to-speak [advanced BH1750](https://opensx70.com/posts/2018/02/aladdin-lightmeter-demo), it as a very small chip that gives me via an i2C bus the value of light it "sees".
I had a bunch of problems with that, to mention a few, I misplaced it on the PCB, not exactly where the light "window" is, the chip has a .5mm pitch and is a bitch to hand solder for the prototypes, an when I manufactured a few board with [SeeedFusion service](https://www.seeedstudio.io/prototype-pcb-assembly.html?gclid=Cj0KCQjwsMDeBRDMARIsAKrOP7EcVVMIP6kW2ImJX65pji9F4KchNQ1wog94thQ8FvV0CL3aWyXcdY4aAr5_EALw_wcB) they basically placed the sensor upside-down.
But when all this was well, I still noticed two things: that the light reading were "faint" so to speak, that is because there is so much "stuff" in front of it, all the light dark filters, the lollypop lens, etc... and secondly and more crucial, the sensor for my purposes is too slow (yes, yes, milliseconds-range slow, but, slow).

So I started the [quest for a new sensor](https://opensx70.com/posts/2018/10/photodiode). This time I was looking for something that was totally analog, in the sense that gave me a value, relative to the amount of light, that was fast, but above all, I wanted something that had the sensor area of aproximately the same size as the one on the SX70 camera.
And then I did what I usually do: buy a bunch of stuff that I don't usually need, to run tests. So here you can see the bags from Mouser:

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/light-meter-tests-09.jpg)

These are a bunch of photodiodes, from Osram and Vishay, 
[BPW 34-S-Z](https://media.osram.info/media/resource/hires/osram-dam-2495869/BPW%2034%20S%20E9601.pdf), 
[SFH2440](https://www.mouser.com/ds/2/311/SFH%202440-920876.pdf), 
[VBP104SR](https://www.vishay.com/docs/81170/vbp104sr.pdf), 
[SFH2430](https://www.osram.com/media/resource/hires/osram-dam-2496025/SFH%202430.pdf).

In an interesting turn of events, I was reading [Edwin H. Land's Essays—Volune I](https://www.amazon.com/Edwin-H-Lands-Essays-Set/dp/0892081708) and in an article by Dr. Land about one-step photography I found this:
 
*"In available light photography the system operates in the integrating mode, using as light sensor a
tiny photodiode. The surface area of the photodiode is less than .006 in.2 (4 mmz), and it generates extremely
small currents (1042 to 10'9 amp). During exposure, light sensed by the photodiode generates a current
which charges a capacitor to a predetermined level. When the capacitor reaches that level it discharges and
its circuit instructs the solenoid to close the shutter blades, thus terminating the exposure. If the light level
is too low to charge the capacitor sufficiently, the shutter is closed automatically after approximately 20 sec."*

I was blown away...

So I wanted to run the tests (quite franly, yet not very scientific) so I made it so I placed the photodiode (in this case SFH2430) in an discarded openSX70 PCB.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/light-meter-tests-04.jpg)

I wanted to make sure that the placement was spot-on, so I made a template, here you can see the template on top of an original PCB and the setup under.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/light-meter-tests-02.jpg)

The template on top of the original.

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/light-meter-tests-03.jpg)

Close-up of the original photodiode!

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/light-meter-tests-05.jpg)

Detail of the test jig before mounting on the camera.

First I started with a Sekonic photography light meter,

![Fire image]({{site.url}}/{{site.baseurl}}img/2018/10/light-meter-tests-06.jpg)

But soon realized that I needed an professional, so to speak, light meter that gave me a value in lux, fortunately I had one that was gifted to me from my friend Leo.

So now I have started to do some "systematic" tests.

<iframe width="1372" height="600" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vRnNIiVsXyOoSa0Ry48K5Z2HXiGQFoCyWRNSfykkjGQKLSZFSFCm9xF4py3Boj9-oWJKaxFYEu9C3l6/pubchart?oid=562815799&amp;format=interactive"></iframe>
The dotted lines are the meassurements "outside" the camera, the thick lines are the readings from the camera, and the thin lines are "projections". 
I made meassurements with different resistors: 1M, 470K, 330K, 100K and 10K. 
Turns out that depending on the value of the resistor you use, you get sensitivity in low-light or when there is a lot of light, like in sunlight, like EV17 and such.

What I have to do now, is run some test with the other photodiodes, also try to come with a more "stable" jig, so the meassurements are more consistent when in-camera (the only ones important for my research). Maybe by setting up a white light box and the camera inside...
Up until now I was just moving a lamp on top of both the light meter and the camera assembly. Not very scientific, singularly at close distances there is a parallax problem.
I think that readings in camera should be as "lineal" and nice as the ones outside of camera... will keep you posted.

So, what does this all mean? first of all I feel confident to design and manufacture a new layout of the PCB with the light sensor and the resistors, even thought I have not decided which one I will use or the specific value of the resistors. 
All of them have the same form factor and package (and also sensor area, very, very close to the original).

I feel also happy, that I have "connected" (in a way) with the original electronics that I admire.

This also means that I have a few "only-manual" PCBs here (Pathfinder and Lens and Bellows), so I decided to give away one to a lucky person. I will make a random draw among the website subscribers in november. 
All you have to do is comment this post (here in the website, not in the FB group) indicating why you feel you can use the kit NOW, the model camera you have (has to be a non-sonar Alpha or Alpha model 2), 
your [soldering skills](https://youtu.be/3Fl2U9cJ5ew) and, of course your express willingness to sacrifice your precious camera! (Bear in mind that I might not be able to give you support on the build, that you are on your own). Also the kit if your the exclusive use of the winner and cannot be sold.

This will also give me assurances that at least someone reads my posts! 
Also if you subscribe you will be able to participate in surveys I might do in the future to shape the project.

I will also be sending a few of the extra boards to people that I wish they test the system, or that have asked me for it. I have already sent a few kits with more or less luck, to Julien at [Brooklyn Film Cameras](http://www.brooklynfilmcamera.com/cameras/), Matt Widmann of [2ndShotSX70 service](http://2ndshotsx70.blogspot.com/), Kendar Chen of [Rezivot](https://www.rezivot.com/) and of course to Marco from [AnalogThings](https://opensx70.com/posts/2018/09/live-build).

If you are interested in reviewing the openSX70 camera/project as it is now, you think you can help the project expand and propagate, please contact me opensx70 at openSX70 dot com and we can arrange something. 
Please all keep in mind that at this moment in time the project is almost a one man orchestra, and that I have limited resources. Also no product is on sale at this moment, so if you would like to purchase one please be patient.


