ORIGIN 0
SEGMENT
CODE:
    JSR ALMOST

GOODEND:
    BRnzp GOODEND

THERE:
    LEA R7, GOODEND
    LDR R6, R0, GOOD
    RET
    LDR R6, R0, BADD
BADEND:
    BRnzp BADEND

ALMOST:
    LEA R5, THERE
    JSRR R5

SEGMENT
DATA:
LVAL1:  DATA2 4x0020
LVAL2:  DATA2 4x00D5
LVAL3:  DATA2 4x000F
SVAL1:  DATA2 ?
SVAL2:  DATA2 ?
SVAL3:  DATA2 ?
SVAL4:  DATA2 ?
GOOD:   DATA2 4x600D
BADD:   DATA2 4xBADD