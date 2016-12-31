		pa_add equ 0FF20h				
		pb_add equ 0FF21h
		pc_add equ 0FF22h
		pcon_add equ 0ff23h
		intTimes equ 0ah		
		
		org 0000h
		ljmp main

		org 000bh
		ljmp isr_t0
		
		org 1000h
main:	mov r0,#0
		mov dptr,#pcon_add	 
		mov a,#81h
		movx @dptr,a		;settings of 8255

		mov ie,#82h		
		mov tmod,#01h	 
		mov th0,#0bh	 
		mov tl0,#0cdh		;setting of counter0
		setb tr0
		mov 30h,#intTimes	;the time of interrupt
		clr f0
		mov p1,#0bdh		

here:	nop
		nop
		call disp			;display of 7 segment LED
		sjmp here

isr_t0:	mov th0,#0bh
		mov tl0,#0cdh
		mov a,30h
		dec a
		mov 30h,a			;11 interrupts will
		jnz ret0   			;produce 1 second 
									
		jb f0,next
		mov r0,50h
		mov 30h,#intTimes
		cjne r0,#10,check0 
		mov 50h,#0		
		inc r1
		inc r3
check0:	cjne r3,#5,notclr  ;time to 50s
		mov r3,#0	
		setb p1.1 		   ;turn on green light
		clr p1.0		   ;turn off yellow light
notclr:	inc 50h
		
		cjne r1,#6,ret0	 	;time to 60s
		setb f0
		call clrreg
		mov p1,#0dbh
next:	mov r0,50h
		mov 30h,#intTimes
		cjne r0,#10,check1 
		mov 50h,#0
		inc r1
		inc r3
check1:	cjne r1,#5,notclr1	 ;time to 50s
		mov r1,#0
		setb p1.5			 ;turn on green light
		clr p1.4			 ;turn off yellow light
notclr1:inc 50h

		cjne r3,#6,ret0		 ;time to 60s
		clr f0
		call clrreg	
		mov p1,#0bdh	 		
ret0:	reti

	
disp:	mov dptr,#pb_add	;hiding 	
		mov a,#0ffh
		movx @dptr,a
		mov a,#0ffh
		mov dptr,#pa_add
		movx @dptr,a
				
		mov a,r1			;display of bit 2	
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

		mov a,r0				;display of bit 1
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
				
		mov a,r3				;display of bit 5
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

		mov a,r0					 ;display of bit 4
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
		mov r3,#0		
		mov a,#0
		mov 50h,#0
		ret
disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,0c0h

		end