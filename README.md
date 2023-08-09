# Japanese national flag

This code was made in assembler to train the connection with peripherals, which in this case is display.

To draw the flag of Japan on the display as a first step we must parameterize the flag and the environment.

We know that we are using a 128x64 pixel display. Being that the total number of pixels is 8192. We also know that in the upper left corner is the origin of coordinates, that is, the point (0,0) and we know that the origin point has memory address 0x10040000 (heap). To advance to the next pixel we add 4 units to the base address.
