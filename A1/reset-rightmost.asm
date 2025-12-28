; reset-rightmost.asm
; CSC 230: Fall 2022
;
; Code provided for Assignment #1
;
; Mike Zastre (2022-Sept-22)

; This skeleton of an assembly-language program is provided to help you
; begin with the programming task for A#1, part (b). In this and other
; files provided through the semester, you will see lines of code
; indicating "DO NOT TOUCH" sections. You are *not* to modify the
; lines within these sections. The only exceptions are for specific
; changes announced on conneX or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****
;
; In a more positive vein, you are expected to place your code with the
; area marked "STUDENT CODE" sections.

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; Your task: You are to take the bit sequence stored in R16,
; and to reset the rightmost contiguous sequence of set
; by storing this new value in R25. For example, given
; the bit sequence 0b01011100, resetting the right-most
; contigous sequence of set bits will produce 0b01000000.
; As another example, given the bit sequence 0b10110110,
; the result will be 0b10110000.
;
; Your solution must work, of course, for bit sequences other
; than those provided in the example. (How does your
; algorithm handle a value with no set bits? with all set bits?)

; ANY SIGNIFICANT IDEAS YOU FIND ON THE WEB THAT HAVE HELPED
; YOU DEVELOP YOUR SOLUTION MUST BE CITED AS A COMMENT (THAT
; IS, WHAT THE IDEA IS, PLUS THE URL).

    .cseg
    .org 0

; ==== END OF "DO NOT TOUCH" SECTION ==========

	ldi R16, 0b11111111
	; ldi R16, 0b10110110


	; THE RESULT **MUST** END UP IN R25

; **** BEGINNING OF "STUDENT CODE" SECTION **** 

; Your solution here.
	mov r14, r16 ;make a copy of the first register data
	

	ldi r21, 8 ;acting as i for the loop
	ldi r22, 0  ;final distance counter
	ldi r23, 0 ;flag for sequence of bits
	ldi r19, 0; amount of shifts 

	sequence_loop:
		sbrc r23, 0;check if flag is up
		rjmp flagged
		sbrc r14, 0 ;skip if bit is zero
		inc r23 ;update flag
		lsr r14 ;shift to the next bit
		inc r19 ;update amount of shifts
		dec r21 ;update the statement
		brne sequence_loop ;run the loop again if r21!=0

	flagged:
		sbrs r14, 0 ;skip if bit is one
		rjmp removed_sequence
		lsr r14 ;shift to the next bit
		inc r19 ;update amount of shifts
		dec r21 ;update the statement
		brne flagged ;run the loop again if r21!=0


	removed_sequence:
		
		lsl r14 ;shift back remaining 1's
		dec r19 ;iterate down
		brne removed_sequence

	and r14, r16 ;once the sequence is removed get final byte

	mov r25,r14 ;final byte
		



; **** END OF "STUDENT CODE" SECTION ********** 



; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
reset_rightmost_stop:
    rjmp reset_rightmost_stop


; ==== END OF "DO NOT TOUCH" SECTION ==========
