	.data           /* Data Storage Area */
	.align 3        /* Important for Double Word sized access */

SUM:	.dword	0

	.text           /* Code Storage Area */
	.align 2        /* ARM code needs to be word aligned */

.global _start
_start:	LDR	W0, =0x0020313A	// Load 0020313Ah 
	LDR	W1, =0x1500A0BB	// Load 1500A0BBh 
	ADD	W0, W1, W0	// Perform Addition
	LDR	X2, =SUM	// Init R2 as Addr. Ptr. 
	STR	X0, [X2]	// Store to SUM 
stop:	B	stop		// Loop Forever

