.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"
mrow: .word 0
mcol: .word 0

.text
main:
    # Read matrix into memory
    la a0, file_path
    la a1, mrow
    la a2, mcol

    jal ra read_matrix

    # Print out elements of matrix
    la a1, mrow
    la a2, mcol
    lw a1, 0(a1)
    lw a2, 0(a2)

    jal ra print_int_array

    # Terminate the program
    addi a0, x0, 10
    ecall