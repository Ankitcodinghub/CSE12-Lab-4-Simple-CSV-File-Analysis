# maxIncome finds the record with the maximum income from the file
# Parameters:	
#   a0 contains address of pointer pair array 
#      this is (0x10040000 in our example) 
#      But your code MUST handle any address value
#   a1:the number of records in the file
# Return value: 
#   a0: pointer to actual location of record stock name in file buffer
#
# Consider whether this is a leaf or nested function
# Consider what registers you may have to save and restore
# What type of register is best to use and why.
# This function must make calls to the input_from_record function.

maxIncome:
	#if empty file, return 0 for both a0, a1
	bnez a1, maxIncome_fileNotEmpty ###F### maxIncome Function
	li a0, 0
	ret

maxIncome_fileNotEmpty:	
# ----------Begining of student code---------
#   ...
#---------- End student code here------------
	ret

