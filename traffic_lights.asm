		pa_add equ 0FF20h				
		pb_add equ 0FF21h
		pc_add equ 0FF22h
		pcon_add equ 0ff23h
		red equ 0010b
		yellow equ 1000b
		green equ 0100b
		 
		org 0000h
main:	lcall clrreg
		mov p1,#0
		mov dptr,#pcon_add	  ;设置8255控制字
		mov a,#81h
		movx @dptr,a

		mov ie,#00h		 ;关中断

here:	lcall coptime0
		nop
		lcall coptime1
		sjmp here

;R0和R1表示南北的计时时间，R2和R3表示东西的计时时间
Coptime0:;调用该延时程序时，
		;需先向r4寄存器写入时间单位为秒
		mov r4,#60
loop0:	mov r5,#30	
loop1:	mov tmod,#01h	 ;计数器工作方式设置
		mov th0,#00h	 ;设置计数初值
		mov tl0,#00dh
		setb tr0
again:	jbc tf0,again
		djnz r5,loop1

		cjne r0,#10,notclr 
		mov r0,#0
		setb p1.2	;东西红灯亮
		inc r1
		cjne r2,#10,notclr
		mov r2,#0
		setb p1.4	;南北黄灯亮
		inc r7
		cjne r7,#2,notclr
		inc r3
		setb p1.5	;南北绿灯亮
		clr p1.4	;南北黄灯灭
		mov r7,#2

notclr:	lcall disp
		inc r0
		inc r2
		djnz r4,loop0
		lcall clrreg
		ret

;R0和R1表示东西计时时间，R2和R3表示南北的计时时间
Coptime1:
		mov r4,#60
loop2:	mov r5,#30	
loop3:	mov tmod,#01h	 ;计数器工作方式设置
		mov th0,#00h	 ;设置计数初值
		mov tl0,#00dh
		setb tr0
again1:	jbc tf0,again1
		djnz r5,loop3

		cjne r2,#10,notclr 
		mov r2,#0
		setb p1.6	;南北红灯亮
		inc r3
		cjne r0,#10,notclr
		mov r0,#0
		setb p1.0	;东西黄灯亮
		inc r7
		cjne r7,#2,notclr1
		inc r1
		setb p1.1	;东西绿灯亮
		clr p1.0	;东西黄灯灭
		mov r7,#2

notclr1:call disp
		inc r2
		inc r0
		djnz r4,loop2
		lcall clrreg
		ret

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
		
		mov dptr,#pb_add	;消隐
		mov a,#0ffh
		movx @dptr,a
		mov a,#0fch
		mov dptr,#pa_add
		movx @dptr,a 
				
		mov a,r2		
		mov dptr,#disdata
		movc a,@a+dptr		  ;查表设置段码
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;设置位码
		mov a,#7fh			  
		movx @dptr,a 
		
		mov dptr,#pb_add	;消隐
		mov a,#0ffh
		movx @dptr,a
		mov a,#0fch
		mov dptr,#pa_add
		movx @dptr,a

		mov a,r3		
		mov dptr,#disdata
		movc a,@a+dptr		  ;查表设置段码
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;设置位码
		mov a,#0bfh			  
		movx @dptr,a 		
		ret

		;清零寄存器
clrreg:	mov r0,#0 	;东西个位
		mov r1,#0	;东西十位
		mov r2,#0	;南北个位
		mov r3,#0	;南北十位
		mov a,#0
		mov r7,#0
		ret
disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h

		end