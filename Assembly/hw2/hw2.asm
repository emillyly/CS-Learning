# Homework #2
# name: Emilly Ly
# sbuid: 111097939

# There should be no .data section in your homework!

.text

###############################
# Part 1 functions
###############################
recitationCount:
	# $a0: class - starting address of the 1D array of students in the class.
	# $a1: classSize - number of entries in class array.
	# $a2: rnum - recitation number.
	blez $a1, rCountError		# Error if classSize is <= 0
	blt $a2, 8, rCountError		# If less than 8 - error call
	bgt $a2, 14, rCountError	# If greater than 14 - error call
	beq $a2, 11, rCountError	# If equal to 11 - error call	
	move $t0, $a0			# Class move to $t0
	move $t1, $a1			# Class size move to $t1
	li $v0, 0			# Counter
	rCountLoop:
		lbu $t9, 14($t0)		# Load byte recitation is first 4 bits
		sll $t9, $t9, 28		# Shift for recitation only
		srl $t9, $t9, 28		# Shift back
		blt $t9, 8, rCountError		# If less than 8 - error call
		bgt $t9, 14, rCountError	# If greater than 14 - error call
		beq $t9, 11, rCountError	# If equal to 11 - error call
		beq $t9, $a2, addRCount		# If recitation number is same as rnum
		doneAddRCount:
		addi $t0, $t0, 16		# Add 16 byte for next student
		addi $t1, $t1, -1		# Decrease class size
		beqz $t1, rCountDone		# If class size is zero then done
		j rCountLoop			
	addRCount:
		addi $v0, $v0, 1		# Add 1 to count
		j doneAddRCount
	rCountError:
		li $v0, -1
		jr $ra
	rCountDone:
		jr $ra
	
aveGradePercentage:
	# $a0: histogram - address of 1D array of integers specifying the number of students with each grade.
	# $a1: gradepoints - address of 1D array of floats specifying the gradepoint values
	move $t0, $a0			# Histogram Address
	move $t1, $a1			# Gradepoints Address
	li $t2, 0 			# Counter for array
	li $t3, 0			# Histogram Count
	mtc1 $t3, $f0			# Total - start at 0 in floating register
	gPercentageLoop:
		lw $t9, ($t0)			# Load from histogram array
		lw $t8, ($t1)			# Load from gradepoints array	
		add $t3, $t3, $t9		# Add to histogram count
		bltz $t9, gPercentageError	# Error if histogram is a negative value
		bltz $t8, gPercentageError	# Error if gradepoint is a negative value
		mtc1 $t9, $f1			# Move histogram value to floating register
		cvt.s.w $f1, $f1		# Convert from word to single 
		mtc1 $t8, $f2			# Move from gradepoint to floating register
		mul.s $f3, $f2, $f1		# Multiply gradepoint val with histogram val
		add.s $f0, $f0, $f3		# Add value to total
		addi $t2, $t2, 1		# Add 1 to the count for array
		beq $t2, 12, gPercentageDone	# If count is 12 then loop is done
		addi $t0, $t0, 4		# Add 4 bytes to histogram address
		addi $t1, $t1, 4		# Add 4 bytes to gradepoint address
		j gPercentageLoop		# Loop again
	gPercentageError:
		li $v0, 0xBF800000		# Floating point value for -1
		jr $ra
	gPercentageDone:
		beqz $t3, gPercentageError	# Error if histogram total is 0 
		mtc1 $t3, $f4			# Move from register to floating register
		cvt.s.w $f4, $f4		# Convert from word to single 
		div.s $f0, $f0, $f4		# Divide total by histogram total
		mfc1 $v0, $f0			# Move value to $v0
		jr $ra

