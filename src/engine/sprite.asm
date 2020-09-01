
; Updates all sprites based on main sprite
UpdateSprites:
; Update Y pos
    ld c, 0
    ld de, $4
    ld hl, SPRITES_START
.loop
    call UpdateVertical
    add hl, de
    inc c
    ld a, [wSpriteNum]
    dec a
    cp c
    jr nc, .loop

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
    cp SIZE_SMALL
    jr z, .small_skip ; no 2nd sprite
    add c
    ld c, a
    ld a, [hl] ; vertical update
    add hl, de
    ld [hl], a
    ; 3rd sprite check
    ld a, [wSpriteSize]
    cp SIZE_BIG
    jr nz, .small_skip ; no 3rd sprite
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
    jr z, .small_skip ; no 2nd sprite
    add c
    ld c, a
    ld a, [hl] ; take x position
    add 8
    add hl, de
    ld [hl], a ; copy x position + 8
    ; 3rd sprite check
    ld a, [wSpriteSize]
    cp SIZE_BIG
    jr nz, .small_skip ; no 3rd sprite
    add c
    ld c, a
    ld a, [hl] ; take x position
    add 8
    add hl, de
    ld [hl], a
.small_skip
    ret

; Takes sprite id in `wCurSprite` and variable in `wSpriteCurVar` and value in `wSpriteByte`
SetSpriteVar:
    push bc
    push hl
    ld a, [wCurSprite]
    ld b, a
    ld a, [wSpriteCurVar]
    ld c, 20
    call SimpleMultiply
    add b ; b + a
    ld c, a
    ld b, 0
    ld hl, wSpriteVars
	add hl, bc
    ld a, [wSpriteByte]
	ld [hl], a
    pop hl
    pop bc
    ret

SetSpriteVarSimple: ; when bc is already set
    push hl
    ld hl, wSpriteVars
	add hl, bc
    ld a, [wSpriteByte]
	ld [hl], a
    pop hl
    ret

DecSpriteVar: ; `b` is lower limit
    push bc
    dec b
    call GetSpriteVar
    dec a
    cp b
    jr nz, .done
    ld a, b
    inc a
.done
    ld [wSpriteByte], a
    call SetSpriteVar
    pop bc
    ret

IncSpriteVar: ; `b` is upper limit
    push bc
    inc b
    call GetSpriteVar
    inc a
    cp b
    jr nz, .done
    ld a, b
    dec a
.done
    ld [wSpriteByte], a
    call SetSpriteVar
    pop bc
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
    ld a, ANIM_MOVE_DOWN
    ld [wSpriteByte], a
    call SetAnimationPointer
.spritemax
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

    ; Ends spawning sprites if we already spawned 3 sprites (max size reached)
    ld a, [wSpriteSize]
    inc a
    ld b, a
    ld a, [wCurSpriteLoop]
    cp b
    ret z
    
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

GetSpriteSize:
    ld a, SPR_PROPERTIES
    ld [wSpriteCurVar], a
    call GetSpriteVar
    and SIZE_MASK
    swap a
    ld [wSpriteSize], a
    ret

LoadSpriteAttrs:
    call GetSpriteSize
    call SetSpriteAnim
    call GetSpriteAnim
	ld bc, 0
.loop
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
    cp -1
    jr nz, .loop
    ld a, [wSpriteSize]
    cp SIZE_BIG
    ld hl, wSpriteEnd
    jr z, .mark_end
    ld hl, wSpriteY
    add hl, bc
.mark_end
    ld a, -1
	ld [hl], a
    ret
