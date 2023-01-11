.data

pattern: 	.space 17	# array of 16 (1 byte) characters (i.e. string) plus one additional character to store the null terminator when N=16

N_prompt:	.asciiz "Enter the number of bits (N): "
newline: 	.asciiz "\n"

.text

main:


#----------------------------------------------
#
# Convert the lab8 C-code to MIPS instructions
#
# Please remember to read the "program specification"
# section in the lab assignment PDF very carefully.
# It has all the information needed to complete this
# assignment :)
#
# TODO: Put your MIPS code here
#
#----------------------------------------------
	addi $v0, $0, 4
	la $a0, N_prompt
	syscall			#print Nprompt
	
	addi $v0, $0, 5
	syscall			#scanf N
	
	add $a0, $0, $v0	
	add $a1, $0, $a0	
	la $t0, pattern($a0)	#could also try add if doesnt work
	sb $0, 0($t0)		#pattern[N] = 0
	
	jal bingen
	addi $v0, $0, 0
	
exit:                     
	addi $v0, $0, 10      	# system call code 10 for exit
	syscall               	# exit the program
	
bingen:
	
	sgt  $t3, $a1, $0
	beq $t3, $0, else
	
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $fp, 12($sp)
	sw $s0, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	addi $fp, $sp, 16
	
	sub $t0, $a0, $a1	
	la $s0, pattern($t0)
	li $t0, '0'
	sb $t0, 0($s0)
	sub $a1, $a1, 1
	
	jal bingen
	
	li $t0, '1'
	sb $t0, 0($s0)
	
	jal bingen
	
	lw $s0, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $fp, 4
	lw $ra, 0($fp)
	lw $fp, -4($fp)

	jr $ra
	
else:
	addi $v0, $0, 4
	la $a0, pattern
	syscall			#print pattern

	la $a0, newline
	syscall			#print newline
	
	jr $ra


