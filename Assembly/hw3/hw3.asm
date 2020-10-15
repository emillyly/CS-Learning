# Homework 3
# Name: Emilly Ly
# Net ID: ely
# SBU ID: 111097939

##################################
# Part 1 - String Functions
##################################

is_whitespace:
	# $a0: c - Character to check.
	lbu $t0, null_char
	beq $a0, $t0, is_white			# Is null char
	lbu $t0, newline_char
	beq $a0, $t0, is_white			# Is newline char
	lbu $t0, space_char
	beq $a0, $t0, is_white			# Is space char
	
	not_white:				
		li $v0, 0			# Return: 0 if not a whitespace
		jr $ra
	is_white:				
		li $v0, 1			# Return: 1 if is a whitespace
		jr $ra

cmp_whitespace:
	# $a0: c1 - First character.
	# $a1: c2 - Second character.
	# returns - If both c1 and c2 are whitespace characters return 1 otherwise return 0.
	addi $sp, $sp, -8			# Shift stack pointer - save s registers to stack
    	sw $s0, 0($sp)				# For first c
    	sw $ra, 4($sp)				# Save $ra
    	
    	move $s0, $a0				# Keep $a0 to put back later
    	jal is_whitespace				# Check if first character is whitespace
    	beqz $v0, not_both_white		# If first character result is 0 (not white) then not both white
    	move $a0, $a1
    	beq $v0, 1, is_both_white		# If second character result is 1 (white) then both white
    	not_both_white:				
		li $v0, 0			# Return: 0 if not both whitespace
		j end_cmp_white
	is_both_white:				
		li $v0, 1			# Return: 1 if both are whitespace
	end_cmp_white:				
		move $a0, $s0			# Move $a0 back
		lw $s0, 0($sp)			# Put back saved register
    		lw $ra, 4($sp)		
		addi $sp, $sp, 8
		jr $ra

strcpy:
	# $a0: src - The address the string is copied from.
        # $a1: dest - The address the string is copied to.
        # #a2: n - Number of bytes to copy from src to dest.
        ble $a0, $a1, end_strcpy
        move $t0, $a0				# String address to be copied from
        move $t1, $a1				# String address to be copied to
        move $t2, $a2				# Number of bytes
        copyLoop:
        	lb $t3, ($t0)			# Load byte to store
       		sb $t3, ($t1)			# Store byte
        	addi $t2, $t2, -1		# Decrease count of number of bytes
        	beqz $t2, end_strcpy		# Exit: If number of bytes is 0 then end
        	addi $t0, $t0, 1		# Change the address to copy by 1 byte
        	addi $t1, $t1, 1		# Change the address to store by 1 byte
        	j copyLoop			# Loop
        end_strcpy:				# End copying
		jr $ra

strlen:
	# $a0: s - String to calculate the length of
	addi $sp, $sp, -16			# Shift stack pointer - save s registers to stack
    	sw $s0, 0($sp)				# For saving string address
    	sw $s1, 4($sp)				# For using string address
    	sw $s2, 8($sp)				# For length
    	sw $ra, 12($sp)				# Save $ra
    	move $s0, $a0				# Keep $a0 to put back later 
    	move $s1, $a0				# Address to count from
    	li $s2, 0				# Start length count at 0
    	lenLoop:
    		lb $a0, ($s1)
    		jal is_whitespace			# Check if whitespace
    		beq $v0, 1, end_strlen		# Exit: If is whitespace then end
    		addi $s2, $s2, 1		# Not whitespace so add to length count
    		addi $s1, $s1, 1		# Change the address by 1 byte
    		j lenLoop			# Loop
	end_strlen:
		move $v0, $s2			
		move $a0, $s0			# Move $a0 back	
		lw $s0, 0($sp)			# Put back saved register
		lw $s1, 4($sp)
		lw $s2, 8($sp)
    		lw $ra, 12($sp)		
		addi $sp, $sp, 16
		jr $ra

##################################
# Part 2 - vt100 MMIO Functions
##################################

