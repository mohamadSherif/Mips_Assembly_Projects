
		
		
		.data
		
prompt: 	.asciiz "Enter a string (. to end): "
array: 		.space 50
new_line: 	.asciiz "\n"

		.text
		
inputLoop:

	la $t0, array 						

	li $v0, 4						
	la $a0, prompt
	syscall				# ask user for input 

	li $v0, 8 						
	la $a0, array
	li $a1, 50 
	syscall				# Store the input in string form
			
loop:

	lbu $t1, 0($t0) 		# load one byte from the array			
	beq $t1, 0x0A, endLoop	 	# if the byte = space, go to endLoop	
	add $t2, $t1, $t2 		# Store(accumulate) the byte in a register 	
	addi $t0, $t0, 1 		# add 1 to the address of array to traverse 
	b loop				# branch to the begining of loop
									

endLoop:

	beq $t2, 0x2E, endInputLoop	# If the input = '.' end program
	
	li $t4, 64
	div $t2, $t4 			# accumulated input/ 64	
	mfhi $t5 			# store the reminder	

	addi $t5, $t5, 32 		# add 32		

	li $v0, 11 						
	move $a0, $t5 					
	syscall				# print the character

	li $v0, 4						
	la $a0, new_line
	syscall				# insert new line
	
	li $t2,0			# clear the register for the next CheckSum

	b inputLoop			# branch to input loop
								

endInputLoop:

	li $v0, 10						
	syscall				# End the program
