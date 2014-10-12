# Quicksort 
# No tail-recursion optimization yet
# To do: Optimize array loading, while loops (avoid jumps if possible)
	.text
	.globl main
main:	la	$s0, list		# List address
	li	$s1, 9			# List length - 1
	
	li	$a0, 0			# Left
	move	$a1, $s1		# Right
	jal	qsort
	
	li	$v0, 10		
	syscall
	
qsort:	
	move	$t0, $a0		# i
	move	$t1, $a1		# j
	
	add	$t2, $t0, $t1		# load pivot, index 4*(i+j)/2
	srl	$t2, $t2, 1
	sll	$t2, $t2, 2		# Make sure is multiple of 4
	add	$t3, $t2, $s0	
	lw	$t2, 0($t3)		# pivot $t2
	
w:	bgt	$t0, $t1, r1		# while (i <= j)
	w1:	move	$t3, $t0	# list[i] in $t3, index in $t4
		sll	$t3, $t3, 2
		add	$t4, $t3, $s0
		lw	$t3, 0($t4)	
		bge	$t3, $t2, w2	# list[i] < pivot
		addi	$t0, $t0, 1
		j	w1

	w2:	move	$t5, $t1	# list[j] in $t5, index in $t6
		sll	$t5, $t5, 2
		add	$t6, $t5, $s0
		lw	$t5, 0($t6)	
		ble	$t5, $t2, w3	# list[j] > pivot
		addi	$t1, $t1, -1
		j	w2
	
	w3:	bgt	$t0, $t1, w	# i <= j
		sw	$t5, 0($t4)	# swap j to i
		sw	$t3, 0($t6)	# i to j
		addi	$t0, $t0, 1
		addi	$t1, $t1, -1
		j	w

r1:	
	bge	$a0, $t1, r2		# left < j
	
	addi	$sp, $sp, -20		# Adjust sp
	sw	$ra, 0($sp)		# Push ra
	sw	$a0, 4($sp)		# Push left
	sw	$a1, 8($sp)		# Push right
	sw	$t0, 12($sp)		# Push i
	sw	$t1, 16($sp)		# Push j

	move	$a1, $t1		# new right arg
	jal 	qsort
	
	lw	$ra, 0($sp)		# Pop ra
	lw	$a0, 4($sp)		# Pop left
	lw	$a1, 8($sp)		# Pop right
	lw	$t0, 12($sp)		# Pop i
	lw	$t1, 16($sp)		# Pop j
	addi	$sp, $sp, 20		# adjust sp
	
	
r2:	bge	$t0, $a1, qend		# i < right

	addi	$sp, $sp, -20		# Adjust sp
	sw	$ra, 0($sp)		# Push ra
	sw	$a0, 4($sp)		# Push left
	sw	$a1, 8($sp)		# Push right
	sw	$t0, 12($sp)		# Push i
	sw	$t1, 16($sp)		# Push j
	
	move	$a0, $t0		# new left arg
	jal 	qsort
	
	lw	$ra, 0($sp)		# Pop ra
	lw	$a0, 4($sp)		# Pop left
	lw	$a1, 8($sp)		# Pop right
	lw	$t0, 12($sp)		# Pop i
	lw	$t1, 16($sp)		# Pop j
	addi	$sp, $sp, 20		# adjust sp
	jr	$ra

qend:	
	#lw	$ra, 0($sp)		# Pop ra
	#addi	$sp, $sp, 12
	jr	$ra
	
	

	.data
list:	.word 12, 5, 0, -2, 1, 7, 3, 9, 25, 9
