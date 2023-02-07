---
published: false
layout: post
netlifycms: true
show_avatar: true
author_name: Joaquín de Prada
author_avatar: joaquin
author_url: /author/joaquin
comments: true
show_related_posts: true
date: 2023-02-07T20:19:58.053Z
title: a look inside the chips on the SX-70 camera (T.I.)
description: a collaboration with the amazing Ken Shirriff and John McMaster
feature_image: https://siliconpr0n.org/archive/lib/exe/fetch.php?cache=&media=mcmaster:polaroid:sx-70-chip2:logo_mit20x.jpg
categories: openSX70
---
I﻿t has always been to take a look the dies of the electronics that run inside the SX-70. We were very lucky when the talented Ken Shirriff partnered with the project and helped us do just that. Hey wrote a [blog post on his website](https://www.righto.com/2022/02/a-look-inside-chips-that-powered.html) that I highly recommend.

N﻿evertheless I am going to a small recap of his notes, and post all those beatiful pictures taken by John McMaster. Please note that all schematics are by Ken.

## The optical chip

The camera exposed automatically the picture based on a system called integration, of course based on the ambient light.

1. ## t﻿he package

![](https://siliconpr0n.org/archive/lib/exe/fetch.php?cache=&media=mcmaster:polaroid:sx-70-opto:pcb.jpg)

![](https://siliconpr0n.org/archive/lib/exe/fetch.php?cache=&media=mcmaster:polaroid:sx-70-opto:pack_top.jpg "the package")

![the package](https://siliconpr0n.org/archive/lib/exe/fetch.php?cache=&media=mcmaster:polaroid:sx-70-opto:pack_btm.jpg "the package")

That is accomplished by the optical chip, this is not just a photodiode, but also contains a custom chip. That custom chip is a silicon die protected by epoxy, but the larger photodiode is exposed so external light can fall on it.

[![The optical chip contains a photodiode and a silicon die in one package.](https://static.righto.com/images/sx70/photo-unit-w300.jpg "The optical chip contains a photodiode and a silicon die in one package.")](https://static.righto.com/images/sx70/photo-unit.jpg)

###### The optical chip contains a photodiode and a silicon die in one package.

Ken explains how this works:

*To measure the ambient light, the chip implements the integrator circuit below. The photodiode generates a small current that depends on the light level. This current is integrated over time using a capacitor until a threshold is reached. By opening the shutter during this interval, the film is exposed for the desired amount of time. (The film's exposure depends on the total amount of light received, which is the same value that the integration calculates.) The op-amp die outputs the voltage across the capacitor without draining the capacitor in the process.*

[![The optical chip is essentially an integrator.](https://static.righto.com/images/sx70/integrator-w250.jpg "The optical chip is essentially an integrator.")](https://static.righto.com/images/sx70/integrator.jpg)

###### The optical chip is essentially an integrator.

*The photo below shows the silicon die under a microscope. The chip, made by Texas Instruments, is dominated by the zig-zags forming two interlocking JFET transistors. A JFET is a special type of transistor, used before MOSFETs became popular. These transistors have very low input currents, so they won't drain the capacitor as it charges. The interlocking layout ensures that both transistors are at the same temperature, so the circuit will stay accurate even if the chip heats up unevenly. The chip also contains NPN and PNP transistors, resistors, and a capacitor (the large pink square labeled 28710).*

[![The optical chip. Photo from siliconPr0n, (CC BY 4.0).](https://static.righto.com/images/sx70/sx-70-opto-w500.jpg "The optical chip. Photo from siliconPr0n, (CC BY 4.0).")](https://static.righto.com/images/sx70/sx-70-opto.jpg)

The optical chip. Photo from [siliconPr0n](https://siliconpr0n.org/archive/doku.php?id=mcmaster:polaroid:sx-70-opto), ([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.en)).

K﻿en continues:

*By reverse-engineering the die, I created the schematic below. It is an op-amp, measuring the difference between two inputs (one tied to ground). The two JFET (Q12/Q13) transistors are configured as a standard differential pair circuit. A fixed current (from the current mirror Q8/Q6) is fed into the transistors, and whichever transistor has the higher input will pass almost all the current. The result is amplified by Q5 for the output. In addition to the op-amp circuitry, the chip contains a reset circuit to discharge the capacitor before use (Q1/Q2). (The internal capacitor C1 stabilizes the op-amp; the integration capacitor is external.)*

[![Schematic of the optical chip. Click for a larger version.](https://static.righto.com/images/sx70/optical-chip-schematic-w600.png "Schematic of the optical chip. Click for a larger version.")](https://static.righto.com/images/sx70/optical-chip-schematic.png)

Schematic of the optical chip. Click for a larger version.