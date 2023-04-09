/* changecase program
   (c) 2023 Tat-Chee Wan 

   Simple program showing file I/O, data manipulation, and flow control
   operations. Although the program is linked using the C compiler, this
   program uses Linux SysCalls only to perform its task. No C library routines
   are used except for the initial process setup and exit.

   See https://arm64.syscall.sh/ for information regarding Linux Syscalls

   Pseudocode of program
   - Open ASCII file "textfile.txt"
   - Read file character by character
   - Convert lowercase character to uppercase
   - Display character to screen
   - Repeat until End of File
   - Close file and exit
 */
    .include "stack.h"

    .equ AT_FDCWD, -100   // from /usr/include/linux/fcntl.h
    .equ O_RDONLY, 0      // from /usr/include/asm-generic/fcntl.h
    .equ  STDIN, 0
    .equ STDOUT, 1
    .equ STDERR, 2

    .data           // Data Storage Area
    .align 2        // Important for Word sized access

charbuffer: .byte 0
filename: .ascii "textfile.txt"
fileerr: .asciz "File access error!\n"
    .equ   fileerrlen, (. - fileerr)

    .text           // Code Storage Area
    .align 4        // Start code on a paragraph (16-byte) boundary

.global main
main:
    PSHREG LR
    PSHREG2 X19, X20         // X19 used to store file descriptor
                             // X20 pointer to char buffer
// Open the file using openat()
    mov    X0, #AT_FDCWD     // AT_FDCWD means current working directory
    ldr    X1, =filename     // name of file to open
    mov    X2, #O_RDONLY     // Read Only access
    mov    X3, #0            // Default mode (0)
    mov    X8, #56     // Service command code 56 openat() opens file
    svc    0           // Call linux
    cmp    X0, #0      // returned FD in X0, Check for negative fd value
    bmi    fileerror   // negative return value == error

initvariables:
    mov    X19, X0     // Save FD
    ldr    X20, =charbuffer // Char Buffer address

readloop:
    mov    X0, X19     // Retrieve FD
    mov    X1, X20     // Setup char buffer pointer
    mov    X2, #1      // Process one byte at a time
    mov    X8, #63     // Service command code 63 read() reads from file
    svc    0           // Call linux

    cmp   X0, #0       // Check no of bytes read
    bmi   fileerror    // File access error
    beq   filedone     // 0 read, End of File

retrievechar:
    ldrb  W0, [X20]    // read char from buffer

modifychar:
    cmp   W0, #'a'     // char < 'a'
    blo   displaychar  // Nothing to do, so display it
    cmp   W0, #'z'     // char > 'b'
    bhi   displaychar  // Nothing to do, so display it
    sub   W0, W0, #('A'-'a')  // convert to uppercase

storechar:
    strb  W0, [X20]    // Keep char in buffer

displaychar:
    mov    X0, #STDOUT // StdOut
    mov    X1, X20     // Setup char buffer pointer
    mov    X2, #1
    mov    X8, #64     // Service command code 64 write() writes to file
    svc    0           // Call linux
    cmp    X0, #1      // Should return number of bytes written
    blt    fileerror   // something went wrong
    b      readloop    // Get next char

filedone:
    mov    X0, X19     // Retrieve FD
    mov    X8, #57     // Service command code 57 close() closes file
    svc    0           // Call linux
    cbz    X0, done    // 0 = No error, so exit

fileerror:
    nop                // Used to check return value from Syscall
    mov    X0, #STDERR       // StdErr
    ldr    X1, =fileerr
    mov    X2, #fileerrlen
    mov    X8, #64     // Service command code 64 write() writes to file
    svc    0           // Call linux

done:
    POPREG2 X19, X20   // Restore registers and LR
    POPREG LR
// Setup the parameters to exit the program and then call Linux to do it
    mov    X0, #0      // Use 0 return code
    mov    X8, #93     // Service command code 93 exit() terminates this program
    svc    0           // Call linux

    .end

