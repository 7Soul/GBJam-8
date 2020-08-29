SECTION "WRAM",WRAM0[$C200]
wTemp:: ds 1
coreVBlankDone :: db
wVBlankOccurred:: db
wGameLoop:: db
wPlaySound:: dw

wPalTemp:: db

; Sprites
wSpriteNum::   db          ; Number of sprites in use
wCurSprite::   db          ; Current sprite being dealt with
wCurSpriteLoop::   db      ; Current sprite being dealt with
wSpriteY::     ds MAX_SIZE ; Current Sprite Y
wSpriteX::     ds MAX_SIZE ; Current Sprite X
wSpriteTile::  ds MAX_SIZE ; Current Sprite Tile 
wSpriteFlags:: ds MAX_SIZE ; Current Sprite Flags
wSpriteSize::  db          ; Current Sprite Size
wSpriteCurVar:: db         ; Current Sprite Variable being dealt with
wSpriteByte::  db          ; Last value of a sprite variable

UNION
wSpriteVars:: ds 7 * 20
NEXTU
wSpriteVar1:: ds 20 ; SPR_PROPERTIES
wSpriteVar2:: ds 20 ; 
wSpriteVar3:: ds 20 ;
wSpriteVar4:: ds 20 ;
wSpriteAnim:: ds 20 ; SPR_ANIM
wSpriteDuration:: ds 20 ; SPR_ANIM_DUR
wSpriteAnimFrame:: ds 20 ; SPR_ANIM_FRAME
ENDU

wPlayerSpriteId:: db
