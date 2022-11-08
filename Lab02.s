/*
-------------------------------------------------------
l02_t01.s
Assign to and add contents of registers.
-------------------------------------------------------
Author:  Samuel T
ID:      999999999
Email:   
Date:    2020-12-13
-------------------------------------------------------
*/
.org	0x1000	// Start at memory location 1000
.text  // Code section
.global _start
_start:

// Copy data from memory to registers
LDR	R3, = A; // there was no equal sign, which cause error. 
LDR	R0, [R3]
LDR	R3, = B; //a typo it was B: instead of B; as well as no equal
LDR	R1, [R3]
ADD	R2, R1, R0 // Ro is storing a copy of R3 
// Copy data to memory
LDR	R3, =Result	// Assign address of Result to R3
STR	R2, [R3]	// Store contents of R2 to address in R3
// address of memory in to the register which is R3
// End program
_stop:
B _stop		
// load the address of Result is add in R3. 
// store value of R2 in to R3 which refer or ([]) to Result.  
.data	     // Initialized data section
A:
.word	4
B:
.word	8
.bss	    // Uninitialized data section
Result:
.space 4	// Set aside 4 bytes for result

.end


//-----------------------------------------------------------------------------
Task#2
/*
-------------------------------------------------------
l02_t02.s
Assign to and add contents of registers.
-------------------------------------------------------
Author:  Samuel 
ID:      999999999
Email:   
Date:    2020-12-13
-------------------------------------------------------
*/
.org	0x1000	// Start at memory location 1000
.text  // Code section
.global _start
_start:

// Copy data from memory to registers
LDR	R3, =First
LDR	R0, [R3]
LDR	R3, =Second
LDR	R1, [R3]
// Perform arithmetic and store results in memory
ADD	R2, R0, R1
LDR	R3, =Total
STR	R2, [R3] //store content of R3 in to address in R3
SUB	R2, R0, R1 // Subtract Second from First
LDR	R3, =Diff // typo used three 'f' instead of two 'f'
STR	R2, [R3] // store content of R3 in to R2
// End program
_stop:
B _stop

.data	// Initialized data section
First:
.word	4
Second:
.word	8
.bss	// Uninitialized data section
Total:
.space 4	// Set aside 4 bytes for total
Diff:
.space 2	// Set aside 4 bytes for difference

.end
//---------------------------------------------------------------------

Task #3
/*
-------------------------------------------------------
l02_t03.s
Copies contents of one vector to another.
-------------------------------------------------------
Author:  Samuel T
ID:      
Email:   
Date:    2020-12-13
-------------------------------------------------------
*/
.org	0x1000	// Start at memory location 1000
.text  // Code section
.global _start
_start:

.text	// code section
// Copy contents of first element of Vec1 to Vec2
LDR	R0, =Vec1
LDR	R1, =Vec2
LDR	R2, [R0]
STR	R2, [R1]
// Copy contents of second element of Vec1 to Vec2
ADD	R0, R0, #4
ADD	R1, R1, #4
LDR	R2, [R0]
STR	R2, [R1]
// Copy contents of second element of Vec1 to Vec2
ADD	R0, R0, #4
ADD	R1, R1, #4
LDR	R2, [R0]
STR	R2, [R1]
// End program
_stop:
B _stop

.data	// Initialized data section
Vec1: .word	1, 2, 3
.bss	// Uninitialized data section
Vec2: .space 12
.end