favtopicPercentage:
	# $a0: class - starting address of the 1D array of students in the class.
	# $a1: classSize - number of entries in class array.
	# $a2: topics - bit vector specifying topics to consider
	blez $a1, topicPercentageError		# Error if classSize is <= 0
	blt $a2, 1, topicPercentageError
	bgt $a2, 15, topicPercentageError
	move $t0, $a0				# Class move to $t0
	move $t1, $a1				# Class size move to $t1
	li $t2, 0				# Counter for students
	topicPercentageLoop:
		lbu $t9, 14($t0)		# Load byte favtopics is first 4 bits
		srl $t9, $t9, 4			# Get favtopics
		and $t8, $t9, $a2		# Check if any topics are the ones specified
		bnez $t8, addTopicCount		# If recitation number is same as rnum
		doneAddTopicCount:
		addi $t0, $t0, 16		# Add 16 byte for next student
		addi $t1, $t1, -1		# Decrease class size
		beqz $t1, topicPercentageDone	# If class size is zero then done
		j topicPercentageLoop			
	addTopicCount:
		addi $t2, $t2, 1		# Add 1 to count
		j doneAddTopicCount
	topicPercentageError:
		li $v0, 0xBF800000		# Floating point value for -1
		jr $ra
	topicPercentageDone:
		mtc1 $t2, $f0			# Move from register to floating register
		cvt.s.w $f0, $f0		# Convert from word to single 
		mtc1 $a1, $f1			# Move from register to floating register
		cvt.s.w $f1, $f1		# Convert from word to single 
		div.s $f2, $f0, $f1
		mfc1 $v0, $f2
		jr $ra

findFavtopic:
   	addi $sp, $sp, -16		# Shift stack pointer - save s registers to stack
    	sw $s0, 0($sp)			# For 1's place
    	sw $s1, 4($sp)			# For 2's place
    	sw $s2, 8($sp)			# For 4's place
    	sw $s3, 12($sp)			# For 8's place
	# $a0: class - starting address of the 1D array of students in the class.
	# $a1: classSize - number of entries in class array.
	# $a2: topics - bit vector specifying topics to consider
	blez $a1, faveTopicError		# Error if classSize is <= 0
	blt $a2, 1, faveTopicError
	bgt $a2, 15, faveTopicError
	move $t0, $a0				# Class move to $t0
	move $t1, $a1				# Class size move to $t1
	andi $s0, $a2, 1			# 1's
	andi $s1, $a2, 2			# 2's
	andi $s2, $a2, 4			# 4's
	andi $s3, $a2, 8			# 8's
	li $t9, 0				# Counter for 1
	li $t8, 0				# Counter for 2
	li $t7, 0				# Counter for 4
	li $t6, 0				# Counter for 8
	faveTopicLoop:
		lbu $t5, 14($t0)		# Load byte favtopics is first 4 bits
		srl $t5, $t5, 4			# Get favtopics
		# 1's
		and $t4, $t5, $s0		# Check for 1	
		bnez $t4, addTo1		# If not 0 then add to 1
		doneAddTo1:
		# 1's
		and $t4, $t5, $s1		# Check for 2			
		bnez $t4, addTo2		# If not 0 then add to 2
		doneAddTo2:
		# 2's
		and $t4, $t5, $s2		# Check for 4			
		bnez $t4, addTo4		# If not 0 then add to 3
		doneAddTo4:
		# 4's
		and $t4, $t5, $s3		# Check for 8			
		bnez $t4, addTo8		# If not 0 then add to 4
		doneAddTo8:
		# 8's
		addi $t0, $t0, 16		# Add 16 byte for next student
		addi $t1, $t1, -1		# Decrease class size
		beqz $t1, faveTopicDone		# If class size is zero then done
		j faveTopicLoop
		
	addTo1:
		addi $t9, $t9, 1		# Add to count for 1's
		j doneAddTo1
	addTo2:
		addi $t8, $t8, 1		# Add to count for 2's
		j doneAddTo2
	addTo4:
		addi $t7, $t7, 1		# Add to count for 4's
		j doneAddTo4
	addTo8:
		addi $t6, $t6, 1		# Add to count for 8's
		j doneAddTo8
	faveTopicError:
		li $v0, -1
		j faveTopicDone2
	faveTopicDone:
		add $t0, $t9, $t8		# Check for any fave topics
		add $t0, $t0, $t7
		add $t0, $t0, $t6
		beqz $t0, faveTopicError	# If noone has a favetopic then error
		# Compare 8
		blt $t6, $t7, next4
		blt $t6, $t8, next4
		blt $t6, $t9, next4
		j Compare8
		# Compare 4
		next4:
		blt $t7, $t8, next2
		blt $t7, $t9, next2
		j Compare4
		# Compare 2
		next2:
		blt $t8, $t9, Compare1
		j Compare2
		Compare1:			# Set fave topic
			move $v0, $s0
			j faveTopicDone2
		Compare2:
			move $v0, $s1
			j faveTopicDone2
		Compare4:
			move $v0, $s2
			j faveTopicDone2
		Compare8:
			move $v0, $s3
			j faveTopicDone2
	faveTopicDone2:
		# Put back saved register
		lw $s0, 0($sp)
    		lw $s1, 4($sp)
    		lw $s2, 8($sp)
    		lw $s3, 12($sp)			
		addi $sp, $sp, 16
		jr $ra


