--[[
    GD50
    Snake Game

    -- constants --

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- 2688 x 758 are the image dimensions (in pixels). 7 and 2 are the number of tiles in my tilemap (so I know exactly how many pixels are in each square of the tilemap)
TILEMAP_SQUARE_PX_COL = 2688/7
TILEMAP_SQUARE_PX_ROW = 768/2
TILE_SIZE = 32
SCALE_X = TILE_SIZE / TILEMAP_SQUARE_PX_COL
SCALE_Y = TILE_SIZE / TILEMAP_SQUARE_PX_ROW

--
-- entity constants
--
SNAKE_MOV = 0.5

TILE_GRASS = {9, 10}
TILE_GRASS_TOP_WALL = 14
TILE_GRASS_BOTTOM_WALL = 11
TILE_GRASS_LEFT_WALL = 13
TILE_GRASS_RIGHT_WALL = 12
TILE_SNAKE_HEAD = 5

BOARD_DIMENSIONS = 8