# Note: make sure that RARS settings call for 64-bit operation
# otherwise sd instructions will not assemble.

# How this program works:
# While running we will input 2 integers from the user, 
# n1 and n2, in the "Run I/O"  window.
# It will then print the result of n1+n2 
# The n1+n2 is calculated with the "sum" function in the code

# You can tinker with this script to better understand 
# the ins and outs of RISCV assembly
# But do so ONLY after having fully read and understood 
# how this code works!!! Understanding this program will
# help you with the first part of Lab3

.macro exit #macro to exit program
		li a7, 10
		ecall
		.end_macro	

.macro print_str(%string1) #macro to print any string
	li a7,4 
	la a0, %string1
	ecall
	.end_macro
	
.macro print_int (%x)  #macro to print any integer or register
	li a7, 1
	add a0, zero, %x
	ecall
	.end_macro
	
.macro read_int #macro to input integer in a0
	li a7, 5
	ecall 
	.end_macro 

.macro print_int(%t0) #macro to print any integer
	li a7, 1
	addi a0, %t0,0
	ecall
	.end_macro 
.data 				

	prompt1: .asciz  "Enter first number n1 :"
	prompt2: .asciz  "Enter second number n2 :"
	outputMsg: .asciz  " (n1) added to "
	outputMsg2: .asciz  " (n2) results in "
	newline: .asciz  "\n"  #this prints a newline
	#In case you might want to print one
	#we dont use it in this program

#-------End of .data section!---------

.text 				
#we are now in the section devoted to storing the actual lines of code in our program.

main: 			
	print_str(prompt1)  # print out promt1
	read_int            # read an int from console into a0
	# a0 now contains user input n1	
    # before we overwrite a0 , we preserve n1 value in t0
    mv t0, a0  # pseudo for: addi t0, a0, 0
	
	print_str(prompt2)
	read_int
	# a0 now contains user input n2	
	# put n2 value in t1 register

    # Note that we can tell by looking at the macro that
    # t0 did not get wiped out by the print_str(prompt2)
    # nor by the read_int.  But in general that is not guaranteed.
 
	mv t1, a0

# The addition of t1+t0 will occur when we call the sum(n1,n2) function.
#
# The sum function accepts arguments n1,n2 in a0,a1 registers
# and returns the sum n1+n2 in a0 
#
# This is the ONLY info main knows about sum(n1,n2) function!

# Let's load up a0,a1 with correct t0,t1 respectively!
	mv a0, t0
	mv a1, t1
	
# Before we pass a0,a1 as arguments, ask yourself:
# Do we care about the values of t0,t1?
#
# The answer is we do since we later print n1,n2 later in I/O console
#
# As per RISCV function convention, the callee function (sum) 
# has no responsibility towards preserving t0,t1
# So if we use these registers preserve t0,t1 on the stack
# as shown here:

# Make enough space on the stack for 2 doublewords
	addi sp, sp, -8
# Store t0,t1 values on the stack to preserve them.
	sw t0, 0(sp)
	sw t1, 4(sp)

#Now are ready to call the "sum" function!
	jal sum
# We have returned from "sum" with the return value in a0

# We have no idea if "sum" modified t0,t1 values or not.
# Of course, we could peek at "sum" function to verify this
# But oftentimes we cannot know.
#
# So we stick to the RISCV function convention 
# So here we reload t0,t1 with the preserved values
	
	lw t0, 0(sp)
	lw t1, 4(sp)
# Reset stack pointer to original level
	addi sp, sp, 8

# Do note, that if we had used S# registers we would
# not have had to save and restore these registers
# in the stack, since the "sum" function would have had 
# to save these if it modified them according to the RISC-V
# conventions.
#
	
# We now display the sentence:
# " <n1> (n1) added to <n2> (n2) results in <n1+n2>"
# So let's get to it!
	
# Before we use the macros, remember that they modify a0 
# So we need we save the current a0 value someplace else!
	mv t2, a0             # Save in a0 (the sum) in t2
	print_int(t0)	      # Output the n1 value
	print_str(outputMsg)  # Output outputMsg string
	print_int(t1)	      # output the n2 value
	print_str(outputMsg2) # output outputMsg2 string
# Output n1+n2 value
	print_int(t2)
	exit	#exit from main()
	
sum:
    # Here we show a definition of the sum function.
    #
    # The function accepts arguments in a0,a1
    # it computes a0+a1
    # then returns the result in a0

    # In this function, we are not using any s registers.
    # So we are not concerned with preserving them to 
    # the stack before we change modify them

    # Also sum is a LEAF function; i.e. it does not 
    # itself call any other functions
    # So no need to preserve the return address (ra) as well

	add a0 , a0, a1  # perform the sum

    # Now let's return to which ever function called us!
	ret

#-------End of .text section!---------

# Now that you have read the code, assemble the code!
# Click Assemble (Wrench and screwdiver icon)
# If the Run Buttom becomes green , assembly is successful
# Click on the Run button
# Voila, you have added 2 input integers through a function!



