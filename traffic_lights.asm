		pa_add equ 0FF20h				
		pb_add equ 0FF21h
		pc_add equ 0FF22h
		pcon_add equ 0ff23h
		time0 equ 30
		time1 equ 60
		 
		org 0000h
main:	lcall clrreg
		mov p1,#0
		mov dptr,#pcon_add	  ;����8255������
		mov a,#81h
		movx @dptr,a

		;R0��R1��ʾ�ϱ��ļ�ʱʱ�䣬R2��R3��ʾ�����ļ�ʱʱ��
		;������r4�Ĵ���д��ʱ�䵥λΪ��
here:	mov p1,#28h	;������������ϱ��Ƶ���
		mov r4,#time1
loop0:	mov r5,#time0	
loop1:	mov tmod,#01h	 ;������������ʽ����
		mov th0,#00h	 ;���ü�����ֵ
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
		clr p1.4	;�ϱ��Ƶ���
		setb p1.5	;�ϱ��̵���		

notclr:	call disp
		inc r0
		inc r2
		djnz r4,loop0
		call clrreg
		nop
		;R0��R1��ʾ������ʱʱ�䣬R2��R3��ʾ�ϱ��ļ�ʱʱ��
		mov p1,#82h
		mov r4,#time1
loop2:	mov r5,#time0	
loop3:	mov tmod,#01h	 ;������������ʽ����
		mov th0,#00h	 ;���ü�����ֵ
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
		clr p1.0	;�����Ƶ���
		setb p1.1	;�����̵���

notclr1:call disp
		inc r2
		inc r0
		djnz r4,loop2
		call clrreg
		sjmp here

		;�ӳ���disp������ǰ����R0��R1�Ĵ���дֵ
		;�Ĵ���R0��Ÿ�λ���Ĵ���R1���ʮλ
disp:	mov dptr,#pb_add	;����
		mov a,#0ffh
		movx @dptr,a
				
		mov a,r1		
		mov dptr,#disdata
		movc a,@a+dptr		  ;������ö���
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;����λ��
		mov a,#0cch			  
		movx @dptr,a 
		
		mov dptr,#pb_add	;����
		mov a,#0ffh
		movx @dptr,a
		mov a,#00
		mov dptr,#pa_add
		movx @dptr,a

		mov a,r0		
		mov dptr,#disdata
		movc a,@a+dptr		  ;������ö���
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;����λ��
		mov a,#0cch			  
		movx @dptr,a 
		
		mov dptr,#pb_add	;����
		mov a,#0ffh
		movx @dptr,a
		mov a,#00
		mov dptr,#pa_add
		movx @dptr,a 
				
		mov a,r2		
		mov dptr,#disdata
		movc a,@a+dptr		  ;������ö���
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;����λ��
		mov a,#0cch			  
		movx @dptr,a 
		
		mov dptr,#pb_add	;����
		mov a,#0ffh
		movx @dptr,a
		mov a,#00
		mov dptr,#pa_add
		movx @dptr,a

		mov a,r3		
		mov dptr,#disdata
		movc a,@a+dptr		  ;������ö���
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;����λ��
		mov a,#0cch			  
		movx @dptr,a 		
		ret

		;����Ĵ���
clrreg:	mov r0,#0 	;������λ
		mov r1,#0	;����ʮλ
		mov r2,#0	;�ϱ���λ
		mov r3,#0	;�ϱ�ʮλ
		mov a,#0
		mov r7,#0
		mov p1,#0
		ret
disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h

		end