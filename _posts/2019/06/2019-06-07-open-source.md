---
show_avatar: true
layout: post
date: '2019-06-07 10:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin2
categories: openSX70
read_time: 6
comments: 'true'
published: true
show_related_posts: 'true'
title: the "truth" about open source
feature_image: SX70_images/openSX70-cameraporn-2
permalink: /posts/2019/06/open-source
description: My opinion, the awful truth about open source
---

![Fire image]({{site.url}}/{{site.baseurl}}img/2019/06/PCB-led-location.jpg)

Here's my humble take about open source. Keep in mind that it's just my opinion.

These days open-source is too many times a *good vibe*, maybe a marketing strategy, it *looks* good.

For me it is much more: openSX70 has always been an open source project. In the beginning I was trying to kick start an elusive collaboration, later I just wanted to share in a "show and tell" sort of way.

There are [three pillars of open source](https://opensource.com/principles): transparency, participation and collaboration.

I think we can all agree that transparency has been accomplished, I have share all my failures and struggles.

Second participation. We got that too: many folks have commented and shared opinions. Amazing. Thank you.

Collaboration: that is definitively what I am struggling with: first of all, most people interested in the project are photographers. Stop. They don't have the skills to help. And when I have pressed for "photographic" technical questions, they shy away. 

Of course there are notable exceptions. Other times people want to help, but for whatever reason they don't have the time.

But every little helps. Help is not only pointing to me that my circuit lacks a bunch of capacitors (thank you [Dave!](https://www.instagram.com/davethewalker80/)). 
I remember I lent the camera to a photographer. [He took flash pictures, he made a video](https://opensx70.com/posts/2019/02/thomaszamolo). Really nice, and I appreciate. He didn't say anything or comment anything about the camera. But watching the video I could see that he was struggling, he was somehow "working against the camera".

Let me explain I came up with this feature of having a self-timer built in the camera. If you pressed the red button for a short period it would take a picture, but if you did a *long press* you ended up with a flashing led and a 10 seconds delay. Cool isn't it?

Well, not quite, the original camera just takes the picture if you do a long press, so many people *expected* the openSX70 camera to do that. AND THEY WHERE RIGHT.

So I fixed that. Now you have to do a quick double press to do the self-timer. Otherwise I pretend to operate as the original camera.
So the bottomline here is, that you don't have to be nice with me! I expect nothing but the truth, that is the way to help me.

And this is is the gist of the open-source thing, improving based on a collective experience: it is also a state of mind, it not a Chinese obscure microcontroller, it is your will to share and improve.

But there's also that "other" thing of course. On the one side I know that there is no rocket-science, that almost anyone can rip-off the idea, even if I didn't share the files. Really, they copy much more complex stuff. There is no really interest, no volume.

But many people measure success in dollars. I tried to protect myself against the obvious (someone manufacturing and selling my stuff) by using anon-commercial license. [https://creativecommons.org/licenses/by-nc/4.0/](https://creativecommons.org/licenses/by-nc/4.0/)

Having a *product* and selling stuff has always been a second thought for me, for me its been about the SX70, and the process to figure out how it all works. Maybe going back to the sources: networking with awesome people, being on the radar so to speak.
Franlkly, I would be happy just to pay my expenses, and believe me, **there are expenses**, power supplies, electronic components, manufacturing, testing... and **FILM** that **IS** expensive. And of course the test cameras. 
I keep buying and *killing* cameras. Think of, better, picture me, as [Sid](https://pixar.fandom.com/wiki/Sid_Phillips) the neighbor of Woody in [Toy Story](https://en.wikipedia.org/wiki/Toy_Story): *Oh, no, not Sid!*

And here I am, trying to set up the business end of things, in a cheap but professional maner. And **that** also takes time, and resources.

On the other hand I feel that many people want to test, to have a camera, and I think this has to be done right. I have decided that I will probably manufacture locally. At least the first batches.

For people wanting to build their own pcbs I keep saying what I have always said: the **project is not ready, it is still experimental crap**. Don't even think about it: it's not there yet.
If you are in Barcelona, you can come and pick up a set of blank pcbs. **I DON'T INTEND TO GIVE SUPPORT** to anyone trying to replicate what I do. 
Don't even ask what to do: I have enough to do with the web updates, designing the PCBs and improving the software.

I also want to say, as I always have said, no matter what, that I admire other commercial products that are basically considered the *gold standard*: I don't like to be compared, it is not fair. 
But that being said, I now feel confident enough to consider openSX70 moving towards being the new standard.

So all that being said, I feel I have to move to a commercial distribution of the openSX70 hardware with this considerations:

- There will always have to be a "reasonably cheap" [kit option for DIY](https://www.youtube.com/watch?v=3Fl2U9cJ5ew) sold by someone that can give SOME support (I do not recommend DIY on your SX70). You could also send your camera to be modified.

- There has to be a cool dongle, in the end the project is judged by the looks, so looks are very important.

- A *ready to use* complete camera: Can be modified early-special-edition, and then some, of course these will be manufactured by the best in the business. That is the *shrink-wrapped-nice-dongle-cool-leather-refurbed-fully-warrantied* camera. That, we hope, will be the best SX70 so far.

- It is my opinion *now* that manual exposure at high speeds is not maybe the best idea due to mechanical tolerances of the camera. I also consider the project as reasonable more reliable "spare" PCB.
 
 I feel this way everybody is happy, first and foremost my base of want-to-be-diy. I feel if you want to attempt this you are going to need some support (not by me!)
 The dongle is a must, it's what I want, it is the ticket to be considered a "big boy" but also it is a great opportunity to play with design, cooperate with [Santi Pladellorens from AnalogueWorks](https://analogueworks.wixsite.com/analogueworks) on a "designed in Barcelona" cool dongle.
 
 But keep in mind that there's so much more about an open-source project: 
 You can do minor tweaks without even knowing how to program, say, the shutter speeds, say the magic number, and many many things. 
 I want to make a post on how you can tweak minor stuff on the software very easily. And of course you can always make your own.
 Open source is not only the "shrink wrapped" project, there are many many small pieces that amount to a lot, the PCB dimensions, the footprint of many parts, the information about the camera's most intimate inner workings:
 You don't have to go down the rabbit hole that I went, but you can certainly take advantage of it!
 
 So now my priority is having *something* that not only works amazingly but looks awesome. Remember we were the first with a dongle-flash, with true fast manual speeds (I will write a post about that).
 
 And there's more coming in the future, definitely sonar, tests on having aperture (up to F.8). More dongle configurations and designs. Do a modern flexcable (maybe with dongle information). I-type stuff...
 
I am no *mad scientist* (thank you [Susan](https://www.instagram.com/themillineryguild/) & [Stan](https://www.instagram.com/stankieffer/)) but I am definitely **mad**, I mean, really, compulsively testing and trying to find out how stuff works, why it is like this, how to improve it being *true* to the camera and to Dr. Land.
I start to come up with a product, and sell it, *that* is only byproduct of my obssesion: mad is too nice a word, I am crazy.

 As always, if you want to chip-in, have some secret document that want to share, some tool, whatever SX70-related, please, please contact me at openSX70 at openSX70 dot com.

