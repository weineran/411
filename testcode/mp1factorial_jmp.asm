ORIGIN 4x0000
SEGMENT  CodeSegment:

; Author: Andrew Weiner
; Date: Tuesday, 27-JAN-15
; This program calculates 5!
; My approach is to add 5 to itself 4 times, then add the result to itself 3 times,
; then add the result to itself 2 times.  I have one main loop called LOOP1.  After
; each iteration of LOOP1 I do some book-keeping to decide whether to repeat the loop
; and to prepare the registers for the next iteration of the loop.

; similar to the test code, we assume R0 starts at 0

; summary of registers used
;	R0 -- used as zero at first; multipurpose later
;	R1 -- the number to add- initialized to 5
;	R2 -- holds negative one for decrementing
;	R3 -- counter - initialized to 4
;	R4 -- accumulator - holds the running total
;	R5 -- multipurpose - check below the counter
;	R6 -- put the result here at the end
;	R7 -- keep track of where we're at in the factorial (from n down to 0)

    ADD  R1, R0, 4x0005	; R1 <= 5
	ADD  R7, R1, R0		; R7 <= 5
    ADD  R2, R0, 4xFF	; R2 <= -1
    ADD  R3, R1, R2		; R3 <= 5 - 1 = 4
	ADD	 R4, R0, 4x000F	; R4 <= x000F
	AND	 R4, R4, 4x0000	; R4 <= x0000

;	Multiply n*(n-1) by adding n to itself n-1 times
LOOP1:
    ADD R4, R4, R1      ; add to the accumulator R4 <= R4 + R1
	ADD R3, R3, R2		; decrement counter R3 <= R3 - 1
    BRp LOOP1           ; Repeat loop if R3 is still positive

;	Prepare for next multiplication loop
NEXT_ITER:
	AND  R0, R0, 4x0000 ; R0 <= 0
	ADD  R7, R7, R2		; decrement the tracker
	ADD  R3, R7, R2		; update the counter R3 <= R7 - 1
	ADD  R1, R0, R4		; update the number to add R1 <= R4
	ADD  R4, R0, R0		; reset the accumulator
	ADD  R5, R3, R2		; check one below the counter
	BRnz DONE			; if counter-1 <= 0 then branch to DONE
	AND R0, R0, 4x0000	; R0 <= 0
	ADD  R0, R0, LOOP1	;
	JMP  R0				; 

DONE:
	AND R0, R0, 4x0000	; R0 <= 0
	ADD R6, R0, R1		; this is somewhat superfluous, but will be easier to spot on waveform

HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.

ZERO:	DATA2 4x0000
FIVE:	DATA2 4x0005
NEGONE: DATA2 4xFFFF
LDEST:  DATA2 4x06
