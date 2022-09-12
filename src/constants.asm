SCREEN_WIDTH  EQU 20
SCREEN_HEIGHT EQU 18
CANVAS_WIDTH  EQU 12
FULL_WIDTH    EQU $1F
SPRITE_MAX    EQU 40

    const_def
    const MENU_TITLE_ANIM ; 0
    const MENU_TITLE ; 1
    const MENU_LEVEL_SELECT ; 2
    const MENU_GAME_OVER ; 3

MARGIN_RIGHT EQU 160 - 24
MARGIN_LEFT EQU 2 * 8
MARGIN_TOP EQU 6 * 8
MARGIN_BOT EQU 144 - 24

MOVE_TILE_X  EQU 16
MOVE_TILE_Y  EQU 16
MOVE_SPEED_X EQU 2
MOVE_SPEED_Y EQU 2

; ATTRIBUTES
SPRITE_PRIORITY = 1 << 7
SPRITE_FLIPY    = 1 << 6
SPRITE_FLIPX    = 1 << 5
SPRITE_PAL1     = 0 << 4
SPRITE_PAL2     = 1 << 4

SOUND_1 EQU 1

; SPRITE VARIABLE CONSTANTS
    const_def
    const SPR_PROPERTIES   ; 0
    const SPR_DIR          ; 1
    const SPR_YOFFSET      ; 2
    const SPR_XOFFSET      ; 3
    const SPR_ANIM_NAME    ; 4
    const SPR_ANIM_DUR     ; 5
    const SPR_ANIM_FRAME   ; 6
    const SPR_ANIM_FRAMES  ; 7
    const SPR_ANIM_CHANGED ; 8

; SPRITE PROPERTIES
; SPRITE TYPE CONSTANTS
    const_def
    const PLAYER
    const ENEMY 
    const BULLET
    const TYPE_3
    const TYPE_4
TYPE_MASK EQU %1111

; SPRITE SIZE CONSTANTS
SIZE_MASK   EQU %11110000
SIZE_SMALL  EQU %00
SIZE_MEDIUM EQU %01
SIZE_BIG    EQU %10
MAX_SIZE    EQU 8

; SPRITE ANIM GROUP CONSTANTS
ANIM_FRAMES_MASK      EQU %0111 ; animations can have up to 8 frames
ANIM_FRAMES_LOOP_BOOL EQU %1000 ; bool to set animation loop

DIR_D EQU 0
DIR_L EQU 1
DIR_U EQU 2
DIR_R EQU 3

; ANIMATION CONSTANTS (used in data/animations.asm)
    const_def
    const ANIM_IDLE
    const ANIM_MOVE
    const ANIM_FIRE

; STAGE CONSTANTS
; Columns
    const_def 16, 16
    const COL0
    const COL1
    const COL2
    const COL3
    const COL4
    const COL5
    const COL6
    const COL7
    const COL8
; Rows
    const_def 32, 16
    const ROW0
    const ROW1
    const ROW2
    const ROW3
    const ROW4
    const ROW5
    const ROW6