		pa_add equ 0FF20h				
		pb_add equ 0FF21h
		pc_add equ 0FF22h
		pcon_add equ 0ff23h
		time0 equ 30
		time1 equ 60
		 
		org 0000h
main:	lcall clrreg
		mov p1,#0
		mov dptr,#pcon_add	  ;设置8255控制字
		mov a,#81h
		movx @dptr,a

		;R0和R1表示南北的计时时间，R2和R3表示东西的计时时间
		;需先向r4寄存器写入时间单位为秒
here:	mov p1,#28h	;东西红灯亮，南北黄灯亮
		mov r4,#time1
loop0:	mov r5,#time0	
loop1:	mov tmod,#01h	 ;计数器工作方式设置
		mov th0,#00h	 ;设置计数初值
		mov tl0,#00dh
		setb tr0
again:	jnb tf0,again
		clr tf0
		clr tr0
		djnz r5,loop1

		cjne r0,#10,check0 
		mov r0,#0		
		inc r1
check0:	cjne r2,#10,notclr
		mov r2,#0
		cjne r3,#0,carry
		inc r7
check1:	cjne r7,#2,notclr
carry:	inc r3
		clr p1.4	;南北黄灯灭
		setb p1.5	;南北绿灯亮		

notclr:	call disp
		inc r0
		inc r2
		djnz r4,loop0
		call clrreg
		nop
		;R0和R1表示东西计时时间，R2和R3表示南北的计时时间
		mov p1,#82h
		mov r4,#time1
loop2:	mov r5,#time0	
loop3:	mov tmod,#01h	 ;计数器工作方式设置
		mov th0,#00h	 ;设置计数初值
		mov tl0,#00dh
		setb tr0
again1:	jnb tf0,again1
		clr tf0
		clr tr0
		djnz r5,loop3

		cjne r2,#10,check2 
		mov r2,#0
		inc r3
check2:	cjne r0,#10,notclr1
		mov r0,#0
		cjne r1,#0,carry1
		inc r7
check3:	cjne r7,#2,notclr1
carry1:	inc r1
		clr p1.0	;东西黄灯灭
		setb p1.1	;东西绿灯亮

notclr1:call disp
		inc r2
		inc r0
		djnz r4,loop2
		call clrreg
		sjmp here

		;子程序disp，调用前需向R0和R1寄存器写值
		;寄存器R0存放个位，寄存器R1存放十位
disp:	mov dptr,#pb_add	;消隐
		mov a,#0ffh
		movx @dptr,a
				
		mov a,r1		
		mov dptr,#disdata
		movc a,@a+dptr		  ;查表设置段码
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;设置位码
		mov a,#0cch			  
		movx @dptr,a 
		
		mov dptr,#pb_add	;消隐
		mov a,#0ffh
		movx @dptr,a
		mov a,#00
		mov dptr,#pa_add
		movx @dptr,a

		mov a,r0		
		mov dptr,#disdata
		movc a,@a+dptr		  ;查表设置段码
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;设置位码
		mov a,#0cch			  
		movx @dptr,a 
		
		mov dptr,#pb_add	;消隐
		mov a,#0ffh
		movx @dptr,a
		mov a,#00
		mov dptr,#pa_add
		movx @dptr,a 
				
		mov a,r2		
		mov dptr,#disdata
		movc a,@a+dptr		  ;查表设置段码
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;设置位码
		mov a,#0cch			  
		movx @dptr,a 
		
		mov dptr,#pb_add	;消隐
		mov a,#0ffh
		movx @dptr,a
		mov a,#00
		mov dptr,#pa_add
		movx @dptr,a

		mov a,r3		
		mov dptr,#disdata
		movc a,@a+dptr		  ;查表设置段码
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;设置位码
		mov a,#0cch			  
		movx @dptr,a 		
		ret

		;清零寄存器
clrreg:	mov r0,#0 	;东西个位
		mov r1,#0	;东西十位
		mov r2,#0	;南北个位
		mov r3,#0	;南北十位
		mov a,#0
		mov r7,#0
		mov p1,#0
		ret
disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h

		end