	ORG 0000H
		MOV P1,#00H		;使P1口作为输出口
		MOV A,#0FFH
		MOV P1,#80H
		MOV P3,A		;使P3口作为输入口
	
s:		MOV 01,P3		;保存P3口的输入值
		NOP
		
CHECK:	MOV A,P3
		NOP
		LCALL DELAY0
		CJNE A,01,CHANGE
		NOP
		LCALL DELAY0
		JMP CHECK
		
		LCALL DELAY0
CHANGE:	CPL P1.0	;改变照明灯状态
		MOV 01,P3	;更新R1
		JMP S

DELAY0:	MOV R3,0
BACK:	NOP
		DJNZ R3,BACK
		RET			
	END	 