--[[
    GD50
    Snake Game

    -- Board --

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

Board = Class{}

function Board:init(player, object)
    self.player = player
    self.object = object

    -- Getting Board top left pixel positions (so its centered in screen)

    self.boardPosX = BOARD_X
    self.boardPosY = BOARD_Y

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

        for row = 0, BOARD_DIMENSIONS - 1 do
            local id = TILE_GRASS[math.random(#TILE_GRASS)]
            
            table.insert(self.tiles[col + 1], id)
        end
    end

    -- Spawning player
    self.player.gridHeadX = math.random(BOARD_DIMENSIONS) - 1
    self.player.gridHeadY = math.random(BOARD_DIMENSIONS) - 1
    self.player.headX = self.player.gridHeadX*TILE_SIZE + self.boardPosX
    self.player.headY = self.player.gridHeadY*TILE_SIZE + self.boardPosY

    -- Checking if the player will not be in the same spot as the fruit when initiating the board
    while true do
        self.object.posGridX = math.random(BOARD_DIMENSIONS) - 1
        self.object.posGridY = math.random(BOARD_DIMENSIONS) - 1
        if not (self.player.gridHeadX == self.object.posGridX) or not (self.player.gridHeadY == self.object.posGridY) then
            -- Spawning Object
            self.object.x = self.boardPosX + self.object.posGridX*TILE_SIZE
            self.object.y = self.boardPosY + self.object.posGridY*TILE_SIZE
            break
        end
    end
end

-- Function that respawn snake fruit on an random empty cell
function Board:respawnObject()
    local flag = true
    -- Loop until the fruit is respawned randomly
    while flag do
        for col = 0, BOARD_DIMENSIONS - 1 do
            for row = 0, BOARD_DIMENSIONS - 1 do
                -- Checking if the cell is not already occupied 
                if not self.player.body[col + 1][row + 1] and (col ~= self.player.gridHeadX and row ~= self.player.gridHeadY) then
                    -- If player wins, do not need to respawn the object
                    if self.player.score == BOARD_DIMENSIONS * BOARD_DIMENSIONS then
                        break
                    end
                    
                    -- Random factor
                    if math.random(3) == 2 then
                        -- Respawning object
                        self.object.posGridX = col
                        self.object.posGridY = row

                        self.object.x = self.boardPosX + self.object.posGridX*TILE_SIZE
                        self.object.y = self.boardPosY + self.object.posGridY*TILE_SIZE
                        flag = false
                        break
                    end
                end
            end
            if not flag then
                break
            end
        end
    end
end

function Board:update(dt)
    self.object:update(dt)
    self.player:update(dt)
end

function Board:render()
    -- Drawing tiles based on their ids on the tile grid list
    for col = 0, BOARD_DIMENSIONS - 1 do
        for row = 0, BOARD_DIMENSIONS - 1 do
            local quad = gFrames["tiles"][self.tiles[col + 1][row + 1]]
            love.graphics.draw(gTextures["tilemap"], quad, row*TILE_SIZE + self.boardPosX, col*TILE_SIZE + self.boardPosY, 0, SCALE_X, SCALE_Y)
        end
    end

    self.object:render()
    self.player:render()
end