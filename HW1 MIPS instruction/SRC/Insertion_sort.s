.data
Array: .word 9, 2, 8, 1, 6, 5, 4, 10, 3, 7 # you can change the element of array

.text
main:
	addi $t0, $zero, 4097      # $t0 = 0x00001001
	sll  $t0, $t0, 16          # set the base address of your array into $t0 = 0x10010000    

	#--------------------------------------#
	

	for:
	addi $t1,$t1,1		#i++(i->t1)	
	add $t2,$t1,$zero	#j=i(j->t2)
		
	while:
	
	slt $t3,$zero,$t2		#if j>0¡A t3 =1
	bne $t3,1,endwhile	#if t3!=1 endwhile
	sll $t4,$t2,2		#t4=j*4
	add $t6,$t4,$t0		#address of array[j]
	addi $t7,$t6,-4		#address of array[j-1]
	lw   $t8,0($t6)		#load array[j]=t8
	lw   $t9,0($t7)		#load array[j-1]=t9
	slt $t3,$t8,$t9		#if array[j]<array[j-1]¡At3=1
	bne $t3,1,endwhile	#if t3!=1 endwhile
	
	sw $t9,0($t6)		#swap
	sw $t8,0($t7)		#swap
	
	addi $t2,$t2,-1		#j=j-1

	j  while

	endwhile:	
	
	bne $t1,9,for

	
	#--------------------------------------#	
	li   $v0, 10               # program stop
	syscall