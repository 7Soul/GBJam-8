HBlankRoutine:
	push af
    push bc
    push de
    push hl

; 	ld a, [wGameLoop]
;     and a
;     jr nz, .skip
; 	; ld a, [wMenuMode]
;     ; cp MENU_TITLE_ANIM
;     ; jr nz, .skip

; 	WaitForNonBusyLCD
	
; 	ldh a, [rLY]
; 	cp $58
; 	jr nc, .reset_scroll

; 	ldh a, [rLY]
; 	and %1000
; 	jr nz, .skip2
; 	ldh a, [hHBlanks]
; 	inc a
; 	ldh [hHBlanks], a

; .skip2
; 	ldh a, [hHBlanks]
; 	ld d, 8
; 	call Sine
; 	ldh [SCROLL_X], a
; 	jr .skip

; .reset_scroll
; 	xor a
; 	ldh [SCROLL_X], a
	
; .skip
	
	pop hl
    pop de
    pop bc
    pop af
	reti
