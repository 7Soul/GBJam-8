VBlankRoutine:
    push af
    push bc
    push de
    push hl

    ldh a, [hVBlanks]
    inc a
    ldh [hVBlanks], a

	xor a
    ld [wVBlankOccurred], a
    ld a, 1
    ld [coreVBlankDone], a

    ld a, [wMenuAnimSpeed]
    dec a
    ld [wMenuAnimSpeed], a
    
; Title Screen Animation
    ld a, [wMenuMode]
    cp MENU_TITLE_ANIM
    jr nz, .not_menu
;     ld a, [wMenuAnimSpeed]
;     cp 0
;     jr z, .menu_anim_1
;     cp 1
;     jr z, .menu_anim_2
; ; backup
;     ldh a, [SCROLL_Y]
;     and a
;     jr z, .up_anim_speed
;     ldh a, [SCROLL_Y]
; 	add 4
; 	ldh [SCROLL_Y], a
;     jr .not_menu

.menu_anim_1 ; down fast
    ld a, [wMenuAnimSpeed]
    and a
    jr nz, .not_menu
    ldh a, [SCROLL_Y]
	dec a
	dec a
	ldh [SCROLL_Y], a
    and a
    jr z, .not_menu
    
    

; .menu_anim_2 ; down slow
;     ldh a, [SCROLL_Y]
;     add 12
;     and a
;     jr z, .up_anim_speed
;     ldh a, [SCROLL_Y]
; 	sub 4
; 	ldh [SCROLL_Y], a
;     jr .not_menu
.up_anim_speed
    ; ldh a, [hVBlanks]
    ; and %11
    ; jr nz, .not_menu
    ld a, [wMenuAnimCount]
    dec a
    ld [wMenuAnimCount], a
    and a
    jr nz, .dont_decrease_speed
    ld a, 2
    ld [wMenuAnimCount], a

    ld a, [wMenuAnimSet]
    dec a
    ld [wMenuAnimSet], a
    ld [wMenuAnimSpeed], a
    and a
    jr nz, .not_menu
    inc a
    ld [wMenuAnimSet], a
    ld [wMenuAnimSpeed], a
.dont_decrease_speed
    ld a, [wMenuAnimSet]
    ld [wMenuAnimSpeed], a

.not_menu
    ld a, [wPlaySound]
	inc a
	jr z, .no_sound
	call PlaySoundHL
.no_sound
    pop hl
    pop de
    pop bc
    pop af
	reti

