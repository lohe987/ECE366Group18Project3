#   Sidharth Brahmbhatt

.data
T: .word 12
best_matching_score: .word -1 # best score = ? within [0, 32]
best_matching_count: .word -1 # how many patterns achieve the best score?
Pattern_Array: .word  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 18, 19, 20 
Score_Array:   .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0


.text
    addi $11, $0, 0x2000    # load start address of data in $11
    addi $8, $0, 0x200C     # load address of pattern array in $8
    lw  $9, 0($11)          # load word to match in $9
    lw  $10, 4($11)         # load best matching score in $10
    addi  $11, $0, 20       # number of words in array in $11
loop1:
    lw  $12, 0($8)          # load word from array
    
    xor $12, $12, $9        # compare word to match with word from array

    add  $13, $0, $0        # we will count the bits in $13 (hamming distance)
count:    
    beq  $12, $0, endcount
    andi $14, $12, 1        # test the rightmost bit
    add  $13, $13, $14      # if it's 1, count one more bit    
next:        
    srl  $12, $12, 1        # move next bit to the right    
    j    count              # repeat
endcount:    
    addi $14, $0, 32
    sub $14, $14, $13       # calculate score = 32 - hamming distance+
    
    slt $13, $14, $10       # if the score is below the best, skip
    bne $13, $0, skip
    add $10, $0, $14        # else, save as best score

skip:
    sw   $14, 80($8)        # save score in score array

    addi $8, $8, 4          # advance to next position in array
    addi $11, $11, -1       # repeat for all words in array
    bne  $11, $0, loop1

    addi $8, $0, 0x2004     # load address of best score in $8
    sw   $10, 0($8)         # save best score

    addi $8, $0, 0x205C     # save start address of score array in $8
    addi $9, $0, 20         # number of words in array in $9
    addi $11, $0, 0         # we will count the number of highest scores with $11
loop2:
    lw   $12, 0($8)         # load score from array

    bne  $10, $12, nxtpos   # if it's not equal to the best score, go to next position
    addi $11, $11, 1        # if they are equal, increment number of highest scores
nxtpos:
    addi $8, $8, 4          # advance to next position in array
    addi $9, $9, -1         # repeat for all words in array
    bne  $9, $0, loop2

    addi $8, $0, 0x2008     # load address of best count in $8
    sw   $11, 0($8)         # save best count


	li $v0, 10
	syscall