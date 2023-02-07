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

The camera exposed automatically the picture based on a system called integration, of course based on the ambient light. [This is the source of the pictures.](https://siliconpr0n.org/archive/doku.php?id=mcmaster:polaroid:sx-70-opto)

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

## The logic chip

The camera is controlled by a complex logic chip that controlled the timing of the various mechanisms, running the motor and solenoids. It had to handle four different use cases: ejecting the protective cover sheet when a film package was inserted, taking a photo, taking a photo with the flash, and ejecting an empty film package.

This chip was constructed from Integrated Injection Logic (I2L), an obscure 1970s logic family featuring high density and low power. Because the camera ran off a battery in the film pack, minimizing power consumption was a critical factor. At the time, I2L was a good choice for dense, low-power circuitry, although it was soon overtaken by CMOS. Texas Instruments did a lot of development with I2L, including [digital watch chips](https://twitter.com/kenshirriff/status/1400579453839810564) and the [76477 sound chip](https://www.righto.com/2018/05/inside-76477-space-invaders-sound.html) so it's not surprising that they chose I2L for the camera chip.

[![The logic chip. Photo from siliconPr0n, (CC BY 4.0).](https://static.righto.com/images/sx70/logic-chip2-w600.jpg "The logic chip. Photo from siliconPr0n, (CC BY 4.0).")](https://siliconpr0n.org/map/polaroid/sx-70-711a/mz_mit20x2/)

The logic chip. Photo from [siliconPr0n](https://siliconpr0n.org/archive/doku.php?id=mcmaster:polaroid:sx-70-711a), ([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.en)).

I2L gates can be packed together at high density, as shown below. Each vertical gray rectangle is two transistors (one above the horizontal centerline and one below), corresponding to two gates. The chip has very little wasted space, especially compared to TTL logic, which was commonly used at the time but required multiple transistors and bulky resistors for each gate.

[![Closeup of the logic chip.](https://static.righto.com/images/sx70/i2l-closeup-w500.jpg "Closeup of the logic chip.")](https://static.righto.com/images/sx70/i2l-closeup.jpg)

Closeup of the logic chip.

I2L is a bit tricky to understand since an I2L gate has one input and multiple outputs. How can that work? The schematic below shows an I2L gate, with one input and three outputs. Normally the current from the injector (ICC) turns on the output transistor, pulling the output low. But if the input is low, the output transistor turns off and the output will be high. Thus, the gate inverts the input. (You can think of the injector as a pull-up resistor on the input.)

[![Implementation of an I2L gate. Note that it has a single input and multiple outputs. Icc is the injected current. From "Integrated Injection Logic: A Bipolar LSI Technique".](https://static.righto.com/images/sx70/i2l-circuit-w350.png 'Implementation of an I2L gate. Note that it has a single input and multiple outputs. Icc is the injected current. From "Integrated Injection Logic: A Bipolar LSI Technique".')](https://static.righto.com/images/sx70/i2l-circuit.png)

Implementation of an I2L gate. Note that it has a single input and multiple outputs. Icc is the injected current. From "Integrated Injection Logic: A Bipolar LSI Technique".

Since the circuit above has a single input, it may seem to be just an inverter. But by wiring several signals together at the input, you get an AND gate "for free": if any signal is low, it will pull the wire low, and otherwise the signal is high. This is called "wired-AND". The wired-AND input to the I2L inverter results in a NAND gate.

One problem arises with wired-AND: if you connect an output to more than one wired-AND, everything gets shorted together. The solution is to have multiple outputs from the inverter. Thus, each I2L NAND gate has a single input and multiple identical outputs. In the diagram below, the outputs from various gates (A and B below) are connected together and fed to the input of an I2L gate, creating a NAND gate.

[![Diagram of a NAND gate implemented in Integrated Injection Logic (I2L). From "Integrated Injection Logic: A Bipolar LSI Technique".](https://static.righto.com/images/sx70/wired-and-w400.png 'Diagram of a NAND gate implemented in Integrated Injection Logic (I2L). From "Integrated Injection Logic: A Bipolar LSI Technique".')](https://static.righto.com/images/sx70/wired-and.png)

Diagram of a NAND gate implemented in Integrated Injection Logic (I2L). From "Integrated Injection Logic: A Bipolar LSI Technique".

The transistors in I2L have multiple collectors, which may seem strange, but the diagram below shows how they are constructed. Each collector has an N region (purple) with a P region (tan) below for the base, and another N region (green) at the bottom, forming an NPN transistor. The multiple collectors are built by creating multiple N regions. Physically, the injector PNP transistor is just a P region for the emitter, reusing the emitter and base's N and P regions; this makes the injector more compact than a "full" transistor.

[![Die photo and cross-section diagram of an I2L gate. The transistor base, collectors, and emitters are labeled along with the current injection.](https://static.righto.com/images/sx70/i2l-w500.jpg "Die photo and cross-section diagram of an I2L gate. The transistor base, collectors, and emitters are labeled along with the current injection.")](https://static.righto.com/images/sx70/i2l.jpg)

Die photo and cross-section diagram of an I2L gate. The transistor base, collectors, and emitters are labeled along with the current injection.

I haven't reverse-engineered this chip yet. I believe that it contains an oscillator and a chain of flip flops for timing, as well as a comparator for the light level and some miscellaneous control logic.



## The power driver chip

Next, the power chip drives solenoids and the motor to activate the camera's mechanisms. The high-current power transistors (the golden triangular shapes) take up most of this chip. Smaller transistors below form the control circuitry.

[![The power driver chip. Photo from siliconPr0n, (CC BY 4.0).](https://static.righto.com/images/sx70/driver-chip-w500.jpg "The power driver chip. Photo from siliconPr0n, (CC BY 4.0).")](https://static.righto.com/images/sx70/driver-chip.jpg)

The power driver chip. Photo from [siliconPr0n](https://siliconpr0n.org/archive/doku.php?id=mcmaster:polaroid:sx-70-287121), ([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.en)).

My reverse-engineered schematic shows that the chip has three parts. First, a simple inverter. This probably interfaces the logic chip to the motor control board.

[![Schematic of the inverter in the power driver chip. Click for a larger version.](https://static.righto.com/images/sx70/power-chip-schematic-1-w200.jpg "Schematic of the inverter in the power driver chip. Click for a larger version.")](https://static.righto.com/images/sx70/power-chip-schematic-1.jpg)

Schematic of the inverter in the power driver chip. Click for a larger version.

Second, a high-current driver. This uses the large power transistor at the left of the die. This probably drives a solenoid.

[![Schematic of the driver in the power driver chip.](https://static.righto.com/images/sx70/power-chip-schematic-2-w600.jpg "Schematic of the driver in the power driver chip.")](https://static.righto.com/images/sx70/power-chip-schematic-2.jpg)

Schematic of the driver in the power driver chip.

Finally, a high-current driver with a separate circuit for the solenoid hold current. (That is, the solenoid is pulled into position with a high current, and then held in that position with a lower current.) This uses the large power transistors at the right of the die. There's a single large transistor underneath the main "triangle" of transistors; that transistor is for the hold current. This circuit uses separate power and ground pads from the rest of the chip.

[![Schematic of the driver/hold circuit in the power driver chip.](https://static.righto.com/images/sx70/power-chip-schematic-3-w800.jpg "Schematic of the driver/hold circuit in the power driver chip.")](https://static.righto.com/images/sx70/power-chip-schematic-3.jpg)

Schematic of the driver/hold circuit in the power driver chip.

The driver circuits are more complex than I'd expect, using current sources and current mirrors. Maybe this design minimizes standby current use.

## Conclusion

While the electronics of the SX-70 camera aren't impressive by modern standards, they were cutting edge at the time. They made the SX-70 easy to operate by handling the exposure and timing automatically. Texas Instruments split the electronics across three chips: a precision JFET op-amp with a photodiode, a high-current power driver chip, and a complex logic chip using dense, low-power I2L logic.

Unfortunately, innovative technology wasn't enough for Polaroid. The company declined after competition from Kodak, the expensive failure of the Polavision instant home movie system, and the rise of digital cameras. Polaroid declared bankruptcy in 2001 and the company was broken up. The SX-70 has seen a resurgence in popularity, with film and cameras sold by [polaroid.com](http://polaroid.com/), which acquired the Polaroid name in 2017.

Follow me on Twitter [@kenshirriff](https://twitter.com/kenshirriff) for more posts. I also have an [RSS feed](https://www.righto.com/feeds/posts/default). Thanks to Joaquín De Prada and Peter Kooiman of [openSX70](https://opensx70.com/) for providing the chips and [John McMaster](https://siliconpr0n.org/) for decapping them.