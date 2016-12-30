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
		mov p1,#0bdh

here:	nop
		nop
		call disp
		setb p1.3
		setb p1.7
		sjmp here

isr_t0:	mov th0,#0bh
		mov tl0,#0cdh
		mov a,30h
		dec a
		mov 30h,a
		jnz ret0
		
		jb f0,next
		mov r0,50h
		mov r2,50h
		mov 30h,#08h
		cjne r0,#10,check0 
		mov 50h,#0		
		inc r1
check0:	cjne r2,#10,notclr
		mov 50h,#0
		inc r3
check1:	cjne r3,#5,notclr  ;time to 50s
		mov r3,#0
		;mov p1,#07dh	
		setb p1.1
		clr p1.0		
notclr:	inc 50h
		
		cjne r1,#6,ret0	 	;time to 60s
		setb f0
		call clrreg
		mov p1,#0dbh
next:	mov r0,50h
		mov r2,50h
		mov 30h,#08h
		cjne r2,#10,check2 
		mov 50h,#0
		inc r3
check2:	cjne r0,#10,notclr1
		mov 50h,#0
		inc r1
check3:	cjne r1,#5,notclr1
		mov r1,#0
		;mov p1,#0d7h
		setb p1.5
		clr p1.4
notclr1:inc 50h

		cjne r3,#6,ret0
		clr f0
		call clrreg	
		mov p1,#0bdh	 		
ret0:	reti

	
disp:	mov dptr,#pb_add	
		mov a,#0ffh
		movx @dptr,a
		mov a,#0ffh
		mov dptr,#pa_add
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
		mov a,#0ffh
		mov dptr,#pa_add
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
		mov a,#0ffh
		mov dptr,#pa_add
		movx @dptr,a
				
		mov a,r3		
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
		mov a,#0ffh
		mov dptr,#pa_add
		movx @dptr,a

		mov a,r0		
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
		mov 50h,#0
		;mov p1,#0ffh
		ret
disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,0c0h

		end