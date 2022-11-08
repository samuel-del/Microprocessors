@Task 1
/*
-------------------------------------------------------
characters.s
Subroutines for working with characters.
-------------------------------------------------------
Author:  Samuel T
ID:      999999999
Email:   
Date:    2020-12-14
-------------------------------------------------------
*/
.org    0x1000    // Start at memory location 1000
.text  // Code section
.global _start
_start:

// Type a character into the UART to test
BL  ReadChar
MOV R2, R0
LDR R4, =characterStr
BL  PrintString
BL  PrintChar
BL  PrintEnter

LDR R4, =isLetterStr
BL  PrintString
BL  isLetter
BL  PrintTrueFalse
BL  PrintEnter

LDR R4, =isLowerStr
BL  PrintString
BL  isLowerCase
BL  PrintTrueFalse
BL  PrintEnter

LDR R4, =isUpperStr
BL  PrintString
BL  isUpperCase
BL  PrintTrueFalse
BL  PrintEnter

_stop:
B    _stop

//-------------------------------------------------------
// Constants
.equ UART_BASE, 0xff201000     // UART base address
.equ ENTER, 0x0a     // enter character
.equ VALID, 0x8000   // Valid data in UART mask

//-------------------------------------------------------
ReadChar:
/*
-------------------------------------------------------
Reads single character from UART.
-------------------------------------------------------
Uses:
  R1 - address of UART
Returns:
  R0 - value of character, null if UART Read FIFO empty
-------------------------------------------------------
*/
STMFD  SP!, {R1, LR}
LDR    R1, =UART_BASE   // Load UART base address
LDR    R0, [R1]         // read the UART data register
TST    R0, #VALID       // check if there is new data
MOVEQ  R0, #0           // if no data, return 0
ANDNE  R0, R0, #0x00FF  // else return only the character
_ReadChar:
LDMFD  SP!, {R1, PC}

//-------------------------------------------------------
PrintChar:
/*
-------------------------------------------------------
Prints single character to UART.
-------------------------------------------------------
Parameters:
  R2 - address of character to print
Uses:
  R1 - address of UART
-------------------------------------------------------
*/
STMFD  SP!, {R1, LR}
LDR    R1, =UART_BASE   // Load UART base address
STRB   R2, [R1]         // copy the character to the UART DATA field
LDMFD  SP!, {R1, PC}

//-------------------------------------------------------
PrintString:
/*
-------------------------------------------------------
Prints a null terminated string to the UART.
-------------------------------------------------------
Parameters:
  R4 - address of string
Uses:
  R1 - address of UART
  R2 - current character to print
-------------------------------------------------------
*/
STMFD  SP!, {R1-R2, R4, LR}
LDR    R1, =UART_BASE
psLOOP:
LDRB   R2, [R4], #1     // load a single byte from the string
CMP    R2, #0           // compare to null character
BEQ    _PrintString     // stop when the null character is found
STRB   R2, [R1]         // else copy the character to the UART DATA field
B      psLOOP
_PrintString:
LDMFD  SP!, {R1-R2, R4, PC}

//-------------------------------------------------------
PrintEnter:
/*
-------------------------------------------------------
Prints the ENTER character to the UART.
-------------------------------------------------------
Uses:
  R2 - holds ENTER character
-------------------------------------------------------
*/
STMFD  SP!, {R2, LR}
MOV    R2, #ENTER       // Load ENTER character
BL     PrintChar
LDMFD  SP!, {R2, PC}

//-------------------------------------------------------
PrintTrueFalse:
/*
-------------------------------------------------------
Prints "T" or "F" as appropriate
-------------------------------------------------------
Parameter
  R0 - input parameter of 0 (false) or 1 (true)
Uses:
  R2 - 'T' or 'F' character to print
-------------------------------------------------------
*/
STMFD  SP!, {R2, LR}
CMP    R0, #0           // Is R0 False?
MOVEQ  R2, #'F'         // load "False" message
MOVNE  R2, #'T'         // load "True" message
BL     PrintChar
LDMFD  SP!, {R2, PC}

//-------------------------------------------------------
isLowerCase:
/*
-------------------------------------------------------
Determines if a character is a lower case letter.
-------------------------------------------------------
Parameters
  R2 - character to test
Returns:
  R0 - returns True (1) if lower case, False (0) otherwise
-------------------------------------------------------
*/
MOV    R0, #0           // default False
CMP    R2, #'a'
BLT    _isLowerCase     // less than 'a', return False
CMP    R2, #'z'
MOVLE  R0, #1           // less than or equal to 'z', return True
_isLowerCase:
MOV    PC, LR

