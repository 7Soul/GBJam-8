; This section is for including files that either need to be in the home section, or files where it doesn't matter 
SECTION "Includes@home",ROM0

INCLUDE "gingerbread.asm"
INCLUDE "constants.asm"
INCLUDE "macros.asm"
INCLUDE "home.asm"
INCLUDE "math.asm"
INCLUDE "engine/vblank.asm"
INCLUDE "engine/hblank.asm"

SECTION "Home", ROM0

Start:
    ld hl, FontTiles
    ld de, TILEDATA_START
    ld bc, FontTilesEnd - FontTiles
    call mCopyVRAM

    ld hl, SpriteTiles
    ld de, TILEDATA_START + FontTilesEnd - FontTiles
    ld bc, SpriteTilesEnd - SpriteTiles
    call mCopyVRAM

    call StartLCD
	call EnableAudio

    jp Main

Main:
	call MainMenu

	ld a, PLAYER + SIZE_MEDIUM
    ld [wSpriteByte], a
    ld a, SPR_PROPERTIES
    ld [wSpriteCurVar], a
    call SetSpriteVar

	ld de, .player_sprites
	call LoadSpriteAttrs
	
	call SpawnSprite

	xor a
	ld [wPlayerSpriteId], a
	
	call RenderTimer

.main_loop_game:
	; Wait for V-Blank
    ld a,[coreVBlankDone]
    and a                  ; V-Blank interrupt ?
    jr z, .main_loop_game  ; No, some other interrupt
    xor a
    ld [coreVBlankDone],a  ; Clear V-Blank flag

    call UpdateGame

	; ld a, [wPalTemp]
	; add	7
	; ld [wPalTemp], a
	; jr	nc, .main_loop_game	; when A overflows, we execute instructions below

	; ld	hl, BG_PALETTE	; HL points to background palette
	; rlc	[hl]
	; rlc	[hl]

    jr .main_loop_game

.player_sprites:
	db SCREEN_HEIGHT / 2 * 8, SCREEN_WIDTH / 2 * 8, $80, $00 ; sprite 0
	db SCREEN_HEIGHT / 2 * 8, SCREEN_WIDTH / 2 * 8, $80, SPRITE_FLIPX ; sprite 1
	db -1, -1, -1, -1 ; sprite 2

UpdateGame::
	call ReadKeys
	call MoveSprite
	call IncreaseTimer

	
; 	ld a, [wPlaySound]
; 	and a
; 	jr z, .no_sound
; 	call PlaySoundHL
; .no_sound
	reti

INCLUDE "engine/timer.asm"
INCLUDE "engine/sprite.asm"
INCLUDE "engine/main_menu.asm"


SECTION "Graphics", ROMX

FontTiles:
INCBIN "gfx/backgrounds/font.2bpp"
FontTilesEnd:

SpriteTiles:
INCBIN "gfx/sprites/sprite.2bpp"
SpriteTilesEnd:


SECTION "Sounds", ROMX

Sound1:
dw SOUND_CH4_START
db %00000000 ; Data to be written to SOUND_CH4_STARTwsl
esl

db %00000100 ; Data to be written to SOUND_CH4_LENGTH
db %11110111 ; Data to be written to SOUND_CH4_ENVELOPE 
db %01010101 ; Data to be written to SOUND_CH4_POLY 
db %11000110 ; Data to be written to SOUND_CH4_OPTIONS

Sound2:
dw SOUND_CH1_START
db %00000000 ; Data to be written to SOUND_CH4_START
db %00001000 ; Data to be written to SOUND_CH4_LENGTH
db %11110111 ; Data to be written to SOUND_CH4_ENVELOPE 
db %01010101 ; Data to be written to SOUND_CH4_POLY 
db %11000010 ; Data to be written to SOUND_CH4_OPTIONS

INCLUDE "wram.asm"
INCLUDE "hram.asm"


; .loop_until_line_144
; 	ld	a, [rLY]	; get lcd line number (which line# is drawn)
; 	cp	144
; 	jp	nz, .loop_until_line_144
; .loop_until_line_145
; 	ld	a, [rLY]
; 	cp	145
; 	jp	nz, .loop_until_line_145


; 	ld	a, [SCROLL_X]
; 	add 2
; 	ld	[SCROLL_X], a


	