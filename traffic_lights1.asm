		pa_add equ 0FF20h				
		pb_add equ 0FF21h
		pc_add equ 0FF22h
		pcon_add equ 0ff23h
		
		org 0000h
		ljmp main

		org 000bh
		ljmp isr_t0
		
		org 1000h
main:	mov r0,#0
		mov dptr,#pcon_add	 
		mov a,#81h
		movx @dptr,a

		mov ie,#82h		
		mov tmod,#01h	 
		mov th0,#0bh	 
		mov tl0,#0cdh
		setb tr0
		mov 30h,#08h
		clr f0

here:	nop
		nop
		call disp
		sjmp here

isr_t0:	mov th0,#0bh
		mov tl0,#0cdh
		mov a,30h
		dec a
		mov 30h,a
		jnz ret0
		
		jb f0,next
		mov 30h,#08h
		cjne r0,#10,check0 
		mov r0,#0		
		inc r1
check0:	cjne r2,#10,notclr
		mov r2,#0
		cjne r3,#0,carry
		inc r7
check1:	cjne r7,#2,notclr
carry:	inc r3
		clr p1.4		 
		setb p1.5			
notclr:	inc r0
		inc r2
		
		cjne r1,#6,ret0
		setb f0
		call clrreg

next:	mov 30h,#08h
		cjne r2,#10,check2 
		mov r2,#0
		inc r3
check2:	cjne r0,#10,notclr1
		mov r0,#0
		cjne r1,#0,carry1
		inc r7
check3:	cjne r7,#2,notclr1
carry1:	inc r1
		clr p1.0		 
		setb p1.1
notclr1:inc r2
		inc r0

		cjne r3,#6,ret0
		clr f0
		call clrreg	
			 		
ret0:	reti

	
disp:	mov dptr,#pb_add	
		mov a,#0ffh
		movx @dptr,a
				
		mov a,r1		
		mov dptr,#disdata
		movc a,@a+dptr		 
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 
		mov a,#0fdh			  
		movx @dptr,a 
		
		mov dptr,#pb_add
		mov a,#0ffh
		movx @dptr,a

		mov a,r0		
		mov dptr,#disdata
		movc a,@a+dptr	
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add
		mov a,#0feh			  
		movx @dptr,a 
		
		mov dptr,#pb_add	
		mov a,#0ffh
		movx @dptr,a
				
		mov a,r2		
		mov dptr,#disdata
		movc a,@a+dptr		
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 
		mov a,#0dfh			  
		movx @dptr,a 
		
		mov dptr,#pb_add	
		mov a,#0ffh
		movx @dptr,a

		mov a,r3		
		mov dptr,#disdata
		movc a,@a+dptr	
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	
		mov a,#0efh			  
		movx @dptr,a 		
		ret
		
			
clrreg:	mov r0,#0 			 
		mov r1,#0			
		mov r2,#0			 
		mov r3,#0		
		mov a,#0
		mov r7,#0
		mov p1,#0
		ret
disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h

		end