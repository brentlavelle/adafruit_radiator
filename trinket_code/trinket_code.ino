#include <Adafruit_NeoPixel.h>

#define PIN 3

// Parameter 1 = number of pixels in strip
// Parameter 2 = pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
//   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
//   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
//   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
Adafruit_NeoPixel strip = Adafruit_NeoPixel(10, PIN, NEO_GRB + NEO_KHZ800);

String command;

// Hex conversion char[5] arrays for on hex byte 
char light[5] = "0X00";
char red[5]   = "0X00";
char green[5] = "0X00";
char blue[5]  = "0X00";

void setup() {
  strip.begin();
  strip.show();            // Initialize all pixels to 'off'
  Serial.begin(9600);      // set up Serial library at 9600 bps
  Serial.setTimeout(250);  // speed up reads to wait only 1/4 second
  Serial.println("Radiator started");  // prints hello with ending line break 
}

void loop() {
  command = "";
  while (command == "") {
    delay(20);
    command = Serial.readString();
    command.trim();
  }
  light[2] =command[0];
  light[3] =command[1];
  red[2]   =command[2];
  red[3]   =command[3];
  green[2] =command[4];
  green[3] =command[5];
  blue[2]  =command[6];
  blue[3]  =command[7];
  int light_i = strtol(light, NULL, 16);
  int red_i   = strtol(red,   NULL, 16);
  int green_i = strtol(green, NULL, 16);
  int blue_i  = strtol(blue,  NULL, 16);
  setPixel(strip.Color(green_i, red_i, blue_i), light_i);
  Serial.println("ACK "+command);
  delay (10);
}

void setPixel(uint32_t c, uint16_t index) {
  strip.setPixelColor(index, c); 
  strip.show(); 
}

