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

-- OBS: 292 is how many pixels are in each axis of the square/tile on the tilemap
TILEMAP_SQUARE_PX = 292
TILE_SIZE = 16
SCALE = TILE_SIZE / TILEMAP_SQUARE_PX

--
-- entity constants
--
SNAKE_WALK_SPEED = 100

TILE_GRASS = {9, 10}
TILE_GRASS_TOP_WALL = 14
TILE_GRASS_BOTTOM_WALL = 11
TILE_GRASS_LEFT_WALL = 13
TILE_GRASS_RIGHT_WALL = 12