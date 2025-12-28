; main.asm for edit-distance assignment
;
; CSC 230: Fall 2022
;
; Code provided for Assignment #1
;
; Mike Zastre (2022-Sept-22)

; This skeleton of an assembly-language program is provided to help you
; begin with the programming task for A#1, part (a). In this and other
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
;
; Your task: To compute the edit distance between two byte values,
; one in R16, the other in R17. If the first byte is:
;    0b10101111
; and the second byte is:
;    0b10011010
; then the edit distance -- that is, the number of corresponding
; bits whose values are not equal -- would be 4 (i.e., here bits 5, 4,
; 2 and 0 are different, where bit 0 is the least-significant bit).
; 
; Your solution must, of course, work for other values than those
; provided in the example above.
;
; In your code, store the computed edit distance value in R25.
;
; Your solution is free to modify the original values in R16
; and R17.
;
; ANY SIGNIFICANT IDEAS YOU FIND ON THE WEB THAT HAVE HELPED
; YOU DEVELOP YOUR SOLUTION MUST BE CITED AS A COMMENT (THAT
; IS, WHAT THE IDEA IS, PLUS THE URL).

    .cseg
    .org 0

; ==== END OF "DO NOT TOUCH" SECTION ==========

	ldi r16, 0xc6
	ldi r17, 0xc7

; **** BEGINNING OF "STUDENT CODE" SECTION **** 

	; Your solution in here.

	; THE RESULT **MUST** END UP IN R25
	mov r14, r16 ;make a copy of the first register data
	mov r15, r17 ;make a copy of the second register data
	eor r14, r15 ;check for difference in bits

	ldi r21, 8 ;acting as i for the loop
	ldi r25, 0  ;final distance counter

	distance_loop:
		sbrc r14, 0 ;skip if bit is zero
		inc r25 ;update distance counter
		lsr r14 ;shift to the next bit
		dec r21 ;update the statement
		brne distance_loop ;run the loop again if r21!=0





; **** END OF "STUDENT CODE" SECTION ********** 

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
edit_distance_stop:
    rjmp edit_distance_stop



; ==== END OF "DO NOT TOUCH" SECTION ==========

;Resources used
;For figuring out for loops, skips and branches https://www.youtube.com/watch?v=H8_5SxreNCc
;For figuring out bitwise shifts https://www.arxterra.com/14-avr-logic-and-shift/ 