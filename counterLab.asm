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
		mov dptr,#pcon_add	  ;设置8255
		mov a,#81h
		movx @dptr,a
		mov dptr,#pa_add
		mov a,#0feh			  ;设置位码
		movx @dptr,a

		mov ie,#82h		 ;允许定时器0中断
		mov tmod,#01h	 ;计数器设置
		mov th0,#0bh
		mov tl0,#0cdh
		setb tr0
		mov 30h,#08h

here:	nop
		nop
		sjmp here

isr_t0:	mov th0,#0bh
		mov tl0,#0cdh
		mov a,30h
		dec a
		mov 30h,a
		jnz ret0

		mov a,r0
		inc a
		mov r0,a
		cjne a,#0ah,disp
		mov r0,#0

disp:	mov a,r0		
		mov dptr,#disdata
		movc a,@a+dptr		  ;设置段码
		mov dptr,#pb_add	
		movx @dptr,a
		mov 30h,#08h
ret0:	reti

disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h

		end