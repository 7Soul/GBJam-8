INCLUDE "macros/sprite.asm"

lb: MACRO ; r, hi, lo
	ld \1, ((\2) & $ff) << 8 | ((\3) & $ff)
ENDM

ldw: MACRO ; Load constant 2 into wRAM byte 1
	ld a, \2
	ld [\1], a
ENDM

; Data

hlcoord EQUS "coord hl,"
bccoord EQUS "coord bc,"
decoord EQUS "coord de,"

coord: MACRO
; register, x, y[, origin]
	if _NARG < 4
	ld \1, (\3) * (SCREEN_WIDTH + CANVAS_WIDTH) + (\2) + BACKGROUND_MAPDATA_START
	else
	ld \1, (\3) * SCREEN_WIDTH + (\2) + \4
	endc
ENDM

dbw: MACRO
	db \1
	dw \2
ENDM

dba: MACRO ; dbw bank, address
rept _NARG
	dbw BANK(\1), \1
	shift
endr
ENDM

; Constants

const_def: MACRO
if _NARG >= 1
const_value = \1
else
const_value = 0
endc
if _NARG >= 2
const_inc = \2
else
const_inc = 1
endc
ENDM

const: MACRO
\1 EQU const_value
const_value = const_value + const_inc
ENDM

; Math

sine_table: MACRO
; \1 samples of sin(x) from x=0 to x<32768 (pi radians)
x = 0
rept \1
	dw (sin(x) + (sin(x) & $ff)) >> 8 ; round up
x = x + DIV(32768, \1) ; a circle has 65536 "degrees"
endr
ENDM

calc_sine_wave: MACRO
; input: a = a signed 6-bit value
; output: a = d * sin(a * pi/32)
	and %111111
	cp %100000
	jr nc, .negative\@
	call .apply\@
	ld a, h
	ret
.negative\@
	and %011111
	call .apply\@
	ld a, h
	xor $ff
	inc a
	ret
.apply\@
	ld e, a
	ld a, d
	ld d, 0
if _NARG == 1
	ld hl, \1
else
	ld hl, .sinetable\@
endc
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, 0
.multiply\@ ; factor amplitude
	srl a
	jr nc, .even\@
	add hl, de
.even\@
	sla e
	rl d
	and a
	jr nz, .multiply\@
	ret
if _NARG == 0
.sinetable\@
	sine_table 64
endc
ENDM


change_animation: MACRO
	ldw wSpriteByte, \1
	ldw wSpriteCurVar, SPR_DIR
    call SetSpriteVar
	ldw wSpriteByte, 1
    ldw wSpriteCurVar, SPR_ANIM_CHANGED
    call SetSpriteVar
    ldw wSpriteByte, 0
	ldw wSpriteCurVar, SPR_ANIM_DUR
	call SetSpriteVar
	; call AnimNextFrame
	; call UpdateAnimations
ENDM

anim_group: MACRO
	db \1 + (\2 << 3) ; frames and loop
	dw \3             ; pointer to animation
	dw \4             ; pointer to next animation
ENDM

anim: MACRO
	dw \1_1
	dw \1_2
	dw \1_3
	dw \1_4
ENDM

anim_frame: MACRO
	db \2, \1         ; X and Y offsets
	db \3             ; sprite tile
	db \4             ; sprite flags
ENDM

