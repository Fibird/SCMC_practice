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
		mov dptr,#pcon_add	  ;����8255������
		mov a,#81h
		movx @dptr,a

		mov ie,#00h		 ;���ж�

here:	lcall coptime0
		nop
		lcall coptime1
		sjmp here

;R0��R1��ʾ�ϱ��ļ�ʱʱ�䣬R2��R3��ʾ�����ļ�ʱʱ��
Coptime0:;���ø���ʱ����ʱ��
		;������r4�Ĵ���д��ʱ�䵥λΪ��
		mov r4,#60
loop0:	mov r5,#30	
loop1:	mov tmod,#01h	 ;������������ʽ����
		mov th0,#00h	 ;���ü�����ֵ
		mov tl0,#00dh
		setb tr0
again:	jbc tf0,again
		djnz r5,loop1

		cjne r0,#10,notclr 
		mov r0,#0
		setb p1.2	;���������
		inc r1
		cjne r2,#10,notclr
		mov r2,#0
		setb p1.4	;�ϱ��Ƶ���
		inc r7
		cjne r7,#2,notclr
		inc r3
		setb p1.5	;�ϱ��̵���
		clr p1.4	;�ϱ��Ƶ���
		mov r7,#2

notclr:	lcall disp
		inc r0
		inc r2
		djnz r4,loop0
		lcall clrreg
		ret

;R0��R1��ʾ������ʱʱ�䣬R2��R3��ʾ�ϱ��ļ�ʱʱ��
Coptime1:
		mov r4,#60
loop2:	mov r5,#30	
loop3:	mov tmod,#01h	 ;������������ʽ����
		mov th0,#00h	 ;���ü�����ֵ
		mov tl0,#00dh
		setb tr0
again1:	jbc tf0,again1
		djnz r5,loop3

		cjne r2,#10,notclr 
		mov r2,#0
		setb p1.6	;�ϱ������
		inc r3
		cjne r0,#10,notclr
		mov r0,#0
		setb p1.0	;�����Ƶ���
		inc r7
		cjne r7,#2,notclr1
		inc r1
		setb p1.1	;�����̵���
		clr p1.0	;�����Ƶ���
		mov r7,#2

notclr1:call disp
		inc r2
		inc r0
		djnz r4,loop2
		lcall clrreg
		ret

		;�ӳ���disp������ǰ����R0��R1�Ĵ���дֵ
		;�Ĵ���R0��Ÿ�λ���Ĵ���R1���ʮλ
disp:	mov dptr,#pb_add	;����
		mov a,#0ffh
		movx @dptr,a
		mov a,#0fch
		mov dptr,#pa_add
		movx @dptr,a 
				
		mov a,r1		
		mov dptr,#disdata
		movc a,@a+dptr		  ;������ö���
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;����λ��
		mov a,#0fdh			  
		movx @dptr,a 
		
		mov dptr,#pb_add	;����
		mov a,#0ffh
		movx @dptr,a
		mov a,#0fch
		mov dptr,#pa_add
		movx @dptr,a

		mov a,r0		
		mov dptr,#disdata
		movc a,@a+dptr		  ;������ö���
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;����λ��
		mov a,#0fdh			  
		movx @dptr,a 
		
		mov dptr,#pb_add	;����
		mov a,#0ffh
		movx @dptr,a
		mov a,#0fch
		mov dptr,#pa_add
		movx @dptr,a 
				
		mov a,r2		
		mov dptr,#disdata
		movc a,@a+dptr		  ;������ö���
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;����λ��
		mov a,#7fh			  
		movx @dptr,a 
		
		mov dptr,#pb_add	;����
		mov a,#0ffh
		movx @dptr,a
		mov a,#0fch
		mov dptr,#pa_add
		movx @dptr,a

		mov a,r3		
		mov dptr,#disdata
		movc a,@a+dptr		  ;������ö���
		mov dptr,#pb_add	
		movx @dptr,a
		mov dptr,#pa_add	 ;����λ��
		mov a,#0bfh			  
		movx @dptr,a 		
		ret

		;����Ĵ���
clrreg:	mov r0,#0 	;������λ
		mov r1,#0	;����ʮλ
		mov r2,#0	;�ϱ���λ
		mov r3,#0	;�ϱ�ʮλ
		mov a,#0
		mov r7,#0
		ret
disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h

		end