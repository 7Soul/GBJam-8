Sprite_Veggie:
	dbw 2, Sprite_Veggie_Move_Down ; ANIM_MOVE_DOWN
	dbw 2, Sprite_Veggie_Move_Left ; ANIM_MOVE_LEFT
	dbw 2, Sprite_Veggie_Move_Up   ; ANIM_MOVE_UP
	dbw 2, Sprite_Veggie_Move_Right; ANIM_MOVE_RIGTH


Sprite_Veggie_Move_Down:
	dw .frame1 ; Animation frame pointers
	dw .frame2

.frame1:
	db $80, $00 ; sprite 0
	db $80, SPRITE_FLIPX ; sprite 1
	db -1

.frame2:
	db $82, $00 ; sprite 0
	db $82, SPRITE_FLIPX ; sprite 1
	db -1


Sprite_Veggie_Move_Left:
	dw .frame1 ; Animation frame pointers
	dw .frame2

.frame1:
	db $82, $00 ; sprite 0
	db $82, SPRITE_FLIPY ; sprite 1
	db -1

.frame2:
	db $82, $00 ; sprite 0
	db $82, SPRITE_FLIPY ; sprite 1
	db -1


Sprite_Veggie_Move_Up:
	dw .frame1 ; Animation frame pointers
	dw .frame2

.frame1:
	db $82, $00 ; sprite 0
	db $82, SPRITE_FLIPY ; sprite 1
	db -1

.frame2:
	db $82, $00 ; sprite 0
	db $82, SPRITE_FLIPY ; sprite 1
	db -1


Sprite_Veggie_Move_Right:
	dw .frame1 ; Animation frame pointers
	dw .frame2

.frame1:
	db $82, $00 ; sprite 0
	db $82, SPRITE_FLIPY ; sprite 1
	db -1

.frame2:
	db $82, $00 ; sprite 0
	db $82, SPRITE_FLIPY ; sprite 1
	db -1