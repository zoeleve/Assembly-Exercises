# ΛΕΒΕΣΑΝΟΥ ΖΩΗ 3150240

	.text
	.globl main
main:
	la $a0, str1 		# Εμφάνιση της συμβολοσειράς
	li $v0, 4			# "Enter number: "
	syscall 			# στην οθόνη.
	
	li $v0, 5			# Διαβάζει έναν ακέραιο.
	syscall 
	add $s0, $v0, $zero # Μετακινεί τον ακέραιο στον καταχωρητή s0(το ίδιο με move)
	add $s3, $s0, $zero	# Αποθηκεύεται ο αριθμός1 στον
						# καταχωρητή s3=Αποτέλεσμα
	lb $t0, t0			# Φορτώνει σε καταχωρητές τους
	lb $t1, t1			# τελεστές +,-,*,/,%,=.
	lb $t2, t2
	lb $t3, t3
	lb $t4, t4
	lb $t5, t5
	j oper				# Πήγαινε στο oper
	
oper:
	la $a0, str2 		# Εμφάνιση της συμβολοσειράς
	li $v0, 4			# "Operators:"
	syscall 			# στην οθόνη.
	
	li $v0, 12			# Διαβάζει έναν τελεστή(χαρακτήρα).
	syscall
	
	move $s1, $v0		# Μετακινεί τον τελεστή στον καταχωρητή s1.
	
	bne $s1, $t5, p1 	# Πήγαινε στο p1 αν o τελεστής δεν είναι =.
	j loop2
p1: bne $s1, $t0, p2	# Πήγαινε στο p2 αν o τελεστής δεν είναι +.Ομοίως για τα υπόλοιπα.
	j loop1
p2: bne $s1, $t1, p3
	j loop1
p3: bne $s1, $t2, p4
	j loop1
p4:	bne $s1, $t3, p5
	j loop1
p5:	bne $s1, $t4, Errors
	j loop1
	
loop1:
	la $a0, str1		# εμφάνισε "Enter number: "
	li $v0, 4			
	syscall				# στην οθόνη. 
	
	li $v0, 5			# Διαβάζει έναν ακέραιο.
	syscall
	move $s2, $v0		# Μετακινεί τον ακέραιο στον κατ. s2.
	
	bne $s1, $t3, p7	# Πήγαινε στο p7 αν ο τελεστής δεν είναι "/".
	j p6
p6: bne $s2, $zero, loop2# Πήγαινε στο loop2 αν ο αριθμός2 δεν είναι 0.
	j Errors			# Εμφάνισε "Error"
	
p7: bne $s1, $t4, loop2 # Πήγαινε στο loop2 αν ο τελεστής δεν είναι "%".
	j p8				# Πήγαινε στο p8
p8:	bne $s2, $zero, loop2
	j Errors
	
loop2:
	beq $s1, $t0, sum	# Πήγαινε στο sum αν ο τελεστής είναι"+".
	beq $s1, $t1, subt	# Ομοίως για τα υπόλοιπα.
	beq $s1, $t2, multi
	beq $s1, $t3, divid
	beq $s1, $t4, md
	beq $s1, $t5, loop3
	
sum: add $s3, $s3, $s2	# Πρόσθεση δύο αριθμών
	 j oper
subt: sub $s3, $s3, $s2	# Αφαίρεση δύο αριθμών
	 j oper
multi: mul $s3, $s3, $s2# Πολλαπλασια σμός δύο αριθμών
	 j oper
divid: div $s3, $s3, $s2# Διαίρεση δύο αριθμών
	 j oper
md: rem $s3, $s3, $s2	# Πηλίκο δύο αριθμών
	 j oper
	
loop3:	
	bne $s1, $t5, oper	# Πήγαινε στο oper αν ο τελεστής δεν είναι =.
	
	la $a0, str4		# Εμφάνιση της συμβολοσειράς
	li $v0, 4			# "Result: "
	syscall				# στην οθόνη.
	
	move $a0, $s3		# Εμφάνιση αποτελέσματος
	li $v0, 1
	syscall
	
	la $a0, str5		# Εμφάνιση της συμβολοσειράς
	li $v0, 4			# "Do you want to continue with a new numeric expression(yes=y/no=n)?"
	syscall				# στην οθόνη.Γράψε y για το yes και n για το no.
	
	li $v0, 12			# Διαβάζει yes ή no
	syscall
	
	move $s4, $v0		# Αποθηκεύει την απάντηση στον κατ. s4
	lb $t6, t6			# Φορτώνει στον κατ. t6 το "yes"
	beq $s4, $t6, main	# Αν ο χρήστης γράψει y ξεκινάει νέα παράσταση
	j Exit
	
Errors:
	la $a0, str3 		# Εμφάνιση της συμβολοσειράς
	li $v0, 4			# "Error"
	syscall 			# στην οθόνη.
	
	j Exit
	
Exit:
	li $v0,10			#Έξοδος προγράμματος
	syscall


 .data 
 str1: .asciiz "Enter number: "
 str2: .asciiz "Operators: "
 str3: .asciiz "Error"
 str4: .asciiz "Result: "
 str5: .asciiz "Do you want to continue with a new numeric expression(yes=y/no=n)?"
 t0:   .asciiz "+"
 t1:   .asciiz "-"
 t2:   .asciiz "*"
 t3:   .asciiz "/"
 t4:   .asciiz "%"
 t5:   .asciiz "="
 t6:   .asciiz "y"