//-------------------------------------------------------
isUpperCase:
/*
-------------------------------------------------------
Determines if a character is an upper case letter.
-------------------------------------------------------
Parameters
  R2 - character to test
Returns:
  R0 - returns True (1) if upper case, False (0) otherwise
-------------------------------------------------------
*/
MOV    R0, #0           // default False
CMP    R2, #'A'
BLT    _isUpperCase     // less than 'A', return False
CMP    R2, #'Z'
MOVLE  R0, #1           // less than or equal to 'Z', return True
_isUpperCase:
MOV    PC, LR

//-------------------------------------------------------
isLetter:
/*
-------------------------------------------------------
Determines if a character is a letter.
-------------------------------------------------------
Parameters
  R2 - character to test
Returns:
  R0 - returns True (1) if letter, False (0) otherwise
-------------------------------------------------------
*/
/*
WHY?
char = 'a'
		branch using a BL to go to the isLowercase 	
		and isUppercase update the link register so when it goes to
		end of the isLetter subroutine, it doesnot know how to get back
		to the main program. cuase LR got overwrittin when BL excuted.
*/

STMFD SP!,{LR}
BL     isLowerCase      // test for lowercase
CMP    R0, #0
BLEQ   isUpperCase      // not lowercase? Test for uppercase.
@MOV    PC, LR
LDMFD SP!,{PC}
//-------------------------------------------------------
.data
characterStr:
.asciz "Char: "
isLetterStr:
.asciz "Letter: "
isLowerStr:
.asciz "Lower: "
isUpperStr:
.asciz "Upper: "
_Data:

.end




@task 2



/*
-------------------------------------------------------
palindrome.s
Subroutines for determining if a string is a palindrome.
-------------------------------------------------------
Author: Samuel T
ID:
Email:
Date:
-------------------------------------------------------
*/
.org    0x1000    // Start at memory location 1000
.text  // Code section
.global _start
_start:

// Test a string to see if it is a palindrome
LDR    R4, =test1
LDR    R1, =_test1 - 2
BL     PrintString
BL     PrintEnter
BL     Palindrome
LDR    R4, =palindromeStr
BL     PrintString
BL     PrintTrueFalse
BL     PrintEnter

LDR    R4, =test2
LDR    R1, =_test2 - 2
BL     PrintString
BL     PrintEnter
BL     Palindrome
LDR    R4, =palindromeStr
BL     PrintString
BL     PrintTrueFalse
BL     PrintEnter

LDR    R4, =test3
LDR    R5, =_test3 - 2
BL     PrintString
BL     PrintEnter
BL     Palindrome
LDR    R4, =palindromeStr
BL     PrintString
BL     PrintTrueFalse
BL     PrintEnter

_stop:
B    _stop

//-------------------------------------------------------

// Constants
.equ UART_BASE, 0xff201000     // UART base address
.equ ENTER, 0x0a     // enter character
.equ VALID, 0x8000   // Valid data in UART mask
.equ DIFF, 'a' - 'A' // Difference between upper and lower case letters

//-------------------------------------------------------
PrintChar:
/*
-------------------------------------------------------
Prints single character to UART.
-------------------------------------------------------
Parameters:
  R2 - address of character to print
Uses:
  R1 - address of UART
-------------------------------------------------------
*/
STMFD  SP!, {R1, LR}
LDR    R1, =UART_BASE   // Load UART base address
STRB   R2, [R1]         // copy the character to the UART DATA field
LDMFD  SP!, {R1, PC}

//-------------------------------------------------------
PrintString:
/*
-------------------------------------------------------
Prints a null terminated string to the UART.
-------------------------------------------------------
Parameters:
  R4 - address of string
Uses:
  R1 - address of UART
  R2 - current character to print
-------------------------------------------------------
*/
STMFD  SP!, {R1-R2, R4, LR}
LDR    R1, =UART_BASE
psLOOP:
LDRB   R2, [R4], #1     // load a single byte from the string
CMP    R2, #0           // compare to null character
BEQ    _PrintString     // stop when the null character is found
STRB   R2, [R1]         // else copy the character to the UART DATA field
B      psLOOP
_PrintString:
LDMFD  SP!, {R1-R2, R4, PC}

