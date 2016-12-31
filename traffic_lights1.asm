		pa_add equ 0FF20h				
		pb_add equ 0FF21h
		pc_add equ 0FF22h
		pcon_add equ 0ff23h
		int_times equ 0ah
		buf_add equ 79h
		
		org 0000h
		ljmp main

		org 000bh
		ljmp isr_t0
		
		org 1000h
main:	mov r0,#0
		mov dptr,#pcon_add		;初始化8255	 
		mov a,#81h
		movx @dptr,a
		
		mov buf_add+2,#0ffh
		mov buf_add+3,#0ffh

		mov ie,#82h	
		mov 30h,#int_times		;设置中断次数	
		mov tmod,#01h	 
		mov th0,#0bh			;初始化计数器	 
		mov tl0,#0cdh
		setb tr0				;启动计数器		
		clr f0					
		mov p1,#0bdh			;初始情况下，东西红灯亮南北绿灯亮
		mov r2,#60
		mov r1,#50
		
here:	nop
		call disp
		nop		  				;不断调用7段数码管的显示程序
		jmp here
		
isr_t0: mov th0,#0bh
		mov tl0,#0cdh
		mov a,30h
		dec a
		mov 30h,a
		jnz ret0
		
		mov 30h,#int_times		;重置中断次数
		jb f0,next
		mov a,r2
		mov b,#10
		div ab
		mov buf_add+0,b
		mov buf_add+1,a
		mov a,r1
		mov b,#10
		div ab
		mov buf_add+4,b
		mov buf_add+5,a

		cjne r1,#0,check0	;判断绿灯或黄灯是否结束
		mov r1,#10		;开始黄灯的10s
		setb p1.1		;灭绿灯
		clr p1.0		;亮黄灯

check0:	cjne r2,#0,dec_f
		mov r2,#60
		mov r1,#50
		setb f0
		mov p1,#0dbh	;南北红灯亮，东西绿灯亮
		;进入下一个状态		
next:	mov a,r2
		mov b,#10
		div ab
		mov buf_add+4,b
		mov buf_add+5,a
		mov a,r1
		mov b,#10
		div ab
		mov buf_add+0,b
		mov buf_add+1,a

		cjne r1,#0,check1	 ;判断绿灯或黄灯是否结束
		mov r1,#10		;开始黄灯的10s
		setb p1.5		;灭绿灯
		clr p1.4		;亮黄灯 

check1:	cjne r2,#0,dec_f
		mov r2,#60
		mov r1,#50
		clr f0
		mov p1,#0bdh	;南北红灯亮，东西绿灯亮
		
dec_f:	dec r2
		dec r1

ret0:	reti

disp:	mov r3,#0feh	  ;存放位码
		mov r0,#buf_add	  ;存放段码的地址
loop1:	mov a,@r0	
		mov dptr,#disdata
		movc a,@a+dptr		 
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 
		mov a,r3			  
		movx @dptr,a 
		
		mov dptr,#pb_add	
		mov a,#0ffh
		movx @dptr,a
		mov a,#0ffh
		mov dptr,#pa_add
		movx @dptr,a

delay:	mov r5,#0fh		 	;调用延时
loop2:	nop
		djnz r5,loop2

		inc r0
		mov a,r3 
		jnb acc.5,ret1
		rl a
		mov r3,a
		jmp loop1
				
ret1:	ret
		
disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,0c0h

		end				