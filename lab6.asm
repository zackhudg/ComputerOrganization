.data

A:			.space 	80  	# create integer array with 20 elements ( A[20] )
size_prompt:		.asciiz 	"Enter array size [between 1 and 20]: "
array_prompt:		.asciiz 	"A["
sorted_array_prompt:	.asciiz 	"Sorted A["
close_bracket: 		.asciiz 	"] = "
search_prompt:		.asciiz		"Enter search value: "
not_found:		.asciiz		" not in sorted A"
newline: 		.asciiz 	"\n" 	

.text

main:	
	# ----------------------------------------------------------------------------------
	# Do not modify
	#
	# MIPS code that performs the C-code below:
	#
	# 	int A[20];
	#	int size = 0;
	#	int v = 0;
	#
	#	printf("Enter array size [between 1 and 20]: " );
	#	scanf( "%d", &size );
	#
	#	for (int i=0; i<size; i++ ) {
	#
	#		printf( "A[%d] = ", i );
	#		scanf( "%d", &A[i]  );
	#
	#	}
	#
	#	printf( "Enter search value: " );
	#	scanf( "%d", &v  );
	#
	# ----------------------------------------------------------------------------------
	la $s0, A			# store address of array A in $s0
  
	add $s1, $0, $0			# create variable "size" ($s1) and set to 0
	add $s2, $0, $0			# create search variable "v" ($s2) and set to 0
	add $t0, $0, $0			# create variable "i" ($t0) and set to 0

	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, size_prompt 		# put string memory address in register $a0
	syscall           		# print string
  
	addi $v0, $0, 5			# system call (5) to get integer from user and store in register $v0
	syscall				# get user input for variable "size"
	add $s1, $0, $v0		# copy to register $s1, b/c we'll reuse $v0
  
prompt_loop:
	# ----------------------------------------------------------------------------------
	slt $t1, $t0, $s1		# if( i < size ) $t1 = 1 (true), else $t1 = 0 (false)
	beq $t1, $0, end_prompt_loop	 
	sll $t2, $t0, 2			# multiply i * 4 (4-byte word offset)
				
  	addi $v0, $0, 4  		# print "A["
  	la $a0, array_prompt 			
  	syscall  
  	         			
  	addi $v0, $0, 1			# print	value of i (in base-10)
  	add $a0, $0, $t0			
  	syscall	
  					
  	addi $v0, $0, 4  		# print "] = "
  	la $a0, close_bracket		
  	syscall					
  	
  	addi $v0, $0, 5			# get input from user and store in $v0
  	syscall 			
	
	add $t3, $s0, $t2		# A[i] = address of A + ( i * 4 )
	sw $v0, 0($t3)			# A[i] = $v0 
	addi $t0, $t0, 1		# i = i + 1
		
	j prompt_loop			# jump to beginning of loop
	# ----------------------------------------------------------------------------------	
end_prompt_loop:

	addi $v0, $0, 4  		# print "Enter search value: "
  	la $a0, search_prompt 			
  	syscall 
  	
  	addi $v0, $0, 5			# system call (5) to get integer from user and store in register $v0
	syscall				# get user input for variable "v"
	add $s2, $0, $v0		# copy to register $s2, b/c we'll reuse $v0

	# ----------------------------------------------------------------------------------
	# TODO:	PART 1
	#	Write the MIPS-code that performs the the C-code (bubble sort) shown below.
	#	You may only use the $s, $v, $a, $t registers (and of course the $0 register)
	#	The above code has already created array A and A[0] to A[size-1] have been 
	#	entered by the user. After the bubble sort has been completed, the values im
	#	A are sorted in increasing order, i.e. A[0] holds the smallest value and 
	#	A[size -1] holds the largest value.
	#	
	#	int t = 0;
	#	
	#	for ( int i=0; i<size-1; i++ ) {
	#		for ( int j=0; j<size-1-i; j++ ) {
 	#			if ( A[j] > A[j+1] ) {
	#				t = A[j+1];
	#				A[j+1] = A[j];
	#				A[j] = t;
	#			}
	#		}
	#	}
	#			
	# ----------------------------------------------------------------------------------
	

	addi $t0, $0, 0		#int i = 0
	addi $t3, $s1, -1	#size-1
	
bubble_loop:

	slt $t1, $t0, $t3	#
	beq $t1, $0, end_bubble_loop	#if i < size-1 continue, else end loop
	
	addi $t2, $0, 0		#int j = 0
	sub $t7, $t3, $t0	#size-1 - i
	
