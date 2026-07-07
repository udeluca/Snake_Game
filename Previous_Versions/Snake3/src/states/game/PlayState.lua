--[[
    GD50
    Snake Game

    -- Play State --

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player{
        headX = nil,
        headY = nil,
        gridHeadX = nil,
        gridHeadY = nil,
        score = 0,
        direction = "down"
    }

    self.object = GameObject{
        GAME_OBJECT_DEFS['food']
    }

    self.board = Board(self.player, self.object)
end

function PlayState:update(dt)
    -- Quit game if esc key was pressed
    if love.keyboard.wasPressed("escape") then
        love.event.quit()
    end
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change('start')
    end

    Timer.update(dt)
    self.board:update(dt)

    -- Collision logic (score updates and grow & respawn functions are triggered)
    if self.board.player:headCollides(self.board.object) then
        self.board.player.score = self.board.player.score + 1
        self.board.player:grow(self.board.object)
        self.board:respawnObject()
    end

    -- Out-of-bounds checking: left/right or top/bottom; Hitting its own body part checking; Win condition checking
    local x, y = self.board.player.gridHeadX, self.board.player.gridHeadY
    if x > BOARD_DIMENSIONS - 1 or y > BOARD_DIMENSIONS - 1 or x < 0 or y < 0  or self.board.player.body[x + 1][y + 1] or self.board.player.score == BOARD_DIMENSIONS*BOARD_DIMENSIONS then
        gStateMachine:change('game-over', {
            board = self.board
        })
    end
end

function PlayState:render()
    --[[
    -- Debuging tilemap --

    -- Grabbing where in the screen it should be printed (center)
    local tileW  = TILEMAP_SQUARE_PX_COL * SCALE_X
    local tileH  = TILEMAP_SQUARE_PX_ROW * SCALE_Y
    local boardW = 7 * tileW
    local boardH = 2 * tileH

    local x = math.floor((VIRTUAL_WIDTH  - boardW) / 2)
    local y = math.floor((VIRTUAL_HEIGHT - boardH) / 2)

    -- Printing tiles rectangles with tilemap
    TilemapViewer(gTextures["tilemap"], 7, 2,
              TILEMAP_SQUARE_PX_COL, TILEMAP_SQUARE_PX_ROW,
              x, y, SCALE_X, SCALE_Y)
              ]]

    -- Rendering board and its components
    self.board:render()

    -- Setting title text Font
   love.graphics.setFont(gFonts["medium"])

   local score_locationX = BOARD_X + BOARD_DIMENSIONS*TILE_SIZE + TILE_SIZE/2
   local score_locationY = BOARD_Y 
   local score = "Score: " .. tostring(self.board.player.score) 

   -- Drawing score text shadow (black with 50% opacity) and offset of 2 pixels
   local shadowOffSet = 0.5
   love.graphics.setColor(0, 0, 0, 0.5)
   love.graphics.print(score, score_locationX - shadowOffSet, score_locationY - shadowOffSet)

   -- Drawing score text (purple with 60% opacity)
   love.graphics.setColor(0.5, 0, 0.5, 0.6)
   love.graphics.print(score, score_locationX, score_locationY)
end