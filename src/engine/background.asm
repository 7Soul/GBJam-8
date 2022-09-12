DrawBackground:
    ; Set background to use tileset from vram address 0
    ldh a, [rLCDC]
    res 4, a
    ldh [rLCDC], a

    call DrawStage

    ret

DrawStage:
    ld a, [wStage]
    ld hl, StagesTiles
    ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
    ld de, BACKGROUND_MAPDATA_START
    lb bc, $14, $12
    call mCopyBackground
    ret

StagesTiles:
    dw Stage1
    dw Stage2
    dw Stage3

Stage1:
INCBIN "data/stage1.tilemap"
Stage1End:

Stage2:
INCBIN "data/stage2.tilemap"
Stage2End:

Stage3:
INCBIN "data/stage2.tilemap"
Stage3End:

LoadGameGraphics:
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