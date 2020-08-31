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
	; Set initial background animation positions
	ldh a, [SCROLL_Y]
	add 80
	ldh [SCROLL_Y], a
	ld a, 2
	ld [wMenuAnimSet], a
	ld [wMenuAnimSpeed], a
	ld [wMenuAnimCount], a
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

.nokeypress
	ld a, [wMenuMode]
	cp MENU_TITLE_ANIM
	jr nz, .check_loop
	
	; ld a, [wMenuAnimSpeed]
	; cp 3
	; jr nz, .check_loop

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
	; Clear lower half background
	xor a
    hlcoord 0, 11 ; x, y
	lb bc, 6, SCREEN_WIDTH ; h, w
    call FillBoxWithByte

	call ShortWait
	; Draw text
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
	; Draws cursor at initial position
	hlcoord $5, $C ; x, y
	call DrawCursor

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
	; Move cursor up
	ld a, [wMenuCursor]
	dec a
	cp -1
	jr nz, .update_cursor
	inc a
	jr .update_cursor
.key_down
	; Move cursor down
	ld a, [wMenuCursor]
	inc a
	cp 3
	jr nz, .update_cursor
	dec a
.update_cursor
	ld [wMenuCursor], a
	ld [wStage], a
	ld hl, Sound2
    call LoadSound

	; Clear cursor area
	xor a
    hlcoord $5, $C ; x, y
	lb bc, 3, 1 ; h, w
    call FillBoxWithByte

	; Draw cursor
	hlcoord $5, $C ; x, y
	ld a, [wMenuCursor]
	ld c, a
	ld a, FULL_WIDTH + 1
	call SimpleMultiply
	ld b, 0
	ld c, a
	add hl, bc
	call DrawCursor

	call ShortWait
	jr .loop
.end
	ld a, 1
	ld [wGameLoop], a

	; Play confirmation sound
	ld hl, Sound1
    call LoadSound

	ret

.level1_string:
	db "Stage 1@"

.level2_string:
	db "Stage 2@"

.level3_string:
	db "Stage 3@"

; Takes coordinate in `hl`
DrawCursor:
	ld a, $7F
	ld bc, 1
	call mSetVRAM
	ret