//-------------------------------------------------------
PrintEnter:
/*
-------------------------------------------------------
Prints the ENTER character to the UART.
-------------------------------------------------------
Uses:
  R2 - holds ENTER character
-------------------------------------------------------
*/
STMFD  SP!, {R2, LR}
MOV    R2, #ENTER       // Load ENTER character
BL     PrintChar
LDMFD  SP!, {R2, PC}

//-------------------------------------------------------
PrintTrueFalse:
/*
-------------------------------------------------------
Prints "T" or "F" as appropriate
-------------------------------------------------------
Parameter
  R0 - input parameter of 0 (false) or 1 (true)
Uses:
  R2 - 'T' or 'F' character to print
-------------------------------------------------------
*/
STMFD  SP!, {R2, LR}
CMP    R0, #0           // Is R0 False?
MOVEQ  R2, #'F'         // load "False" message
MOVNE  R2, #'T'         // load "True" message
BL     PrintChar
LDMFD  SP!, {R2, PC}

//-------------------------------------------------------
isLowerCase:
/*
-------------------------------------------------------
Determines if a character is a lower case letter.
-------------------------------------------------------
Parameters
  R2 - character to test
Returns:
  R0 - returns True (1) if lower case, False (0) otherwise
-------------------------------------------------------
*/
MOV    R0, #0           // default False
CMP    R2, #'a'
BLT    _isLowerCase     // less than 'a', return False
CMP    R2, #'z'
MOVLE  R0, #1           // less than or equal to 'z', return True
_isLowerCase:
MOV    PC, LR

//-------------------------------------------------------
isUpperCase:
/*
-------------------------------------------------------
Determines if a character is an upper case letter.
-------------------------------------------------------
Parameters
  R2 - character to test
Returns:
  R0 - returns True (1) if upper case, False (0) otherwise
-------------------------------------------------------
*/
MOV    R0, #0           // default False
CMP    R2, #'A'
BLT    _isUpperCase     // less than 'A', return False
CMP    R2, #'Z'
MOVLE  R0, #1           // less than or equal to 'Z', return True
_isUpperCase:
MOV    PC, LR

//-------------------------------------------------------
isLetter:
/*
-------------------------------------------------------
Determines if a character is a letter.
-------------------------------------------------------
Parameters
  R2 - character to test
Returns:
  R0 - returns True (1) if letter, False (0) otherwise
-------------------------------------------------------
*/
STMFD SP!,{LR}
BL     isLowerCase      // test for lowercase
CMP    R0, #0
BLEQ   isUpperCase      // not lowercase? Test for uppercase.
@MOV    PC, LR
LDMFD SP!,{PC}

//-------------------------------------------------------
toLower:
/*
-------------------------------------------------------
Converts a character to lower case.
-------------------------------------------------------
Parameters
  R2 - character to convert
Returns:
  R2 - lowercase version of character
-------------------------------------------------------
*/
STMFD  SP!, {LR}
BL     isUpperCase      // test for upper case
CMP    R0, #0
ADDNE  R2, #DIFF        // Convert to lower case
LDMFD  SP!, {PC}

//-------------------------------------------------------
Palindrome:
/*
-------------------------------------------------------
Determines if a string is a palindrome.
-------------------------------------------------------
Parameters
  R4 - address of first character of string to test
  R5 - address of last character of string to test
Uses:
  R? - ?
Returns:
  R0 - returns True (1) if palindrome, False (0) otherwise
-------------------------------------------------------
*/

// your code here
STMFD   SP!, {R1-R5, LR}
	
	MOV    R0, #1			@ Assume the string is a palindrome

	@ BASE CASE: if the string is empty return true
	CMP 	R4,R5
	BEQ 	_Palindrome
	
	@ Get the address of the character to check
	LDRB R2,[R4]     @check if it a letter 
	BL isLetter 			
	CMP R0, #1
	ADDNE R4,#1 
	BNE	Palindrome		
	BL isLowerCase

	ADD R3, R2 @adding r2 in r3

    LDRB   R5, [R3], #1	@ Get the character to check from the right
	CMP R3, R5
	MOVNE 	R0, #0		@ if they are not equal return false
	BNE	_Palindrome		
	BL      _Palindrome      @ Recursive call
	
_Palindrome:
	LDMFD	SP!, {R1-R5, PC}

//-------------------------------------------------------
.data
palindromeStr:
.asciz "Palindrome: "
test1:
.asciz "otto"
_test1:
test2:
.asciz "RaceCar"
_test2:
test3:

.end	