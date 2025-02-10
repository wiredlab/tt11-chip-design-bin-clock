<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This chip creates a 12 hour binary clock in base 60. The hour is coded in 4 bits (for up to 12 hours). The minute is coded in 6 bits (for up to 60 minutes). The meridiem (AM or PM) is coded in 1 bit (0 is AM, 1 is PM).
```
----------------------------------
Bit      | 32 16 8 4 2 1 | Decimal
----------------------------------
Hours    |       0 1 1 0 | 6
Minutes  |  1  0 0 1 0 1 | 37
Meridiem |             1 | PM
----------------------------------
```
## How to test

Explain how to use your project

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
