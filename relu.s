.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -8
    sw s0, 4(sp)
    sw s1, 0(sp)
        
    mv s0, a0
    mv s1, a1
    li t0, 0

loop_start:

    ble s1, x0, loop_end
    slli t1, t0, 2
    add t1, s0, t1
    lw t2, 0(t1)
    bge t2, x0, loop_continue
    sw x0, 0(t1)

loop_continue:
    
    addi t0, t0, 1
    addi s1, s1, -1
    j loop_start

loop_end:

    # Epilogue
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 8
    
	ret
