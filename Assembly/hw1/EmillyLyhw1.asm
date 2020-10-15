# Homework 1
# Name: Emilly Ly
# Net ID: ely
# SBU ID: 111097939

.data
# include the file with the test case information
.include "Struct3.asm"  # change this line to test with other inputs

.align 2  # word alignment 

numargs: .word 0
AddressOfNetId: .word 0
AddressOfId: .word 0
AddressOfGrade: .word 0
AddressOfRecitation: .word 0
AddressOfFavTopics: .word 0
AddressOfPercentile: .word 0

err_string: .asciiz "ERROR\n"

newline: .asciiz "\n"

updated_NetId: .asciiz "Updated NetId\n"
updated_Id: .asciiz "Updated Id\n"
updated_Grade: .asciiz "Updated Grade\n"
updated_Recitation: .asciiz "Updated Recitation\n"
updated_FavTopics: .asciiz "Updated FavTopics\n"
updated_Percentile: .asciiz "Updated Percentile\n"
unchanged_Percentile: .asciiz "Unchanged Percentile\n"
unchanged_NetId: .asciiz "Unchanged NetId\n"
unchanged_Id: .asciiz "Unchanged Id\n"
unchanged_Grade: .asciiz "Unchanged Grade\n"
unchanged_Recitation: .asciiz "Unchanged Recitation\n"
unchanged_FavTopics:  .asciiz "Unchanged FavTopics\n"

# Any new labels in the .data section should go below this 
zero: .asciiz "0.0"
hundred: .asciiz "100.0"
# Helper macro for accessing command line arguments via Label
.macro load_args
    sw $a0, numargs
    lw $t0, 0($a1)
    sw $t0, AddressOfNetId
    lw $t0, 4($a1)
    sw $t0, AddressOfId
    lw $t0, 8($a1)
    sw $t0, AddressOfGrade
    lw $t0, 12($a1)
    sw $t0, AddressOfRecitation
    lw $t0, 16($a1)
    sw $t0, AddressOfFavTopics
    lw $t0, 20($a1)
    sw $t0, AddressOfPercentile
.end_macro

