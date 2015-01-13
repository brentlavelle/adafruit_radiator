# Adafruit radiator

The goal is to make a cheap device that will light up some multi-color neopixels to indicate the status of a CI job, probably running in Jenkins or Team City

* **blue** - running
* **green** - passing
* **red** - broken
* **yellow** - the tests can't run

## Material
* [5 volt Trinket](http://www.adafruit.com/product/1501)
* [Pack of 5 8mm NeoPixels](http://www.adafruit.com/products/1734)
* A mini USB cable to power and program the trinket.  Not a micro USB cable.
* Some wire
* I should have bought a breadboard, mine is in the mail from China right for the last few weeks.

## Getting Started

* Download the [Arduino IDE](https://learn.adafruit.com/introducing-trinket/setting-up-with-arduino-ide) with the Trinket
* Load the trinket_code.ino into the IDO
* Wire up the 5V, Ground and I/O pin 1 to the data in of your NeoPixel [Trinket pinout](https://learn.adafruit.com/introducing-trinket/pinouts) [NeoPixel pinout](http://www.adafruit.com/images/1200x900/1734-04.jpg)
* Connect the Trinket to your computer with the USB cable, the board green light will come on and the neopixel will probably be white
* Press the reset button on the trinket, and within 10 seconds, while the red light is flashing slowly
* Press the upload button in the IDE, the red light will blink a little then hopefully you will see it cycle through the colors then off
* Code more to make this a radiator
