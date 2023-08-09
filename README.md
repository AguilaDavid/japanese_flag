# Japanese national flag

This code was made in assembler to train the connection with peripherals, which in this case is display.

For this project we are using the MIPS mars assembler simulator. The display settings in the simulator are as follows.

![Captura de Ecrã (2406)](https://github.com/AguilaDavid/japanese_flag/assets/125582704/0209beb1-f733-4142-b3b5-9daf2c84b8d6)

In the simulator we have that the height of the display is 256 but since each pixel in reality is equivalent to 4 we have that the height of the display is 256/4=64 pixels. The same happens with the length, which is equal to 512/4=128 pixels.

To draw the flag of Japan on the display as a first step we must parameterize the flag and the environment.

We know that we are using a 128x64 pixel display. Being that the total number of pixels is 8192. We also know that in the upper left corner is the origin of coordinates, that is, the point (0,0) and we know that the origin point has memory address 0x10040000 (heap). To advance to the next pixel we add 4 units to the base address.

![Captura de Ecrã (2404)](https://github.com/AguilaDavid/japanese_flag/assets/125582704/0457b469-3488-4d2a-b6ec-7b6607da5d30)

In this project, the first operation to be carried out on the display will be to set all the pixels to black, this with the aim of cleaning it from previous designs. For that we go through all the pixels of the display and write zero in them.

```assembly
clear_bitmap_display:
	la $s0,address
	lw $t9,0($s0)			# counter: controller of the repetitions of the cycle
clear_loop:
	sw $zero, 0($t9)
	addi $t9, $t9, 4 
	blt $t9, 0x10048000, clear_loop
	jr $ra				# jump to caller
```

in the above code we use the address tag contains the base address that is passed to the $t9 register. register $t9 will serve as a cycle counter. The counter must run through all the pixels. For that we have that the number of pixels we have is 128x64=8192. But we must also take into consideration the representation of pixels. In the simulator, the display considers every 4 pixels of our monitor as one pixel of the diaply. Thus, we come to the conclusion that register $t9 must reach a value of base_adress + 4 * 8192 = 0x10048000 to scroll all pixels.

Now we need to build the white background for that we use a reasoning similar to the previous one only that instead of writing zero in the pixels we write the white color code that is 0xFFFFFFFF

