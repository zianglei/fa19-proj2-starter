.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw ra, 20(sp)
    sw s0, 16(sp)
    sw s1, 12(sp)
    sw s2, 8(sp)
    sw s3, 4(sp)
    sw s4, 0(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3

    mv a1, s0
    li a2, 1 # write permission
    jal ra fopen
    blt a0, x0, eof_or_error

    mv s4, a0 # s4 is the pointer to the file


    li a0, 2
    slli a0, a0, 2
    jal ra malloc

    mv t0, a0 # t0 is the pointer to the memory space for the number of cols and rows
    sw s2, 0(t0)
    sw s3, 4(t0)

    mv a1, s4
    mv a2, t0
    li a3, 2
    li a4, 4
    jal ra fwrite # write the number of rows and the number of columns of the matrix
    blt a0, a3, eof_or_error

    mul t0, s2, s3
    mv a1, s4
    mv a2, s1
    mv a3, t0
    li a4, 4

    jal ra fwrite # write the matrix
    blt a0, a3, eof_or_error

    mv a1, s4
    jal ra fflush
    blt a0, x0, eof_or_error

    mv a1, s4
    jal ra fclose
    blt a0, x0, eof_or_error

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
    