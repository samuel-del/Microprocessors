/*
-------------------------------------------------------
l03_t01.s
A simple count down program (BGT)
-------------------------------------------------------
Author:  Samuel T
ID:      999999999
Email:  
Date:    2020-12-14
-------------------------------------------------------
*/
.org	0x1000	// Start at memory location 1000
.text  // Code section
.global _start
_start:

.text	// code section
// Store data in registers
MOV	R3, #5		// Initialize a countdown value
	
TOP:
SUB	R3, R3, #1	// Decrement the countdown value
CMP	R3, #0		// Compare the countdown value to 0
BGE	TOP	        // Branch to TOP if > 0

_stop:
B	_stop

.end
#task 2
/*
-------------------------------------------------------
l03_t02.s
A simple count down program (BGE)
-------------------------------------------------------
Author: Samuel T
ID:      999999999
Email:   
Date:    2020-12-14
-------------------------------------------------------
*/
.org	0x1000	// Start at memory location 1000
.text  // Code section
.global _start
_start:

// Store data in registers
LDR	R0, =COUNTER		// Initialize a countdown value
LDR R3, [R0]	
TOP:
SUB	R3, R3, #1	// Decrement the countdown value
CMP	R3, #0		// Compare the countdown value to 0
BGE	TOP			// Branch to top under certain conditions
	
_stop:
B	_stop
.data
COUNTER:
.word 5
.bss
.end
#-------------------------------------------------------------------------------




#-----------------------------------------------------------------------------
#Task_3
/*
-------------------------------------------------------
l03_t03.s
An infinite loop program with a timer delay and
LED display.
-------------------------------------------------------
Author:  Samuel T
ID:      999999999
Email:   
Date:    2020-12-14
-------------------------------------------------------
*/
// Constants
.equ TIMER, 0xfffec600
.equ LEDS,  0xff200000
.org	0x1000	// Start at memory location 1000
.text  // Code section
.global _start
_start:

LDR R0, =LEDS		// LEDs base address
LDR R1, =TIMER		// private timer base address

LDR R2, =LED_BITS	// value to set LEDs
LDR R3, [R2]	// timeout = 1/(200 MHz) x 200x10^6 = 1 sec
LDR R3, =DELAY_TIME		// write timeout to timer load register
LDR R3, [R3]
// set bits: mode = 1 (auto), enable = 1
STR R3, [R1]// write to timer control register
MOV R3,#0b011
STR R3,[R1, #0x8]
LOOP:
STR R2, [R0]		// load the LEDs
WAIT:
LDR R3, [R1, #0xC]	// read timer status
CMP R3, #0
BEQ WAIT			// wait for timer to expire
STR R3, [R1, #0xC]	// reset timer flag bit
ROR	R2, #1			// rotate the LED bits
B LOOP
.data
LED_BITS:
.word 0x0F0F0F0F
DELAY_TIME:
.word 200000000
.end