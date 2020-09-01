; Animations
Sprite_Player:
    ; Frames, Loop pointer
	dbw 3, Sprite_Player_Move_Down ; ANIM_MOVE_DOWN
	dbw 3, Sprite_Player_Move_Up   ; ANIM_MOVE_UP

; Animation pointers
Sprite_Player_Move_Down:
	dw .player_down_frame1
	dw .player_down_frame2
	dw .player_down_frame3
	dw .player_down_frame4

.player_down_frame1:
	db $A0, SPRITE_PAL ; sprite 0
	db $A2, SPRITE_PAL ; sprite 1
	db $A0, SPRITE_FLIPX + SPRITE_PAL ; sprite 2 (sprite 0 flipped)
	db -1

.player_down_frame2:
	db $A4, SPRITE_PAL ; sprite 0
	db $A6, SPRITE_PAL ; sprite 1
	db $A8, SPRITE_PAL ; sprite 2
	db -1

.player_down_frame3:
	db $A0, SPRITE_PAL ; sprite 0
	db $A2, SPRITE_FLIPX + SPRITE_PAL ; sprite 1
	db $A0, SPRITE_FLIPX + SPRITE_PAL ; sprite 2 (sprite 0 flipped)
	db -1

.player_down_frame4:
	db $A8, SPRITE_FLIPX + SPRITE_PAL ; sprite 0
	db $A6, SPRITE_FLIPX + SPRITE_PAL ; sprite 1
	db $A4, SPRITE_FLIPX + SPRITE_PAL ; sprite 2
	db -1

Sprite_Player_Move_Up:
    dw .player_up_frame1

.player_up_frame1:
	db $A9, SPRITE_PAL ; sprite 0
	db $AB, SPRITE_PAL ; sprite 1
	db $A9, SPRITE_FLIPX + SPRITE_PAL ; sprite 2 (sprite 0 flipped)


bullet_sprites:
	db $82, $00 ; sprite 0
	db $82, SPRITE_FLIPY ; sprite 1
	db -1

; Stores an animation into wSpriteAnim
; Takes animation in DE
SetSpriteAnim:
    push bc
    push hl
	ldw wSpriteCurVar, SPR_ANIM_FRAMES
	ld a, [hli]
	ld [wSpriteByte], a
	call SetSpriteVar ; sets SPR_ANIM_FRAMES
    ld a, [hli]
	ld d, [hl]
	ld e, a

    ld a, [wCurSprite]
    ld b, 0
    ld c, a
	ld hl, wSpriteAnim
	add hl, bc
	add hl, bc

    ld a, e
    ld [hli], a
    ld a, d
    ld [hl], a
    pop hl
    pop bc
    ret

; Returns pointer from wSpriteAnim in HL
GetSpriteAnim:
    push bc
    push hl

	ld de, wSpriteAnim
	ld a, [de]
    ld l, a
	inc de
    ld a, [de]
    ld h, a

	ldw wSpriteCurVar, SPR_ANIM_FRAME
    call GetSpriteVar
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc

	ld a, [hli]
	ld d, [hl]
	ld e, a
    pop hl
    pop bc
    ret

; Changes animation for a sprite
SetAnimationPointer:
	call GetSpriteAnim
	ld a, [wSpriteByte]
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wSpriteSize], a
	ret

; Moves pointer from start position to frames based on 
UpdateAnimations:
    ld c, 0
.loop
	ld a, c
    ld [wCurSprite], a

    ldw wSpriteCurVar, SPR_ANIM_DUR
    ld b, 0
    call DecSpriteVar
    and a
    jr nz, .same_frame

    ldw wSpriteCurVar, SPR_ANIM_FRAMES
    call GetSpriteVar
	inc a
    ld b, a
	ldw wSpriteCurVar, SPR_ANIM_DUR
	ldw wSpriteByte, 4
	call SetSpriteVar
    ldw wSpriteCurVar, SPR_ANIM_FRAME
    call IncSpriteVar

	cp b
	jr nz, .dont_reset_frames
	xor a
	ld [wSpriteByte], a
	call SetSpriteVar
.dont_reset_frames
	push bc
    call AnimNextFrame
    call SetNextFrameTiles
	pop bc
.same_frame
	ld a, [wSpriteSize]
    add c
	ld c, a
    ld a, [wSpriteNum]
    dec a
    cp c
    jr nz, .loop
    ret

AnimNextFrame:
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

SetNextFrameTiles:
	xor a
    ld [wCurSpriteLoop], a
.set_tiles
	ld hl, wSpriteTile
    ld a, [wCurSpriteLoop]
    ld b, 0
    ld c, a
    add hl, bc
    ld d, h
    ld e, l

	ld a, [wCurSpriteLoop]
    ld c, 4
    call SimpleMultiply
    ld hl, SPRITES_START
    ld b, 0
    ld c, a
    add hl, bc
	inc hl
	inc hl
    ld a, [de]
    ld [hli], a
    call .NextDe
    ld a, [de]
    ld [hl], a

    ld hl, wCurSpriteLoop
    inc [hl]

    ; Ends spawning sprites if we already spawned 3 sprites (max size reached)
    ld a, [wSpriteSize]
    inc a
    ld b, a
    ld a, [wCurSpriteLoop]
    cp b
    ret z
    
    jr .set_tiles

    ret

.NextDe:
    inc de
    inc de
    inc de
    ret