###############################
# Part 2 functions
###############################

twoFavtopics:
	addi $sp, $sp, -8		# Shift stack pointer - save s registers to stack
    	sw $s0, 0($sp)			# Save $v0
    	sw $ra, 4($sp)			# Save $ra
    	
    	blez $a1, twoFavTopicError	# Error if classSize is <= 0
    	li $a2, 15			# Check all topics
    	jal findFavtopic		# First fave topic
    	bltz $v0, twoFavTopicError	# Error if no favtopic
    	move $s0, $v0			# Save fave topic
    	subu $a2, $a2, $v0		# Subtract first fave topic
    	jal findFavtopic		# Second fave topic
    	move $v1, $v0			# Move second fave topic to v1
    	move $v0, $s0			# Move first fave topic back in place
    	j twoFavTopicDone
    		
    	twoFavTopicError:
    		li $v0, -1
    		li $v1, -1
    		
    	twoFavTopicDone:
    		lw $s0, 0($sp)			# Put registers back
    		lw $ra, 4($sp)			
		addi $sp, $sp, 8
		jr $ra

calcAveClassGrade:
	addi $sp, $sp, -20		# Shift stack pointer - save s registers to stack
    	sw $s0, 0($sp)			# For class
    	sw $s1, 4($sp)			# For classSize
    	sw $s2, 8($sp)			# For histogram address
    	sw $s3, 12($sp)			# For gradepoints
    	sw $ra, 16($sp)			# Save $ra
	# $a0: class - starting address of the 1D array of students in the class.
	# $a1: classSize - number of entries in class array.
	# $a2: histogram - starting address of a 1D array in memory to hold the histogram counts.
	# $a3: gradepoints - 1D array of float specifying the gradepoint values.
	move $s0, $a0			# Class
	move $s1, $a1			# Class size
	move $s2, $a2			# Histogram
	move $s3, $a3			# Gradepoints
	blez $a1, aveClassGradeError	# Error if classSize is <= 0
	move $t0, $a2
	li $t1, 12
	li $t2, 0
	setZeroLoop:
		sw $t2, ($t0)
		addi $t0, $t0, 4		# Add 16 byte for next student
		addi $t1, $t1, -1		# Decrease count
		beqz $t1, setZeroLoopDone	# If class size is zero then done
		j setZeroLoop
	setZeroLoopDone:
	histogramLoop:
		lhu $t0, 12($s0)		# Get grade of student
		move $a0, $t0			# Move grade to argument register
		jal getGradeIndex		# Find index of grade
		bltz $v0, aveClassGradeError	# Error if error
		sll $t0, $v0, 2 		# Index * 4 
		add $t0, $s2, $t0		# Add product to histogram address
		lw $t1, ($t0)			# Load number at address
		addi $t1, $t1, 1		# Add 1 to the count
		sw $t1, ($t0)			# Update count
		addi $s0, $s0, 16		# Add 16 byte for next student
		addi $s1, $s1, -1		# Decrease class size
		beqz $s1, histogramLoopDone	# If class size is zero then done
		j histogramLoop
	histogramLoopDone:
		move $a0, $s2
		move $a1, $s3
		jal aveGradePercentage 
		j aveClassGradeDone
	aveClassGradeError:
		li $v0, 0xBF800000		# Floating point value for -1
	aveClassGradeDone:
    		lw $s0, 0($sp)			# Put registers back
    		lw $s1, 4($sp)
    		lw $s2, 8($sp)
    		lw $s3, 12($sp)
    		lw $ra, 16($sp)			
		addi $sp, $sp, 20
		jr $ra

