; bcd-addition.asm
; CSC 230: Fall 2022
;
; Code provided for Assignment #1
;
; Mike Zastre (2022-Sept-22)

; This skeleton of an assembly-language program is provided to help you
; begin with the programming task for A#1, part (c). In this and other
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
; Your task: Two packed-BCD numbers are provided in R16
; and R17. You are to add the two numbers together, such
; the the rightmost two BCD "digits" are stored in R25
; while the carry value (0 or 1) is stored R24.
;
; For example, we know that 94 + 9 equals 103. If
; the digits are encoded as BCD, we would have
;   *  0x94 in R16
;   *  0x09 in R17
; with the result of the addition being:
;   * 0x03 in R25
;   * 0x01 in R24
;
; Similarly, we know than 35 + 49 equals 84. If 
; the digits are encoded as BCD, we would have
;   * 0x35 in R16
;   * 0x49 in R17
; with the result of the addition being:
;   * 0x84 in R25
;   * 0x00 in R24
;

; ANY SIGNIFICANT IDEAS YOU FIND ON THE WEB THAT HAVE HELPED
; YOU DEVELOP YOUR SOLUTION MUST BE CITED AS A COMMENT (THAT
; IS, WHAT THE IDEA IS, PLUS THE URL).

; use of comparisons https://electronics.stackexchange.com/questions/165303/best-way-to-compare-value-in-register-with-constant-assembly-avr

    .cseg
    .org 0

	; Some test cases below for you to try. And as usual
	; your solution is expected to work with values other
	; than those provided here.
	;
	; Your code will always be tested with legal BCD
	; values in r16 and r17 (i.e. no need for error checking).

	; 94 + 9 = 03, carry = 1
	; ldi r16, 0x94
	; ldi r17, 0x09

	; 86 + 79 = 65, carry = 1
	 ldi r16, 0x86
	 ldi r17, 0x79

	; 35 + 49 = 84, carry = 0
	;ldi r16, 0x35
	;ldi r17, 0x49

	; 32 + 41 = 73, carry = 0
	;ldi r16, 0x32
	;ldi r17, 0x41

; ==== END OF "DO NOT TOUCH" SECTION ==========

; **** BEGINNING OF "STUDENT CODE" SECTION **** 

	ldi r22, 10 ;for decimal conversion
	ldi r23, 100 ;for carry conversion

	mov r18,r16 ;copy r16 to r18
	mov r19,r16 ;copy r16 to r19
	andi r18, 0x0F ;take the low nibble and store it
	lsr r19 ;shift over the high nibble 
	lsr r19
	lsr r19
	lsr r19
	mul r19, r22 ;move high nibble to tenth's place
	mov r19, r0 ;retrieve product
	add r19, r18 ;r16 in decimal
	
	mov r20,r17 ;copy r17 to r20
	mov r21,r17 ;copy r17 to r21
	andi r20, 0x0F ;take the low nibble and store it
	lsr r21 ;shift over the high nibble 
	lsr r21
	lsr r21
	lsr r21
	mul r21, r22 ;move high nibble to tenth's place
	mov r21, r0 ;retrieve product
	add r21, r20 ;r17 in decimal

	clr r20 ;clear r20 for use later

	add r21,r19 ;BDM summation

	ldi r24, 0;set carry to zero if r21 isnt over 100

	cpi r21, 100 ;check for carry
	brlo digits

	
	cpi r21, 100 ;check that r21 still is greater than 100
	sub r21, r23 ;subtract 100
	ldi r24, 1 ;set the carry to 1
	
	

	digits:
		mov r25,r21 ;update r25 with remainder

	

	mov r20, r25 ;copy r25 to r20 for "division"

	clr r21 ;clear 21 for ten's incrementaion

	divison_loop:
		cpi r20, 10 ;check that r20 is greater than 10
		brlo bdm
		sub r20, r22 ;subtract 10
		inc r21 ;increment the ten's place
		rjmp divison_loop

	bdm:
		mov r25, r21
		lsl r25 ;shift over the high nibble 
		lsl r25 
		lsl r25  
		lsl r25
		or r25, r20 ;create final bdm






; **** END OF "STUDENT CODE" SECTION ********** 

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
bcd_addition_end:
	rjmp bcd_addition_end



; ==== END OF "DO NOT TOUCH" SECTION ==========
