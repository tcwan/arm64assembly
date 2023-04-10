    .include "stack.h"

    .data           // Data Storage Area
    .align 3        // Important for Double Word sized access

    .equ n, 5

readings: .word  70, 126, 5, 33, 56
min: .word 0
max: .word 0

    .text           // Code Storage Area
    .align 2        // ARM code needs to be word aligned

    .extern min_max
    .global main
main:	
// Setup parameters for calling min max

    mov    W0, #n
    ldr    X1, =readings
    ldr    X2, =min
    ldr    X3, =max
    bl     min_max

done:
// Setup the parameters to exit the program and then call Linux
    cmp    W0, #n      // Check for error from min_max return
    cset   X0, ne      // If W0 != n, return 1 (error), else 0
    mov    X8, #93     // Service code 93 terminates program
    svc    0           // Call Linux to terminate the program

    .end

