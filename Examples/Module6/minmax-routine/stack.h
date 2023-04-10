// Basic AArch64 stack manipulation macros
// Copyright (c) 2023, Tat-Chee Wan <tcwan@usm.my>
// This file is licensed under the 3-clause BSD License
// https://opensource.org/license/bsd-3-clause/

// Assumes Full Descending Stack
// AArch64 requires SP to be quad-word aligned when accessing memory

// Reserve and Release Stack Space for Local Variables
// numbytes is the byte count to reserve (will be aligned to 16-byte address)
// Padding of 16 bytes may be added if number of bytes is divisible by 16
    .macro RSVLOC numbytes
    SUB SP, SP, #(\numbytes & 0xFFFFFFFFFFFFFFF0 + 0x10)
    .endm

    .macro RLSLOC numbytes
    ADD SP, SP, #(\numbytes & 0xFFFFFFFFFFFFFFF0 + 0x10)
    .endm

// Single Register PUSH and POP
    .macro PSHREG reg
    STR \reg, [SP, #-16]!
    .endm

    .macro POPREG reg
    LDR \reg, [SP], #16
    .endm

// Double Register PUSH and POP
    .macro PSHREG2 reg1, reg2
    STP \reg1, \reg2, [SP, #-16]!
    .endm

    .macro POPREG2 reg1, reg2
    LDP \reg1, \reg2, [SP], #16
    .endm