set_state_color:
	# $a0: state - The address of the state struct representing the current state.
	# $a1: color - The byte describing the VT100 color in the VT100 color format.
	# $a2: category - The color category that is being set (0 is default, 1 is highlight).
	# $a3: mode - The mode specifies if the foreground, background or both colors are set.
	add $t9, $a0, $a2		# If category is 1 then address need to be moved 1 byte
	lbu $t0, 0($t9)
	beq $a3, 2, setBg		# If mode is 2 then only set background
	sll $t1, $a1, 28		# Get the color of fg
	srl $t1, $t1, 28		# Shift back
	srl $t0, $t0, 4			# Shift the fg color out
	sll $t0, $t0, 4			# Shift back
	or $t0, $t0, $t1		# Set fg
	sb $t0, 0($t9)
	beq $a3, 1, doneSetStateColor	# If mode is 1 then only set foreground
	srl $t1, $a1, 4			# Get the color of bg
	sll $t1, $t1, 4			# Shift back
	sll $t2, $t0, 28		# Save the fg color to put back
	srl $t2, $t2, 28		# Shift back
	srl $t0, $t0, 8			# Shift all the color out
	sll $t0, $t0, 8			# Shift back
	or $t0, $t0, $t1		# Put the bg color in 
	or $t0, $t0, $t2		# Put the fg color back
	sb $t0, 0($t9)
	j doneSetStateColor
	setBg:
		sll $t1, $a1, 4			# Shift back
		sll $t2, $t0, 28		# Save the fg color to put back
		srl $t2, $t2, 28		# Shift back
		srl $t0, $t0, 8			# Shift all the color out
		sll $t0, $t0, 8			# Shift back
		or $t0, $t0, $t1		# Put the bg color in 
		or $t0, $t0, $t2		# Put the fg color back
		sb $t0, 0($t9)
	doneSetStateColor:
		jr $ra

save_char:
	# $a0: state - The address of the state struct representing the current state.
	# $a1: c - The character to put at the cursor’s position.
	li $t0, 0xFFFF0000		# Starting address
	lbu $t1, 2($a0) 		# Load byte of cursor x
	lbu $t2, 3($a0)			# Load byte of cursor y
	li $t3, 80			# Num of columns 
	mul $t1, $t1, $t3		# Multiply row number by number of columns
	add $t1, $t1, $t2		# Add col number
	li $t3, 2			# Element size in bytes
	mul $t1, $t1, $t3		# Multiply by element size in bytes
	add $t0, $t0, $t1		# Add everything to base address
	sb $a1, 0($t0)			# Store byte
	jr $ra

reset:
	# $a0: state - The address of the state struct representing the current state.
	# $a1: color_only - If 1, clear color only, otherwise, clear both color and ASCII.
	lbu $t0, 0($a0) 		# Get the default color
	li $t1, 0 			# Count of elements till 2000
	li $t2, 0xFFFF0000		# Starting address
	li $t3, 0			# 0 for null character
	beqz $a1, resetBothLoop		# If color only is 0 then reset both
	resetColorLoop: 
		beq $t1, 2000, doneReset
		sb $t0, 1($t2)		# Set color to default
		addi $t1, $t1, 1	# Add to count
		addi $t2, $t2, 2	# Add 2 bytes to address
		j resetColorLoop
		
	resetBothLoop:
		beq $t1, 2000, doneReset
		sb $t3, 0($t2)		# Set character to null
		sb $t0, 1($t2)		# Set color to default
		addi $t1, $t1, 1	# Add to count
		addi $t2, $t2, 2	# Add 2 bytes to address
		j resetBothLoop
	doneReset:
		jr $ra

