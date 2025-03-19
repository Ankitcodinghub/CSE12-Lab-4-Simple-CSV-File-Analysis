
    #
    # The income_from_record function must return the numerical 
    # (binary value) of corresponding to the income from a 
    # specific record e.g. for record 
    # "Microsoft,34\r\n",it should return an integer value
    # of 34 in a0
    #
    # argument: a0 passed to income_from_record contains 
    # the address that points to the second pointers in 
    # the array of pointer pairs.  
    # e.g. for above example above it will point at the "3"
    # byte address.
    #
    # For more details look at how this gets invoked look
    # at the test bench call.
    #
    # Also look at the file: income_from_record_ideas_asm
    # for ideas about how to code this.
    # ...	
	# Note if you do not edit this code it just returns 0 :(
#------------- Modify this with your code! --------------
income_from_record:
	li a0, 0 # REPLACE THIS LINE WITH CODE THAT WORKS 
#------------- End your  coding  here! -------------------
	ret
############## end of income_from_record #################
