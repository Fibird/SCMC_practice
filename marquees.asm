;实验2 跑马灯实验
		org 0000h
		mov a,#0fdh
again:	mov r0,#00h		
		rl a
		mov p1,a
delay1:	mov r1,#00h
delay2:	nop
		djnz r1,delay2
		djnz r0,delay1
		sjmp again