updateGrades:
	addi $sp, $sp, -16		# Shift stack pointer - save s registers to stack
    	sw $s0, 0($sp)			# For class
    	sw $s1, 4($sp)			# For classSize
    	sw $s2, 8($sp)			# For cutoffs
    	sw $ra, 12($sp)			# Save $ra
	# $a0: class - starting address of the 1D array of students in the class.
	# $a1: classSize - number of entries in class array.
	# $a2: histogram - starting address of a 1D array in memory to hold the histogram counts.
	# $a3: gradepoints - 1D array of float specifying the gradepoint values.
	move $s0, $a0			# Class
	move $s1, $a1			# Class size
	move $s2, $a2			# Cutoffs
	blez $a1, updateGradesError	# Error if classSize is <= 0
	move $t0, $s2		# Cuttoff array
	move $t1, $s1
	validCutOffLoop:
		lw $t2, ($t0)
		addi $t0, $t0, 4
		lw $t3, ($t0)
		ble $t2, $t3, updateGradesError
		addi $t1, $t1, -1
		beqz $t1, updateGradesLoop
		j validCutOffLoop
	updateGradesLoop:
		lw $t0, 8($s0)		# Gets student percentile
		move $t1, $s2		# Cuttoff array
		li $t2, 0		# Index
		cutOffLoop:
			lw $t3, ($t1)
			bge $t0, $t3, doneCutOffLoop
			addi $t1, $t1, 4
			addi $t2, $t2, 1
			bgt $t2, 11, updateGradesError
			j cutOffLoop
		doneCutOffLoop:
		move $a0, $t2
		jal getGrade
		bltz $v0, updateGradesError
		sh $v0, 12($s0)
		addi $s0, $s0, 16		# Add 16 byte for next student
		addi $s1, $s1, -1		# Decrease class size
		beqz $s1, updateGradesSuccess	# If class size is zero then done
		j updateGradesLoop
	updateGradesError:
		li $v0, -1
		j updateGradesDone
	updateGradesSuccess:
		li $v0, 0
	updateGradesDone:
    		lw $s0, 0($sp)			# Put registers back
    		lw $s1, 4($sp)
    		lw $s2, 8($sp)
    		lw $ra, 12($sp)	
		addi $sp, $sp, -16
		jr $ra
	jr $ra

###############################
# Part 3 functions
###############################

