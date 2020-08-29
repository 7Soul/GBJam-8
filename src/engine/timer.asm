; Triggers once per second
SecondsChanged:
	
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
    call RenderTimer
	ret

.minute
	xor a
	ld [hl], a

    ld hl, hGameTimeMinutes
    ld a, [hl]
    inc a
    daa
    ld [hl], a
    call RenderTimer
    ret

RenderTimer:
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

    ; ldh a, [hGameTimeFrames]
    ; ld c, 5
    ; call SimpleMultiply
    ; ld c, 3
    ; call SimpleDivide
    ; ld a, b
    ; sub 1
    ; add 1
    ; daa
    
	; ld b, $30
	; ld c, 1
	; lb de, 7, 0
	; call RenderTwoDecimalNumbers
    ret

.time_string:
    db ":@"