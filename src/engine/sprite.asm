
MoveSprite:
    xor a
    ld [wCurSprite], a
    ldh a, [hJoypadDown]
    push af
    and KEY_RIGHT
    call nz, .MoveSpriteRight
    pop af
    push af
    and KEY_LEFT
    call nz, .MoveSpriteLeft
    pop af
    push af
    and KEY_UP
    call nz, .MoveSpriteUp
    pop af
    and KEY_DOWN
    call nz, .MoveSpriteDown

    ldh a, [hJoypadPressed]
    and KEY_A
    call nz, .Fire
    
    ret

.MoveSpriteRight:
    call GetSpriteXAttr
	add MOVE_SPEED
    cp MARGIN_RIGHT
    ret nc
    ld [wSpriteX], a
	call SetSpriteXAttr
    ; ld hl, Sound1
    ; call LoadSound

    ret

.MoveSpriteLeft:
    call GetSpriteXAttr
	sub MOVE_SPEED
    cp MARGIN_LEFT + 8
    ret c
    ld [wSpriteX], a
	call SetSpriteXAttr
    ret

.MoveSpriteUp:
    call GetSpriteYAttr
	sub MOVE_SPEED
    cp MARGIN_TOP + 8
    ret c
    ld [wSpriteY], a
	call SetSpriteYAttr
    ret

.MoveSpriteDown:
    call GetSpriteYAttr
	add MOVE_SPEED
    cp MARGIN_BOT - 8
    ret nc
    ld [wSpriteY], a
	call SetSpriteYAttr
    ret

.Fire:
    ld a, [wSpriteNum]
    ld [wCurSprite], a
    ld a, BULLET + SIZE_MEDIUM
    ld [wSpriteByte], a
    ld a, SPR_PROPERTIES
    ld [wSpriteCurVar], a
    call SetSpriteVar

    ld de, .bullet_sprites
    call LoadSpriteAttrs

    xor a
    ld [wCurSprite], a
    call GetSpriteXYAttr
    ld a, [wSpriteX]
    ld [wSpriteX + 1], a
    ld a, [wSpriteY]
    ld [wSpriteY + 1], a
    call SpawnSprite

    ret

.bullet_sprites:
	db 0, 0, $82, $00 ; sprite 0
	db 0, 0, $82, SPRITE_FLIPY ; sprite 1
	db -1, -1, -1 ; sprite 2

; Updates all sprites based on main sprite
UpdateSprites:
; Update Y pos
    ld c, 0
    ld de, $4
    ld hl, SPRITES_START
.loop
    ; push hl
    ; ld hl, SPRITES_START + 2 ; Tile ID
    ; add hl, de
    ; ld a, [hl]
    ; pop hl
    ; and a
    ; jr z, .last_sprite
    call UpdateVertical
    add hl, de
    inc c
    ld a, [wSpriteNum]
    dec a
    cp c
    jr nc, .loop

; .last_sprite
; Update X pos
    ld c, 0
    ld de, $4
    ld hl, SPRITES_START + 1
.loop2
    call UpdateHorizontal
    add hl, de
    inc c
    ld a, [wSpriteNum]
    dec a
    cp c
    jr nc, .loop2
    ret

UpdateVertical:
    ld a, c
    ld [wCurSprite], a
    call GetSpriteSize
    and a
    jr z, .small_skip
    add c
    ld c, a
    ld a, [hl] ; vertical update
    add hl, de
    ld [hl], a
.small_skip
    ret

UpdateHorizontal:
    ld a, c
    ld [wCurSprite], a
    call GetSpriteSize
    and a
    jr z, .small_skip
    add c
    ld c, a
    ld a, [hl] ; take x position
    add 8
    add hl, de
    ld [hl], a ; copy x position + 8
.small_skip
    ret

; Takes sprite id in `wCurSprite` and variable in `wSpriteCurVar` and value in `wSpriteByte`
SetSpriteVar:
    push hl
    push bc
    ld a, [wCurSprite]
    ld b, a
    ld a, [wSpriteCurVar]
    ld c, 20
    call SimpleMultiply
	ld hl, wSpriteVars
    add b
    ld c, a
    ld b, 0
	add hl, bc
    ld a, [wSpriteByte]
	ld [hl], a
    pop bc
    pop hl
    ret

