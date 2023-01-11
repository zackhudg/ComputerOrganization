.data

A:		.space 40  	# create integer array with 10 elements ( A[10] )
size_prompt:	.asciiz 	"Enter array size [between 1 and 10]: "
array_prompt:	.asciiz 	"A["
close_bracket: 	.asciiz 	"] = "
print_a:	.asciiz		"a = "
newline: 	.asciiz 	"\n" 	

.text

main:
	# ----------------------------------------------------------------------------------
	# Do not modify
	#
	# MIPS code that performs the C-code below:
	#
	# 	int A[10];
	#	int size = 0;
	#
	#	printf("Enter array size [between 1 and 10]: " );
	#	scanf( "%d", &size );
	#
	#	for (int i=0; i<size; i++ ) {
	#
	#		printf("A[%d] = ", i );
	#		scanf( "%d", &A[i]  );
	#
	#	}
	#
	# ----------------------------------------------------------------------------------
	la $s0, A			# store address of array A in $s0
  
	add $s1, $0, $0			# create variable "size" ($s1) and set to 0
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

	# ----------------------------------------------------------------------------------
	# TODO:	Write the MIPS-code that performs the C-code shown below.
	#	You may only use the $s, $v, $a, $t registers (and of course the $0 register)
	#	The MIPS code above has already created the array A where values
    #   A[0] to A[size-1] have been entered by the user.
	#
	#	int a = 0;
	#
	#	for ( int i=0; i<size; i++ ) {
	#
	#		if ( A[i] > 0 ) {
	#
	#			a = a + A[i];
	#
	#		}
	#
	#	}
	#
	#	printf( "a = %d\n", a );
	#			
	# ----------------------------------------------------------------------------------
	
	add $s2, $0, 0			#initialize a = 0
	addi $t0, $0, 0			#initialize i = 0 for the loop
loop:
	slt $t1 ,$t0, $s1
	beq $t1, $0, end_loop		#if i >= size then goes to end_loop
	
if:	
	sll $t2, $t0, 2			#mem add of i (i*4)
	add $t3, $s0, $t2		#t3 = A[i] = address of A + ( i * 4 )
	lw $t3, 0($t3)			#t3 = VAL of A[i]
	slt $t1, $0, $t3
	beq $t1, $0, end_if
	
	add $s2, $s2, $t3		# a = a + A[i]

end_if:
	add $t0, $t0, 1			#increments i
	j loop
  	
end_loop:
	addi $v0, $0, 4  		# print "a = "
  	la $a0, print_a 			
  	syscall
  	
  	addi $v0, $0, 1			#print val of a
  	la $a0, ($s2)		
	syscall
	
	addi $v0, $0, 4			#print \n
	la $a0, newline
	syscall
# ----------------------------------------------------------------------------------
# Do not modify the exit
# ----------------------------------------------------------------------------------
exit:                     
  addi $v0, $0, 10      		# system call (10) exits the progra
  syscall               		# exit the program
  
