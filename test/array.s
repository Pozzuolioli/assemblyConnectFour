@ printArray2.s
@ Stores index number in each element of array
@ and prints the array.
@ 2017-09-29: Bob Plantz

@ Define my Raspberry Pi
        .arch	armv6
	.section	.rodata
        .syntax unified         @ modern syntax

@ Constants for assembler
        .equ    nElements,42    @ number of elements in array
        .equ    intArray,-180    @ array beginning
        .equ    decString,-192   @ for decimal text string
        .equ    locals,184       @ space for local vars
	.equ	rowSize,7	@ constant for max row size

.space:
	.ascii	" "

@ The program
        .text
        .align  2
        .global main
        .type   main, %function

main:
	push	{r4, r5, fp, lr}
	add	fp, sp, 12	@ set our frame pointer
        sub     sp, sp, locals  @ for the array

        add     r4, fp, intArray  @ address of array beginning
        mov     r5, 0           @ index = 0;
fillLoop:
        cmp     r5, nElements   @ all filled?
        bge     allFull         @ yes
        lsl     r0, r5, 2       @ no, offset is 4 * index

	mov	r1, #0
	str	r1, [r4, r0]	@ 

        add     r5, r5, 1       @ index++;
        b       fillLoop
allFull:
        add     r4, fp, intArray  @ address of array beginning
        mov     r5, 0           @ index = 0;
printLoop:
        cmp     r5, nElements   @ all filled?
        bge     allDone         @ yes
        lsl     r0, r5, 2       @ no, offset is 4 * index
        ldr     r1, [r4, r0]    @ get index-th element
        add     r0, fp, decString  @ to store decimal string
        bl      uIntToDec       @ convert it
        add     r0, fp, decString  @ get decimal string
        bl      writeStr        @ write it

	ldr	r0, spaceAddr
	bl	writeStr	@ adds a space after each character

	add	r0, r5, #1	@ store array position in r0
	mov	r1, rowSize	@ moves row size into r1
	bl	__aeabi_idivmod	@ divides row position by row size

	cmp	r1, #0		@ compare remainder with zero
	bne	incrementLCV	@ continue current line if there is a non-zero remainder,
	bl	newLine		@ otherwise jump to next line

incrementLCV:
	add	r5, r5, 1	@ index++
	b	printLoop

@ get next slot choice, alternate players
@	if choice is an exit

@ drop the coin
	@r0 <- row number

@ winner ?
@ if y then "!!!"
@    n then

@ repeat print board, get choice. winner ?

allDone:
        mov     r0, 0           @ return 0;
        add     sp, sp, locals  @ deallocate local var
	pop	{r4, r5, fp, lr}
        bx      lr              @ return

spaceAddr:
	.word	.space
