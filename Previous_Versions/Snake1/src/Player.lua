--[[
    GD50
    Snake Game

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

Player = Class{}

function Player:init(def)
    -- Getting head board position
    self.headX = def.headX
    self.headY = def.headY

    -- Getting head grid position
    self.gridHeadX = def.gridHeadX
    self.gridHeadY = def.gridHeadY

    -- Iniating body grid position list
    self.body = def.body

    -- Iniating score value
    self.score = def.score

    -- Initial direction
    self.direction = def.direction

    -- Player should be able to act initially
    self.canAct = true
end

function Player:update(dt)
    -- Changing direction if some input was pressed 
    self:changeDirection()

    -- Move to next tile based on the direction and if the player can move
    -- Player should only be able to move, after animation/tween going from one tile to the next is finished
    if self.direction == "up" and self.canAct then
        self.canAct = false
        Timer.tween(SNAKE_MOV, {[self] = {gridHeadY = self.gridHeadY - 1}})
        :finish(function() self.canAct = true end) 

    elseif self.direction == "down" and self.canAct then
        self.canAct = false
        Timer.tween(SNAKE_MOV, {[self] = {gridHeadY = self.gridHeadY + 1}})
        :finish(function() self.canAct = true end)

    elseif self.direction == "left" and self.canAct then
        self.canAct = false
        Timer.tween(SNAKE_MOV, {[self] = {gridHeadX = self.gridHeadX - 1}})
        :finish(function() self.canAct = true end)

    elseif self.direction == "right" and self.canAct then
        self.canAct = false
        Timer.tween(SNAKE_MOV, {[self] = {gridHeadX = self.gridHeadX + 1}})
        :finish(function() self.canAct = true end)
    end
end

function Player:changeDirection()
    if love.keyboard.wasPressed("up") then
        self.direction = "up"
    elseif love.keyboard.wasPressed("down") then
        self.direction = "down"
    elseif love.keyboard.wasPressed("left") then
        self.direction = "left"
    elseif love.keyboard.wasPressed("right") then
        self.direction = "right"
    else
        -- If no input was made, maintain direction
        self.direction = self.direction
    end
end

function Player:render()
    local quad = gFrames["tiles"][TILE_SNAKE_HEAD]
    love.graphics.draw(gTextures["tilemap"], quad, self.gridHeadX*TILE_SIZE + self.headX, self.gridHeadY*TILE_SIZE + self.headY, 0, SCALE_X, SCALE_Y)
end