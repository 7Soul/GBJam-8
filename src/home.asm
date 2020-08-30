DelayFrame::
; Wait for one frame
	ld a, 1
	ld [wVBlankOccurred], a

; Wait for the next VBlank, halting to conserve battery
.halt
	halt ; rgbasm adds a nop after this instruction by default
	ld a, [wVBlankOccurred]
	and a
	jr nz, .halt
	ret

DelayFrames::
; Wait c frames
	call DelayFrame
	dec c
	jr nz, DelayFrames
	ret

ShortWait::
    ld c, 20
    
.loop:    
    call DelayFrame
	dec c
	jr nz, .loop
	ret

ClearBackground:
	ld a, 0
    ld hl, BACKGROUND_MAPDATA_START
    ld bc, 32 * 32
    call mSetVRAM
	ret