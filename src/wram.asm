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
wSpriteNum::		 db     ; Number of sprites in use
wSpawnSprite::       db
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
wSpriteVars::        ds 9 * SPRITE_MAX
NEXTU
wSpriteVar1::        ds SPRITE_MAX  ; SPR_PROPERTIES
wSpriteVar2::        ds SPRITE_MAX  ; SPR_DIR
wSpriteVarYOff::     ds SPRITE_MAX  ; SPR_YOFFSET
wSpriteVarXOff::     ds SPRITE_MAX  ; SPR_XOFFSET
wSpriteAnimName::    ds SPRITE_MAX  ; SPR_ANIM_NAME
wSpriteAnimDur::     ds SPRITE_MAX  ; SPR_ANIM_DUR    ; Counts down time frames until next animation frame
wSpriteAnimFrame::   ds SPRITE_MAX  ; SPR_ANIM_FRAME  ; Current frame index
wSpriteAnimFrames::  ds SPRITE_MAX  ; SPR_ANIM_FRAMES ; Number of frames in current animation + loop properties
wSpriteAnimChanged:: ds SPRITE_MAX  ; SPR_ANIM_CHANGED
ENDU
wSpriteAnimGroup::   ds SPRITE_MAX * 2  ; Pointer to animation group
wSpriteAnimPointer:: ds SPRITE_MAX * 2  ; Pointer to animation
wSpriteAnim::        ds SPRITE_MAX * 2  ; Pointer to frame of anim

wSpriteAnimNext::    ds SPRITE_MAX * 2  ; Pointer to next animation

; Player
wPlayerMotionX:: db
wPlayerMotionY:: db
wPlayerSpriteId:: db
