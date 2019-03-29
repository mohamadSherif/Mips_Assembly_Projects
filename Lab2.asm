	.data
	
rain:	.float    2.98, 0.69, 1.99, 4.06, 5.44, 6.47, 5.83, 7.21, 2.74, 5.19, 1.81, 7.48, 
                  2.37, 5.37, 11.13, 2.54, 2.68, 2.67, 3.83, 1.39, 4.48, 3.85, 2.06, 3.67,
                  3.72, 2.98, 5.69, 7.17, 3.17, 2.61, 3.09, 17.43, 6.67, 5.21, 3.63, 4.76, 
                  3.56, 0.82, 2.02, 3.15, 4.65, 5.22, 2.77, 4.13, 2.99, 4.5, 1.68, 5.2, 
                  2.76, 3.08, 2.72, 2.35, 4.36, 10.04, 4.92, 4.53, 2.22, 0.6, 3.06, 4.87,
                  2.86, 5.19, 4.51, 3.19, 6.9, 3.93, 7.15, 1.89, 1.23, 4.13, 4.59, 5.34, 
                  5.02, 2.57, 4.65, 2.24, 1.44, 6.13, 2.7, 1.21, 3, 4.3, 1.59, 4.67,
                  4.93, 4.32, 1.6, 1.31, 4.56, 2.35, 7.15, 0.85, 1.7, 3.07, 2.8, 4.17,
                  4.61, 1.51, 3.54, 6.29, 7.32, 5.36, 4.08, 7.63, 1.78, 5.2, 2.1, 1.94,
                  2.17, 6.67, 5.54, 5.04, 5.85, 4.96, 4.3, 4.18, 8.82, 3.2, 8.72, 5.81
                  
newLine:	.asciiz	"\n"  
space:		.asciiz	"            "       
high:		.asciiz ": highest annual rainfall of "
low:		.asciiz ": lowest annual rainfall of "  
head:		.asciiz	"year          rain (inches)     rain (cm)"

highAve:	.asciiz "years with above average rainfall: "
lowAve:		.asciiz "years with below average rainfall: "  

divi:		.float	12  
cent:		.float	2.54    
average:	.float	48.9
            
max:		.word  	12
temp:   	.word	1
maxOut:		.word  	10
tempOut:   	.word	1

tempHi:		.float	100
tempLo:		.float 	0	

yearly:	.space	50

	.text
		
	lw	$t1, temp 		# loop counter
        lw      $t2, max  		# upper bound
        
        lw	$t5, tempOut 		# loop counter
        lw      $t6, maxOut  		# upper bound
        
        la      $t0, rain  		# address of array
        la	$t4, yearly
        li	$t7,2009 
        
        li 	$v0, 4
    	la 	$a0, head
    	syscall				# header for the table
    	
    	li	$v0,4
	la	$a0,newLine
	syscall				# New Line
          
outer_loop:

      	l.s	$f6,tempLo      	# Load a zero to reset the accumulator 
inner_loop:
	l.s    	$f12, 0($t0)		# load one year number from ... 
	add.s	$f6,$f6,$f12		# accumulate the one year
	
   	 # increment loop counter and move to next value
    	addi 	$t1, $t1, 1
    	addi 	$t0, $t0, 4
    	ble 	$t1, $t2, inner_loop
    	
end_inner_loop:
	li	$v0,1
	move	$a0,$t7
	syscall				# Print year
	
	addi	$t7,$t7,1		# Accumulator to count the year
	
    	li 	$v0, 4
    	la 	$a0, space
    	syscall				# print space
	
	li     	$v0, 2
	mov.s	$f12,$f6
    	syscall				# print in inches
    	
    	s.s 	$f6,0($t4)		# store the numbers in the mem

    	li 	$v0, 4
    	la 	$a0, space
    	syscall				# print space
    	
    	l.s	$f2,cent
	mul.s	$f7,$f6,$f2
	
	li     $v0, 2
	mov.s	$f12,$f7
    	syscall				# print in centi
    	
    	li	$v0,4
	la	$a0,newLine
	syscall				# New Line
	
	li	$t1, 1
	
	addi 	$t5, $t5, 1		# encriment the loop counter
    	addi 	$t4, $t4, 4		# encriment the address of the array

    	ble  	$t5, $t6, outer_loop
  
    	li	$v0,4
	la	$a0,newLine
	syscall				# New Line
    	
    	#------------------------------------------------------------
    	
    	li	$t5,0			#
    	la	$t4,yearly		#
    	li	$t7,2009 		# Reset the variables for the next loop
    	l.s	$f9,tempHi		#
    	l.s	$f10,tempLo		#
