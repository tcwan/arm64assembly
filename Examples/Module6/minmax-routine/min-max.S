/* ARM64 Min-Max Routine
 * (c) 2023 TC Wan, USM
 *
 * C Prototype:
 * int min_max(int n, int *readings, int *min, int *max);
 *
 * Inputs Parameters:
 *   W0: n
 *   X1: readings array pointer
 *   X2: min variable pointer
 *   X3: max variable pointer
 *
 * Output Parameters:
 *   X0: Return value (n if success, 0 if error)
 *  
 * Check that readings, min and max are not NULL pointers
 * If any are NULL, return 0
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
 * return n
 */

/*
 * Use 32-bit registers for algorithm
 * W4: Temporary value storage
 * W5: min value
 * W6: max value
 *
 * Note: Since all the registers X0-X7 are temporary 
 * registers, there is no need to preserve them
 */

    .include "stack.h"

    .text           // Code Storage Area
    .align 4        // Start code on a paragraph (16-byte) boundary

    .global min_max
min_max:
    // W0, X1, X2, X3 contains parameters passed from caller

sanity_check:
    // Check W0 is non-zero
    cbz    W0, min_max_error    // n == 0, exit with error
    // Check X1 is not NULL (0)
    cbz    X1, min_max_error    // X1 NULL, exit with error
    // Check X2 is not NULL (0)
    cbz    X2, min_max_error    // X2 NULL, exit with error
    // Check X3 is not NULL (0)
    cbz    X3, min_max_error    // X3 NULL, exit with error


min_max_init:
    PSHREG2 X0, lr     // Preserve X0, return success
                       // lr is preserved by default 
    mov    W6, #0      // Initialize max to 0
    mov    W5, #0xffffffff // Initialize min to UINT_MAX

loop:
    sub    W0, W0, #1  // counter = counter - 1

// If
    ldr    W4, [X1, W0, UXTW #2]  // Load data item from memory
    // Item Address = Base Pointer (X1) + Offset Address
    // Convert Index (W0) into Offset Address for Word data
    // Word Offset = Index x 4, calculated as W0 LSL #2
check_min:
    cmp    W4, W5          // check readings[counter] W4 < min
    csel   W5, W4, W5, lo  // W5 = lo {W4 < W5} ? W4 : W5

check_max:
    cmp    W4, W6          // check readings[counter] W4 > max
    csel   W6, W4, W6, hi  // W6 = hi {W4 > W6} ? W4 : W6

next_iter:
    cbnz    W0, loop       // counter > 0? if so, loop

exitloop:
    str    W5, [X2]        // Store min into memory location min
    str    W6, [X3]        // Store max into memory location max

min_max_exit:
    POPREG2 X0, lr         // Restore X0 as return value, restore lr
    ret                    // Normal return path

min_max_error:
    mov    X0, #0
    ret                    // Error return path
