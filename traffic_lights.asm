		pa_add equ 0FF20h				
		pb_add equ 0FF21h
		pc_add equ 0FF22h
		pcon_add equ 0ff23h
		
		org 0000h
		ljmp main

		org 000bh
		ljmp isr_t0
		
		org 1000h
main:	mov r0,#0 	;��λ
		mov r1,#0	;ʮλ
		mov dptr,#pcon_add	  ;����8255
		mov a,#81h
		movx @dptr,a
		mov dptr,#pa_add
		mov a,#0feh			  ;����λ��
		movx @dptr,a

		mov ie,#82h		 ;����ʱ��0�ж�
		mov tmod,#01h	 ;������������ʽ����
		mov th0,#0bh	 ;���ü�����ֵ
		mov tl0,#0cdh
		setb tr0
		mov 30h,#08h

here:	
		sjmp here


delay0:	;���ø���ʱ����ʱ��
		;������r4�Ĵ���д��ʱ�䵥λΪ��
loop0:	mov r5,#30	
loop1:	mov tmod,#01h	 ;������������ʽ����
		mov th0,#00h	 ;���ü�����ֵ
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
		cjne a,#0ah,disp	;�жϼ����Ƿ񵽴�10
		inc r1
		mov r0,#0

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
		ret
;�ӳ���ledcon������ǰ������ŵ��Ĵ���R3��
ledcon:		
disdata:
		db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h

		end