#include <Adafruit_NeoPixel.h>

#define PIN 3

// Parameter 1 = number of pixels in strip
// Parameter 2 = pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
//   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
//   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
//   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
Adafruit_NeoPixel strip = Adafruit_NeoPixel(60, PIN, NEO_GRB + NEO_KHZ800);

int count = 0;
void setup() {
  strip.begin();
  strip.show();            // Initialize all pixels to 'off'
  Serial.begin(9600);      // set up Serial library at 9600 bps
  Serial.setTimeout(250);  // speed up reads to wait only 1/4 second

  Serial.println("Radiator started!");  // prints hello with ending line break 
}

void loop() {
  ++count;
  String prompt = String(count)+" prompt> ";
  Serial.println(prompt);
  String command = "";
  while (command == "") {
    delay(10);
    command = Serial.readString();
//     Serial.println("In loop: '"+command+"'");
  }
  if (command == "red") {
    setPixel(strip.Color(  0, 127,   0), 0);
  } else if (command == "green") {
    setPixel(strip.Color(127,   0,   0), 0); 
  } else if (command == "blue") {
    setPixel(strip.Color(0,   0,   127), 0); 
  } else if (command == "black") {
    setPixel(strip.Color(0,   0,   0), 0); 
  }
  delay (100);
}

void setPixel(uint32_t c, uint16_t index) {
  strip.setPixelColor(index, c); 
  strip.show(); 
}

