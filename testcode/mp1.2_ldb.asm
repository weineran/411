ORIGIN 0
SEGMENT
CODE:

;; JSR TEST
;    JSR ALMOST
;
; GOODEND:
;    BRnzp GOODEND
; THERE:
;    LEA R7, GOODEND
;    RET
; ALMOST:
;    LEA R5, THERE
;    JSRR R5
;
;; LDB TEST
;	AND R2, R2, 4x00
;	LDB R0, R2, 4x08
;	LDB R1, R2, 4x09
;DONE:
;	BRnzp DONE
;
;; LDI TEST
	LDI R0, R0, ADDR1

SEGMENT
DATA:
VAL1:	DATA2 4xFFAA
ADDR1:	DATA2 4x06
VAL2:	DATA2 4xABCD