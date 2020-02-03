.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -8
    sw s0, 4(sp)
    sw s1, 0(sp)
    
    mv s0, a0
    mv s1, a1
    li t0, 1
    lw a1, 0(a0)
    li a0, 0

loop_start:
    bge, t0, s1, loop_end
    slli t1, t0, 2
    add t1, s0, t1
    lw t1, 0(t1)
    blt t1, a1, loop_continue
    mv a1, t1 # copy the larger element to a1
    mv a0, t0 # copy the index of the larger element

loop_continue:

    addi t0, t0, 1
    j loop_start

loop_end:

    # Epilogue
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 8
    
    ret
