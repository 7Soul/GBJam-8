SCREEN_WIDTH  EQU 20
SCREEN_HEIGHT EQU 18
CANVAS_WIDTH  EQU 12
FULL_WIDTH    EQU $1F

    const_def
    const MENU_TITLE_ANIM ; 0
    const MENU_TITLE ; 1
    const MENU_LEVEL_SELECT ; 2
    const MENU_GAME_OVER ; 3

MARGIN_RIGHT EQU 160 - 24
MARGIN_LEFT EQU 2 * 8
MARGIN_TOP EQU 6 * 8
MARGIN_BOT EQU 144 - 24

MOVE_TILE_X  EQU 24
MOVE_TILE_Y  EQU 16
MOVE_SPEED_X EQU 2
MOVE_SPEED_Y EQU 2

; ATTRIBUTES
SPRITE_PAL      = 1 << 7
SPRITE_FLIPY    = 1 << 6
SPRITE_FLIPX    = 1 << 5
SPRITE_PRIORITY = 1 << 4

SOUND_1 EQU 1

; SPRITE VARIABLE CONSTANTS
    const_def
    const SPR_PROPERTIES ; 0
    const SPR_VAR1       ; 1
    const SPR_VAR2       ; 2
    const SPR_VAR3       ; 3
    const SPR_ANIM       ; 4
    const SPR_ANIM_DUR   ; 5
    const SPR_ANIM_FRAME ; 6

; SPRITE PROPERTIES
; SPRITE TYPE CONSTANTS
PLAYER    EQU %0000
ENEMY     EQU %0001
BULLET    EQU %0011
TYPE_3    EQU %0100
TYPE_MASK EQU %1111
; SPRITE SIZE CONSTANTS
SIZE_MASK   EQU %110000
SIZE_SMALL  EQU %000000
SIZE_MEDIUM EQU %010000
SIZE_BIG    EQU %110000
MAX_SIZE    EQU 3

; STAGE CONSTANTS
LANEX1 EQU 24
LANEX2 EQU LANEX1 + 24
LANEX3 EQU LANEX2 + 24
LANEX4 EQU LANEX3 + 24
LANEX5 EQU LANEX4 + 24