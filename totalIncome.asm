# totalIncome finds the total income from the file
# arguments:
#	a0 contains a pointer to the array of record pointer pairs 
#      location (0x10040000 in our example) 
#      Note your code MUST handle any address value
#	a1: the number of records in the file
# return value:
#    a0: will return the total income 
#        by adding up all the record incomes.
#
# Consider whether this is a leaf or nested function
# Consider what registers you may have to save and restore
# What type of register is best to use and why.
# This function must make calls to the input_from_record function.

# You must make function calls to income_from_record 
# in a loop to obtain the various incomes from your code. 
# This assembly program along with: income_from_record.asm,
#   maxIncome.asm and minIncome.asm all gets
# gets included from lab4_testbench_rev#.asm so 
# reference to label income_from_record is available 
# for your code to use from this file.
# All labels used across all these files should be made unique
# since all the files are included into one file.

# A question for you: Is this a nested or a leaf function?
# Optimize register spills accordingly.

totalIncome:
	bnez a1, totalIncome_fileNotEmpty ###F### totalIncome function
	li a0, 0 # if a1 is 0 return 0 for the total income 
	ret

totalIncome_fileNotEmpty:
#------ Edit this section, starting your code here ---------
    ### DELETE THESE LINES AND REPLACE THEM WITH YOUR CODE ###
    li a0, 0 # if the student does not change this code  
    ret      # a0 will return an income of 0 always :(

#------ End your  coding  here! ----------------------------
    ret   # PC = ra

