# Note: make sure that RARS settings are set for 32-bit operation
# avoing the need to save 64-bit addresses.

# How this program works:
# User will input 2 positive integers n1 and n2, in 
# the "Run I/O"  window.
# The program will then print the result n1*n2 
#
# n1*n2 is done by the multiply function
# multiply function itself calls another function sum
#
# NOTE: This code ONLY works if n2 >=0 
# If you input n2 < 0, you will always get 0 output!
#
# You can tinker with this script to better understand 
# the ins and outs of RISCV assembly
# but do so ONLY after having read and fully understood 
# how the program works!!!

.macro exit # macro to exit program
    li a7, 10
    ecall
    .end_macro	

.macro print_str(%string1) # macro to print any string
	li a7,4 
	la a0, %string1
	ecall
	.end_macro
	
.macro print_int (%x)  # macro prints an integer from a register
	li a7, 1
	add a0, zero, %x
	# zero here refers to register x0
	# the x0 register always has constant value of 0
	ecall
	.end_macro
	
.macro read_int # macro to input integer in a0
	li a7, 5
	ecall 
	.end_macro 

# When using functions in code, be VERY careful if you
# create any macros!
# Macros can unintentionally change register values 
# and cause runtime errors

.data 				
    # Here we are in the data section of memory.
	prompt1: .asciz  "Enter first number n1 :"
	prompt2: .asciz  "Enter second number n2 :"
	outputMsg: .asciz  " (n1) multiplied with "
	outputMsg2: .asciz  " (n2) gives the result "
	newline: .asciz  "\n"  #this prints a newline
	# newline is in case you want to print one
	# we dont use it in this program

#-------End of .data section!---------

.text 				
# We are now in the "text" section which is devoted 
# to storing the instructions making up our program.

main: # Label to define the main (entry point) of our program.
    # print_str prints prompts on the console
	print_str(prompt1) # print request for n1
	read_int   # returns n1 in a0
	mv t0, a0  # set t0 to the value of n1
	
	print_str(prompt2) # print request for n2
	read_int  # a0 gets n2
	addi t1, a0, 0  # save it in t1

    # t1*t2 will occur in the multiply(n1,n2) function
    # this function accepts arguments n1,n2 in a0,a1 registers
    # and returns n1*n2 in a0 
    # This is the ONLY info main knows about the
    #  multiply(n1,n2) function!

    # Let's load up a0,a1 with correct t0,t1 respectively!
	mv a0, t0  # a0 gets n1
	mv a1, t1  # a1 gets n2

    # preserve t0,t1 on the stack
	addi sp, sp, -8
	sw t0, 0(sp)
	sw t1, 4(sp)

#Now are ready to call multiply function!
	jal multiply
	
    # We have no idea if sum manipulated t0,t1 values or not
    # Of course, you can peek at sum function to verify this
    # But in a program with say, a million functions, 
    # or where you didn't write multiply it is not possible 
    # to know.
    # So we stick to the RISCV function convention 
    # We assume the worst and reload t0,t1 with the 
    # preserved values
	lw t0, 0(sp)
	lw t1, 4(sp)
    # Reset stack pointer to original level
	addi sp, sp, 8
	
    # Now we need to display the sentence:
    # " n1 added to n2  gives the result (n1+n2)"
    # so let's get to it!
	
    # Before we use the macros, remember they will modify 
    # a0 quite a lot!
    # so we need to transfer current a0 value someplace else!
	mv t2, a0
    #let's print the result
    print_int(t0)#n1
    print_str(outputMsg)
    print_int(t1)#n2
    print_str(outputMsg2)
    print_int(t2)#n1*n2

    exit
    # Note that instead of saving and restoring t0,t1
    # You can have multiply use s0 and s1, which it does
    # not need to save, and make this program more efficient.
    # Try it.

multiply: #ennter multiply function
    # accepts a0 and a1 as arguments for n1,m2
    # returns n1*n2 in a0

    # multiply in our example is callee to main but 
    # is also a caller to the sum funciton
    # Uusing sum function herely is purely for 
    # demonstrational purposes only in reality, we 
    # would not need to call a function just to add 2 numbers!
    #
    # In this function, we are not using any s registers.
    # So we are not concerned with preserving them to 
    # stack before we change modify them
    #
    # However, we need to preserve the ra (return address) register
    # so that calls made by this function do not wipe it out.
    addi sp, sp, -4
	sw ra, 0(sp)  # save ra on the stack.

	mv t0,a0  # save a0 (n1) in t0
	mv t1,a1  # save a1 (n2) in t1

	addi t3,zero, 0  # intialize counter i=0
	addi t4,zero, 0  # initialize result = 0
	
loop:
    beq t3,t1, loop_exit # exit loop when i=n2
    # Let's call function sum to compute: t4+t0
    #
	# preserve t0,t1,t2,t3,t4 to stack as caller funciton
	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw t4, 16(sp)
	
	#place arguments in a0,a1
	addi a0, t4, 0
	addi a1, t0, 0
	
	jal sum
	#a0 returns with n1+n2
	
	#restore stack values as caller 
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw t4, 16(sp)
	addi sp, sp, 20
	
	#acumulate a0 in  t4
	addi t4, a0, 0
	
loop_update:
	addi, t3,t3,1
	b loop
	
loop_exit:
	#restore ra fo the convenience of multiply's caller
	lw ra, 0(sp)
	addi sp, sp, 4

#done with multiply function!
	ret

sum: 
    #exact same function from add_function.asm
    #function accepts arguments in a0,a1
    #function computes a0+a1
    #function returns result in a0

    # Sum is a leaf function, so it does not need to 
    # preserve the ra register, since it performs no 
    # function calls (jal instructions) that would wipe
    # out the ra register.
    #
    # Note, since it is a leaf function it is more optimal not
    # to use s# registers.  Since we are not using (modifying)
    # any s# registers. we are not concerned with preserving 
    # and restoring these to and from the stack.
    #
	add a0 , a0, a1
    # Now let's return to which ever function called us!
	ret
#-------End of .text section!---------
