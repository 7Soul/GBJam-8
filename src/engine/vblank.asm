VBlankRoutine:
	xor a
    ld [wVBlankOccurred], a
    ld a, 1
    ld [coreVBlankDone], a
	reti