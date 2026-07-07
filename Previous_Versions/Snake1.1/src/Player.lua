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

    -- Iniating score value
    self.score = def.score

    -- Initial direction
    self.direction = def.direction

    -- Iniating body grid position list
    self.body = {}
    for col = 1, BOARD_DIMENSIONS do
        table.insert(self.body, {})
        for row = 1, BOARD_DIMENSIONS do
            table.insert(self.body[col], false)
        end
    end

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

-- Collision with object happen if they share the same cell in the board/grid 
function Player:headCollides(object)
    local x, y = self.gridHeadX, self.gridHeadY
    local targetX, targetY = object.posGridX, object.posGridY
    
    return (x == targetX and y == targetY)
end

function Player:render()
    local quad = gFrames["tiles"][TILE_SNAKE_HEAD]
    love.graphics.draw(gTextures["tilemap"], quad, self.gridHeadX*TILE_SIZE + self.headX, self.gridHeadY*TILE_SIZE + self.headY, 0, SCALE_X, SCALE_Y)
end