clear_line:
	# $a0: x - The row on the VT100 display.
	# $a1: y - The column on the VT100 display.
	# $a2: color - The color to set the VT100 cells to.
	li $t0, 0xFFFF0000		# Starting address
	li $t2, 80			# Num of columns 
	mul $t1, $a0, $t2		# Multiply row number by number of columns
	add $t1, $t1, $a1		# Add col number
	li $t2, 2			# Element size in bytes
	mul $t1, $t1, $t2		# Multiply by element size in bytes
	add $t0, $t0, $t1		# Add everything to base address
	
	move $t1, $a1			# For count
	li $t2, 0 			# For null character
	clearLoop:
		beq $t1, 79, doneClear		# Count is up to 79 then done
		sb $t2, 0($t0)			# Store null character
		sb $a2, 1($t0)			# Change color
		addi $t1, $t1, 1		# Add 1 to count
		addi $t0, $t0, 2		# Add 2 bytes to address
		j clearLoop
	doneClear:
		jr $ra

set_cursor:
	# $a0: state - The address of the state struct representing the current state.
	# $a1: x - New row value for the cursor.
	# $a2: y - New column value for the cursor.
	# $a3: initial - If initial is set to 1 then the cursor is not cleared first, otherwise it is
	beq $a3, 1, setCursor 		# If initial is 1 then do not clear first
	li $t0, 0xFFFF0000		# Starting address
	lbu $t1, 2($a0) 		# Load byte of cursor x
	lbu $t2, 3($a0)			# Load byte of cursor y
	li $t3, 80			# Num of columns 
	mul $t1, $t1, $t3		# Multiply row number by number of columns
	add $t1, $t1, $t2		# Add col number
	li $t3, 2			# Element size in bytes
	mul $t1, $t1, $t3		# Multiply by element size in bytes
	add $t0, $t0, $t1		# Add everything to base address
	lbu $t3, 1($t0)			# Load color byte
	xori $t3, $t3, 136		# Flip bold bits
	sb $t3, 1($t0)			# Store color back 
	setCursor:
		sb $a1, 2($a0)			# Set x cursor to new x
		sb $a2, 3($a0)			# Set y cursor to new y
		li $t0, 0xFFFF0000		# Starting address
		li $t3, 80			# Num of columns 
		mul $t1, $a1, $t3		# Multiply row number by number of columns
		add $t1, $t1, $a2		# Add col number
		li $t3, 2			# Element size in bytes
		mul $t1, $t1, $t3		# Multiply by element size in bytes
		add $t0, $t0, $t1		# Add everything to base address
		lbu $t3, 1($t0)			# Load color byte
		xori $t3, $t3, 136		# Flip bold bits
		sb $t3, 1($t0)			# Store color back 
		jr $ra
	
move_cursor:
	# $a0: state - The address of the state struct representing the current state.
	# $a1: direction - The ASCII letter specifying the direction to move the cursor in.
	addi $sp, $sp, -4			# Shift stack pointer - save s registers to stack
    	sw $ra, 0($sp)				# Save $ra
	lbu $t0, 2($a0) 		# Load byte of cursor x
	lbu $t1, 3($a0)			# Load byte of cursor y
	beq $a1, 104, left		# h - left
	beq $a1, 106, down		# j - down
	beq $a1, 107, up		# k - up
	beq $a1, 108, right		# l - right
	left:
		beqz $t1, doneMove
		addi $t1, $t1, -1
		move $a1, $t0
		move $a2, $t1
		li $a3, 0
		jal set_cursor
		j doneMove
	down:
		addi $t0, $t0, 1
		beq $t0, 25 doneMove
		move $a1, $t0
		move $a2, $t1
		li $a3, 0
		jal set_cursor
		j doneMove
	up:
		beqz $t0, doneMove
		addi $t0, $t0, -1
		move $a1, $t0
		move $a2, $t1
		li $a3, 0
		jal set_cursor
		j doneMove
	right:
		addi $t1, $t1, 1
		beq $t1, 80 doneMove
		move $a1, $t0
		move $a2, $t1
		li $a3, 0
		jal set_cursor
	doneMove:
		lw $ra, 0($sp)			# Put back saved register
		addi $sp, $sp, 4
		jr $ra