bubble_nested_loop:

	slt $t1, $t2, $t7	#
	beq $t1, $0, end_bubble_nested_loop	#if j < size-1-i continue, else end loop
	
bubble_if:

	sll $t4, $t2, 2		#j*4 for mem addressing
	add $t4, $s0, $t4	#address of A[j]
	lw $t5, 0($t4)		#value of A[j]
	lw $t6, 4($t4)		#value of A[j+1]
	slt $t1, $t6, $t5
	beq $t1, $0, end_bubble_if	#if A[j+1] < A[j] continue, else end loop
	
	sw $t5, 4($t4)		#A[j] = val from A[j+1]		SWAPPING
	sw $t6, 0($t4)		#A[j+1] = val from A[j]		SWAPPING
	
end_bubble_if:	
	
	addi $t2, $t2, 1	#j++
	j bubble_nested_loop

end_bubble_nested_loop:
	
	addi $t0, $t0, 1	#i++
	j bubble_loop

end_bubble_loop:

	# ----------------------------------------------------------------------------------
	# TODO:	PART 2
	#	Write the MIPS-code that performs the C-code (binary earch) shown below.
	#	You may only use the $s, $v, $a, $t registers (and of course the $0 register)
	#	The array A has already been sorted by your code above int PART 1, where A[0] 
	#	holds the smallest value and A[size -1] holds the largest value, and v holds 
	# 	the search value entered by the user
	#	
	#	int left = 0;
	# 	int right = size - 1;
	#	int middle = 0;
	#	int element_index = -1;
 	#
	#	while ( left <= right ) { 
        #
        #		middle = left + (right - left) / 2; 
	#
        #		if ( array[middle] == v) {
        #    			element_index = middle;
        #    			break;
        #		}
        #
        #		if ( array[middle] < v ) 
        #    			left = middle + 1; 
        #		else
        #    			right = middle - 1; 
	#
    	#	} 
	#
    	#	if ( element_index < 0 ) 
    	#		printf( "%d not in sorted A\n", v );
    	#	else 
    	#		printf( "Sorted A[%d] = %d\n", element_index, v );
	#			
	# ----------------------------------------------------------------------------------


	addi $t0, $0, 0		#int left = 0
	#t3			 right = size-1
	#s2			#v
  	#addi $t1, $0, 0	#int middle = 0
  	addi $t2, $0, -1	#int element_index = -1
  	
binary_loop:

	slt $t4, $t3, $t0	#if right < left --> t4 = 1 --> END LOOP
	bne $t4, $0, binary_if
	
	sub $t1, $t3, $t0	#middle = right - left
  	div $t1, $t1, 2		#middle = (right - left) / 2
  	add $t1, $t0, $t1	#middle = left + (right-left)/2
  	
binary_if_equals:

	sll $t5, $t1, 2		#middle*4 for address
	add $t5, $s0, $t5	#address of A[middle]
	lw $t5, 0($t5)		#val of A[middle]
	bne $t5, $s2, binary_if_lt	#if A[middle] == v continue
	addi $t2, $t1, 0	#element_index = middle
	j binary_if
	
binary_if_lt:
  	
  	slt $t4, $t5, $s2
  	beq $t4, $0, binary_gt	#if A[middle] < v continue
  	addi $t0, $t1, 1	#left = middle + 1
  	j binary_loop
  	
binary_gt: 

	addi $t3, $t1, -1	#right = middle - 1
	j binary_loop
  	
binary_if:

	slt $t4, $t2, $0
	beq $t4, $0, binary_else	#if element_index < 0 continue
	
	addi $v0, $0, 1			# print	value of v (in base-10)
  	add $a0, $0, $s2			
  	syscall	
  	
	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, not_found 		# put string memory address in register $a0
	syscall           		# print string
	
	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, newline 		# put string memory address in register $a0
	syscall           		# print string
	
	j exit
	
binary_else:

	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, sorted_array_prompt 		# put string memory address in register $a0
	syscall           		# print string
	
	addi $v0, $0, 1			# print	value of element_index (in base-10)
  	add $a0, $0, $t2			
  	syscall	
  	
  	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, close_bracket 		# put string memory address in register $a0
	syscall           		# print string
	
	addi $v0, $0, 1			# print	value of v (in base-10)
  	add $a0, $0, $s2			
  	syscall	
  	
  	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, newline 		# put string memory address in register $a0
	syscall           		# print string
	
# ----------------------------------------------------------------------------------
# Do not modify the exit
# ----------------------------------------------------------------------------------
exit:                     
  addi $v0, $0, 10      		# system call (10) exits the progra
  syscall               		# exit the program
  
