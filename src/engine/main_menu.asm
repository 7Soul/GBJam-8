MainMenu:
	lb de, $4, $4
    ld hl, .title_string
    call RenderTextToEnd

	lb de, $4, $D
    ld hl, .start_string
    call RenderTextToEnd

.loop
	ld a,[coreVBlankDone]
    and a                  ; V-Blank interrupt ?
    jr z, .loop  ; No, some other interrupt
    xor a
    ld [coreVBlankDone],a  ; Clear V-Blank flag

	call ReadKeys
	ldh a, [hJoypadDown]
	and KEY_START | KEY_A
	jr z, .nokeypress

	ld a, 1
	ld [wGameLoop], a

	ld hl, Sound1
    ld a, h
    ld [wPlaySound], a
    ld a, l
    ld [wPlaySound + 1], a

.nokeypress
	ld a, [wGameLoop]
	and a
	jr z, .loop

	call ClearBackground
	call TurnOnWindow

	ret

.title_string:
	db "7Soul's Game@"

.start_string:
	db "Press Start@"