mmio_streq:
	# $a0: mmio - Address of the start of the MMIO string.
	# $a1: b - The regular string that the MMIO string should be compared to.
	# returns: 1 if strings are equal, 0 if they are not.
	addi $sp, $sp, -16			# Shift stack pointer - save s registers to stack
    	sw $s0, 0($sp)				# For mmio address
    	sw $s1, 4($sp)				# For string address
    	sw $s2, 8($sp)				# For count
    	sw $ra, 12($sp)				# Save $ra
    	move $s0, $a0				# Adress of mmio
    	move $s1, $a1				# Adress of string
    	move $a0, $a1
    	jal strlen
    	move $s2, $v0
    	mmioLoop:
    		beqz $s2, areEqual
    		lbu $t0, 0($s0)				# Load character of mmio
    		lbu $t1, 0($s1)				# Load character of string
    		move $a0, $t0				# First charater arg
    		move $a1, $t1				# Second character arg
    		jal cmp_whitespace
    		beqz $v0, notEqual			# Not both white space
    		bne $t0, $t1, notEqual			# Not the same character
    		addi $s0, $s0, 2			# Increase mmio by 2 bytes
    		addi $s1, $s1, 1			# Increase string by 1 byte
    		addi $s2, $s2, -1
    		j mmioLoop
    	notEqual:				# Strings are not equal
    		li $v0, 0				
    		j endMmio				# String are equal
    	areEqual:
    		li $v0, 1				
	endMmio:
		lw $s0, 0($sp)			# Put back saved register
		lw $s1, 4($sp)
    		lw $s2, 8($sp)				
    		lw $ra, 12($sp)				
		addi $sp, $sp, 16
		jr $ra

##################################
# Part 3 - UI/UX Functions
##################################

handle_nl:
	# $a0: state - The address of the state struct representing the current state.
	addi $sp, $sp, -8			# Shift stack pointer - save s registers to stack
    	sw $s0, 0($sp)				# For mmio address
    	sw $ra, 4($sp)				# Save $ra
	move $s0, $a0
	lbu $a0, 2($s0)				# x cursor
	lbu $a1, 3($s0)				# y cursor
	lbu $a3, 0($s0)				# default color
	jal clear_line				# clear
	move $a0, $s0				# state
	lbu $a1, newline_char			# newline character
	jal save_char				# save newline
	lbu $t0, 2($s0)				# x cursor
	beq $t0, 24, lastRow
	move $a0, $s0
	lbu $a1, 2($s0)
	addi $a1, $a1, 1
	li $a2, 0
	jal set_cursor
	j endNl
	lastRow:
		move $a0, $s0
		lbu $a1, 2($s0)
		li $a2, 0
		jal set_cursor
	endNl:
		lw $s0, 0($sp)			# Put back saved register
		lw $ra, 4($sp)		
		addi $sp, $sp, 8
		jr $ra
handle_backspace:
	# $a0: state - The address of the state struct representing the current state.
	addi $sp, $sp, -8			# Shift stack pointer - save s registers to stack
    	sw $s0, 0($sp)				# Save state
    	sw $ra, 4($sp)				# Save $ra
    	move $s0, $a0
	li $t0, 0xFFFF0000		# Starting address
	lbu $t1, 2($s0) 		# Load byte of cursor x
	lbu $t2, 3($s0)			# Load byte of cursor y
	li $t3, 80			# Num of columns 
	mul $t1, $t1, $t3		# Multiply row number by number of columns
	add $t1, $t1, $t2		# Add col number
	li $t3, 2			# Element size in bytes
	mul $t1, $t1, $t3		# Multiply by element size in bytes
	add $t0, $t0, $t1		# Add everything to base address
	li $t9, 2
	mul $a2, $t2, $t9
	li $t9, 158
	subu $a2, $t9, $a2
	move $a1, $t0
	addi $a0, $t0, 2
	jal strcpy
	li $t0, 0xFFFF0000		# Starting address
	lbu $t1, 2($s0) 		# Load byte of cursor x
	li $t2, 79			# Load byte of cursor y
	li $t3, 80			# Num of columns 
	mul $t1, $t1, $t3		# Multiply row number by number of columns
	add $t1, $t1, $t2		# Add col number
	li $t3, 2			# Element size in bytes
	mul $t1, $t1, $t3		# Multiply by element size in bytes
	add $t0, $t0, $t1		# Add everything to base address
	lbu $t3, 0($s0)			# Load color byte
	sb $t3, 1($t0)			# Store color back 
	lbu $t3, newline_char
	sb $t3, 0($t0)
	lw $s0, 0($sp)			# Put back saved register	
	lw $ra, 4($sp)			
	addi $sp, $sp, 8
	jr $ra
