---
published: true
layout: post
netlifycms: true
show_avatar: true
author_name: Joaquín de Prada
author_avatar: joaquin
author_url: /author/joaquin
comments: true
show_related_posts: true
date: 2023-04-29T15:01:12.273Z
title: a look inside the chips on the SX-70 camera (T.I.)
description: a collaboration with the amazing Ken Shirriff and John McMaster
feature_image: https://siliconpr0n.org/archive/lib/exe/fetch.php?cache=&media=mcmaster:polaroid:sx-70-chip2:logo_mit20x.jpg
categories: openSX70
---
I﻿t has always been to take a look the dies of the electronics that run inside the SX-70. We were very lucky when the talented Ken Shirriff partnered with the project and helped us do just that. Hey wrote a [blog post on his website](https://www.righto.com/2022/02/a-look-inside-chips-that-powered.html) that I highly recommend.

 I am going to concentrate in the beautiful pictures taken by [John McMaster](https://siliconpr0n.org/archive/doku.php?id=tag:vendor_polaroid&do=backlink)

T﻿here are 3 chips in the main PCB of the SX-70 (ECM or Electronic Control Module in Polaroid lingo) the opto chip that controls the exposure called integration, the "brains" logic chip which is the one in control of all the cool stuff the SX-70 does, and finally the power chip, this is in charge of turning on and off the solenoids and the motor.

P﻿lease note that there were two companies that manufactured ECMs, TI (Texas Instruments) and Fairchild Camera.

I﻿f you want to know more about the competition between these company please [read this post](https://opensx70.com/posts/2021/04/battle).

![](/img/2023/sin-título-1.jpg)

## The optical chip

The camera exposed automatically the picture based on a system called integration, of course based on the ambient light. [This is the source of the pictures.](https://siliconpr0n.org/archive/doku.php?id=mcmaster:polaroid:sx-70-opto)

![](https://siliconpr0n.org/archive/lib/exe/fetch.php?cache=&media=mcmaster:polaroid:sx-70-opto:pcb.jpg)

![](https://siliconpr0n.org/archive/lib/exe/fetch.php?cache=&media=mcmaster:polaroid:sx-70-opto:pack_top.jpg "the package")

![the package](https://siliconpr0n.org/archive/lib/exe/fetch.php?cache=&media=mcmaster:polaroid:sx-70-opto:pack_btm.jpg "the package")

That is accomplished by the optical chip, this is not just a photodiode, but also contains a custom chip. That custom chip is a silicon die protected by epoxy, but the larger photodiode is exposed so external light can fall on it.

[![The optical chip contains a photodiode and a silicon die in one package.](https://static.righto.com/images/sx70/photo-unit-w300.jpg "The optical chip contains a photodiode and a silicon die in one package.")](https://static.righto.com/images/sx70/photo-unit.jpg)

###### The optical chip contains a photodiode and a silicon die in one package.



[![The optical chip. Photo from siliconPr0n, (CC BY 4.0).](https://static.righto.com/images/sx70/sx-70-opto-w500.jpg "The optical chip. Photo from siliconPr0n, (CC BY 4.0).")](https://static.righto.com/images/sx70/sx-70-opto.jpg)

The optical chip. Photo from [siliconPr0n](https://siliconpr0n.org/archive/doku.php?id=mcmaster:polaroid:sx-70-opto), ([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.en)).



# The  "brain" logic chip

I﻿n Ken's words:

*The camera is controlled by a complex logic chip that controlled the timing of the various mechanisms, running the motor and solenoids. It had to handle four different use cases: ejecting the protective cover sheet when a film package was inserted, taking a photo, taking a photo with the flash, and ejecting an empty film package.n*

*This chip was constructed from Integrated Injection Logic (I2L), an obscure 1970s logic family featuring high density and low power. Because the camera ran off a battery in the film pack, minimizing power consumption was a critical factor. At the time, I2L was a good choice for dense, low-power circuitry, although it was soon overtaken by CMOS. Texas Instruments did a lot of development with I2L, including [digital watch chips](https://twitter.com/kenshirriff/status/1400579453839810564) and the [76477 sound chip](https://www.righto.com/2018/05/inside-76477-space-invaders-sound.html) so it's not surprising that they chose I2L for the camera chip.*

[![The logic chip. Photo from siliconPr0n, (CC BY 4.0).](https://static.righto.com/images/sx70/logic-chip2-w600.jpg "The logic chip. Photo from siliconPr0n, (CC BY 4.0).")](https://siliconpr0n.org/map/polaroid/sx-70-711a/mz_mit20x2/)

The logic chip. Photo from [siliconPr0n](https://siliconpr0n.org/archive/doku.php?id=mcmaster:polaroid:sx-70-711a), ([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.en)).

[![Closeup of the logic chip.](https://static.righto.com/images/sx70/i2l-closeup-w500.jpg "Closeup of the logic chip.")](https://static.righto.com/images/sx70/i2l-closeup.jpg)

Closeup of the logic chip.

![](/img/2023/pack_btm.jpg)

![](/img/2023/logo_mit20x.jpg)

![](/img/2023/pack_top.jpg)

## The power driver chip

Next, the power chip drives solenoids and the motor to activate the camera's mechanisms. The high-current power transistors (the golden triangular shapes) take up most of this chip. Smaller transistors below form the control circuitry.

T﻿here is a vertical number 287121

[![The power driver chip. Photo from siliconPr0n, (CC BY 4.0).](https://static.righto.com/images/sx70/driver-chip-w500.jpg "The power driver chip. Photo from siliconPr0n, (CC BY 4.0).")](https://static.righto.com/images/sx70/driver-chip.jpg)

The power driver chip. Photo from [siliconPr0n](https://siliconpr0n.org/archive/doku.php?id=mcmaster:polaroid:sx-70-287121), ([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.en)).

![](/img/2023/pack_btm.jpg)

## Conclusion

*While the electronics of the SX-70 camera aren't impressive by modern standards, they were cutting edge at the time. They made the SX-70 easy to operate by handling the exposure and timing automatically. Texas Instruments split the electronics across three chips: a precision JFET op-amp with a photodiode, a high-current power driver chip, and a complex logic chip using dense, low-power I2L logic.*

Follow Ken on Twitter [@kenshirriff](https://twitter.com/kenshirriff) for more posts. Thanks to Joaquín De Prada and Peter Kooiman of [openSX70](https://opensx70.com/) for providing the chips and [John McMaster](https://siliconpr0n.org/) for decapping them.