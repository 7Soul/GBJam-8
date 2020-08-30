DrawBackground:
    ldh a, [rLCDC]
    res 4, a
    ldh [rLCDC], a

    call DrawBorder

    ld a, 5
    call DrawEntrance

    ; ld hl, .data
    ; ld de, BACKGROUND_MAPDATA_START + 32
    ; ld bc, 1
    ; call mCopyVRAM


    ret

.data:
    db $4

DrawBorder:
    ld hl, Border
    ld de, BACKGROUND_MAPDATA_START
    lb bc, $14, $12
    call mCopyBackground
    ret

DrawEntrance:
    ret

Border:
INCBIN "data/border.tilemap"
BorderEnd:

LoadGameGraphics::
    xor a
	push af
	ld a, BANK("Graphics")
	rst Bankswitch

    ld hl, FontTiles
    ld de, TILEDATA_START
    ld bc, FontTilesEnd - FontTiles
    call mCopyVRAM

	ld hl, SpriteTiles
    ld de, TILEDATA_START + FontTilesEnd - FontTiles
    ld bc, SpriteTilesEnd - SpriteTiles
    call mCopyVRAM

	ld hl, BackgroundTiles
    ld de, TILEDATA_START + FontTilesEnd - FontTiles + SpriteTilesEnd - SpriteTiles
    ld bc, BackgroundTilesEnd - BackgroundTiles
    call mCopyVRAM

	pop af
	rst Bankswitch


    ret