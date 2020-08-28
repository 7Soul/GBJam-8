HBlankRoutine:
	push af
	push bc
	ld a, [wTemp]
	add	7
	ld [wTemp], a
	pop bc
	pop af
	reti