.globl main
.text
main:
    load_args()     # Only do this once
    # Your .text code goes below here
    
    	# Part 1
    	
	# Checks if there are 6 arguments
	lw $t0, numargs
	bne $t0, 6, Error_call
	
	# Validation for ID - inclusive range of [0,999999999]
	lw $a0, AddressOfId
	li $v0, 84			# atoi
	syscall
	beq $v1, -1, Error_call		# If not successful - error_call
	bltz $v0, Error_call		# If less than 0 - error_call
	li $t0, 999999999
	bgt $v0, $t0, Error_call	# If greater than 999999999 - error_call
	
	# Validation for Grade - 2 ASCII characters long
	lw $t9, AddressOfGrade
	lbu $t0, 0($t9)			# First character
	lbu $t1, 1($t9)			# Second character
	lbu $t2, 2($t9)			# Third character should be 0
	# First character in range of capital "A" to capital "F"
	blt $t0, 65, Error_call		# If less than 65 - error_call (Capital "A")
	bgt $t0, 70, Error_call		# If greater than 70 - error_call (Capital "F")
	# Second character is "+" or "-" or " "
	beqz $t1, Skip_charSign		# If equal to 0 - skip character check (" ")
	blt $t1, 42, Error_call		# If less than 65 - error_call ("+")
	bgt $t1, 45, Error_call		# If greater than 45 - error_call ("-")
	beq $t1, 44, Error_call		# If equal to 44 - error call (",")
	# Third character
	bnez $t2, Error_call		# If third character not empty - error call
	Skip_charSign:
	
	# Validation for recitation - must be in following set (8,9,10,12,13,14)
	lw $a0, AddressOfRecitation
	li $v0, 84			# atoi
	syscall
	beq $v1, -1, Error_call		# If not successful - error_call
	blt $v0, 8, Error_call		# If less than 8 - error call
	bgt $v0, 14, Error_call		# If greater than 14 - error call
	beq $v0, 11, Error_call		# If equal to 11 - error call
	
	# Validation for favtopics - contains 4 ones or zeros
	lw $t9, AddressOfFavTopics
	lbu $t0, 0($t9)			# First integer as ASCII
	lbu $t1, 1($t9)			# Second integer as ASCII
	lbu $t2, 2($t9)			# Third integer as ASCII
	lbu $t3, 3($t9)			# Fourth integer as ASCII
	lbu $t4, 4($t9)			# Fifth character
	# First integer
	blt $t0, 48, Error_call		# If less than 48 - error_call ("0")
	bgt $t0, 49, Error_call		# If greater than 49 - error_call ("1")
	beqz $t0, Error_call
	# Second integer
	blt $t1, 48, Error_call		# If less than 48 - error_call ("0")
	bgt $t1, 49, Error_call		# If greater than 49 - error_call ("1")
	beqz $t1, Error_call
	# Third integer
	blt $t2, 48, Error_call		# If less than 48 - error_call ("0")
	bgt $t2, 49, Error_call		# If greater than 49 - error_call ("1")
	beqz $t2, Error_call
	# Fourth integer
	blt $t3, 48, Error_call		# If less than 48 - error_call ("0")
	bgt $t3, 49, Error_call		# If greater than 49 - error_call ("1")
	beqz $t3, Error_call
	# Fifth integer
	bnez $t4, Error_call		# If fifth character not empty - error call
	
	# Validate percentile - inclusive range [0.0, 100.0].
	lw $a0, AddressOfPercentile
	li $v0, 85			# atof
	syscall
	beq $v1, -1, Error_call		# If not successful - error_call
	move $t9, $v0			# Moves float to coproc 1 - so it can hold IEE 754 format
	# If less than 0.0
	la $a0, zero			# Loads the number 0 
	li $v0, 85			# atof
	syscall
	beq $v1, -1, Error_call		# If not successful - error_call
	blt $t9, $v0, Error_call	# If less than 0.0 - error call
	# If greater than 100.0
	la $a0, hundred			# Loads the number 100
	li $v0, 85			# atof
	syscall
	beq $v1, -1, Error_call		# If not successful - error_call
	bgt $t9, $v0, Error_call	# If greater than 100.0 - error call
	
	# Part 2
	la $s0, Student_Data		# Load address of student data to $t1
	
	# Check for matching Id
	lw $a0, AddressOfId
	li $v0, 84			# atoi
	syscall
	move $t9, $v0			# Value to update with
	lw $t0, 0($s0)			# Load ID from struct
	beq $v0, $t0, UnchangedId	# If equal - Unchanged
	bne $v0, $t0, UpdatedId		# If not equal - Update
	IdDone:
	
	# Check for matching NetId
	lw $t0, AddressOfNetId		# Argument
	lw $t1, 4($s0)			# Adress of netid
	NetIdLoop:
	lbu $t2, 0($t0)	
	lbu $t3, 0($t1)
	beqz $t2, NetIdUn
	bne $t2, $t3, UpdatedNetId
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j NetIdLoop
	NetIdUn:
	j UnchangedNetId
	NetIdDone:
	
	#Check for matching percentile
	lw $a0, AddressOfPercentile
	li $v0, 85			# atof
	syscall
	move $t9, $v0			# Value to update with
	lw $t0, 8($s0)			# Load percentile from struct
	beq $v0, $t0, UnchangedPercentile	# If equal - Unchanged
	bne $v0, $t0, UpdatedPercentile		# If not equal - Update
	PercentileDone:
	
	#Check for matching grade
	lw $t9, AddressOfGrade
	lbu $t0, 0($t9)			# First character in args
	lbu $t1, 1($t9)			# Second character in args
	lbu $t2, 12($s0)			# First character in struct
	lbu $t3, 13($s0)			# Second character in struct
	bne $t0, $t2, UpdatedGrade	# If not equal - Update
	bne $t1, $t3, UpdatedGrade	# If not equal - Update
	j UnchangedGrade		# If equal - unchanged
	GradeDone:
	
	#Check for matching recitation
	lw $a0, AddressOfRecitation
	li $v0, 84			# atoi
	syscall
	move $t9, $v0			# Value to update with
	lbu $t0, 14($s0)		# Load byte recitation is first 4 bits
	sll $t1, $t0, 28
	srl $t1, $t1, 28
	srl $t2, $t0, 4
	sll $t2, $t2, 4
	beq $t9, $t1, UnchangedRecitation
	bne $t9, $t1, UpdatedRecitation
	RecitationDone:
	
	#Check for matching favtopics
	lbu $t0, 14($s0)		# Load byte favtopics is first 4 bits
	srl $t1, $t0, 4		# Get favtopics
	sll $t3, $t0, 28	# For value update
	srl $t3, $t3, 28	# Shift back
	
	li $t0, 0 			# Sum 
	lw $t9, AddressOfFavTopics
	# First int
	lbu $t2, 0($t9)			# First integer as ASCII
	beq $t2, 48, int2
	addi $t0, $t0, 8
	int2:
	lbu $t2, 1($t9)			# Second integer as ASCII
	beq $t2, 48, int3
	addi $t0, $t0, 4
	int3:
	lbu $t2, 2($t9)			# Third integer as ASCII
	beq $t2, 48, int4
	addi $t0, $t0, 2
	int4:
	lbu $t2, 3($t9)			# Fourth integer as ASCII
	beq $t2, 48, intDone
	addi $t0, $t0, 1
	intDone:
	beq $t1, $t0, UnchangedFavTopics	# If equal - Unchanged
	bne $t1, $t0, UpdatedFavTopics		# If not equal - Update
	FavTopicsDone:
	
	# Print hex
	move $t0, $s0			# Adress of netid
	li $t1, 0
	PrintLoop:
	lbu $a0, 0($t0)	
	bgt $t1, 14 printDone
	li $v0, 34
	syscall
	la $a0, newline			# Newline string 
	li $v0, 4			# Print 
	syscall
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j PrintLoop
	printDone:
	
	# Exit the program
	li $v0, 10
	syscall
	
	# Labels
	# If theres an error case this label is used to show error and exit
	Error_call:	
	la $a0, err_string		# Error string
	li $v0, 4			# Print string
	syscall
	li $v0, 10			# Exit program
	syscall
	
	# Match Id Labels
	UnchangedId:	
	la $a0, unchanged_Id		# Unchanged ID string 
	li $v0, 4			# Print String
	syscall
	j IdDone			# Jump to IdDone
	
	UpdatedId:	
	la $a0, updated_Id		# Updated ID string
	li $v0, 4			# Print string
	syscall
	sw $t9, 0($s0)			# Update Id
	j IdDone			# Jump to IdDone
	
	# Match NetId Labels
	UnchangedNetId:	
	la $a0, unchanged_NetId		# Unchanged NetId string 
	li $v0, 4			# Print String
	syscall
	j NetIdDone
	
	UpdatedNetId:	
	la $a0, updated_NetId		# Unchanged NetId string 
	li $v0, 4			# Print String
	syscall
	lw $t0, AddressOfNetId	
	sw $t0, 4($s0)
	j NetIdDone
	
	# Match Percentile Labels
	UnchangedPercentile:	
	la $a0, unchanged_Percentile	# Unchanged Percentile string 
	li $v0, 4			# Print String
	syscall
	j PercentileDone
	
	UpdatedPercentile:	
	la $a0, updated_Percentile	# Unchanged Percentile string 
	li $v0, 4			# Print String
	syscall
	sw $t9, 8($s0)			# Update percentile
	j PercentileDone
	
	# Match Grade Labels
	UnchangedGrade:	
	la $a0, unchanged_Grade		# Unchanged Grade string 
	li $v0, 4			# Print String
	syscall
	j GradeDone
	
	UpdatedGrade:	
	la $a0, updated_Grade		# Unchanged Grade string 
	li $v0, 4			# Print String
	syscall
	sb $t0, 12($s0)
	sb $t1, 13($s0)
	j GradeDone
	
	# Match Recitation Labels
	UnchangedRecitation:	
	la $a0, unchanged_Recitation	# Unchanged Recitation string 
	li $v0, 4			# Print String
	syscall
	j RecitationDone
	
	UpdatedRecitation:	
	la $a0, updated_Recitation	# Unchanged Recitation string 
	li $v0, 4			# Print String
	or $t0, $t2, $t9
	sb $t0, 14($s0)
	syscall
	j RecitationDone
	
	# Match FavTopics Labels
	UnchangedFavTopics:	
	la $a0, unchanged_FavTopics	# Unchanged FavTopics string 
	li $v0, 4			# Print String
	syscall
	j FavTopicsDone
	
	UpdatedFavTopics:	
	la $a0, updated_FavTopics	# Unchanged FavTopics string 
	li $v0, 4			# Print String
	sll $t1, $t0, 4				# Shift back 
	or $t4, $t1, $t3
	sb $t4, 14($s0)
	syscall
	j FavTopicsDone