find_cheaters:
	addi $sp, $sp, -20		# Shift stack pointer - save s registers to stack
    	sw $s0, 0($sp)			# For room
    	sw $s1, 4($sp)			# For row
    	sw $s2, 8($sp)			# For cols
    	sw $s3, 12($sp)			# For cheaters
    	sw $ra, 16($sp)			# Save $ra
    	# $a0: class - starting address of the 1D array of students in the class.
	# $a1: classSize - number of entries in class array.
	# $a2: histogram - starting address of a 1D array in memory to hold the histogram counts.
	# $a3: gradepoints - 1D array of float specifying the gradepoint values.
    	move $s0, $a0			# Room
	move $s1, $a1			# Row
	move $s2, $a2			# Col
	move $s3, $a3			# Cheaters
	blez $a1, cheatersError		# Error if row is <= 0
	blez $a2, cheatersError		# Error if col is <= 0
    	li $t9, 0 			# Cheaters
	li $t8, 0 			# Students
    	li $t0, 0			# Row - i
    	loopRows:
    		li $t1, 0			# Col - j
    		loopCols:
    			mul $t7, $t0, $s2
    			add $t7, $t7, $t1
    			li $t5, 8
    			mul $t7, $t7, $t5
    			add $t7, $t7, $s0
    			lw $t6, ($t7)		# Grade
    			lw $t5, 4($t7)
    			beqz $t5, loopColsDone
    			addi $t8, $t8, 1	# Increase student
    			lw $t5, 4($t5)		# Netid
    			beqz $t0, topCheck
    			addi $t2, $s1, -1
    			beq $t0, $t2, bottomCheck
    			beqz $t1, leftCheck
    			addi $t2, $s2, -1
    			beq $t1, $t2, rightCheck
    			j else
    			topCheck:
    				beqz $t1, topCorner
    				addi $t2, $s1, -1
    				beq $t1, $t2, topRightCorner
    				jal check3
    				jal check4
    				jal check5
    				jal check6
    				jal check7
    				j loopColsDone
    			bottomCheck:
    				beqz $t1, bottomCorner
    				addi $t2, $s2, -1
    				beq $t1, $t2 bottomRightCorner
    				jal check0
    				jal check1
    				jal check2
    				jal check3
    				jal check7
    				j loopColsDone
    			leftCheck:
    				jal check1
    				jal check2
    				jal check3
    				jal check4
    				jal check5
    				j loopColsDone
    			rightCheck:
    				jal check0
    				jal check1
    				jal check5
    				jal check6
    				jal check7
    				j loopColsDone
    			topCorner: 
    				jal check3
    				jal check4
    				jal check5
    				j loopColsDone
    			bottomCorner:
    				jal check1
    				jal check2
    				jal check3
    				j loopColsDone
    			topRightCorner: 
    				jal check5
    				jal check6
    				jal check7
    				j loopColsDone
    			bottomRightCorner:
    				jal check0
    				jal check1
    				jal check7
    				j loopColsDone
    			else:
    				jal check0
    				jal check1
    				jal check2
    				jal check3
    				jal check4 
    				jal check5
    				jal check6
    				jal check7 
    				j loopColsDone
    			check0:
    				addi $t2, $t0, -1
    				addi $t3, $t1, -1
    				mul $t2, $t2, $s2
    				add $t2, $t2, $t3
    				li $t3, 8
    				mul $t2, $t2, $t3
    				add $t2, $t2, $s0
    				lw $t2, ($t2)		# Grade
    				beq $t6, $t2, cheaterFound
    				jr $ra
    			check1:
    				addi $t2, $t0, -1
    				addi $t3, $t1, 0
    				mul $t2, $t2, $s2
    				add $t2, $t2, $t3
    				li $t3, 8
    				mul $t2, $t2, $t3
    				add $t2, $t2, $s0
    				lw $t2, ($t2)		# Grade
    				beq $t6, $t2, cheaterFound
    				jr $ra
    			check2:
    				addi $t2, $t0, -1
    				addi $t3, $t1, 1
    				mul $t2, $t2, $s2
    				add $t2, $t2, $t3
    				li $t3, 8
    				mul $t2, $t2, $t3
    				add $t2, $t2, $s0
    				lw $t2, ($t2)		# Grade
    				beq $t6, $t2, cheaterFound
    			check3:
    				addi $t2, $t0, 0
    				addi $t3, $t1, 1
    				mul $t2, $t2, $s2
    				add $t2, $t2, $t3
    				li $t3, 8
    				mul $t2, $t2, $t3
    				add $t2, $t2, $s0
    				lw $t2, ($t2)		# Grade
    				beq $t6, $t2, cheaterFound
    				jr $ra
    			check4: 
    				addi $t2, $t0, 1
    				addi $t3, $t1, 1
    				mul $t2, $t2, $s2
    				add $t2, $t2, $t3
    				li $t3, 8
    				mul $t2, $t2, $t3
    				add $t2, $t2, $s0
    				lw $t2, ($t2)		# Grade
    				beq $t6, $t2, cheaterFound
    				jr $ra
    			check5:
    				addi $t2, $t0, 1
    				addi $t3, $t1, 0
    				mul $t2, $t2, $s2
    				add $t2, $t2, $t3
    				li $t3, 8
    				mul $t2, $t2, $t3
    				add $t2, $t2, $s0
    				lw $t2, ($t2)		# Grade
    				beq $t6, $t2, cheaterFound
    				jr $ra
    			check6:
    				addi $t2, $t0, 1
    				addi $t3, $t1, -1
    				mul $t2, $t2, $s2
    				add $t2, $t2, $t3
    				li $t3, 8
    				mul $t2, $t2, $t3
    				add $t2, $t2, $s0
    				lw $t2, ($t2)		# Grade
    				beq $t6, $t2, cheaterFound
    				jr $ra
    			check7:
    				addi $t2, $t0, 0
    				addi $t3, $t1, -1
    				mul $t2, $t2, $s2
    				add $t2, $t2, $t3
    				li $t3, 8
    				mul $t2, $t2, $t3
    				add $t2, $t2, $s0
    				lw $t2, ($t2)		# Grade
    				beq $t6, $t2, cheaterFound
    				jr $ra
    			cheaterFound:
    				addi $t9, $t9, 1
    				sw $t5, ($s3)
    				addi $s3, $s3, 4
    			loopColsDone:
    			addi $t1, $t1, 1
    			beq $t1, $s2, colsDone
    			j loopCols
    		colsDone:
    		addi $t0, $t0, 1
    		beq $t0, $s1, cheatersSuccess
    		j loopRows
	cheatersError:
    		li $v0, -1
    		li $v1, -1
    		j cheatersDone
    	cheatersSuccess:
    		move $v0, $t9
    		move $v1, $t8
    	cheatersDone:
		lw $s0, 0($sp)			# Put registers back
    		lw $s1, 4($sp)
    		lw $s2, 8($sp)
    		lw $s3, 12($sp)
    		lw $ra, 16($sp)			
		addi $sp, $sp, 20
		jr $ra
