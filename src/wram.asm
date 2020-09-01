SECTION "WRAM",WRAM0[$C200]
wTemp:: ds 1
coreVBlankDone :: db
wVBlankOccurred:: db
wGameLoop:: db
wMenuMode:: db
wMenuAnimSpeed:: db
wMenuAnimSet:: db
wMenuAnimCount:: db
wMenuCursor:: db
wPlaySound:: dw
wStage:: db

wPalTemp:: db

; Sprites
wSpriteNum::         db     ; Number of sprites in use
wCurSprite::         db     ; Current sprite being dealt with
wCurSpriteLoop::     db     ; Current sprite being dealt with
wSpriteY::     ds MAX_SIZE  ; Current Sprite Y
wSpriteX::     ds MAX_SIZE  ; Current Sprite X
wSpriteTile::  ds MAX_SIZE  ; Current Sprite Tile 
wSpriteFlags:: ds MAX_SIZE  ; Current Sprite Flags
wSpriteEnd::         db 
wSpriteSize::        db     ; Current Sprite Size
wSpriteCurVar::      db     ; Current Sprite Variable being dealt with
wSpriteByte::        db     ; Last value of a sprite variable

UNION
wSpriteVars:: ds 7 * 20
NEXTU
wSpriteVar1::        ds 20  ; SPR_PROPERTIES
wSpriteVar2::        ds 20  ; SPR_VAR1
wSpriteVar3::        ds 20  ; SPR_VAR2
wSpriteVar4::        ds 20  ; SPR_VAR3
wSpriteAnimDur::     ds 20  ; SPR_ANIM_DUR    ; Counts down time frames until next animation frame
wSpriteAnimFrame::   ds 20  ; SPR_ANIM_FRAME  ; Current frame index
wSpriteAnimFrames::  ds 20  ; SPR_ANIM_FRAMES ; Number of frames in cur anim
wSpriteAnimChanged:: ds 20  ; SPR_ANIM_CHANGED
ENDU
wSpriteAnim::        ds 40  ; Pointer to animation

; Player
wPlayerMotionX:: db
wPlayerMotionY:: db
wPlayerSpriteId:: db
