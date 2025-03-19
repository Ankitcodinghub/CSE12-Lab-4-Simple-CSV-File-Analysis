#------------- Modify this with your code! --------------
income_from_record:
    # Description:
    # The function must return the numerical (binary value) of 
    #  the income from a specific record e.g. for record 
    # "NVIDIA,34\r\n",it should return an integer value
    # of 34 in a0
    #
    # argument: a0 passed to income_from_record contains 
    # pointer to the start of numerical portion of record.
    # e.g. for above example it will a pointer that points
    # at the ASCII 3 in the string in memory:
    #    "NVIDIA,34\r\n"
    # To find where the test bench look in the MMIO area 
    # while viewing memory in ASCII mode.
    # ...	
    #
    # so it does not need to spill any registers.
    .eqv CR 13
    .eqv TEN 10
    #
    # Assume the ASCII digits for the amount ends in CR/LF
    #
    # Note, this is a leaf function. 
    # Which do you think will be more efficient to use, and why?
    # t# or s# registers
    #
    # li t1, CR   # Carriage Return
    # li t2 TEN   # Value of 10
    # li t3,0     # running total
    # OR
    # li s1, CR   # Carriage Return
    # li s2 TEN   # Value of 10
    # li s3,0     # running total
    #
    lbu a1, 0(a0)       # a1 = next character
    addi a0, a0, 1      # point to new next character
    # Convert numbers in ASCII to binary 
    # ...

#   USE PRINTING MACROS AND RARS DEBUGGER TO 
#   TROUBLESHOOT YOUR PROGRAM AS NEEDED.  
#   Beware that macros can wipe out a0.
#
###### END YOUR CODE HERE, MAKE SURE YOU RETURN CORRECT 
#      BINARY NUMBER IN REGISTER a0 ####
#------------- End your  coding  here! -------------------
    ret

