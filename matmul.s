.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions

    # Prologue
    addi sp, sp, -28
    sw s0, 24(sp)
    sw s1, 20(sp)
    sw s2, 16(sp)
    sw s3, 12(sp)
    sw s4, 8(sp)
    sw s5, 4(sp)
    sw s6, 0(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    mv t0, s6 # t0 is the pointer to the start of d
    mv t1, x0 # t1 is the index of the first row of m0

outer_loop_start:
    bge t1, s1, outer_loop_end
    mv t2, x0 # t2 is the index of the first row of m1

inner_loop_start:

    bge t2, s5, inner_loop_end
    slli t3, t2, 2
    add t3, s3, t3

    # save registers
    addi sp, sp, -20
    sw t0, 16(sp)
    sw t1, 12(sp)
    sw t2, 8(sp)
    sw t3, 4(sp)
    sw ra, 0(sp)

    # Call dot
    mv a0, s0
    mv a1, t3
    mv a2, s2
    li a3, 1
    mv a4, s5
    jal ra dot
    
    lw t0, 16(sp)
    lw t1, 12(sp)
    lw t2, 8(sp)
    lw t3, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 20

    sw a0, 0(t0)
    addi t0, t0, 4

    addi t2, t2, 1
    j inner_loop_start
    
inner_loop_end:
    
    slli t3, s2, 2  
    add s0, s0, t3 # point to the next row
    addi t1, t1, 1
    j outer_loop_start

outer_loop_end:

    # Epilogue
    lw s0, 24(sp)
    lw s1, 20(sp)
    lw s2, 16(sp)
    lw s3, 12(sp)
    lw s4, 8(sp)
    lw s5, 4(sp)
    lw s6, 0(sp)
    
    addi sp, sp, 28
    ret


mismatched_dimensions:
    li a1 2
    jal exit2
