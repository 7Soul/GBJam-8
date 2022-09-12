
MovePlayer:
    xor a
    ld [wCurSprite], a
    
    ld a, [wPlayerMotionX]
    and a
    jr z, .can_move_x
    
    call UpdatePlayerMovementX
    jr nz, .check_move_y

.can_move_x
    ldh a, [hJoypadDown]
    push af
    and KEY_RIGHT
    call nz, .MoveSpriteRight
    pop af
    and KEY_LEFT
    call nz, .MoveSpriteLeft

.check_move_y
    ld a, [wPlayerMotionY]
    and a
    jr z, .can_move_y

    call UpdatePlayerMovementY
    jr nz, .check_fire

.can_move_y
    ldh a, [hJoypadDown]
    push af
    and KEY_UP
    call nz, .MoveSpriteUp
    pop af
    and KEY_DOWN
    call nz, .MoveSpriteDown

.check_fire
    ldh a, [hJoypadPressed]
    and KEY_A
    call nz, .Fire
    
    ret

.MoveSpriteRight:
    call GetSpriteXAttr
    cp COL7 - 4
    ret nc

    change_animation DIR_R

    ld a, [wPlayerMotionX]
	add MOVE_TILE_X
    ld [wPlayerMotionX], a
    ret

.MoveSpriteLeft:
    call GetSpriteXAttr
    cp COL0 + 8 - 4
    ret c
    ret z

    change_animation DIR_L

    ld a, [wPlayerMotionX]
	sub MOVE_TILE_X
    ld [wPlayerMotionX], a
    ret

.MoveSpriteUp:
    call GetSpriteYAttr
    cp ROW0
    ret c
    ret z

    change_animation DIR_U

    ld a, [wPlayerMotionY]
	sub MOVE_TILE_Y
    ld [wPlayerMotionY], a
    ret

.MoveSpriteDown:
    call GetSpriteYAttr
    cp ROW6
    ret nc

    change_animation DIR_D

    ld a, [wPlayerMotionY]
	add MOVE_TILE_Y
    ld [wPlayerMotionY], a
    ret

.Fire:
    ld a, [wSpriteNum]
    ld [wCurSprite], a

    ldw wSpriteByte, BULLET + (SIZE_MEDIUM << 4)
	ldw wSpriteCurVar, SPR_PROPERTIES
    call SetSpriteVar
	ldw wSpriteByte, 4
	ldw wSpriteCurVar, SPR_ANIM_DUR
    call SetSpriteVar

    ld hl, Sprite_Veggie
    call LoadSpriteAttrs

    ld a, [wCurSprite]
    push af

    xor a
    ld [wCurSprite], a
    call GetSpriteXYAttr

    pop af
    ld [wCurSprite], a
    
    call SpawnSprite

    ret


UpdatePlayerMovementX:
    ld a, [wPlayerMotionX]
    cp $80
    jr nc, .left
    call GetSpriteXAttr
	add MOVE_SPEED_X
    ld [wSpriteX], a
	call SetSpriteXAttr

    ld a, [wPlayerMotionX]
    sub MOVE_SPEED_X
    ld [wPlayerMotionX], a
    ret

.left
    call GetSpriteXAttr
	sub MOVE_SPEED_X
    ld [wSpriteX], a
	call SetSpriteXAttr

    ld a, [wPlayerMotionX]
    add MOVE_SPEED_X
    ld [wPlayerMotionX], a
    ret

UpdatePlayerMovementY:
    ld a, [wPlayerMotionY]
    cp $80
    jr nc, .up
    call GetSpriteYAttr
	add MOVE_SPEED_Y
    ld [wSpriteY], a
	call SetSpriteYAttr

    ld a, [wPlayerMotionY]
    sub MOVE_SPEED_Y
    ld [wPlayerMotionY], a
    ret

.up
    call GetSpriteYAttr
	sub MOVE_SPEED_Y
    ld [wSpriteY], a
	call SetSpriteYAttr

    ld a, [wPlayerMotionY]
    add MOVE_SPEED_Y
    ld [wPlayerMotionY], a
    ret