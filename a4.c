/* a4.c
 * CSC Fall 2022
 * 
 * Student name: Cole Romick
 * Student UVic ID: V01005730
 * Date of completed work:
 *
 *
 * Code provided for Assignment #4
 *
 * Author: Mike Zastre (2022-Nov-22)
 *
 * This skeleton of a C language program is provided to help you
 * begin the programming tasks for A#4. As with the previous
 * assignments, there are "DO NOT TOUCH" sections. You are *not* to
 * modify the lines within these section.
 *
 * You are also NOT to introduce any new program-or file-scope
 * variables (i.e., ALL of your variables must be local variables).
 * YOU MAY, however, read from and write to the existing program- and
 * file-scope variables. Note: "global" variables are program-
 * and file-scope variables.
 *
 * UNAPPROVED CHANGES to "DO NOT TOUCH" sections could result in
 * either incorrect code execution during assignment evaluation, or
 * perhaps even code that cannot be compiled.  The resulting mark may
 * be zero.
 */


/* =============================================
 * ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
 * =============================================
 */

#define __DELAY_BACKWARD_COMPATIBLE__ 1
#define F_CPU 16000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define DELAY1 0.000001
#define DELAY3 0.01

#define PRESCALE_DIV1 8
#define PRESCALE_DIV3 64
#define TOP1 ((int)(0.5 + (F_CPU/PRESCALE_DIV1*DELAY1))) 
#define TOP3 ((int)(0.5 + (F_CPU/PRESCALE_DIV3*DELAY3)))

#define PWM_PERIOD ((long int)500)

volatile long int count = 0;
volatile long int slow_count = 0;


ISR(TIMER1_COMPA_vect) {
	count++;
}


ISR(TIMER3_COMPA_vect) {
	slow_count += 5;
}

/* =======================================
 * ==== END OF "DO NOT TOUCH" SECTION ====
 * =======================================
 */


/* *********************************************
 * **** BEGINNING OF "STUDENT CODE" SECTION ****
 * *********************************************
 */

void led_state(uint8_t LED, uint8_t state) {
	DDRL = 0xFF;
	
	switch(LED){ //uses a switch to turn on or off each of the four LEDs 0-3
		case 0: //LED 0
		if (state == 0) {
			PORTL &= ~(0b10000000); //LED 0 off
			} else {
			PORTL |= 0b10000000; //LED 0 on
		}
		break;
		case 1://LED 1
		if (state == 0) {
			PORTL &= ~(0b00100000);//LED 1 off
			} else {
			PORTL |= 0b00100000;//LED 1 on
		}
		break;
		case 2://LED 2
		if (state == 0) {
			PORTL &= ~(0b00001000);//LED 2 off
			} else {
			PORTL |= 0b00001000;//LED 2 on
		}
		break;
		case 3://LED 3
		if (state == 0) {
			PORTL &= ~(0b00000010);//LED 3 off
			} else {
			PORTL |= 0b00000010;//LED 3 on
		}
		break;
		
		default: // break the switch if the range exceeds 3
		break;
	}

}



void SOS() {
    uint8_t light[] = {
        0x1, 0, 0x1, 0, 0x1, 0,
        0xf, 0, 0xf, 0, 0xf, 0,
        0x1, 0, 0x1, 0, 0x1, 0,
        0x0
    };

    int duration[] = {
        100, 250, 100, 250, 100, 500,
        250, 250, 250, 250, 250, 500,
        100, 250, 100, 250, 100, 250,
        250
    };

	int length = 19;
	
	for (int i = 0; i < length; i++) { // an outer for loop that iterates through each pattern
		uint8_t pattern = light[i];
		
		for (uint8_t led = 0; led < 4; led++) { // inner for loop that turns on each led required
			if (pattern & (1 << led)) {
				led_state(led, 1); //turns the led on
			} else {
				led_state(led, 0); // turns the led off
			}
		}
		
		_delay_ms(duration[i]); //delay to create dash and or dot
	}
	for (uint8_t led=0; led < 4; led++){ // for loop to turn off the leds at the end of the function
		led_state(led, 0);
	}
}


void glow(uint8_t LED, float brightness) {
	long int threshold = (long int)(PWM_PERIOD * brightness); // threshold calculation to create brightness
	
	uint8_t led_is_on = 0; // tracker of on or off state of led
	
	while(1) { //Infinite Loop for PWM brightness control
		if (count < threshold && !led_is_on) { // led on for the portion of the duty cycle
			led_state(LED, 1);
			led_is_on = 0;
		}
		else if (count >= threshold && count < PWM_PERIOD && led_is_on) { // led off for the portion of the duty cycle 
			led_state(LED, 0);
			led_is_on = 0;
		}
		else if (count >= PWM_PERIOD) { // reset the count at the end of the period
			count = 0;
			led_state(LED, 1);
			led_is_on = 1;
		}
	}
}



