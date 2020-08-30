VBlankRoutine:
    push af
    push bc
    push de
    push hl
	xor a
    ld [wVBlankOccurred], a
    ld a, 1
    ld [coreVBlankDone], a
    pop hl
    pop de
    pop bc
    pop af
	reti