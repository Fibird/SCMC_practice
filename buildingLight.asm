	ORG 0000H
S:		MOV A,#0FFH
		MOV P2,A		;ʹP1����Ϊ�����
		MOV P1,#00H		;ʹP1����Ϊ�����

		MOV 01,P2		;����P1�ڵ�����ֵ
		NOP
		
CHECK:	MOV A,P2
		CJNE A,01,CHANGE
		JMP CHECK
		
CHANGE:	CPL P1.0	;�ı�������״̬
		MOV 01,P2	;����R1
		JMP S
		
	END	 