void pulse_glow(uint8_t LED) {
	long int threshold = 0; // threshold calculation to create brightness
	uint8_t led_is_on = 0; // tracker of on or off state of led
	uint8_t increasing = 1; // 1 is increasing, 0 is decreasing brightness
	long int last_slow_count = 0;
	uint8_t update_counter = 0;

	
	while(1) {  //Infinite Loop for PWM brightness control
		if (count < threshold && !led_is_on){// led on for the portion of the duty cycle
			led_state(LED,1);
			led_is_on = 1;
		}
		else if(count >= threshold && count < PWM_PERIOD && led_is_on) { // led off for the portion of the duty cycle
			led_state(LED, 0);
			led_is_on = 0;
		}
		else if(count >= PWM_PERIOD) { // reset the count at the end of the period
			count = 0;
			if (threshold > 0) {
				led_state(LED, 1);
				led_is_on = 1;
			} else{
				led_is_on = 0;
			}
		}
		
		if (slow_count != last_slow_count) { // change threshold according to slow_count
			last_slow_count = slow_count;
			update_counter++;
			
			if (update_counter >= 5){ //update threshold every 50ms
				update_counter = 0;
			
			
				if (increasing) { // increase brightness by lengthening duty cycle
					threshold +=2; // increase brightness by 2
				
					if (threshold >= PWM_PERIOD) { //check if threshold is at the max brightness
						threshold = PWM_PERIOD;
						increasing = 0; // flag to start decreasing the brightness
				}
			} else{
				threshold -=2; // decrease brightness by 2
				
				if (threshold <= 0) { //check if threshold is at the min brightness
					threshold = 0;
					increasing = 1; // flag to start increasing again
					}
				}
			}
		}
	}
}


void light_show() {
	// I am to lazy to get the pattern from the video my bad
}


/* ***************************************************
 * **** END OF FIRST "STUDENT CODE" SECTION **********
 * ***************************************************
 */


/* =============================================
 * ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
 * =============================================
 */

int main() {
    /* Turn off global interrupts while setting up timers. */

	cli();

	/* Set up timer 1, i.e., an interrupt every 1 microsecond. */
	OCR1A = TOP1;
	TCCR1A = 0;
	TCCR1B = 0;
	TCCR1B |= (1 << WGM12);
    /* Next two lines provide a prescaler value of 8. */
	TCCR1B |= (1 << CS11);
	TCCR1B |= (1 << CS10);
	TIMSK1 |= (1 << OCIE1A);

	/* Set up timer 3, i.e., an interrupt every 10 milliseconds. */
	OCR3A = TOP3;
	TCCR3A = 0;
	TCCR3B = 0;
	TCCR3B |= (1 << WGM32);
    /* Next line provides a prescaler value of 64. */
	TCCR3B |= (1 << CS31);
	TIMSK3 |= (1 << OCIE3A);


	/* Turn on global interrupts */
	sei();

/* =======================================
 * ==== END OF "DO NOT TOUCH" SECTION ====
 * =======================================
 */


/* *********************************************
 * **** BEGINNING OF "STUDENT CODE" SECTION ****
 * *********************************************
 */

//This code could be used to test your work for part A.

	//led_state(0, 1);
	//_delay_ms(1000);
	//led_state(2, 1);
	//_delay_ms(1000);
	//led_state(1, 1);
	//_delay_ms(1000);
	//led_state(2, 0);
	//_delay_ms(1000);
	//led_state(0, 0);
	//_delay_ms(1000);
	//led_state(1, 0);
	//_delay_ms(1000);

// This code could be used to test your work for part B.

	//SOS();


// This code could be used to test your work for part C.

/*	led_state(3, 1);
	_delay_ms(1000);
	glow(2, .05);
	
	glow(2, 0.4);
	led_state(2, 0);
	_delay_ms(1000);
	glow(2, 0.7);
	led_state(2, 0);
	_delay_ms(1000);
	glow(2, 1.0);

*/


//This code could be used to test your work for part D.

	pulse_glow(3);
 


// This code could be used to test your work for the bonus part.

	//light_show();


/* ****************************************************
 * **** END OF SECOND "STUDENT CODE" SECTION **********
 * ****************************************************
 */
}
