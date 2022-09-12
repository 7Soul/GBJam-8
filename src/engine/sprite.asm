
; Updates all sprites based on meta sprite
UpdateSprites:
; Update Y pos
	ld c, 0
	ld de, $4
	ld hl, SPRITES_START + 0 ; OAM Y
.loop ; loop through all sprites, from 0 to wSpriteNum
	ld a, c
	ld [wCurSprite], a
	call GetSpriteSize

	call UpdateVertical
	add hl, de
	inc c
	ld a, [wSpriteNum]
	cp c
	jr nc, .loop
	jr z, .loop

; Update X pos
	ld c, 0
	ld de, $4
	ld hl, SPRITES_START + 1 ; OAM X
.loop2
	ld a, c
	ld [wCurSprite], a
	call GetSpriteSize

	call UpdateHorizontal
	add hl, de
	inc c
	ld a, [wSpriteNum]
	cp c
	jr nc, .loop2
	jr z, .loop2
	ret

UpdateVertical:
	ld a, [hl] ; take actor's y position
	ld b, a
	; go to actor's sprite 1 (0-index)
	ld a, c
	inc a
	ld [wCurSprite], a
	ld c, 1
.loop
	inc c
	ldw wSpriteCurVar, SPR_YOFFSET
	call GetSpriteVar
	add b
	add hl, de
	ld [hl], a ; copy y position + SPR_XOFFSET

	; next sprite
	ld a, [wCurSprite]
	inc a
	ld [wCurSprite], a

	; loop SpriteSize times
	ld a, [wSpriteSize]
	cp c
	jr nc, .loop

	ret

UpdateHorizontal:
	ld a, [hl] ; take actor's x position
	ld b, a
	; go to actor's sprite 1 (0-index)
	ld a, c
	inc a
	ld [wCurSprite], a
	ld c, 1
.loop
	inc c
	ldw wSpriteCurVar, SPR_XOFFSET
	call GetSpriteVar
	add b
	add hl, de
	ld [hl], a ; copy x position + SPR_XOFFSET

	; next sprite
	ld a, [wCurSprite]
	inc a
	ld [wCurSprite], a

	; loop SpriteSize times
	ld a, [wSpriteSize]
	cp c
	jr nc, .loop

	ret


; Takes sprite id in `wCurSprite` and variable in `wSpriteCurVar` 
; Returns value in `wSpriteByte` and `a`
GetSpriteVar:
	push hl
	call GetToVarsGroup
	ld a, [hl]
	ld [wSpriteByte], a
	pop hl
	ret

; Takes sprite id in `wCurSprite` and variable in `wSpriteCurVar` and value in `wSpriteByte`
SetSpriteVar:
	push hl
	call GetToVarsGroup
	ld a, [wSpriteByte]
	ld [hl], a
	pop hl
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

; Get to vars group (eg: wSpriteAnimFrame) taking a wSpriteCurVar constant (eg: SPR_ANIM_FRAME)
GetToVarsGroup:
	push de
	push bc
	ld hl, wSpriteVars
	ld a, [wSpriteCurVar]
	and a
	jr z, .first_var
	ld c, a
	ld d, 0
	ld e, SPRITE_MAX
	; move forward SPRITE_MAX times for each variable
.loop
	add hl, de
	dec c
	jr nz, .loop
	; we got the location for the group of vars, now we go to the specific sprite
.first_var
	ld a, [wCurSprite]
	ld b, 0
	ld c, a
	add hl, bc
	pop bc
	pop de
	ret

; Takes sprite id in `wCurSprite`
InitSpriteAttr:
	ld a, [wSpawnSprite]

	ld c, 4
	call SimpleMultiply
	ld hl, SPRITES_START
	ld b, 0
	ld c, a
	add hl, bc

	; offset spawn position as to not spawn everything from the top-left (might remove this)
	ld a, [wSpriteY]
	add 16
	ld [hli], a
	ld a, [wSpriteX]
	add 8
	ld [hl], a
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

; Check size for sprite wCurSprite    
; returns sprite size constant in wSpriteSize and `a`   
GetSpriteSize:
	ld a, SPR_PROPERTIES
	ld [wSpriteCurVar], a
	call GetSpriteVar
	and SIZE_MASK
	swap a
	ld [wSpriteSize], a
	ret

; Increases sprite count to add space to this actor's sprites, sets actor's initial animation and plays it
LoadSpriteAttrs:
	call GetSpriteSize
	ld b, a
	ld a, [wSpriteNum]
	ld [wSpawnSprite], a
	add b
	inc a
	ld [wSpriteNum], a

	; Puts animation from HL in wSpriteAnimGroup (never changes)
	ld d, h
	ld e, l

	ld a, [wCurSprite]
	ld b, 0
	ld c, a
	ld hl, wSpriteAnimGroup
	add hl, bc
	add hl, bc

	ld a, d
	ld [hli], a
	ld [hl], e

	call SetSpriteAnim
	jp AnimNextFrame
	ret

; Creates a new sprite
SpawnSprite:
	ld a, [wSpawnSprite]
	cp SPRITE_MAX
	jr nc, .spritemax

	ld [wSpawnSprite], a
	call InitSpriteAttr
.spritemax
	ret