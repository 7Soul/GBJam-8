; Loads main menu graphics
MainMenuLoad:
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
; fallthrough
MainMenu:
	ld a, $FF
	ld [wMenuMode], a
	call ShortWait
	call ShortWait
	ldh a, [SCROLL_Y]
	add 64
	ldh [SCROLL_Y], a
	xor a
	ld [wMenuMode], a
	; Draw title screen
	ld hl, Title
    ld de, BACKGROUND_MAPDATA_START
    lb bc, $14, $12
    call mCopyBackground

.loop
	call ReadKeys
	ldh a, [hJoypadDown]
	and KEY_START | KEY_A
	jr z, .nokeypress

	ld a, [wMenuMode]
	cp MENU_TITLE
	jr z, .end_menu
	cp MENU_LEVEL_SELECT
	jr z, .end_menu
	jr .loop


.end_menu
	ld a, MENU_LEVEL_SELECT
	ld [wMenuMode], a
	call ShortWait
	jp MenuLevelSelect

	ld a, 1
	ld [wGameLoop], a

	ld hl, Sound1
    ld a, h
    ld [wPlaySound], a
    ld a, l
    ld [wPlaySound + 1], a
	ret

.nokeypress
	ld a, [wMenuMode]
	cp MENU_TITLE_ANIM
	jr nz, .check_loop
	
	ld a, [wMenuAnimSpeed]
	cp 3
	jr nz, .check_loop

	ldh a, [SCROLL_Y]
    cp 0
	jr nz, .check_loop
	
	ld a, MENU_TITLE
	ld [wMenuMode], a
	call ShortWait
	; Draw Press Start
	lb de, $4, $D
    ld hl, .start_string
    call RenderTextToEnd
	; Draw credits
	lb de, $2, $11
    ld hl, .credits_string
    call RenderTextToEnd
.check_loop
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

MenuLevelSelect:
	xor a
    hlcoord 0, 11 ; x, y
	lb bc, 6, SCREEN_WIDTH ; h, w
    call FillBoxWithByte

	call ShortWait

	lb de, $7, $C
    ld hl, .level1_string
    call RenderTextToEnd

	lb de, $7, $D
    ld hl, .level2_string
    call RenderTextToEnd

	lb de, $7, $E
    ld hl, .level3_string
    call RenderTextToEnd

	call ShortWait

	ld a, $7F
	hlcoord $5, $C ; x, y
	ld bc, 1
	call mSetVRAM


.loop
	call ReadKeys
	ldh a, [hJoypadPressed]
	and KEY_DOWN
	jr nz, .key_down
	ldh a, [hJoypadPressed]
	and KEY_UP
	jr nz, .key_up
	ldh a, [hJoypadPressed]
	and KEY_START | KEY_A
	jr nz, .end

	jr .loop
.key_up
	ld a, [wMenuCursor]
	dec a
	cp -1
	jr nz, .update_cursor
	inc a
	jr .update_cursor
.key_down
	ld a, [wMenuCursor]
	inc a
	cp 3
	jr nz, .update_cursor
	dec a
.update_cursor
	ld [wMenuCursor], a
	ld hl, Sound2
    call LoadSound
	; Clear cursor
	xor a
    hlcoord $5, $C ; x, y
	lb bc, 3, 1 ; h, w
    call FillBoxWithByte

	hlcoord $5, $C ; x, y
	ld a, [wMenuCursor]
	ld c, a
	ld a, FULL_WIDTH + 1
	call SimpleMultiply
	ld b, 0
	ld c, a
	add hl, bc
	ld a, $7F
	ld bc, 1
	call mSetVRAM

	call ShortWait
	jr .loop
.end
	ret

.level1_string:
	db "Stage 1@"

.level2_string:
	db "Stage 2@"

.level3_string:
	db "Stage 3@"