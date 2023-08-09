# Japanese national flag

This code was made in assembler to train the connection with peripherals, which in this case is display.

To draw the flag of Japan on the display as a first step we must parameterize the flag and the environment.

We know that we are using a 128x64 pixel display. Being that the total number of pixels is 8192. We also know that in the upper left corner is the origin of coordinates, that is, the point (0,0) and we know that the origin point has memory address 0x10040000 (heap). To advance to the next pixel we add 4 units to the base address.

![Captura de Ecrã (2404)](https://github.com/AguilaDavid/japanese_flag/assets/125582704/0457b469-3488-4d2a-b6ec-7b6607da5d30)

In this project, the first operation to be carried out on the display will be to set all the pixels to black, this with the aim of cleaning it from previous designs. For that we go through all the pixels of the display and write zero in them.
