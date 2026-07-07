--[[
    GD50
    Snake Game

    -- Board --

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

Board = Class{}

function Board:init(player)--, object)
    self.player = player
    --self.object = object

    -- Getting Board top left pixel positions (so its centered in screen)
    local tileW  = TILEMAP_SQUARE_PX_COL * SCALE_X
    local tileH  = TILEMAP_SQUARE_PX_ROW * SCALE_Y
    local boardW = BOARD_DIMENSIONS * tileW
    local boardH = BOARD_DIMENSIONS * tileH

    self.boardPosX = math.floor((VIRTUAL_WIDTH  - boardW) / 2)
    self.boardPosY = math.floor((VIRTUAL_HEIGHT - boardH) / 2)

    -- Initiating empty grid
    self.grid = {}

    -- Initiating tile grid
    self.tiles = {}

    -- Generating grass tiles in grid
    self:generateBoard()
end

function Board:generateBoard()
    -- Looping though tile grid (board dimensions) and inserting grass tiles ids so it can be drawn afterwards
    -- Creating the grid that will tell if a cell is occupied or not
    for col = 0, BOARD_DIMENSIONS - 1 do
        table.insert(self.tiles, {})
        table.insert(self.grid, {})

        for row = 0, BOARD_DIMENSIONS - 1 do
            local id = TILE_GRASS[math.random(#TILE_GRASS)]
            
            table.insert(self.tiles[col + 1], id)

            -- Initiating board with all cells not occupied
            table.insert(self.grid[col + 1], false)
        end
    end

    -- Spawning player
    self.player.gridHeadX = math.random(BOARD_DIMENSIONS) - 1
    self.player.gridHeadY = math.random(BOARD_DIMENSIONS) - 1
    self.player.headX = self.boardPosX
    self.player.headY = self.boardPosY

    -- Player cell is occupied
    self.grid[self.player.gridHeadX + 1][self.player.gridHeadY + 1] = true
--[[
    -- Checking if the player will not be in the same spot as the fruit when initiating the board
    while true do
        local randomPosX = math.random(BOARD_DIMENSIONS) - 1
        local randomPosY = math.random(BOARD_DIMENSIONS) - 1
        if not (self.player.headX == randomPosX) or not (self.player.headY == randomPosY) then
            self.object.posGridX = randomPosX
            self.object.posGridY = randomPosY
            self.grid[randomPosX + 1][randomPosY + 1] = true
            break
        end
    end
    ]]
end

function Board:checkEmptyCells()

end

function Board:update(dt)
    self.player:update(dt)
    --self.object:update(dt)
end

function Board:render()
    -- Drawing tiles based on their ids on the tile grid list
    for col = 0, BOARD_DIMENSIONS - 1 do
        for row = 0, BOARD_DIMENSIONS - 1 do
            local quad = gFrames["tiles"][self.tiles[col + 1][row + 1]]
            love.graphics.draw(gTextures["tilemap"], quad, row*TILE_SIZE + self.boardPosX, col*TILE_SIZE + self.boardPosY, 0, SCALE_X, SCALE_Y)
        end
    end

    --self.object:render()
    self.player:render()
end