highlight:
	# $a0: x - Row of starting location.
	# $a1: y - Column of starting location.
	# $a2: color - The VT100 color that should be set.
	# $a3: n - The number of VT100 cells that should be highlighted.
	li $t0, 0xFFFF0000		# Starting address
	li $t2, 80			# Num of columns 
	mul $t1, $a0, $t2		# Multiply row number by number of columns
	add $t1, $t1, $a1		# Add col number
	li $t2, 2			# Element size in bytes
	mul $t1, $t1, $t2		# Multiply by element size in bytes
	add $t0, $t0, $t1		# Add everything to base address
	highlightLoop:
		beqz $a3, doneHighlight	# Count is up to 79 then done
		sb $a2, 1($t0)			# Change color
		addi $a2, $a2, -1		# Subtract 1 to count
		addi $t0, $t0, 2		# Add 2 bytes to address
		j clearLoop
	doneHighlight:
		jr $ra

highlight_all:
	# $a0: byte color
	# $a1: String[] dictionary
	addi $sp, $sp, -28			# Shift stack pointer - save s registers to stack
    	sw $s0, 0($sp)				# For address
    	sw $s1, 4($sp)				# For byte color
    	sw $s2, 8($sp)				# For String[] dictionary
    	sw $s3, 12($sp)				# For String[] dictionary loop
    	sw $s4, 16($sp)				# x cursor
    	sw $s5, 20($sp)				# y cursor
    	sw $ra, 24($sp)				# Save $ra
    	li $s0, 0xFFFF0000
    	move $s1, $a0
    	move $s2, $a1
    	li $s4, 0
    	li $s5, 0
    	notEndLoop:
    		li $t0, 0xFFFF0F9C
    		bgt $s0, $t0, endHighlightAll
    		lbu $a0, 0($s0)
    		jal is_whitespace		# If whitespace then next cell
    		bnez $v0, next	
    		move $s3, $s2
    		matchLoop:
    			lw $a1, 0($s3)		# Word from dict
    			beqz $a1, next		# If word from dict is 0 then next
    			move $a0, $s0		# Cell address
    			jal mmio_streq
    			beqz $v0, jMatchLoop
    			move $a0, $a1
    			jal strlen
			add $s0, $s0, $v0
			add $s0, $s0, $v0
    			move $a0, $s4
    			move $a1, $s5
    			move $a2, $s1
    			move $a3, $v0
    			jal highlight
    			j end
    			jMatchLoop:
    				addi $s3, $s3, 4
    				j matchLoop
    		next:
    			beq $s5, 79, addX
    			addi $s5, $s5, 1
    			addi $s0, $s0, 2
    		addX:
    			addi $s4, $s4, 1
    			li $s5, 0
    			addi $s0, $s0, 2		
    		end:	
    			j notEndLoop
    	endHighlightAll:
		lw $s0, 0($sp)			# Put back saved register
		lw $s1, 4($sp)				
    		lw $s2, 8($sp)				
    		lw $s3, 12($sp)				
    		lw $s4, 16($sp)				
    		lw $s5, 20($sp)				
    		lw $ra, 24($sp)						
		addi $sp, $sp, 28
		jr $ra

.data

null_char: .asciiz "\0"
newline_char: .asciiz "\n"
space_char: .asciiz " "
	
.align 2  # Align next items to word boundary
