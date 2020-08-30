VBlankRoutine:
    push af
    push bc
    push de
    push hl
	xor a
    ld [wVBlankOccurred], a
    ld a, 1
    ld [coreVBlankDone], a

    ld a, [wMenuMode]
    cp MENU_TITLE_ANIM
    jr nz, .not_menu
    ld a, [wMenuAnimSpeed]
    cp 0
    jr z, .menu_anim_1
    cp 1
    jr z, .menu_anim_2
; backup
    ldh a, [SCROLL_Y]
    and a
    jr z, .up_anim_speed
    ldh a, [SCROLL_Y]
	add 4
	ldh [SCROLL_Y], a
    jr .not_menu

.menu_anim_1 ; down fast
    ldh a, [SCROLL_Y]
    cp 32
    jr z, .up_anim_speed
    ldh a, [SCROLL_Y]
	sub 8
	ldh [SCROLL_Y], a
    jr .not_menu

.menu_anim_2 ; down slow
    ldh a, [SCROLL_Y]
    add 12
    and a
    jr z, .up_anim_speed
    ldh a, [SCROLL_Y]
	sub 4
	ldh [SCROLL_Y], a
    jr .not_menu
.up_anim_speed
    ld a, [wMenuAnimSpeed]
    inc a
    ld [wMenuAnimSpeed], a
.not_menu
    ld a, [wPlaySound]
	and a
	jr z, .no_sound
	call PlaySoundHL
.no_sound

    pop hl
    pop de
    pop bc
    pop af
	reti

