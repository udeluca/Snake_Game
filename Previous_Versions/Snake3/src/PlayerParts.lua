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

    -- Initiating direction
    self.direction = def.direction

    -- Getting if it can move in that frame
    self.canMove = true

    -- Getting what is the coordinates it should go next
    self.nextGridY = nil
    self.nextGridX = nil

    -- Store previous direction
    self.prevDir = nil

    -- Storing rotation angle
    self.rotation = ANGLE[self.direction]

end

function PlayerParts:update(dt)
    -- Move to next tile based on the direction and if the player can move
    -- Body part should only be able to move, after animation/tween going from one tile to the next is finished
    if self.canMove and not (self.nextGridY == nil) and not (self.nextGridX == nil) then
        self.canMove = false

        -- Getting next direction
        local nextDirection = nil
        if self.gridX > self.nextGridX then
            nextDirection = "left"
        elseif self.gridX < self.nextGridX then
            nextDirection = "right"
        elseif self.gridY > self.nextGridY then
            nextDirection = "up"
        elseif self.gridY < self.nextGridY then
            nextDirection = "down"
        end

        -- Storing previous direction and updating new one
        self.prevDir = self.direction
        self.direction = nextDirection

        -- Going to the next tile in the grid
        Timer.tween(SNAKE_MOV, {[self] = {y = BOARD_Y + self.nextGridY*TILE_SIZE, x = BOARD_X + self.nextGridX*TILE_SIZE}})
        :finish(function() 
            self.canMove = true 
            self.gridX = self.nextGridX
            self.gridY = self.nextGridY
        end)
    end

    self.rotation = ANGLE[self.direction]
end


function PlayerParts:render()
    -- Body part if no direction changed
    local body_sprite = TILE_SNAKE_BODY

    -- Body part if direction changed
    if not (self.prevDir == self.direction) then
        if self.direction == "up" and self.prevDir == "left" then
            body_sprite = 6
        elseif self.direction == "up" and self.prevDir == "right" then
            body_sprite = 8
        elseif self.direction == "left" and self.prevDir == "up" then
            body_sprite = 4
        elseif self.direction == "right" and self.prevDir == "up" then
            body_sprite = 2

        elseif self.direction == "down" and self.prevDir == "left" then
            body_sprite = 2
        elseif self.direction == "down" and self.prevDir == "right" then
            body_sprite = 4
        elseif self.direction == "left" and self.prevDir == "down" then
            body_sprite = 8
        elseif self.direction == "right" and self.prevDir == "down" then
            body_sprite = 6
        end
    end

    if self.isTail then
        -- Push new "virtual space"
        love.graphics.push()

        -- Compute the tail's center in world pixels
        local centerX = self.x + TILE_SIZE/2
        local centerY = self.y + TILE_SIZE/2

        -- Compute rotation angle
        local angle = math.rad(self.rotation)

        -- Re-center the coordinate system on the tail's center,
        -- Rotate there, then move the origin back.
        love.graphics.translate(centerX, centerY)
        love.graphics.rotate(angle)
        love.graphics.translate(-centerX, -centerY)


        -- Draw the tail at its normal top-left, but it will now be rotated
        -- around its center because of the temporary transform above.
        local quad = gFrames["tiles"][TILE_SNAKE_TAIL]
        love.graphics.draw(gTextures["tilemap"], quad, self.x, self.y, 0, SCALE_X, SCALE_Y)

        -- Only apply this configuration until the pop command (this virtual world end with the pop command)
        love.graphics.pop()
    else
        -- Rendering body part that is not tail
        local quad = gFrames["tiles"][body_sprite]
        love.graphics.draw(gTextures["tilemap"], quad, self.x, self.y, 0, SCALE_X, SCALE_Y)
    end
end