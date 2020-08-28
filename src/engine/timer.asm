; Triggers once per second
SecondsChanged:
	
	ret

IncreaseTimer:
    ld hl, wGameTimeFrames
    ld a, [hl]
    inc a
    cp 60
    jr nc, .second

    ld [hl], a
	ret

.second
	xor a
	ld [hl], a

    ld hl, wGameTimeSeconds
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

    ld hl, wGameTimeMinutes
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

    ld a, [wGameTimeSeconds]
	ld b, $30
	ld c, 1
	lb de, 4, 0
	call RenderTwoDecimalNumbers

    ld a, [wGameTimeMinutes]
	ld b, $30
	ld c, 1
	lb de, 1, 0
	call RenderTwoDecimalNumbers

    ; ld a, [wGameTimeFrames]
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