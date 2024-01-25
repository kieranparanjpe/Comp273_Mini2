.data
	buffer1: .space 270
	buffer2: .space 270
	shiftAmount: .space 9
	prompt1: .asciiz "Input a string 30 characters or less: "
	prompt2: .asciiz "\nInput an integer greater than 0: "
	answer: .asciiz "\nShifted String = "
	error: .asciiz "\nNo input. Run again."
	.align 2
	error1: .asciiz "\nWrong input. Run again"
	.align 2
	newLine: .ascii "\n"
	.align 2
	leftBracket: .ascii "["
	.align 2
	rightBracket: .ascii "]"


.text
.globl main # main()
	main:
		la $a0, prompt1 #load prompt into a0
		li $v0, 4	#print string at a0
    		syscall
    		
    		li $v0, 8	#set mode to read user string input

    		la $a0, buffer1 #load buffer1 address to a0 to be referenced later
    		li $a1, 32      # allot the number of characters to be used, this is also an argument just like a0. must be 31 to account for \n
    		syscall
    		#sw $a0, buffer1

    	

    	    	lw $t0, newLine	#load the newline character into t0
    		lw $t1, buffer1	#load the input from user into t1
    		
    		beq $t0, $t1, exit #if the input is just the newline character then exit the program with an error
    		
    		la $a0, prompt2 #load prompt 2 into a0
		li $v0, 4	#print string at a0
    		syscall
    		
    		li $v0, 8	#set mode to read string
    		la $a0, shiftAmount
    		li $a1, 9
    		syscall 	#store the user input in $v0
    		
    		la $s1, shiftAmount
    		
    	goToEndOfShiftAmount:
    		addi $s1, $s1, 1
    		lb $s0, 0($s1)
    		beq $s0, $t0, continue
    		bne $s0, $0, goToEndOfShiftAmount
    	
    	continue:
    		la $s2, shiftAmount
    		li $s3, 1
    		li $t2, 0
    	parseInt:
    		subi $s1, $s1, 1
    		lb $s0, 0($s1)
    		subi $s0, $s0, 48
    		blt $s0, $0, exit1
    		mult $s0, $s3
    		mflo $t4
    		add $t2, $t2, $t4
    		li $t4, 10
    		mult $s3, $t4
    		mflo $s3
    		bgt $s1, $s2, parseInt
    		
    		
    		ble $t2, $0, exit1 #if our shift number is less than or equal to 0 then we exit
    		
    		li $s7, -1 #init length counter into s7. it is -1 because we need to start one less to account for newline char
    		
    	findLength: #{
    	    	addi $s7, $s7, 1 	#current length counter increment
    	    	la $s1, buffer1 	#find base address of the array of input
    	    	add $s1, $s1, $s7 	#add the current length to the address that we have as an offset
    	    	lb $s2, 0($s1) 		#load the current character (of size byte) into s2 by indexing the offset we has last time.
    		bne $s2, $t0, findLength#if the current char at s2 is not equal to the newline character we previouslt storied in t0 then we should loop again
		#}
    		#length now stored in s7 (does not include newline)!
    		
    		div $t2, $s7
    		mfhi $t2
    		sub $t2, $s7, $t2	
    		
   		li $s0, 0 		#start index counter at 1. this is the for(int i = 0)
    	shift: 	#{			#we want to shift each char to new index of: 1 + (index + (length - shift amount)) % length 
		la $s1, buffer1 	#find base address of the array of input
    	    	add $s1, $s1, $s0 	#add the current length to the address that we have as an offset
    	    	lb $s2, 0($s1) 		#load the current character (of size byte) into s2 by indexing the offset we has last time.
    
    		
    		add $t3, $s0, $t2	#put the index + shift amount into t3
    		div $t3, $s7		#stores (index + shift amount) % length into hi register
    		mfhi $t4 		#gets the hi register (new index) and puts it in t4
    		
    		
    		
      		la $s3, buffer2 	#load the address to buffer2 into s3
      		
		add $s3, $s3, $t4  	#add the calulated target index from t4 to the address that we have as an offset
    	    	sb $s2, 0($s3)		#buffer2[s3] = buffer1[i]
		
		addi $s0, $s0, 1 	#i++	
		blt $s0, $s7, shift	#loop back to shift as long as i <= length
		#}
		
		la $a0, answer 		#put the answer pretext to output in a0
		li $v0, 4		#print string at a0
    		syscall
    		    
    		la $a0, leftBracket 		#put the answer pretext to output in a0
		li $v0, 4		#print string at a0
    		syscall	
		
		la $a0, buffer2 	#put the new buffer to output in a0
		li $v0, 4		#print string at a0
    		syscall
    		
    		la $a0, rightBracket 		#put the answer pretext to output in a0
		li $v0, 4		#print string at a0
    		syscall	
    		    		
		li $v0, 10 #end prog.
		syscall
    		
    	exit:
    		la $a0, error #load not long enough promp into a0
		li $v0, 4	#print string at a0
    		syscall
    		
		li $v0, 10 #end prog.
		syscall
		    		
    	exit1:
    		la $a0, error1 #load not long enough promp into a0
		li $v0, 4	#print string at a0
    		syscall
    		
		li $v0, 10 #end prog.
		syscall
	
