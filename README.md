# Japanese national flag made in MIPS assembly

This code was made in assembler to train the connection with peripherals, which in this case is display.

For this project we are using the ``MIPS mars assembler simulator``. The display settings in the simulator are as follows.

![Captura de Ecrã (2406)](https://github.com/AguilaDavid/japanese_flag/assets/125582704/2b815652-8923-4afe-99ab-371a0f4e18e7)

In the simulator we have that the height of the display is 256 but since each pixel in reality is equivalent to 4 we have that the height of the display is 256/4=64 pixels. The same happens with the length, which is equal to 512/4=128 pixels.

To draw the flag of Japan on the display as a first step we must parameterize the flag and the environment.

We know that we are using a 128x64 pixel display. Being that the total number of pixels is 8192. We also know that in the upper left corner is the origin of coordinates, that is, the point (0,0) and we know that ``the origin point has memory address 0x10040000 (heap)``. To advance to the next pixel we add 4 units to the base address.

![Captura de Ecrã (2404)](https://github.com/AguilaDavid/japanese_flag/assets/125582704/ba76ef4e-368b-423a-86e7-acdeb3e2eb8b)

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

in the above code we use the address tag contains the base address that is passed to the $t9 register. register $t9 will serve as a cycle counter. The counter must run through all the pixels. For that we have that the number of pixels we have is 128x64=8192. But we must also take into consideration the representation of pixels. In the simulator, the display considers every 4 pixels of our monitor as one pixel of the diaply. Thus, we come to the conclusion that register ``$t9 must reach a value of base_adress + 4 * 8192 = 0x10048000`` to scroll all pixels.

Now we need to build the white background for that we use a reasoning similar to the previous one only that instead of writing zero in the pixels we write the white color code that is 0xFFFFFFFF

Having the white background now we only need to create the circumference in the center of the rectangle.

To create the circle we will go through all the pixels of the display and we will verify if it belongs to the interior of the circumference. For this we use the following formula:

```assembly
	# formula of a circle with center=(h,k) and R=radius
	# 0 > (x - h)^2 + (y - k)^2 - R^2
```

Since the center of the circle coincides with the center of the rectangle, then ``the center of the circle is (h=64,k=32)`` In this project we consider the radius of the circle being equal to ``R=25``.

To get the variables x and y. What we do is have two nested cycles so that in each line x is increased and when we go to the next line, we increase y and restart x.

```assembly
loop:
	# prepare function arguments
	la	$a0,0($t1)		# send x coordinate
	la	$a1,0($t2)		# send y coordinate
	jal	verify			# go to the function verify
	
	addi	$t0,$t0,4		# advance to the next pixel
	
	add	$t1,$t1,1		# counter: controller repetitions in a colunm
	blt	$t1,128,loop		# if ($t1 < 128) branch to loop
	
	li	$t1,0
	addi	$t2,$t2,1		# counter: controller repetitions in a line
	blt	$t2,64,loop		# if ($t2 < 64) branch to loop
```

Being that in the previous example the ``$t1 register has the x coordinate`` and the ``$t2 register has the y coordinate``

Finally, the verify function tests the condition of the interior of the circle. If verified, the pixel is painted.

Thus, as a final result we obtain the following drawing, which is a faithful representation of the Japanese flag made in assembly MIPS.

![Captura de Ecrã (2400)](https://github.com/AguilaDavid/japanese_flag/assets/125582704/0867cd27-9924-4cd8-b10d-3751cb3ffbe4)

