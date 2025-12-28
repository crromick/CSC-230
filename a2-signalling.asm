; a2-signalling.asm
; CSC 230: Fall 2022
;
; Student name: Cole Romick
; Student ID: V01005730
; Date of completed work:October 26th 2025
;
;http://www.rjhcoding.com/avr-asm-functions.php Help with understanding 
;stacks and in avr
;
; *******************************
; Code provided for Assignment #2
;
; Author: Mike Zastre (2022-Oct-15)
;
 
; This skeleton of an assembly-language program is provided to help you
; begin with the programming tasks for A#2. As with A#1, there are "DO
; NOT TOUCH" sections. You are *not* to modify the lines within these
; sections. The only exceptions are for specific changes changes
; announced on Brightspace or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****

.include "m2560def.inc"
.cseg
.org 0

; ***************************************************
; **** BEGINNING OF FIRST "STUDENT CODE" SECTION ****
; ***************************************************

	; initializion code will need to appear in this
    ; section

ldi r20, 0xFF
sts DDRL, r20
out DDRB, r20

clr r20

ldi r20, LOW(RAMEND)
ldi r21, HIGH(RAMEND)
out SPL, r20
out SPH, r21




; ***************************************************
; **** END OF FIRST "STUDENT CODE" SECTION **********
; ***************************************************

; ---------------------------------------------------
; ---- TESTING SECTIONS OF THE CODE -----------------
; ---- TO BE USED AS FUNCTIONS ARE COMPLETED. -------
; ---------------------------------------------------
; ---- YOU CAN SELECT WHICH TEST IS INVOKED ---------
; ---- BY MODIFY THE rjmp INSTRUCTION BELOW. --------
; -----------------------------------------------------

	rjmp test_part_e
	; Test code


test_part_a:
	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00111000
	rcall set_leds
	rcall delay_short

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds

	rjmp end


test_part_b:
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds

	rcall delay_long
	rcall delay_long

	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds

	rjmp end

test_part_c:
    ldi r16, 0b11111000
    push r16
    rcall leds_with_speed
    pop r16

    ldi r16, 0b11011100
    push r16
    rcall leds_with_speed
    pop r16

    ldi r20, 0b00100000
test_part_c_loop:

	clr r16
    push r20
    rcall leds_with_speed
    pop r20
    lsr r20
    brne test_part_c_loop

    rjmp end


test_part_d:
	ldi r21, 'E'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'A'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long


	ldi r21, 'M'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'H'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	rjmp end


test_part_e:
	ldi r25, HIGH(WORD02 << 1)
	ldi r24, LOW(WORD02 << 1)
	rcall display_message
	rjmp end

end:
    rjmp end






; ****************************************************
; **** BEGINNING OF SECOND "STUDENT CODE" SECTION ****
; ****************************************************

set_leds:

	push r16
	push r18
	push r19

    clr r26 // PORTL LED register 
    clr r27 // PORTB LED register
    
	; make r26 hold the significant bits for LED representation
    sbrc r16, 0
    ori  r26, 0b10000000  // for LED 6
    sbrc r16, 1
    ori  r26, 0b00100000    // for LED 5
    sbrc r16, 2
    ori  r26, 0b00001000   // for LED 4 
    sbrc r16, 3
    ori  r26, 0b00000010   // for LED 3

    ; make r27 hold the significant bits for LED representation
    sbrc r16, 4
    ori  r27, 0b00001000    // for LED 2
    sbrc r16, 5
    ori  r27, 0b00000010    // for LED 1

    ;out put the LEDs
    sts PORTL, r26
    out PORTB, r27

	pop r19
	pop r18
	pop r16
    ret


slow_leds:
	
	push r16
	push r17

	; set LED and then delay appropriately
	mov r16, r17
	rcall set_leds
	rcall delay_long
	ldi r16, 0x00 // turn off LED
	rcall set_leds
	pop r17
	pop r16
	ret


fast_leds:
	push r16
	push r17

	; set LED and then delay appropriately
	mov r16, r17
	rcall set_leds
	rcall delay_short
	ldi r16, 0x00 // turn off LED
	rcall set_leds
	pop r17
	pop r16
	ret


leds_with_speed:
	push ZL
	push ZH
	
	push r19
	push r18

	;set the stack pointers
	in ZH, SPH
	in ZL, SPL

	;parameter from the stack onto temp
	ldd r19, Z+8

	mov r17, r19
	andi r19, 0b11000000  

	;branch for slow or fast 
	cpi r19, 0b11000000 
	breq slow

	cpi r19, 0b00000000 
	breq fast


	rjmp wrapup1


slow: 
	
	rcall slow_leds
	rjmp wrapup1
fast:
	
	rcall fast_leds
	rjmp wrapup1





wrapup1:
	pop r18
	pop r19
	pop ZH
	pop ZL
	ret


; Note -- this function will only ever be tested
; with upper-case letters, but it is a good idea
; to anticipate some errors when programming (i.e. by
; accidentally putting in lower-case letters). Therefore
; the loop does explicitly check if the hyphen/dash occurs,
; in which case it terminates with a code not found
; for any legal letter.

