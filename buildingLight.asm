	ORG 0000H
S:		MOV A,#0FFH
		MOV P2,A		;使P1口作为输入口
		MOV P1,#00H		;使P1口作为输出口

		MOV 01,P2		;保存P1口的输入值
		NOP
		
CHECK:	MOV A,P2
		CJNE A,01,CHANGE
		JMP CHECK
		
CHANGE:	CPL P1.0	;改变照明灯状态
		MOV 01,P2	;更新R1
		JMP S
		
	END	 