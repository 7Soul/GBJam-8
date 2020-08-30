INCLUDE "macros/sprite.asm"

lb: MACRO ; r, hi, lo
	ld \1, ((\2) & $ff) << 8 | ((\3) & $ff)
ENDM

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
