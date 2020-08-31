; Triggers once per second
SecondsChanged:
; 	ldh a, [hGameTimeSeconds]
;     cp 2
;     jr z, .spawn1
;     ret
; .spawn1
;     ld a, [wSpriteNum]
;     ld [wCurSprite], a
;     ld a, BULLET + SIZE_MEDIUM
;     ld [wSpriteByte], a
;     ld a, SPR_PROPERTIES
;     ld [wSpriteCurVar], a
;     call SetSpriteVar

;     ld de, bullet_sprites
;     call LoadSpriteAttrs

;     xor a
;     ld [wCurSprite], a
;     call GetSpriteXYAttr
;     ld a, [wSpriteX]
;     ld [wSpriteX + 1], a
;     ld a, [wSpriteY]
;     ld [wSpriteY + 1], a
;     call SpawnSprite
	ret

; 
FrameTriggers:
    ldh a, [hGameTimeFrames]
    ld b, a
    call TriggerHalfSecond

    call TriggerQuarterSecond

    call TriggerFifthSecond
	ret

TriggerHalfSecond:
    
    ret

TriggerQuarterSecond:

    ret

TriggerFifthSecond:
    ld a, b
    and a
    jr z, .zero
.mod
    sub 10
    jr nc, .mod
    add 10
    ret nz
.zero
    call UpdateAnimations
    ret

IncreaseTimer:
    call FrameTriggers
    ld hl, hGameTimeFrames
    ld a, [hl]
    inc a
    cp 60
    jr nc, .second

    ld [hl], a
    
	ret

.second
	xor a
	ld [hl], a

    ld hl, hGameTimeSeconds
    ld a, [hl]
    inc a
    daa
    cp $60
    jr nc, .minute
    
    ld [hl], a
    call SecondsChanged
    ; call RenderTimer
	ret

.minute
	xor a
	ld [hl], a

    ld hl, hGameTimeMinutes
    ld a, [hl]
    inc a
    daa
    ld [hl], a
    ; call RenderTimer
    ret

RenderTimer:   
    ldh a, [rLCDC]
    set 4, a
    ldh [rLCDC], a

    ld c, 1
    lb de, 3, 0
    ld hl, .time_string
    call RenderTextToEnd

    ldh a, [hGameTimeSeconds]
	ld b, $30
	ld c, 1
	lb de, 4, 0
	call RenderTwoDecimalNumbers

    ldh a, [hGameTimeMinutes]
	ld b, $30
	ld c, 1
	lb de, 1, 0
	call RenderTwoDecimalNumbers
    ret

.time_string:
    db ":@"

ResetTimer:
    xor a
	ldh [hGameTimeMinutes], a
	ldh [hGameTimeSeconds], a
	ldh [hGameTimeFrames], a
    ret