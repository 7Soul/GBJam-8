INCLUDE "data/anim_player.asm"
INCLUDE "data/anim_veggie.asm"

; Puts animation group for `wCurSprite` in `hl`
GetSpriteAnimGroup:
	ld a, [wCurSprite]
    ld b, 0
    ld c, a
	ld hl, wSpriteAnimGroup
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld l, a
	ld a, b
	ld h, a
	ret

; Stores an animation into wSpriteAnim for wCurSprite. This is called from the update function whenever this sprite's SPR_ANIM_CHANGED is set to 1
; wSpriteAnim for actor will point to frame data
SetSpriteAnim:
    push bc
    push hl
	; Puts which anim group this sprite uses into hl
	call GetSpriteAnimGroup
	; Move forward to find animation name
	ldw wSpriteCurVar, SPR_ANIM_NAME
	call GetSpriteVar
	and a
	jr z, .skip_hl_increment
	ld c, 5    ; skip this section when curSprite = 0
	call SimpleMultiply
	ld b, 0    ; 
    ld c, a    ;
	add hl, bc ; skip past anim name
	add hl, bc ; skip past next anim name
	inc hl     ; skip past frame count and loop

.skip_hl_increment
	; Set how many frames this animation has
	ldw wSpriteCurVar, SPR_ANIM_FRAMES
	ld a, [hli] ; hl is now before anim pointer in anim group (eg: Sprite_Player_Idle)
	; and ANIM_FRAMES_MASK
	ld [wSpriteByte], a
	call SetSpriteVar ; sets SPR_ANIM_FRAMES with Loop info
	; gets pointer from hl and move hl to that location by using de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	; increase and push hl so we can grab next animation later
	inc hl ; hl is now before next anim pointer in anim group (eg: $0000)

	; save animation pointer
	push hl
	ld hl, wSpriteAnimPointer
	ld a, [wCurSprite]
    ld b, 0
    ld c, a
	add hl, bc
	add hl, bc
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	pop hl

	push hl
	ld h, d
	ld l, e ; hl is animation
.move_to_frame
	; move hl to current direction
	ldw wSpriteCurVar, SPR_DIR
	call GetSpriteVar
	ld b, 0
    ld c, a
	add hl, bc
	add hl, bc
	; de is frame data
	ld a, [hli]
	ld d, [hl]
	ld e, a

	; 
	ld hl, wSpriteAnim
    ld a, [wCurSprite]
    ld b, 0
    ld c, a
	add hl, bc
	add hl, bc

    ld a, d
    ld [hli], a
    ld a, e
    ld [hl], a

	; Loads next animation into wSpriteAnimNext
	pop hl
	ld a, [hli]
	ld d, [hl]
	ld e, a

	ld hl, wSpriteAnimNext
    ld a, [wCurSprite]
    ld b, 0
    ld c, a
	add hl, bc
	add hl, bc

    ld a, d
    ld [hli], a
    ld a, e
    ld [hl], a

    pop hl
    pop bc
    ret

; Points `hl` to animation frame data for current frame based on `wCurSprite` and its animation pointer in  `wSpriteAnim` which is set every time we change its animation name
GetSpriteAnim:
    push bc
    push hl

	ld a, [wCurSprite]
	ld b, 0
	ld c, a
	ld hl, wSpriteAnimPointer
	add hl, bc
	add hl, bc
	ld d, h
	ld e, l
	; put HL at frame 0 in frame data
	ld a, [de]
    ld h, a
	inc de
    ld a, [de]
    ld l, a

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

; Moves pointer from start position to frames based on 
; Loops through all actors
UpdateAnimations:
    ld c, 0
.loop
	ld a, c
    ld [wCurSprite], a
	call GetSpriteSize

	ldw wSpriteCurVar, SPR_ANIM_CHANGED
    call GetSpriteVar
    and a
    jr z, .same_animation
    call SetSpriteAnim
    ldw wSpriteCurVar, SPR_ANIM_CHANGED
    ldw wSpriteByte, 0
    call SetSpriteVar
.same_animation

    ldw wSpriteCurVar, SPR_ANIM_DUR
    ld b, 0
    call DecSpriteVar
    and a
    jr nz, .same_frame

    ldw wSpriteCurVar, SPR_ANIM_FRAMES
    call GetSpriteVar
	and ANIM_FRAMES_MASK
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
 	pop bc
.same_frame	
	ld a, [wSpriteSize]
    add c
	
	ld c, a
	inc c
    ld a, [wSpriteNum]
    cp c
    jr nz, .loop
    ret

; Loads sprite animation into the OAM
AnimNextFrame:
	; DE points to frame data
	call GetSpriteAnim
	ldw wTemp, 0

	ld a, [wCurSprite]
	ld [wCurSprite], a
    ld c, 4
    call SimpleMultiply
    ld hl, SPRITES_START
    ld b, 0
    ld c, a
    add hl, bc
.loop
	ld a, [wTemp]
	and a
	jr z, .skip_first_sprite_xy
	; Load Y pos offset
    ld a, [de]
	ld [hli], a
	ld [wSpriteByte], a
	ld a, SPR_YOFFSET
	ld [wSpriteCurVar], a
	call SetSpriteVar
	inc de
	; Load X pos offset
    ld a, [de]
	ld [hli], a
	ld [wSpriteByte], a
	ld a, SPR_XOFFSET
	ld [wSpriteCurVar], a
	call SetSpriteVar
	inc de
.skip_first_sprite_xy_
	; Load sprite tile
    ld a, [de]
	ld [hli], a
	inc de
	; Load sprite attrs
    ld a, [de]
	ld [hli], a
	inc de
	ld a, [wCurSprite]
	inc a
	ld [wCurSprite], a

	ldw wTemp, 1
	
	; check if frame data is -1
    ld a, [de]
    cp -1
	; move to next sprite in frame data
    jr nz, .loop
	ret

.skip_first_sprite_xy
	inc hl
	inc hl
	inc de
	inc de
	jp .skip_first_sprite_xy_