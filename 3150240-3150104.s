 
	 .text
	 .globl main
	 
main:  
      la $s0,hash  #$s0 = διευθυνση hash[0]
	  lw $s1,N      #$s1=N
	  li $t2,0 #position
	  lw $t5,($s0) #Φορτωσε στον $t5=hash[0]
	  li $t4,0 #i=0
	  li $t6,-1#Φορτωσε στον $t6=-1
	  li $t7,0 #keys=0
loop:
      la $a0,Menu #Εμφανισε στην οθονη τη συμβολοσειρα Menu:
	  li $v0,4
	  syscall
	  
	  la $a0,Insert #Εμφανισε στην οθονη τη συμβολοσειρα 1.Insert Key
	  li $v0,4
	  syscall
	  
	  la $a0,Find #Εμφανισε στην οθονη τη συμβολοσειρα 2.Find Key
	  li $v0,4
	  syscall
	  
	  la $a0,Display #Εμφανισε στην οθονη τη συμβολοσειρα 3.Display Hash Table
	  li $v0,4
	  syscall
	  
	  la $a0,Exit #Εμφανισε στην οθονη τη συμβολοσειρα 4.Exit
	  li $v0,4
	  syscall
	  
	  la $a0,Choice #Εμφανισε στην οθονη τη συμβολοσειρα Choice?
	  li $v0,4
	  syscall
	  
	  li $v0,5 #Διαβασε εναν ακεραιο
	  syscall
	  
	  add $t0,$zero,$v0 #$t0=choice(Μεταφερε στον καταχωρητη $t0 τον ακεραιο που διαβαστηκε)
	  
	  beq $t0,1,lbl1 #Aν το περιεχομενο του καταχωρητη $t0 ειναι ισο με 1 πηγαινε στο lbl1
	  beq $t0,2,lbl2 #Ομοιως και για τα υπολοιπα
	  beq $t0,3,lbl3
	  beq $t0,4,lbl4
	  
lbl1: 	  
      la $a0,Key1 #Εμφανισε στην οθονη τη συμβολοσειρα Give new key(greater than zero):
	  li $v0,4
	  syscall
	  
	  li $v0,5 #Διαβασε εναν ακεραιο
	  syscall
	 
	  add $t1,$t1,$v0 #$t1=key(Μεταφερε στον καταχωρητη $t1 τον ακεραιο που διαβαστηκε)
	  
	  bgtz $t1,insertkey #Αν το περιεχομενο του καταχωρητη $t1 ειναι μεγαλυτερο του 0 πηγαινε στο insertkey
	  la $a0,Prompt #Εμφανισε στην οθονη τη συμβολοσειρα Key must be greater than zero
	  li $v0,4
	  syscall
	  
	  j loop  #Πηγαινε στην ετικετα loop

lbl2:
      la $a0,Key2 #Εμφανισε στην οθονη τη συμβολοσειρα Give key to search for: 
	  li $v0,4
	  syscall
      
	  li $v0,5
	  syscall
	  move $t1,$v0
      jal findkey
	  move $a1,$v0 #τιμη επιστροφης(position or -1)
	  
	  
	  beq $a1,$t6,nokey
	  
	  la $a0,Keyvalue #Εμφανισε στην οθονη τη συμβολοσειρα Key value=  
	  li $v0,4
	  syscall
	  
	  lw $a2,hashval #Φορτωσε στον $a2 τo hashval
	  move $v0,$a2 
	  li $v0,1 #Eμφανισε το key value
	  syscall
	  
	  
      
	  la $a0,Tablepos #Εμφανισε στην οθονη τη συμβολοσειρα Table position= 
	  li $v0,4
	  syscall
	  
	  move $a0,$a1 
	  li $v0,1  #Εμφανισε το Position του key
	  syscall
	  
	  j loop
      
	  
nokey:  
      la $a0,Keynotfound #Εμφανισε στην οθονη τη συμβολοσειρα Key not in hash table. 
	  li $v0,4
	  syscall
        
	  j loop #Πηγαινε στην ετικετα loop
	  
lbl3:	  
      jal displaytable
	  j loop  #Πηγαινε στην ετικετα loop
lbl4:
      li $v0,10 #Τερματισε το προγραμμα
	  syscall
	  
findkey:
         
		 li $t3,0 #found
		 rem $t2,$t1,$s1 #position=key%N
		 lw $t5,($s0)
