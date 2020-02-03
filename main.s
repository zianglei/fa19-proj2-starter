.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.data
m0r: .word 0
m0c: .word 0
m1r: .word 0
m1c: .word 0
mir: .word 0
mic: .word 0

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args
    li t0, 5
    bne a0, t0, error
    mv s0, a1

	# =====================================
    # LOAD MATRICES
    # =====================================


    # Load pretrained m0

    lw s1, 4(s0) # s1 is the pointer to m0
    mv a0, s1
    la a1, m0r
    la a2, m0c

    jal ra read_matrix
    mv s1, a0

    # Load pretrained m1

    lw s2, 8(s0) # s2 is the pointer to m1
    mv a0, s2
    la a1, m1r
    la a2, m1c
    jal ra read_matrix
    mv s2, a0

    # Load input matrix

    lw s3, 12(s0)
    mv a0, s3
    la a1, mir
    la a2, mic
    jal ra read_matrix
    mv s3, a0 # s3 is the pointer to the input matrix


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    la t0, m0r
    lw t0, 0(t0)
    la t1, mic
    lw t1, 0(t1)
    mul s4, t0, t1
    slli a0, s4, 2
    jal ra malloc
    mv s5 a0    # s5 is the pointer to m0 * input


    mv a0, s1
    la a1, m0r
    lw a1, 0(a1)
    la a2, m0c
    lw a2, 0(a2)
    mv a3, s3
    la a4, mir
    lw a4, 0(a4)
    la a5, mic
    lw a5, 0(a5)
    mv a6, s5
    jal ra matmul

    mv a0, s5
    mv a1, s4
    jal ra relu

    la t4, m1r
    lw t4, 0(t4)
    la t1, mic
    lw t1, 0(t1)
    mul t5, t4, t1
    slli a0, t5, 2
    jal ra malloc
    mv s6 a0    # s6 is the pointer to m1 * ReLU(m0 * input)

    mv a0, s2
    la a1, m1r
    lw a1, 0(a1)
    la a2, m1c
    lw a2, 0(a2) 
    mv a3, s5

    la a4, m0r
    lw a4, 0(a4)
    la a5, mic
    lw a5, 0(a5)
    mv a6, s6
    jal ra matmul    
    

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0) # Load pointer to output filename
    mv a1, s6
    la a2, m1r
    lw a2, 0(a2)
    la a3, mic
    lw a3, 0(a3)
    jal ra write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0, s6
    la t0, m1r
    lw t0, 0(t0)
    la t1, mic
    lw t1, 0(t1)
    mul a1, t0, t1
    jal ra argmax
    mv t0, a0

    # Print classification
    mv a1, t0
    jal ra print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit

error:
    li a1 3
    jal exit2
