@ Project 1, Daniel Sanandaj

.equ SWI_DICHR,   0x00 @input r0: character, prints character
.equ SWI_DISTR,   0x02 @input r0: address of a null terminated ASCII string, output: 0x69, Display String on Stdout
.equ SWI_EXIT,    0x11 @halts execution
.equ SWI_MEALLOC, 0x12 @input r0: block size in bytes, output r0: address of block, allocates block of memory to heap
.equ SWI_DALLOC,  0x13 @deallocates all heap blocks
.equ SWI_OPEN,    0x66 @input r0: file name, r1: mode, output r0: file handle(-1 returned if not opened), mode: 0 for input, 1 for output, 2 for appending
.equ SWI_CLOSE,   0x68 @input r0: file handle, closes file
.equ SWI_PRSTR,   0x69 @input r0: file handleor Stdout, r1: address of a null terminated ASCII string, write String to File or Stdout
.equ SWI_RDSTR,   0x6a @input r0: file handle,  r1: destination address, r2: max bytes to store, output: r0: number of  bytes stored, read String from a File
.equ SWI_PRINT,   0x6b @input r0: file handle, r1: integer, Write Integer to a File
.equ SWI_RDINT,   0x6c @input r0: file handle, output r0: the integer
.equ SWI_TIMER,   0x6d @output: r0: the number of  ticks (milliseconds), Get the current time(ticks)


@Set name of file to input, set mode, opens file, check for error, save file handle

			LDR	R0,=InFileName	
			MOV	R1, #0				
			SWI	SWI_OPEN
			BCS	InFileError
			LDR	R1,=InFileHandle
			STR	R0,[R1]
			
			
@Loops through each int and checks the int
Loop:
			LDR	R0,=InFileHandle
			LDR	R0,[R0]
			SWI	SWI_RDINT
			BCS	PrintList

			CMP 	R0, #127
			BLE 	else0
			ADD 	R10,R10,#1
			ADD 	R3,R3,#1
			B	Loop
			
else0:			CMP	R0, #102
			BLT	else1
			ADD	R4,R4,#1
			ADD 	R3,R3,#1
			B 	Loop
			
else1:			CMP 	R0,#93
			BLT	else2
			ADD	R5,R5,#1
			ADD 	R3,R3,#1
			B	Loop
			
else2:			CMP	R0,#71
			BLE	else3
			ADD	R10,R10,#1
			ADD 	R3,R3,#1
			B	Loop
			
else3:			CMP	R0,#53
			BLT	else4
			ADD	R6,R6,#1
			ADD 	R3,R3,#1
			B	Loop
			
else4:			CMP	R0,	#38
			BLT	else5
			ADD	R7,R7,#1
			ADD	R3,R3,#1
			B	Loop
			
else5:			CMP 	R0,#37
			BLT	else6
			ADD	R10,R10,#1
			ADD 	R3,R3,#1
			B	Loop
			
else6:			CMP	R0,#22
			BLT	else7
			ADD	R8,R8,#1
			ADD 	R3,R3,#1
			B	Loop
			
else7:			CMP	R0,#7
			BLT	else8
			ADD	R9,R9,#1
			ADD 	R3,R3,#1
			B	Loop

else8:			ADD 	R10,R10,#1
			ADD 	R3,R3,#1
			B	Loop
	

@ close the file
endif:
			LDR      r0,=InFileHandle
			LDR      r0,[r0]
			SWI      SWI_CLOSE
			SWI	 SWI_EXIT

@Stores the text required
			.text
.align
InFileHandle:		.word 0
InFileName: 		.asciz "Integers.dat"	
InFileErrorM: 		.asciz "Unable to open input file\n"
ReadErrorM:		.asciz "No input values\n"
NL:			.asciz "\n"
Lost: 			.asciz "Lost generation: "
Greatest:		.asciz "Greatest generation: "
BB:			.asciz "Baby boomer generation: "
GX:			.asciz "Generation X: "
GY:			.asciz "Generation Y: "
GZ:			.asciz "Generation Z: "
NA:			.asciz "Not applicable: "

@Prints out the total numbers
PrintList:		
			CMP	R3,#0
			BEQ	ReadError
			
			LDR	R0,=Lost
			SWI	SWI_DISTR
			MOV		R0,#1
			MOV 	R1,R4
			SWI 	SWI_PRINT 
			LDR 	R0,=NL
			SWI	SWI_DISTR
			
			LDR	R0,=Greatest
			SWI	SWI_DISTR
			MOV		R0,#1
			MOV 	R1,R5
			SWI 	SWI_PRINT
			LDR 	R0,=NL
			SWI	SWI_DISTR
			
			LDR	R0,=BB
			SWI	SWI_DISTR
			MOV		R0,#1
			MOV	 R1,R6
			SWI 	SWI_PRINT
			LDR 	R0,=NL
			SWI	SWI_DISTR
			
			LDR	R0,=GX
			SWI	SWI_DISTR
			MOV		R0,#1
			MOV 	R1,R7
			SWI 	SWI_PRINT
			LDR 	R0,=NL
			SWI	SWI_DISTR
			
			LDR	R0,=GY
			SWI	SWI_DISTR
			MOV		R0,#1
			MOV 	R1,R8
			SWI 	SWI_PRINT
			LDR 	R0,=NL
			SWI	SWI_DISTR
			
			LDR	R0,=GZ
			SWI	SWI_DISTR
			MOV		R0,#1
			MOV 	R1,R9
			SWI 	SWI_PRINT
			LDR 	R0,=NL
			SWI	SWI_DISTR
			
			LDR	R0,=NA
			SWI	SWI_DISTR
			MOV		R0,#1
			MOV 	R1,R10
			SWI 	SWI_PRINT
			LDR 	R0,=NL
			SWI	SWI_DISTR
			
			B endif
			
@Error if no integers on first try
ReadError: 
			LDR	R0,=ReadErrorM
			SWI	SWI_DISTR
			B endif

InFileError:
			LDR R0,=InFileErrorM
			SWI	SWI_DISTR
			B endif