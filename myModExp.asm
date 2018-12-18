#   Sidharth Brahmbhatt

	.data
	r: .word  -1	#Result goes here
	base: .word -1
	exp: .word -1	
	s1: .asciiz	"Enter base:\n"
	s2: .asciiz	"Enter exp:\n"
	s3: .asciiz	"Enter # to perform mod on result:\n"
	

	.text
main:
	li $v0, 4	# load appropriate system call code into register $v0;
	la $a0, s1	# load address of string to be printed into $a0
	syscall		# call operating system to perform print operation
	
	li $v0, 5
	syscall
	move $t0, $v0	#base
	
	li $v0, 4	
	la $a0, s2	
	syscall		

	li $v0, 5
	syscall
	move $t1, $v0	#exp
	
	sw $t0, base
	sw $t1, exp	
	move $t2, $t0	# copy of base
	sub $t1, $t1, 1
	
loop:
	beqz $t1, done
	mulu $t2, $t2, $t0
	sub $t1, $t1, 1
	j loop
done:	
	sw $t2, r
	
#	move $t1, $v0
	
	li $v0, 4	
	la $a0, s3	
	syscall	
	
	li $v0, 5
	syscall
	move $t1, $v0
	
loop2:	
		sub $t3,$t2,$t1			
		slt $s0, $t3,$0		
		bne $s0,$0, done2
		add $t2,$t3,$0			
		j loop2				
done2:		
		sw $t2, r			
	
#		end: j end
		
		li $v0, 10
		syscall