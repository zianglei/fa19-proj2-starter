.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -24
    sw ra, 20(sp)
    sw s0, 16(sp)
    sw s1, 12(sp)
    sw s2, 8(sp)
    sw s3, 4(sp)
    sw s4, 0(sp)
    

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # open the file
    mv a1, s0
    li a2, 0
    jal ra, fopen

    ble a0, x0, eof_or_error
    mv s3, a0 # s3 is the pointer to the matrix file
    
    mv a1, s3
    mv a2, s1
    li a3, 4

    jal ra, fread # read the row of the matrix  
    bne a0, a3, eof_or_error
    mv a1, s3
    mv a2, s2
    li a3, 4
    jal ra, fread # read the col of the matrix

    bne a0, a3, eof_or_error

    # allocate memory for the matrix
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul a0, t0, t1
    slli a0, a0, 2
    
    addi sp, sp, -8
    sw t0, 4(sp)
    sw t1, 0(sp)

    jal ra malloc

    lw t0, 4(sp)
    lw t1, 0(sp)
    addi sp, sp, 8

    mv s4, a0 # s4 is the pointer to the allocated memory

    mv a1, s3
    mv a2, s4
    mul a3, t0, t1
    slli a3, a3, 2    

    jal ra fread # read the matrix

    bne a0, a3, eof_or_error

    mv a1, s3
    jal ra fclose
    mv a1, a0
    blt a0, x0, eof_or_error

    mv a0, s4

    # Epilogue
    lw ra, 20(sp)
    lw s0, 16(sp)
    lw s1, 12(sp)
    lw s2, 8(sp)
    lw s3, 4(sp)
    lw s4, 0(sp)
    addi sp, sp, 24

    ret

eof_or_error:
    li a1 1
    jal exit2
    