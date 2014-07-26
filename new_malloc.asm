	.text
print_str:				# $a0 has string to be printed
	addi	$v0, $zero, 4		# system code for print_str
	syscall				# print it
	jr 	$ra			# return
print_int:				# $a0 has number to be printed
	addi	$v0, $zero, 1		# system code for print_int
	syscall
	jr 	$ra
print_char:				# $a0 has char to be printed
	addi	$v0, $zero, 11		# system code for print_char
	syscall
	jr	$ra
read_int:				# $v0 contains the read int
	addi	$v0, $zero, 5		# system code for read_int
	syscall				
	jr	$ra
read_char:				# $a0 contains the read char
	addi	$v0, $zero, 12		# system code for read_char
	syscall
	jr 	$ra
read_str:				# address of str in $a0, 
					# length is in $a1.
	addi	$v0, $zero, 8		# system code for read_str
	syscall
	jr 	$ra
	
__start:
	la	$a0, input_msg		# address of the input prompt
	jal	print_str		# print it
	la	$a0, input_str		# address where input is put.
	addi	$a1, $zero, 32		# the length of the string
	jal	read_str		# read the input
	# Conveniently, $a0 contains the address of the string. 
	# Call atoi to return the integer in $v0. No need as of now to 
	# save anything.
	jal	atoi
	# The return value is correct only if $v1 is zero.
	# If it is nonzero, print an overflow message.
	# Save the returned integer in $s0.
	add	$s0, $zero, $v0
	beq	$v1, $zero, no_overflow	# if $v1 == 0, proper integer
	la	$a0, overflow_msg	# else, print overflow message
	jal	print_str		# and
	j 	exit			# exit
no_overflow:
	la	$a0, output_msg
	jal	print_str
	add	$a0, $zero, $s0		# ready to print the integer
	jal	print_int		# print it
	addi	$a0, $zero, '\n'	# print a newline
	jal	print_char		# and
	j	exit			# exit
exit:
	addi	$v0, $zero, 10		# system code for exit
	syscall				# exit gracefully

	.data
input_msg:
	.asciiz	"Enter the integer as a string (from -2^31 + 1 to 2^31 - 1): "
output_msg:
	.asciiz "The output is ...(you wouldn't believe): "
overflow_msg:
	.asciiz	"Sorry! Input has overflown the proper limits.\n"
input_str:
	.space 32
	
	.text
atoi:					
	# $a0 has the address of the string. 
	# Integer is to be returned in $v0.
	# First check for sign.
	add	$v0, $zero, $zero	# initialize val to 0
	add	$v1, $zero, $zero	# and status to no_overflow
	lb	$t0, 0($a0)
	beq	$t0, '-', negative	# negative if $a0[0] == '-'
	addi	$t2, $zero, 1		# else positive
	j	build_val		# go on to build val
negative:
	addi	$t2, $zero, -1		# negative sign
	addi	$a0, $a0, 1		# advance past the '-'	
build_val:
	lb	$t0, 0($a0)		# $t0 = *($a0)++
	addi	$a0, $a0, 1
	slti	$t3, $t0, 48		# if $t0 < '0'
	bne	$t3, $zero, exit_bv	# exit loop
	slti	$t3, $t0, 58		# else, if $t0 > '9'
	beq	$t3, $zero, exit_bv	# exit loop
	addi	$t3, $zero, 10
	mult	$v0, $t3		# hi:lo = v0 * 10
	mfhi	$t3			# check for overflow
	bne	$t3, $zero, setv1	# if so, set $v1 to reflect it
	mflo	$v0			# else, get the lo value.
	slt	$t3, $v0, $zero		# make sure val isn't neg.
	bne	$t3, $zero, setv1	# if neg., 
					# set $v1 to reflect overflow
					# else, 	
	addi	$t0, $t0, -48		# $t0 = *(s0) - '0'
	addu	$v0, $v0, $t0		# val+=$t0
	slt	$t3, $v0, $zero		# make sure val isn't neg.
	bne	$t3, $zero, setv1	# if neg., 
					# set $v1 to reflect overflow
	j	build_val		# else, continue. 
setv1:
	addi	$v1, $zero, 1		# $v1 indicates overflow.
	add	$v0, $zero, $zero	# clear val
	jr	$ra
exit_bv:
	mul	$v0, $v0, $t2		# multiply val by the sign.
	jr	$ra			# $v0 has the required value.
