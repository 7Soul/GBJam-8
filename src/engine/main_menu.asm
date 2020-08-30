MainMenu:
	xor a
	push af
	ld a, BANK("Graphics")
	rst Bankswitch

    ld hl, FontTiles
    ld de, TILEDATA_START
    ld bc, FontTilesEnd - FontTiles
    call mCopyVRAM

	ld hl, TitleTiles
    ld de, TILEDATA_START + FontTilesEnd - FontTiles
    ld bc, TitleTilesEnd - TitleTiles
    call mCopyVRAM

	pop af
	rst Bankswitch

	call StartLCD

	ld hl, Title
    ld de, BACKGROUND_MAPDATA_START
    lb bc, $14, $12
    call mCopyBackground

	lb de, $4, $D
    ld hl, .start_string
    call RenderTextToEnd

	lb de, $2, $11
    ld hl, .credits_string
    call RenderTextToEnd

.loop
	; ld a,[coreVBlankDone]
    ; and a                  ; V-Blank interrupt ?
    ; jr z, .loop            ; No, some other interrupt
    ; xor a
    ; ld [coreVBlankDone], a ; Clear V-Blank flag

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
	ret

.nokeypress
	ld a, [wGameLoop]
	and a
	jr z, .loop

	ret

.start_string:
	db "Press Start@"

.credits_string:
	db "A GAME BY 7SOUL@"

Title:
INCBIN "data/title.tilemap"
TitleEnd: