---
show_avatar: true
layout: post
date: '2020-11-10 10:00 +0100'
author_name: Joaquín de Prada
author_url: /author/joaquin
author_avatar: joaquin2
categories: openSX70
read_time: 19
comments: 'true'
published: true
show_related_posts: 'true'
title: the SX70 unleashed
feature_image: SX70_images/openSX70-cameraporn-17
permalink: /posts/2020/11/pneumatics
description: Pneumatics in the SX70 shutter
---

![Fire image]({{site.url}}/{{site.baseurl}}img/2020/11/solenoid-patent.jpg)

This is sort of a technical question, no doubt, but also a philosophical one. But if you are curious or interested in the secrets of the SX-70 shutter, and how to "improve it" please bear with me.

## introduction

We have been discussing long about the [SX70 shutter](https://opensx70.com/posts/2018/11/sx70-shutter).
But to do a quick recap, the SX70 has no aperture per se, the shutter IS the aperture, so there is only maximum aperture, specially at fast speeds.

![Fire image]({{site.url}}/{{site.baseurl}}img/2020/11/introduction-to-the-system-ambient-flash.jpg)

So when talk about F.8, that only means that the maximum aperture that can be accomplished is that. But in reality aperture doesn't exist, we can say that EV17 is 1/180 (maximum speed) at f.22, but that is just a way we have to understand and predict the exposure of the camera.


Ok. But there's always been the question about the shutter speed, when some products claim to do 1/2000. The answer is NO, but then, I have been asking myself, is it possible to make the shutter work faster?

So I had this plan to replace the spring, which I had not very scientifically measured to be 20gr with a stronger, since the main problem is opening. Closing the shutter is, by design, much faster.

![Fire image]({{site.url}}/{{site.baseurl}}img/2020/11/solenoid1-spring-english.jpg) 

## the patent
 
But then I found Patent [US 3868712](https://patents.google.com/patent/US3868712A/en?oq=US+3868712)

*Ideally, therefore, apertures selected at such higher f/stop values as may be practically available, while corresponding shutter speed is selected as fast as possible in view of the lighting conditions and desired aperture setting. For the most part, the exposure programs compromise or draw a balance between achieving large depth of field throught the use of small relative apertures and in selecting appropriate exposure interval times.*

*By simultaneously combining the effects of this spring bias with a pneumatically derived retardation of the plunger element of a solenoid during such aperture defining movement, a desirably programmed and controlled definition of aperture values for given levels of scene brightness is achieved. The pneumatic damping technique of the invention enjoys the further advantage of being readily factory calibrated as well as providing for the enhancement of the closing characteristics of the noted form of exposure control mechanism.*

*plunger (...) is pneumatically retarded in correspondence with the size of gap*

*Note that the lapsed interval of opening has been selectively elongated to about 25 milliseconds. Where flap valve 156 is provided in conjunction with control over the clearance of gap 152, curves as at 174 may be developed wherein about a 35 millisecond total elapsed interval of opening may be derived. Note, therefore, that with the pneumatic control over the operation of plunger 80 within solenoid 70 more precise exposure regulation is provided.*

![Fire image]({{site.url}}/{{site.baseurl}}img/2020/11/Fig-6-patent.jpg)

*Curve 170 provides a nominal representation in which flap valve 156 is not present and orifice 154 is permitted to vent chamber 150.*

*Curve 172 reveals the effect of closing down the clearance provided by gap 152 a select amount. Note that the lapsed interval of opening has been selectively elongated to about 25 milliseconds.*

*curves as at 174 may be developed wherein about a 35 millisecond total elapsed interval of opening may be derived*

## the pneumatic

So think of a syringe, if you block the hole its almost impossible to pull it. Same here, the Polaroid engineers devised a system so that they could calibrate the opening (and also at the same time closing) so they could set it to the right sweetspot. So they had room to wiggle.

Repair Information Bulletin #231A even specifies that they had a special cover to be able to access the needle. 

![Fire image]({{site.url}}/{{site.baseurl}}img/2020/11/RIB231A.jpg)

So I devised a system turning (counterclockwise) in 180º steps the way a specify this is by incremental numbers, being negative in case of counterclockwise, and every half turn is a unit, so for example a full revolution counterclockwise would P=-2, I made different videos with the HFR 1000FPS mode in my RX100 V camera.

<iframe src="https://player.vimeo.com/video/479771662" width="640" height="330" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
<p><a href="https://vimeo.com/479771662">66ms_Alpha_C0011_T</a> from <a href="https://vimeo.com/user2146483">Joaquin de Prada</a> on <a href="https://vimeo.com">Vimeo</a>.</p>
First a sort of benchmark, an older video with an older prototype.

Now my totally unscientific tests with prototype XXI. Keep in mind that I feel that at "normal" setting, I feel that is running a bit slow. But for comparison, I guess it illustrates what can be accomplished.

<iframe src="https://player.vimeo.com/video/472039950" width="640" height="444" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe> normal pneumatic
<iframe src="https://player.vimeo.com/video/472040298" width="640" height="430" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe> pneumatic set at P=-3
The difference is obvious.

It basically plateaus earlier, so it remains more time at full f.8, and overall exposure time should be less.

![Fire image]({{site.url}}/{{site.baseurl}}img/2020/11/aperture-time.jpg)

My totally made-up red line.

## conclusions

The main conclusion is simple. The shutter can go significantly much faster just by turning the needle counterclockwise. The RIB warns *NEVER MAX OUT THE NEEDLE* so lets keep that in mind.

I contacted [Dr. Plummer](https://www.wtpoptics.com/about.html) to ask him about this. In the article "The photographic shutter as a *lens element*" in his ["Beyond Raytracing"](https://www.wtpoptics.com/BRdocB.html) paper he devises a formula and an experiment to the devise the merit of the inefficient shutter. In his own words:

*The SX-70 camera from 1972 onward contained a great many screws. About four years later the SX-70 was followed by a non-folding camera using the same film, called the Pronto!  The Pronto! was assembled entirely by friction and snap features, and contained only ONE screw in the whole thing.  That one screw was needed again to adjust the air flow in the dashpot that controlled the shutter speed.  In all cases the shutter had to OPEN slowly to achieve a good depth of field.*

*The original Pronto! had manual focus, with viscous grease in the lens threads to prevent welding when the lens was ultrasonically fastened to the shutter board.  In time there was a rangefinder model, then later a sonar focus model that needed low lens thread viscosity, so the lens was secured to the shutter with a sheet metal nut.*

*About 1981 we introduced the models 640 and 660, in which the shutter opening speed was kept low enough with inertial masses.  Same function, different means.*

So this was definitely desired, and on later cheaper models was accomplished by other means. One experiment would be to check what happens in the SLR680 that is 600ISO natively.

But WHY? Why 25ms to open and 9ms to close.

Is it ISO related? Is there any other reason? Difficult to know.

The philosophical question, is just because we can thanks to the openSX70 control of the camera should we?

One would argue that the aesthetics have changed, and what was desirable for a mass-market instant camera in 1973 has changed. Back in the day the objective was to sort of go for the settings that would render the better results for the average non-photographer user. In that mindset, depth of field was premium factor, to render as many pictures as possible in focus.

One could also argue that those criteria have changed in 50 years, and that now, shallow depth of field is, for the experimental analog photographer a premium, in the sense that we are all searching for that edge, that difference.

Also faster speed makes more sense for higher 600 ISO.

## epilogue

Please, keep in mind that this modification affects the way the picture is exposed, and, that integration in a regular SX70 will not work properly. In any case be careful not to max out the needle.

In the setting of the SX70 that is not a problem, although the magic numbers have to be adjusted. 

Also keep in mind that prototype XXI that I set at P=-3, I feel has the blades dirty and drags, making for friction and probably affecting the results.

Shooting with the camera, the shutter behavior feels odd, not bad or good, just different. It is easily noticeable.

Keep also in mind that this are my shots, and are, at most, anecdotal, still I feel that the pictures look different, maybe sharper... 

What do you think? Post your thoughts.

![Fire image]({{site.url}}/{{site.baseurl}}img/2020/11/20201011_PXXI_fast-pneumatic-iso100-5.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2020/11/20201011_PXXI_fast-pneumatic-iso100-4.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2020/11/20201011_PXXI_fast-pneumatic-iso100-2.jpg)
![Fire image]({{site.url}}/{{site.baseurl}}img/2020/11/20201011_PXXI_fast-pneumatic-iso100-1.jpg)


 