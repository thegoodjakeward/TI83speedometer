.nolist
#include "ti83plus.inc"
.list
.org userMem
.db t2ByteTok, tAsmCmp

    bcall(_GrBufClr)       ; clear graph buffer
    bcall(_RclAns)         ; recall what is in Ans
    bcall(_ConvOP1)        ; place what was in Ans in register A

    ; --- lookup pointer in sprite_table (HL -> table + 2*A) ---
    ld hl, sprite_table    ; HL points to the start of the sprite pointer table
    ld e, a
    ld d, 0                ; put the value of A into DE
    add hl, de
    add hl, de             ; the sprite pointers are two bytes apart, so adding DE (which is equal to A) twice will get you to the right pointer
    ld e, (hl)             ; copy the lower byte of the sprite pointer
    inc hl                 ; move HL one byte forward
    ld d, (hl)             ; copy the higher byte of the sprite pointer
                           ; now DE points to the sprite data

    ld hl, PlotSScreen + (4*12+1) ; set HL to point at the screen data. y-Offset = 4 rows (12 bytes per row), x-Offset = 1 byte
    ex de, hl                     ; swap DE and HL, so DE points at the screen data at the proper offset coordinates (our destination) and HL points to the sprite data

    ld b, 56               ; set B to 56 to act as our row counter. each digit is 56 rows so this will have our copy_row function execute 56 times
copy_row:
    push bc                ; put BC onto the stack to preserve our row counter
    ld bc, 4               ; set BC to 4 to act as our column counter. each digit is 4 bytes wide so this will ensure all 4 bytes are copied
    ldir                   ; copy 4 bytes from where HL points to where DE points: (HL)->(DE), HL+=4, DE+=4, BC-=4 -> BC=0
    pop bc                 ; restore BC which restores our row counter into B

    ; add 8 to DE so net advance for DE is 12 (4 from LDIR + 8 manual)
    ld a, e                ; use A (the accumulator) to add 8 to DE
    add a, 8
    ld e, a                ; adding 8 to DE, the net advance for DE is 12 (4 from LDIR + 8 manual) which is one row downwards so we are set up to copy the next row
    jr nc, no_inc_d        ; check if a carry occured. if not jump to no_inc_d
    inc d                  ; if adding 8 to E cause a carry to occur, we add 1 to D so that DE holds the correct value
no_inc_d:

    djnz copy_row          ; decrements B and then runs copy_row until B = 0, thus all 56 rows will be copied

    bcall(_GrBufCpy)       ; copy the graph buffer to the screen, i.e. update the screen
    ret                    ; return

; =======================================================
; Sprite pointer table (10 entries, 2 bytes each)
; =======================================================
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

; =======================================================
; Each digit = 32x56 bits = 224 bytes = 4*56 bytes
; =======================================================
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



