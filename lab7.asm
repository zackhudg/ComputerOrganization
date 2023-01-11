.data
	AA:	   .space 400  		# int AA[100]
	BB:	   .space 400  		# int BB[100]
	CC:  	   .space 400  		# int CC[100]
	m:   	   .word	 0   		# m is an int whose value is at most 10
	m_prompt:	.asciiz 	"m = " 
	AA_prompt:	.asciiz		"AA["
	BB_prompt:	.asciiz		"BB["
	CC_prompt:	.asciiz		"CC["
	close_prompt:	.asciiz		"] = "
	newline:	.asciiz		"\n"
	
.text


#----------------------------------------------
#
# Convert the lab7 C-code to MIPS instructions
#
# Please remember to read the "program specification"
# section in the lab assignment PDF very carefully.
# It has all the information needed to complete this
# assignment :)
#
# TODO: Put your MIPS code here
#
#----------------------------------------------

main:
	la $t0, m		#t0 = m
	lw $t0, 0($t0)
	addi $v0, $0, 4
	la $a0, m_prompt
	syscall			#printf("m = ")
	
	addi $v0, $0, 5
	syscall
	add $t0, $t0, $v0	#scanf %d &m	
	
	jal run
	
exit:                     
	addi $v0, $0, 10      	# system call code 10 for exit
	syscall               	# exit the program

run:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $fp, 0($sp)
	addi $fp, $sp, 4
	
	addi $t1, $0, 0		#t1 = i
	mult $t0, $t0
	mflo $t2		#t2 = mxm
	
loop:	
	slt $t3, $t1, $t2
	beq $t3, $0, end_loop	#t3 = sll
	
	addi $v0, $0, 4
	la $a0, AA_prompt
	syscall
	addi $v0, $0, 1
	add $a0, $t1, $0
	syscall
	addi $v0, $0, 4
	la $a0, close_prompt
	syscall
	
	addi $v0, $0, 5
	syscall
	sll $t4, $t1, 2		#t4 = i*4
	la $t6, AA
	add $t6, $t4, $t6
	sw $v0, 0($t6)		#scanf %d &AA[i]
	
	addi $v0, $0, 4
	la $a0, BB_prompt
	syscall
	addi $v0, $0, 1
	add $a0, $t1, $0
	syscall
	addi $v0, $0, 4
	la $a0, close_prompt
	syscall
	
	addi $v0, $0, 5
	syscall
	la $t6, BB
	add $t6, $t4, $t6
	sw $v0, 0($t6)		#scanf %d &BB[i]	
	
	addi $t1, $t1, 1	#i++
	j loop
		
end_loop:	
	
	jal matrixmult
	
	addi $sp, $fp, 4
	lw $ra, 0($fp)
	lw $fp, -4($fp)
	jr $ra
	
matrixmult:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $fp, 0($sp)
	addi $fp, $sp, 4
	
	addi $t1, $0, 0		#t1 = i
	
loop1:
	slt $t3, $t1, $t0
	beq $t3, $0, end_loop1
	
	addi $t2, $0, 0		#t2 = j
	
loop2:
	slt $t3, $t2, $t0
	beq $t3, $0, end_loop2
	
	addi $t4, $0, 0		#t4 = k
	addi $t5, $0, 0		#t5 = s
	
loop3:
	slt $t3, $t4, $t0
	beq $t3, $0, end_loop3
	
	mult $t1, $t0
	mflo $t6
	add $t6, $t6, $t4
	sll $t6, $t6, 2
	la $t3, AA
	add $t6, $t6, $t3
	lw $t6, 0($t6)		#AA[i*m+k]
	mult $t4, $t0
	mflo $t7
	add $t7, $t7, $t2
	sll $t7, $t7, 2
	la $t3, BB
	add $t7, $t7, $t3
	lw $t7, 0($t7)		#BB[k*m+j]
	mult $t6, $t7
	mflo $t6
	add $t5, $t5, $t6	#s += 
	
	addi $t4, $t4, 1
	j loop3
	
end_loop3:
	mult $t1, $t0
	mflo $t6
	add $t6, $t6, $t2
	sll $t6, $t6, 2
	sw $t5, CC($t6)		#CC[i*m+j]
	
	addi $t2, $t2, 1
	j loop2
	
end_loop2:
	addi $t1, $t1, 1
	j loop1

end_loop1:
	jal printC
	
	addi $sp, $fp, 4
	lw $ra, 0($fp)
	lw $fp, -4($fp)
	jr $ra

printC:
	addi $t1, $0, 0
	mult $t0, $t0
	mflo $t2
	
loopC:
	slt $t3, $t1, $t2
	beq $t3, $0, end_loopC
	
	addi $v0, $0, 4
	la $a0, CC_prompt
	syscall
	addi $v0, $0, 1
	add $a0, $t1, $0
	syscall
	addi $v0, $0, 4
	la $a0, close_prompt
	syscall
	addi $v0, $0, 1
	sll $t5, $t1, 2
	lw $t4, CC($t5)
	add $a0, $t4, $0
	syscall
	addi $v0, $0, 4
	la $a0, newline
	syscall
	
	addi $t1, $t1, 1
	j loopC
end_loopC:
	jr $ra

