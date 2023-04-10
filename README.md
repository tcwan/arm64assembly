# arm64assembly
Example ARM64 Assembly programs for Raspberry Pi running AArch64 (ARM64) Linux. The code uses only Linux Syscalls, it does not use any C Library functions except for program start and exit.

The following project folders are available:
- Examples
  - Code snippets to illustrate the use of ARM64 instructions. 
  - Projects with start.S are pure Assembly programs which does not depend on the C Library, which has '_start' as the entry point.
  - Projects with main.S are Assembly programs linked with the C Library, which has 'main' as the entry point.
- armskel64
  - Simple skeleton program to demonstrate ARM64 Assembly code for console I/O, data manipulation, and flow control
- changecase
  - Simple ARM64 Assembly program showing file I/O, data manipulation, and flow control
   operations
  - NOTE: There are 2 logical errors in the program. This project is meant for Debugging practice
