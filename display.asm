.nolist
#include "ti83plus.inc"
.list
.org userMem
.db t2ByteTok, tAsmCmp

; =======================================================
; Displays one 32x56 sprite corresponding to Ans (0–9)
; =======================================================

    bcall(_GrBufClr)
    bcall(_RclAns)
    bcall(_ConvOP1)        ; A = value in Ans (0–255)
    cp 10
    jr c, digit_ok
    xor a                  ; if >=10, default to 0
digit_ok:
    ld hl, sprite_table
    ld e,a
    ld d,0
    add hl,de
    add hl,de              ; multiply by 2 (each entry is 2 bytes)
    ld e,(hl)
    inc hl
    ld d,(hl)              ; DE = pointer to sprite data

    ld hl, PlotSScreen + (4*12) + 0  ; HL = destination on screen
    call draw_sprite32x56

    bcall(_GrBufCpy)
    ret

; =======================================================
; Draw 32x56 (4x7 bytes) sprite to PlotSScreen
; Each row = 4 bytes (32 bits), total 56 rows
; =======================================================
; HL = destination address in PlotSScreen
; DE = source sprite pointer

draw_sprite32x56:
    push bc
    ld b,56                 ; 56 rows tall
draw_row:
    push bc
    push hl
    push de
    ld bc,4
    ldir                    ; copy 4 bytes across (32 bits wide)
    pop de
    pop hl
    ld a,d
    add a,12                ; move down one screen row (12 bytes/row)
    ld d,a
    pop bc
    djnz draw_row
    pop bc
    ret

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
; Placeholder sprite data (fill in yourself)
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



