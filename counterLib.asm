		pa_add equ 0FF20h				
		pb_add equ 0FF21h
		pc_add equ 0FF22h
		pcon_add equ 0ff23h
		
		org 0000h
		sjmp main

		org 000bh
		mov a,#10
		subb a,r0
		jz exit		;计数到10清零
		mov a,r0		
		mov dptr,#0040h
		movc a,@a+dptr	
		mov dptr,#pa_add
		movx @dptr,a
		
		mov a,r0
		inc a
		mov r0,a
		
exit:	mov r0,#0
		reti
		
main:	mov r0,#0
		mov dptr,#pcon_add	  ;设置8255
		mov a,#81h
		movx @dptr,a

		mov tmod,#10h	 ;计数器设置
		mov th0,#00h
		mov tl0,#00h
		setb tr0

here:	nop
		nop
		sjmp here

		org 0040h
		db 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,90h

		end