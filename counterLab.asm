		pa_add equ 0FF20h				
		pb_add equ 0FF21h
		pc_add equ 0FF22h
		pcon_add equ 0ff23h
		
		org 0000h
		ljmp main

		org 000bh
		ljmp isr_t0
		
main:	mov r0,#0
		mov dptr,#pcon_add	  ;����8255
		mov a,#81h
		movx @dptr,a
		mov dptr,#pb_add
		mov a,#0f0h			  ;����λ��
		movx @dptr,a

		mov ie,#82h		 ;����ʱ��0�ж�
		mov tmod,#01h	 ;����������
		mov th0,#0bh
		mov tl0,#0cdh
		setb tr0
		mov 30h,08h

here:	nop
		nop
		sjmp here

isr_t0:	mov th0,#0bh
		mov tl0,#0cdh
		mov a,30h
		dec a
		mov 30h,a
		jnz ret0

check:	mov a,#10
		subb a,r0
		jz clear		;������10����

disp:	mov a,r0		
		mov dptr,#disdata
		movc a,@a+dptr		  ;���ö���
		mov dptr,#pa_add	
		movx @dptr,a
		
		mov a,r0
		inc a
		mov r0,a
		
ret0:	reti

clear:	mov r0,#0
		jmp disp

disdata:
		db 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,90h

		end