for1:     
         addi $t4,$t4,1 #i++
		 
		 beq $t5,$t1,lbl5 ##Aν το περιεχομενο του καταχωρητη $t5 ειναι ισο με key($t1) πηγαινε στο lbl5
		 
		 addi $t2,$t2,1 #position++
		 rem $t2,$t2,$s1 #position%=N
		 addi $s0,$s0,4 #Eπομενη διευθυνση του hash
		 lw $t5,($s0)
         sw $t5,hashval
		 lw $a1,hashval
		 move $a0,$a1
		 li $v0,1
		 syscall
		
		 blt $t4,$s1,for1 #Αν i<N πηγαινε στο for1
		 
		 beqz $t3,lbl6   #Αν found=0 Πηγαινε στο lbl6
		 
lbl5:    addi $t3,$t3,1 #found=1
       
         move $v0,$t2
		 
		 jr $ra #return position

lbl6:   
         li $t6,-1
         move $v0,$t6 
		 jr $ra #return -1
		 
hashfunction: 
             
              rem $t2,$t1,$s1 #position=key%N
			  
for2:         addi $s0,$s0,4 ##Eπομενη διευθυνση του hash
              addi $t4,$t4,1 #i++
              blt $t4,$s1,for2 #Αν i<N πηγαινε στο for2
              
while1:       addi $t2,$t2,1 #position ++
              rem $t2,$t2,$s1 #position%=N
			  addi $s0,$s0,4  #Eπομενη διευθυνση του hash
			  lw $t5,($s0)
			  bnez $t5,while1 #Aν hash[position]!=0 πηγαινε while1
			  
			  move $v0,$t2
			  jr $ra  #return position
              
			  
              
insertkey: 
             addi $sp,$sp,-4
             sw $ra,0($sp)
             jal findkey 
             move $t2,$v0
             
             beq $t2,$t6,lbl8
 			 la $a0,Prompt2 #Εμφανισε στην οθονη τη συμβολοσειρα Key is already in hash table
			 li $v0,4
			 syscall
			 
			 
lbl8:      
             blt $t1,$s1,lbl9
			 la $a0,Prompt3 #Εμφανισε στην οθονη τη συμβολοσειρα Hash table is full
			 li $v0,4
			 syscall
			 
			 
lbl9:   	
             addi $sp,$sp,-4
             sw $ra,4($sp)
             jal hashfunction
			 move $t2,$v0
for3:        addi $s0,$s0,4 ##Eπομενη διευθυνση του hash
             addi $t4,$t4,1 #i++
             blt $t4,$t2,for3 #Αν i<position πηγαινε στο for3
			 
			 sw $t1,($s0) #hash[position]=key
			 addi $t7,$t7,1 #keys++
			 addi $sp,$sp,4
             lw $ra,0($sp)
			 
			 jr $ra
displaytable:
			 la $a0,Prompt4 #Εμφανισε στην οθονη τη συμβολοσειρα pos key
			 li $v0,4
			 syscall
			 li $t4,0 #i=0
			 la $s0,hash  #$s0 = διευθυνση hash[0]
			 lw $t5,($s0)
			 
for4: 		 move $a0,$t4 
			 li $v0,1	#Εμφανιση i
			 syscall
			 la $a0,Space
			 li $v0,4
			 syscall
			 move $a0,$t5
			 li $v0,1	#Εμφανιση hash[i]
			 syscall
			 
			 la $a0,CRLF
			 li $v0,4
			 syscall
			 addi $s0,$s0,4 ##Eπομενη διευθυνση του hash
			 lw $t5,($s0)
             addi $t4,$t4,1 #i++
             blt $t4,$s1,for4 #Αν i<N πηγαινε στο for4
			 jr $ra
	 .data
Menu: .asciiz "Menu:\n"
Insert: .asciiz "1.Insert Key\n"
Find: .asciiz "2.Find Key\n"
Display: .asciiz "3.Display Hash Table\n"
Exit: .asciiz "4.Exit\n"
hash: .word 0, 0, 6, 1, 0, 0, 7, 0, 0, 0
N: .word 10
Choice: .asciiz "Choice?"
Key1: .asciiz "\nGive new key(greater than zero): "
Prompt: .asciiz "\nKey must be greater than zero\n"
Key2: .asciiz "Give key to search for: \n"
Keynotfound: .asciiz "Key not in hash table. \n"
Keyvalue: .asciiz "Key value= "
Tablepos: .asciiz "\nTable position= "
hashval: .word 0
Prompt2: .asciiz "Key is already in hash table\n"
Prompt3: .asciiz "Hash table is full\n"
Prompt4: .asciiz "\n pos key \n"
Space: .asciiz " "
CRLF: .asciiz "\n"
