.nolist
#include "ti83plus.inc"
.list
.org userMem
.db t2ByteTok, tAsmCmp

; ================================================================
; Constants for digit placement (in bytes)
; ================================================================
LEFT_DIGIT_OFFSET  .equ (4*12 + 1)		; make a parameter LEFT_DIGIT_OFFSET = 4 rows and 1 column shift
RIGHT_DIGIT_OFFSET .equ (4*12 + 7)		; make a parameter RIGHT_DIGIT_OFFSET = 4 rows and 7 column shift

; ================================================================
; Main routine
; ================================================================
    bcall(_GrBufClr)				; clear graph buffer
    bcall(_RclAns)				    ; grab value stored in Ans
    bcall(_ConvOP1)          		; put Ans into A register, assume Ans will be between 0-99 inclusive

;----------------------------------------
; Split A into tens and ones digits
;----------------------------------------
    ld b, 0                  		; B will be used to store tens digit. initially set to 0
divide_loop:
    cp 10					        ; compare A to 10
    jr c, division_done				; if A drops below zero, the carry flag will be set and we will jump to division_done
    sub 10					        ; subtract 10 from A
    inc b					        ; increase the tens place (B) because we haven't reached below zero yet so we subtracted another 10
    jr divide_loop				    ; keep looping until we are done with division
division_done:
    ; we couldn't subtract any more tens without going negative, so B holds the corrects tens place and what's left in A is the ones place (remainder)

;----------------------------------------
; Draw tens digit
;----------------------------------------
    push af					        ; store AF on the stack. We don't need F, but you can only put register pairs on the stack
    ld a, b					        ; put tens place (B) into A
    ld hl, LEFT_DIGIT_OFFSET		; set HL equal to the left digit (tens place) screen offset
    call draw_digit				    ; call the draw_digit function
    pop af					        ; restore AF because now A will hold the ones place digit value

;----------------------------------------
; Draw ones digit
;----------------------------------------
    ld hl, RIGHT_DIGIT_OFFSET		; set HL equal to the right digit (ones place) screen offset
    call draw_digit				    ; call the draw_digit function

;----------------------------------------
; Copy buffer to LCD
;----------------------------------------
    bcall(_GrBufCpy)				; update the screen with what we've put in the graph buffer
    ret


; ================================================================
; draw_digit
; Input: A = digit (0–9)
;        HL = offset from PlotSScreen
; ================================================================
draw_digit:
    push hl                  ; preserve offset
    call get_digit_ptr       ; call get_digit_ptr. sprite data address is now in DE
    pop hl                   ; restore offset into HL
    ld bc, PlotSScreen	     ; put base screen address into BC
    add hl, bc               ; add offset to base screen address
    ex de, hl                ; swap DE and HL so that DE (destination) now contains the screen + offset address, and HL (source) points to the sprite data
    call draw_sprite32x56    ; now that we have the correct destination and source, call draw_sprite32x56
    ret


; ================================================================
; get_digit_ptr
; Input:  A = digit (0–9)
; Output: DE = pointer to sprite data
; ================================================================
get_digit_ptr:
    ld hl, sprite_table	     ; set HL to the start of the sprite table
    ld e, a		     
    ld d, 0		             ; put the digit from A into DE
    add hl, de		          
    add hl, de		         ; add 2*digit to get to the right part of the sprite table since each digit in that table is 2 bytes
    ld e, (hl)		         ; copy lower byte from the sprite table into E
    inc hl		             ; move HL up one to look at the higher byte in the sprite table
    ld d, (hl)		         ; copy higher byte from the sprite table into E
    ret			             ; now DE contains a pointer to the relevant sprite data


; ================================================================
; draw_sprite32x56
; HL = source (sprite)
; DE = destination (PlotSScreen)
; ================================================================
draw_sprite32x56:
    ld b, 56		         ; B is our row counter. each sprite is 56 rows so we want to repeat row_loop 56 times
row_loop:
    push bc		             ; save off BC to the stack to preserve our row counter as we will soon use BC for a column counter
    ld bc, 4		         ; BC is now our column counter. each sprite is 4 bytes wide so we want to copy 4 times
    ldir                     ; copies all 4 bytes for this row. HL+=4, DE+=4, BC-=4 -> BC=0
    pop bc		             ; restore BC so we get our row counter back
    ld a, e		             ; we already moved 4 bytes, but a full row is 12 bytes, so to get to the next row, we have to move an additional 8 bytes
    add a, 8
    ld e, a		             ; add 8 onto DE to update our destination to the start of the next row
    jr nc, skip_inc_d	     ; if no carry occurs when adding 8 to E, skip to skip_inc_d. else, increment D to account for carry
    inc d
skip_inc_d:
    djnz row_loop	         ; decrement BC (our row counter) and run row_loop again. when BC=0 it will move to the next line and return
    ret


; ================================================================
; Sprite table and data
; ================================================================
sprite_table:
    .dw digit0
    .dw digit1
    .dw digit2
    .dw digit3
    .dw digit4
    .dw digit5
    .dw digit6
    .dw digit7
    .dw digit8
    .dw digit9

digit0:
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
digit1:
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
digit2:
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
digit3:
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
digit4:
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF

digit5:
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
digit6:
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $00, $00, $00
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF

digit7:
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
digit8:
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
digit9:
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $00, $00, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $00, $00, $00, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF
    .db $FF, $FF, $FF, $FF

.end
.end
