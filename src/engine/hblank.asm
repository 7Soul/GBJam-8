HBlankRoutine:
	push af
    push bc
    push de
    push hl
; 	ldh a, [rLY]
; 	and %111
; 	jr nz, .skip

; 	ldh a, [SCROLL_X]
; 	add 1
; 	ldh [SCROLL_X], a

; .skip
	pop hl
    pop de
    pop bc
    pop af
	reti
