/* armskel64 program
   (c) 2023 Tat-Chee Wan 

   Skeleton program showing console I/O, data manipulation, and flow control
   operations. Although the program is linked using the C compiler, this
   program uses Linux SysCalls only to perform its task. No C library routines
   are used except for the initial process setup and exit.

   See https://arm64.syscall.sh/ for information regarding Linux Syscalls

   Pseudocode of program
   - Repeat
   -     Display string to screen
   -     Drop leftmost character from string
   - Until no characters left in string
   - Exit
 */
    .include "stack.h"

    .equ  STDIN, 0
    .equ STDOUT, 1
    .equ STDERR, 2

    .data           // Data Storage Area
    .align 2        // Important for Word sized access

helloworld: .asciz  "Hello World!\n"
    .equ   helloworldlen, (. - helloworld)

    .text           // Code Storage Area
    .align 4        // Start code on a paragraph (16-byte) boundary

    .global main
main:
    PSHREG LR
    PSHREG2 X19, X20     // X19 used to store string pointer
                         // X20 length of string to display

    ldr    X19, =helloworld
    mov    X20, #helloworldlen

displayloop:
// Setup the parameters to print the string
// and then call Linux to do it.
    mov    X0, #STDOUT  // StdOut
    mov    X1, X19      // String pointer
    mov    X2, X20      // Length
    mov    X8, #64      // Service command code 64 write() writes to file
    svc    0            // Call linux

dropleftchar:
    add    X19, X19, #1 // Drop leftmost char by pointing to next char in string
    subs   X20, X20, #1 // Decrement string length
    bne    displayloop  // If string length non-zero, repeat

done:
    POPREG2 X19, X20    // Restore registers and LR
    POPREG LR
// Setup the parameters to exit the program and then call Linux to do it
    mov    X0, #0      // Use 0 return code
    mov    X8, #93     // Service command code 93 exit() terminates this program
    svc    0           // Call linux

    .end

