--[[
    GD50
    Snake Game

    -- Start State --

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

PlayerParts = Class{}

function PlayerParts:init(def)
    -- Getting head board position
    self.x = def.x
    self.y = def.y

    -- Getting head grid position
    self.gridX = def.gridX
    self.gridY = def.gridY

    -- Is this body part a tail
    self.isTail = def.isTail

    -- Getting if it can move in that frame
    self.canMove = true

    -- Getting what is the coordinates it should go next
    self.nextGridY = nil
    self.nextGridX = nil

end

function PlayerParts:update(dt)
    -- Move to next tile based on the direction and if the player can move
    -- Player should only be able to move, after animation/tween going from one tile to the next is finished
    if self.canMove and not (self.nextGridY == nil) and not (self.nextGridX == nil) then
        self.canMove = false
        Timer.tween(SNAKE_MOV, {[self] = {y = BOARD_Y + self.nextGridY*TILE_SIZE, x = BOARD_X + self.nextGridX*TILE_SIZE}})
        :finish(function() self.canMove = true end)
        self.gridX = self.nextGridX
        self.gridY = self.nextGridY
    end
end


function PlayerParts:render()
    local quad = gFrames["tiles"][self.isTail and TILE_SNAKE_TAIL or TILE_SNAKE_BODY]
    love.graphics.draw(gTextures["tilemap"], quad, self.x, self.y, 0, SCALE_X, SCALE_Y)
end