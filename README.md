# TI83+ Speedometer
This project turns a TI83+ into a speedometer by taking speed information from a vehicle's OBD2 port via a hacked ELM327 adapter connected to an Arduino Nano, which is then connected to the calculator via its I/O port.

# Hardware Required

ELM327 Adapter 
- Bluetooth or USB-wired, doesn't matter which since we will be soldering directly to the Tx/Rx pins and bypassing the bluetooth or USB module
- Bluetooth is generally a lot cheaper (~$5 vs. ~$15)

Arduino Nano
- Make sure it has a 3.3V pin as that's what the calculator's I/O port runs on.

Resistors
- Two 1k current-limiting resistors (not sure if completely necessary, but a good idea)
- Two 10k pull-up resistors (probably optional, but doesn't hurt)

# Code

There are 3 categories of code needed to get this to work:

## Calculator (TI-BASIC)

This is the language we will be using for our main higher-level loop on the calculator.

Unfortuantely it is missing some key functionas:
- does not have a function to read from the I/O port
- screen printing abilities are extremely limited
  - limited to printing full screen images
  - images can't be shifted left/right or up/doown by any offset

## Calculator (Assembly)

We will use the calculators ability to compile and run assembly code to fill in the gaps:
- wrote small driver to read from I/O port (the TI-BASIC code can call this function to receive a number from the I/O port and store it in Ans)
- wrote code to display large speedometer digits 0-9 in the ones and tens place, using the value stored in Ans to determine the number displayed

## Arduino (C++)

The Arduino Nano functions as the middleman between the ELM327 adapter and the TI83+ calculator

- reads speed data coming from ELM327
- sends speed data to calculator using the protocol that the calculator's I/O port-reading driver understands