encode_letter:
	; protecting the registers to be used in the subroutine
 	push YH
	push YL
	push ZH
	push ZL
	push r18
	push r22
	push r26
	push r24
	push r23
	push r19

	;setting stack pointer
	in YH, SPH
	in YL, SPL

	; getting adress pointer
	ldi ZH, high(PATTERNS << 1)
	ldi ZL, low(PATTERNS << 1)
	clr r25
	
	
	; loading registers
	ldd r18,Y+14    
	lpm r22, Z             
	ldi r23, 0x2e  //"-" representation
	ldi r24, 0x6f   // "o" representation
	ldi r19, 0b00100000    
                            
	; will loop through PATTERNS table to find matching letter
	matchLetter:
		cp r18, r22
		breq patternFind
		adiw Z, 8           
		lpm r22, Z         
		rjmp matchLetter 

	; loops and finds which LED's must be on to represent letter, and sorts by speed type 
	patternFind:
		cpi r19, 0x00      
		breq checkSpeed       
		adiw Z, 1           
		lpm r22, Z         
		cp r22, r24
		breq setBit         
		lsr r19
		rjmp patternFind

	;sets the bit to turn on according LED
	setBit:
		add r25, r19
		lsr r19
		rjmp patternFind

	;finds proper speed of blink
	checkSpeed:
		adiw Z, 1           
		lpm r22, Z         
		cpi r22, 0x10      
		breq duration       
                            
		rjmp wrapup2

	; sets up the starting two bits to denote long/slow 
	duration:
		ldi r19, 0b11000000
		add r25, r19

	wrapup2:
		pop r19
		pop r23
		pop r24
		pop r26
		pop r22
		pop r18
		pop ZL
		pop ZH
		pop YL
		pop YH

		ret 

display_message:
	push r25
	push r24
	push r23
	push ZH
	push ZL

	; moves addresses
	mov ZH, r25
	mov ZL, r24
	
	; looping through the letters in the word
	wordLoop:
		lpm r23, Z+             ; loads first letter
		tst r23                 ; checks for 0
                                
		breq wrapup3
		push r23                
		rcall encode_letter
		pop r23
		push r25                
		rcall leds_with_speed   
		pop r25                
		rcall delay_long       ; delay for readability/ adhereing to given video

		rjmp wordLoop 

	wrapup3:
		pop ZL
		pop ZH
		pop r23
		pop r24
		pop r25
		ret



; ****************************************************
; **** END OF SECOND "STUDENT CODE" SECTION **********
; ****************************************************




; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================

; about one second
delay_long:
	push r16

	ldi r16, 14
delay_long_loop:
	rcall delay
	dec r16
	brne delay_long_loop

	pop r16
	ret


; about 0.25 of a second
delay_short:
	push r16

	ldi r16, 4
delay_short_loop:
	rcall delay
	dec r16
	brne delay_short_loop

	pop r16
	ret

; When wanting about a 1/5th of a second delay, all other
; code must call this function
;
delay:
	rcall delay_busywait
	ret


; This function is ONLY called from "delay", and
; never directly from other code. Really this is
; nothing other than a specially-tuned triply-nested
; loop. It provides the delay it does by virtue of
; running on a mega2560 processor.
;
delay_busywait:
	push r16
	push r17
	push r18

	ldi r16, 0x08
delay_busywait_loop1:
	dec r16
	breq delay_busywait_exit

	ldi r17, 0xff
delay_busywait_loop2:
	dec r17
	breq delay_busywait_loop1

	ldi r18, 0xff
delay_busywait_loop3:
	dec r18
	breq delay_busywait_loop2
	rjmp delay_busywait_loop3

delay_busywait_exit:
	pop r18
	pop r17
	pop r16
	ret


; Some tables

PATTERNS:
	; LED pattern shown from left to right: "." means off, "o" means
    ; on, 1 means long/slow, while 2 means short/fast.
	.db "A", "..oo..", 1
	.db "B", ".o..o.", 2
	.db "C", "o.o...", 1
	.db "D", ".....o", 1
	.db "E", "oooooo", 1
	.db "F", ".oooo.", 2
	.db "G", "oo..oo", 2
	.db "H", "..oo..", 2
	.db "I", ".o..o.", 1
	.db "J", ".....o", 2
	.db "K", "....oo", 2
	.db "L", "o.o.o.", 1
	.db "M", "oooooo", 2
	.db "N", "oo....", 1
	.db "O", ".oooo.", 1
	.db "P", "o.oo.o", 1
	.db "Q", "o.oo.o", 2
	.db "R", "oo..oo", 1
	.db "S", "....oo", 1
	.db "T", "..oo..", 1
	.db "U", "o.....", 1
	.db "V", "o.o.o.", 2
	.db "W", "o.o...", 2
	.db "X", "oo....", 2
	.db "Y", "..oo..", 2
	.db "Z", "o.....", 2
	.db "-", "o...oo", 1   ; Just in case!

WORD00: .db "HELLOWORLD", 0, 0
WORD01: .db "THE", 0
WORD02: .db "QUICK", 0
WORD03: .db "BROWN", 0
WORD04: .db "FOX", 0
WORD05: .db "JUMPED", 0, 0
WORD06: .db "OVER", 0, 0
WORD07: .db "THE", 0
WORD08: .db "LAZY", 0, 0
WORD09: .db "DOG", 0

; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================

