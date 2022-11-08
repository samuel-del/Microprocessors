/*
-------------------------------------------------------
l01.s
Assign to and add contents of registers.
-------------------------------------------------------
Author:  Samuel T
ID:      999999999
Email:   
Date:    2020-12-13
-------------------------------------------------------
*/
.org    0x1000  // Start at memory location 1000
.text  // Code section
.global _start
_start:

MOV R0, #9       // Store decimal 9 in register R0
MOV R1, #14     // Store hex E (decimal 14) in register R1
ADD R2, R1, R0  // Add the contents of R0 and R1 and put result in R2

@Task 2 // Yes, it does work but it is illigal. 
MOV R3, #8
ADD R3,R3,R3

@Task 3 //NO, it does not work,it is impposible to add without having 
//declare a MOV instruction. 
//ADD R4, #4, #5 
MOV R4, #4
ADD R5,R4,#5

// End program
_stop:
B   _stop