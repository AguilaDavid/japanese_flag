# Bitmap Display

# This is a program written in MIPS assembly that creates the Japanese flag on a 128x64 pixel display. 
# Using low level instructions, the code carefully arranges the elements to replicate the iconic red circle against a white background. 
# The resulting in a faithful representation of the flag of Japan. 

 	 .data
address: .word 0x10040000		# Bitmap Display base address (heap)
red: 	 .word 0x00FF0000		# red color address
white:   .word 0xFFFFFFFF		# white color address
	 .text
	 

main:
	# clear display
	jal clear_bitmap_display
	# set up display
	jal write_white_bitmap_display
	
	# set up the variavel
	
	# prepare circuit color
	la	$s0,red
	lw	$t9,0($s0)		# this record has the red color used to paint the circle
	
	# prepare counter
	la	$s0,address
	lw	$t0,0($s0)		# this record has the screen pixels
	
	# Initialize coordinates
	li	$t1,0			# initialize x coordinate
	li	$t2,0			# initialize y coordinate
	
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
exit:
	li $v0, 10         		# $v0 = 10, system call for exit
	syscall				# exit

# void verify(int x, int y)
# verify if the pixels belong to the circumference and paint it
verify:
 	# push
	addi 	$sp,$sp, -16		# space in stack 4 words
	sw 	$ra, 12($sp) 		# save ret addr
	sw 	$a0, 8($sp) 		# store the number of the current column
	sw 	$a1, 4($sp) 		# store the number of the current line
	
	# body
	
	# formula of a circle with center=(h,k) and R=radius
	# 0 > (x - h)^2 + (y - k)^2 - R^2
	
	# initialize the coordinates of the center of the circle
	
	# Since the center of the circle coincides with the center of the 128x64 pixel display. 
	# So the coordinates of the center are center=(64,32)
	
	li	$t6,64			# $t6 = h = 64
	li	$t7,32			# $t7 = k = 32
	
	sub	$t6,$a0,$t6		# $t6 = (x - h)
	sub	$t7,$a1,$t7		# $t7 = (y - k)
	
	mul	$t6,$t6,$t6		# $t6 = (x - h)^2
	mul	$t7,$t7,$t7		# $t7 = (y - k)^2
	
	add	$t6,$t6,$t7		# $t6 = (x - h)^2 + (y - k)^2
	
	# Considering the radius R=25 we have that R^2=625
	sub	$t6,$t6,625		# $t6 = (x - h)^2 + (y - k)^2 - R^2
	
	slt	$v0,$t6,$zero		# if ($t6 < 0) the pixel belongs to the interior of the circle
	beq	$v0,1,print_color
	
	# pop
	lw	$a1, 4($sp) 		# get the number of the current column
	lw 	$a0, 8($sp) 		# get the number of the current line
	lw 	$ra, 12($sp) 		# get the ret addr
	addi	$sp, $sp, 16 		# free stack
	jr 	$ra			# jump to caller
	
# void print_color(void)
# paint one pixel 
print_color:
	sw	$t9,0($t0)
	jr	$ra			# jump to caller

# void clear_bitmap_display(void) 
# clear bitmap display (set all pixels to black)
clear_bitmap_display:
	la $s0,address
	lw $t9,0($s0)			# counter: controller of the repetitions of the cycle
clear_loop:
	sw $zero, 0($t9)
	addi $t9, $t9, 4 
	blt $t9, 0x10048000, clear_loop # if ($t9 < base_adress + 4 * 8192 = 0x10048000) branch to clear_loop
	jr $ra				# jump to caller
	
# void write_white_bitmap_display(void) 
# write white bitmap display (set all pixels to white)
write_white_bitmap_display:			
	la $s0,white
	lw $t0,0($s0)
	la $s0,address
	lw $t9,0($s0)			# counter: controller of the repetitions of the cycle
write_loop:
	sw $t0, 0($t9)
	addi $t9, $t9, 4
	blt $t9, 0x10048000, write_loop # if ($t9 < base_adress + 4 * 8192 = 0x10048000) branch to write_loop
	jr $ra				# jump to caller
