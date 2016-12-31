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
		mov dptr,#pcon_add		;��ʼ��8255	 
		mov a,#81h
		movx @dptr,a
		mov a,#6

		mov ie,#82h	
		mov 30h,#int_times		;�����жϴ���	
		mov tmod,#01h	 
		mov th0,#0bh			;��ʼ��������	 
		mov tl0,#0cdh
		setb tr0				;����������		
		clr f0					
		mov p1,#0bdh			;��ʼ����£�����������ϱ��̵���
		mov r0,#60
		mov r1,#50
		
here:	nop
		call disp
		nop		  				;���ϵ���7������ܵ���ʾ����
		jmp here
		
isr_t0: mov th0,#0bh
		mov tl0,#0cdh
		mov a,30h
		dec a
		mov 30h,a
		jnz ret0
		
		mov 30h,#int_times		;�����жϴ���
		jb f0,next
		mov a,r0
		mov b,#10
		div ab
		mov buf_add+0,b
		mov buf_add+1,a
		mov a,r1
		mov b,#10
		div ab
		mov buf_add+5,b
		mov buf_add+6,a

		cjne r1,#0,check0	;�ж��̵ƻ�Ƶ��Ƿ����
		mov r1,#10		;��ʼ�ƵƵ�10s
		setb p1.1		;���̵�
		clr p1.0		;���Ƶ�

check0:	cjne r0,#0,dec_f
		mov r0,#60
		mov r1,#50
		setb f0
		mov p1,#0dbh	;�ϱ�������������̵���
		;������һ��״̬		
next:	mov a,r0
		mov b,#10
		div ab
		mov buf_add+5,b
		mov buf_add+6,a
		mov a,r1
		mov b,#10
		div ab
		mov buf_add+0,b
		mov buf_add+1,a

		cjne r1,#0,check1	 ;�ж��̵ƻ�Ƶ��Ƿ����
		mov r1,#10		;��ʼ�ƵƵ�10s
		setb p1.5		;���̵�
		clr p1.4		;���Ƶ� 

check1:	cjne r0,#0,dec_f
		mov r0,#60
		mov r1,#50
		clr f0
		mov p1,#0bdh	;�ϱ�������������̵���
		
dec_f:	dec r0
		dec r1

ret0:	reti

disp:	mov dptr,#pb_add	
		mov a,#0ffh
		movx @dptr,a
		mov a,#0ffh
		mov dptr,#pa_add
		movx @dptr,a
				
		mov a,buf_add+1		
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

		mov a,buf_add+0		
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
				
		mov a,buf_add+6		
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

		mov a,buf_add+5		
		mov dptr,#disdata
		movc a,@a+dptr	
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	
		mov a,#0efh			  
		movx @dptr,a 		
		ret
		
disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,0c0h

		end				