highest:
    	l.s    	$f8, 0($t4)		# find the greatest num
    	c.lt.s	$f8,$f10		# If the number is greater than 0
	bc1t	skip1			# branch and skip the next lines
	
	mov.s	$f10,$f8		# find the greatest
	add	$t7,$t7,$t5		# find number of year
    
skip1:	

	addi 	$t5, $t5, 1		# increment the loop
    	addi 	$t4, $t4, 4		# increment the address
    	ble 	$t5, $t6, highest	#branch loop
    	
    	li	$v0,1
	move	$a0,$t7
	syscall				#Print Year
    	
    	li	$v0,4
	la	$a0,high
	syscall				# here goes the text
    	
	li     	$v0, 2
	mov.s	$f12,$f10
    	syscall				#print greatest num
    	
    	li	$v0,4
	la	$a0,newLine
	syscall				# New Line
    	
    	li	$t5,1			#
    	la	$t4,yearly		# Reset the variables for the next loop
    	li	$t7,1994		#
	
lowest:
    	l.s    	$f8, 0($t4)		#find the low num
    	c.lt.s	$f9,$f8			# if the  
	bc1t	skip2
	
	mov.s	$f9,$f8			# find the low
	add	$t7,$t7,$t5		# find number of year
    
skip2:	
	addi 	$t5, $t5, 1		# increment the loop
    	addi 	$t4, $t4, 4		# increment the address
    	ble 	$t5, $t6, lowest	#branch loop
    	
    	li	$v0,1
	move	$a0,$t7
	syscall				#Print Year
    	
    	li	$v0,4
	la	$a0,low
	syscall				# here goes the text
    	
	li     	$v0, 2
	mov.s	$f12,$f9
    	syscall				#print greatest num
    	
    	li	$v0,4
	la	$a0,newLine
	syscall				# New Line
	
	li	$v0,4
	la	$a0,newLine
	syscall				# New Line
	
	#---------------------------Find the average----------------------------------------
	
	li	$t5,1			# 
    	la	$t4,yearly		#
    	li	$t7,0			# Reset the variables for the next loop
    	l.s	$f6, average 		#
    	
lowestAvg:
    	l.s    	$f8, 0($t4)		# load the array to register
    	c.lt.s	$f6,$f8			# if the number is lower than avergae
	bc1t	skip3			# skip the next few lines 
	
	addi	$t7,$t7,1		# find number of year
    
skip3:	
	addi 	$t5, $t5, 1		# increment the loop
    	addi 	$t4, $t4, 4		# increment the address
    	ble 	$t5, $t6, lowestAvg	#branch loop
    	
    	li	$v0,4
	la	$a0,lowAve 
	syscall				# here goes the text
    	
	li	$v0,1
	move	$a0,$t7
	syscall				# Print Year
	
	li	$v0,4
	la	$a0,newLine
	syscall				# New Line
	
	li	$t5,1			#
    	la	$t4,yearly		#
    	li	$t7,0			# Reset the variables for the next loop
    	l.s	$f6, average 		#
    	
highAvg:
    	l.s    	$f8, 0($t4)		# load array to register
    	c.lt.s	$f8,$f6			# if the number is greater than average 
	bc1t	skip4			# skip the next lines 
	
	addi	$t7,$t7,1		# find number of year
    
skip4:	
	addi 	$t5, $t5, 1		# increment the loop
    	addi 	$t4, $t4, 4		# increment the address
    	ble 	$t5, $t6, highAvg	#branch loop
    	
    	li	$v0,4
	la	$a0,highAve 
	syscall				# here goes the text
    	
	li	$v0,1
	move	$a0,$t7
	syscall				# Print Year
	
	
	
