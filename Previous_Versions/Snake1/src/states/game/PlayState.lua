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
        body = {},
        score = 0,
        width = 1,
        height = 1,

        direction = "down"
    }
    self.board = Board(self.player)
end

function PlayState:update(dt)
    Timer.update(dt)
    -- Quit game if esc key was pressed
    if love.keyboard.wasPressed("escape") then
        love.event.quit()
    end
    self.board:update(dt)
    -- Change to play state if enter was pressed
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change('start')
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
    self.board:render()
end