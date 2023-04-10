/* ARM64 Assembly version of Min-Max Algorithm
 * (c) 2023 TC Wan, USM
 *
 * Given n 32-bit unsigned numbers in array readings[]
 * max = 0
 * min = UINT_MAX
 * counter = n
 * do
 *    counter = counter - 1
 *    if (readings[counter] < min) then
 *      min = readings[counter]
 *    if (readings[counter] > max) then
 *      max = readings[counter]
 * while (counter <> 0)
 */
    .equ n,5        // Number of items in array

    .data           // Data Storage Area
    .align 2        // Important for Word sized access

readings: .word  70, 126, 5, 33, 56
min: .word 0
max: .word 0


/*
 * Use 32-bit registers for algorithm
 * W0: Temporary value storage
 * W1: counter
 * W2: Address Pointer
 * W3: min value
 * W4: max value
 */


    .text           // Code Storage Area
    .align 4        // Start code on a paragraph (16-byte) boundary

    .global main
main:

    mov    W4, #0      // Initialize max to 0
    mov    W3, #0xffffffff // Initialize min to UINT_MAX
    mov    W1, #n      // Initialize counter to 0
    ldr    X2, =readings   // Initialize X2 as pointer to readings array

loop:
    sub    W1, W1, #1  // counter = counter - 1

// If
    ldr    W0, [X2, W1, UXTW #2]  // Load data item from memory into W0
                         // Item Address = Base Pointer (X2) + Offset Address
                         // Convert Index (W1) into Offset Address for Word data
                         // Word Offset = Index x 4, calculated as W1 LSL #2
check_min:
    cmp    W0, W3          // check readings[counter] (in W0) < min
    csel   W3, W0, W3, lo  // W3 = lo {W0 < W3} ? W0 : W3

check_max:
    cmp    W0, W4          // check readings[counter] (in W0) > max
    csel   W4, W0, W4, hi  // W4 = hi {W0 > W4} ? W0 : W4

next_iter:
    cbnz    W1, loop       // counter > 0? if so, loop

exitloop:
    ldr    X2, =min
    str    W3, [X2]        // Store min into memory location min
    str    W4, [X2, #4]    // Store max into memory location (min+4)

done:
// Setup the parameters to exit the program and then call Linux to do it
    mov    X0, #0      // Use 0 return code
    mov    X8, #93     // Service command code 93 terminates this program
    svc    0           // Call linux to terminate the program

    .end
