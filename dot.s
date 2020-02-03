.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:

    # Prologue
    addi sp, sp, -12
    sw s1, 8(sp)
    sw s2, 4(sp)
    sw s3, 0(sp)

    mv s1, a0
    mv s2, a1
    mv s3, a2
    mv a0, x0
    mv t0, x0 # t0 is the index of v0
    mv t1, x0 # t1 is the index of v1

loop_start:

    ble s3, x0, loop_end
    slli t2, t0, 2
    slli t3, t1, 2
    add t2, s1, t2
    add t3, s2, t3
    lw t2, 0(t2)
    lw t3, 0(t3)
    mul t2, t2, t3
    add a0, a0, t2
    add t0, t0, a3 # add the stride of v0
    add t1, t1, a4 # add the stride of v1
    addi s3, s3, -1
    j loop_start

loop_end:

    # Epilogue
    lw s1, 8(sp)
    lw s2, 4(sp)
    lw s3, 0(sp)
    addi sp, sp, 12
    
    ret
