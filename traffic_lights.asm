		pa_add equ 0FF20h				
		pb_add equ 0FF21h
		pc_add equ 0FF22h
		pcon_add equ 0ff23h
		
		org 0000h
		ljmp main

		org 000bh
		ljmp isr_t0
		
		org 1000h
main:	mov r0,#0 	;个位
		mov r1,#0	;十位
		mov dptr,#pcon_add	  ;设置8255
		mov a,#81h
		movx @dptr,a
		mov dptr,#pa_add
		mov a,#0feh			  ;设置位码
		movx @dptr,a

		mov ie,#82h		 ;允许定时器0中断
		mov tmod,#01h	 ;计数器工作方式设置
		mov th0,#0bh	 ;设置计数初值
		mov tl0,#0cdh
		setb tr0
		mov 30h,#08h

here:	
		sjmp here


delay0:	;调用该延时程序时，
		;需先向r4寄存器写入时间单位为秒
loop0:	mov r5,#30	
loop1:	mov tmod,#01h	 ;计数器工作方式设置
		mov th0,#00h	 ;设置计数初值
		mov tl0,#00dh
		setb tr0
again:	jbc tf0,again
		djnz r5,loop1
		djnz r4,loop0
		ret

isr_t0:	mov th0,#0bh
		mov tl0,#0cdh
		mov a,30h
		dec a
		mov 30h,a

		mov a,r0
		inc a
		mov r0,a
		cjne a,#0ah,disp	;判断计数是否到达10
		inc r1
		mov r0,#0

		;子程序disp，调用前需向R0和R1寄存器写值
		;寄存器R0存放个位，寄存器R1存放十位
disp:	mov dptr,#pb_add	;消隐
		mov a,#0ffh
		movx @dptr,a
		mov a,#0fch
		mov dptr,#pa_add
		movx @dptr,a 
				
		mov a,r1		
		mov dptr,#disdata
		movc a,@a+dptr		  ;查表设置段码
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;设置位码
		mov a,#0fdh			  
		movx @dptr,a 
		
		mov dptr,#pb_add	;消隐
		mov a,#0ffh
		movx @dptr,a
		mov a,#0fch
		mov dptr,#pa_add
		movx @dptr,a

		mov a,r0		
		mov dptr,#disdata
		movc a,@a+dptr		  ;查表设置段码
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;设置位码
		mov a,#0fdh			  
		movx @dptr,a 		
		ret
;子程序ledcon，调用前将编码放到寄存器R3中
ledcon:		
disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h

		end