; Takes sprite id in `wCurSprite` and variable in `wSpriteCurVar` 
; Returns value in `wSpriteByte` and `a`
GetSpriteVar:
    push hl
    push bc
    ld a, [wCurSprite]
    ld b, a
    ld a, [wSpriteCurVar]
    ld c, 20
    call SimpleMultiply
	ld hl, wSpriteVars
    add b
    ld c, a
    ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wSpriteByte], a
    pop bc
    pop hl
    ret

; Creates a new sprite
SpawnSprite:
    ld a, [wSpriteNum]
    ld [wCurSprite], a
    cp 40
    jr z, .spritemax

    ld [wCurSprite], a
    call InitSpriteAttr
.spritemax
    ret

GetSpriteSize:
    ld a, SPR_PROPERTIES
    ld [wSpriteCurVar], a
    call GetSpriteVar
    and SIZE_MASK
    swap a
    ret

; Takes sprite id in `wCurSprite`
InitSpriteAttr:
    xor a
    ld [wCurSpriteLoop], a
.loop
    ld hl, wSpriteY
    ld a, [wCurSpriteLoop]
    ld b, 0
    ld c, a
    add hl, bc
    ld d, h
    ld e, l
    ld a, [de]
    cp -1
    ret z

    ld a, [wCurSprite]
    ld c, 4
    call SimpleMultiply
    ld hl, SPRITES_START
    ld b, 0
    ld c, a
    add hl, bc

    ld a, [de]
    add 16
    ld [hli], a
    call .NextDe
    ld a, [de]
    add 8
    ld [hli], a
    call .NextDe
    ld a, [de]
    ld [hli], a
    call .NextDe
    ld a, [de]
    ld [hl], a

    ld hl, wCurSprite
    inc [hl]
    ld hl, wCurSpriteLoop
    inc [hl]
    ld hl, wSpriteNum
    inc [hl]
    
    jr .loop
    ret

.NextDe:
    inc de
    inc de
    inc de
    ret

; Takes sprite id in `wCurSprite`
SetSpriteTile:
    ld a, [wCurSprite]
    ld hl, SPRITES_START + 2
    ld b, 0
    ld c, a
    add hl, bc
    ld a, [wSpriteTile]
    ld [hl], a
    ret

GetSpriteXYAttr:
    call GetSpriteYAttr
    call GetSpriteXAttr
    ret

; Takes sprite id in `wCurSprite`
GetSpriteYAttr:
    ld a, [wCurSprite]
    ld hl, SPRITES_START
    ld b, 0
    ld c, a
    add hl, bc
    ld a, [hl]
    ld [wSpriteY], a
    ret

; Takes sprite id in `wCurSprite`
SetSpriteYAttr:
    ld a, [wCurSprite]
    ld hl, SPRITES_START
    ld b, 0
    ld c, a
    add hl, bc
    ld a, [wSpriteY]
    ld [hl], a
    ret

; Takes sprite id in `wCurSprite`
GetSpriteXAttr:
    ld a, [wCurSprite]
    ld hl, SPRITES_START + 1
    ld b, 0
    ld c, a
    add hl, bc
    ld a, [hl]
    ld [wSpriteX], a
    ret

; Takes sprite id in `wCurSprite`
SetSpriteXAttr:
    ld a, [wCurSprite]
    ld hl, SPRITES_START + 1
    ld b, 0
    ld c, a
    add hl, bc
    ld a, [wSpriteX]
    ld [hl], a
    ret

LoadSpriteAttrs:
    ld bc, 0
.loop
	ld a, [de]
    ld hl, wSpriteY
    add hl, bc
	ld [hl], a
    inc de

    ld a, [de]
    ld hl, wSpriteX
    add hl, bc
	ld [hl], a
    inc de

    ld a, [de]
    ld hl, wSpriteTile
    add hl, bc
	ld [hl], a
    inc de

    ld a, [de]
    ld hl, wSpriteFlags
    add hl, bc
	ld [hl], a
    inc de
    
    inc c
    ld a, [de]
    ld hl, wSpriteY
    add hl, bc
	ld [hl], a
    cp -1
    jr nz, .loop
    ret


UpdateAnimations:
    xor a
    ld [wCurSprite], a
.loop
    ld a, SPR_ANIM_FRAME
    ld [wSpriteCurVar], a
    call GetSpriteVar
    
    inc a
    ld [wSpriteByte], a
    call SetSpriteVar

    ld a, [wCurSprite]
    inc a
    ld [wCurSprite], a
    ld c, a
    ld a, [wSpriteNum]
    cp c
    jr nc, .loop
    ret