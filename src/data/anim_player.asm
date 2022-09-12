; Animation group. wSpriteAnimGroup points to this
Sprite_Player:
    ; Frames, Loop, Pointer, next pointer
	anim_group 4, 1, Sprite_Player_Idle, Sprite_Player_Move
	anim_group 4, 1, Sprite_Player_Move, Sprite_Player_Idle
	; anim_group 1, 0, Sprite_Player_Fire, $0000


; Animation pointers. wSpriteAnimPointer points to this
Sprite_Player_Move:
	anim .player_down_frame
	anim .player_left_frame
	; anim .player_up_frame
	; anim .player_right_frame

; Frame data. wSpriteAnim points to this
.player_down_frame_1:
	anim_frame 0,  0, $A0, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $A2, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 16, $A0, SPRITE_PAL2 | SPRITE_FLIPX ; sprite 2
	db -1

.player_down_frame_2:
	anim_frame 0,  0, $A4, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $A6, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 16, $A8, SPRITE_PAL2 ; sprite 2
	db -1

.player_down_frame_3:
	anim_frame 0,  0, $A0, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $A2, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 1
	anim_frame 16, 16, $A0, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 2
	db -1

.player_down_frame_4:
	anim_frame 0,  0, $A8, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $A6, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 1
	anim_frame 16, 16, $A4, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 2
	db -1

;;
.player_left_frame_1:
	anim_frame 0,  0, $C0, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $C2, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $C4, SPRITE_PAL2 ; sprite 2
	db -1

.player_left_frame_2:
	anim_frame 0,  0, $C6, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $C8, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $CA, SPRITE_PAL2 ; sprite 2
	db -1

.player_left_frame_3:
	anim_frame 0,  0, $C0, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $C2, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $C4, SPRITE_PAL2 ; sprite 2
	db -1

.player_left_frame_4:
	anim_frame 0,  0, $CC, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $CE, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $D0, SPRITE_PAL2 ; sprite 2
	db -1


Sprite_Player_Idle:
	anim .player_down_frame
	anim .player_left_frame

; Frame data
.player_down_frame_1:
	anim_frame 0,  0, $A0, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $A2, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $A0, SPRITE_PAL2 | SPRITE_FLIPX ; sprite 2
	; db -1

.player_down_frame_2:
	anim_frame 0,  0, $A4, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $A6, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $A8, SPRITE_PAL2 ; sprite 2
	; db -1

.player_down_frame_3:
	anim_frame 0,  0, $A0, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $A2, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $A0, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 2
	; db -1

.player_down_frame_4:
	anim_frame 0,  0, $A8, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $A6, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $A4, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 2
	; db -1

;; 
.player_left_frame_1:
	anim_frame 0,  0, $C0, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $C2, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $C4, SPRITE_PAL2 ; sprite 2
	db -1

.player_left_frame_2:
	anim_frame 0,  0, $C6, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $C8, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $CA, SPRITE_PAL2 ; sprite 2
	db -1

.player_left_frame_3:
	anim_frame 0,  0, $C0, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $C2, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $C4, SPRITE_PAL2 ; sprite 2
	db -1

.player_left_frame_4:
	anim_frame 0,  0, $CC, SPRITE_PAL2 ; sprite 0
	anim_frame 8,  0, $CE, SPRITE_PAL2 ; sprite 1
	anim_frame 16, 0, $D0, SPRITE_PAL2 ; sprite 2
	db -1

; Sprite_Player_Move_Left:
;     dw .player_left_frame1
;     dw .player_left_frame2
;     dw .player_left_frame3
;     dw .player_left_frame4

; .player_left_frame1:
; 	db $C0, SPRITE_PAL2 ; sprite 0
; 	db $C2, SPRITE_PAL2 ; sprite 1
; 	db $C4, SPRITE_PAL2 ; sprite 2
; 	db -1

; .player_left_frame2:
; 	db $C6, SPRITE_PAL2 ; sprite 0
; 	db $C8, SPRITE_PAL2 ; sprite 1
; 	db $CA, SPRITE_PAL2 ; sprite 2
; 	db -1

; .player_left_frame3:
; 	db $C0, SPRITE_PAL2 ; sprite 0
; 	db $C2, SPRITE_PAL2 ; sprite 1
; 	db $C4, SPRITE_PAL2 ; sprite 2
; 	db -1

; .player_left_frame4:
; 	db $CC, SPRITE_PAL2 ; sprite 0
; 	db $CE, SPRITE_PAL2 ; sprite 1
; 	db $D0, SPRITE_PAL2 ; sprite 2
; 	db -1


; Sprite_Player_Move_Up:
;     dw .player_up_frame1
;     dw .player_up_frame2
;     dw .player_up_frame3
;     dw .player_up_frame4

; .player_up_frame1:
; 	db $B0, SPRITE_PAL2 ; sprite 0
; 	db $B2, SPRITE_PAL2 ; sprite 1
; 	db $B0, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 2 (sprite 0 flipped)
; 	db -1

; .player_up_frame2:
; 	db $B4, SPRITE_PAL2 ; sprite 0
; 	db $B6, SPRITE_PAL2 ; sprite 1
; 	db $B8, SPRITE_PAL2 ; sprite 2
; 	db -1

; .player_up_frame3:
; 	db $B0, SPRITE_PAL2 ; sprite 0
; 	db $B2, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 1
; 	db $B0, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 2
; 	db -1

; .player_up_frame4:
; 	db $B8, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 0
; 	db $B6, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 1
; 	db $B4, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 2
; 	db -1


; Sprite_Player_Move_Right:
;     dw .player_right_frame1
;     dw .player_right_frame2
;     dw .player_right_frame3
;     dw .player_right_frame4

; .player_right_frame1:
; 	db $C4, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 0
; 	db $C2, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 1
; 	db $C0, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 2
; 	db -1

; .player_right_frame2:
; 	db $CA, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 0
; 	db $C8, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 1
; 	db $C6, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 2
; 	db -1

; .player_right_frame3:
; 	db $C4, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 0
; 	db $C2, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 1
; 	db $C0, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 2
; 	db -1

; .player_right_frame4:
; 	db $D0, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 0
; 	db $CE, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 1
; 	db $CC, SPRITE_FLIPX + SPRITE_PAL2 ; sprite 2
; 	db -1
    