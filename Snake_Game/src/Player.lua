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

    -- If player is AI
    self.isAI = def.isAI

    -- Iniating body grid position list
    self.body = {}
    for col = 0, BOARD_DIMENSIONS - 1 do
        table.insert(self.body, {})
        for row = 0, BOARD_DIMENSIONS - 1 do
            table.insert(self.body[col + 1], false)
        end
    end

    -- Grid representation of body
    self.bodyGrid = {}

    -- Player should be able to act initially
    self.canAct = true

    -- Getting rotation
    self.rotation = ANGLE[self.direction]

    -- Creating AI is player is AI
    self.path = nil
    self.AI = nil
    if self.isAI then
        self.AI = AI()
    end

end

function Player:update(dt)
    -- Changing direction if some input was pressed every frame
    self:changeDirection()

    -- Only update the position in the frames where player can act
    if self.canAct then
        self.canAct = false

        -- Move to next tile based on the direction and if the player can move
        local dx, dy = 0, 0
        if self.direction == "up" then
            dx, dy = 0, -1

        elseif self.direction == "down" then
            dx, dy = 0, 1

        elseif self.direction == "left" then
            dx, dy = -1, 0

        elseif self.direction == "right" then
            dx, dy = 1, 0
        end
        
        -- Updates each snake body part and the coordinates it is following
        local prevGX, prevGY = self.gridHeadX, self.gridHeadY
        if self.score > 0 then
            -- Updating if the cell is occupied by the body or not
            self:updateCells()

            -- Make head appear as blocked in the body grid
            self.body[prevGX + 1][prevGY + 1] = true 

            -- Only update each body part after it knows who it should follow 
            -- Otherwise it will only update who it should be following in the next frame (different position from where it was)
            self:updateParts(prevGX, prevGY)
            for i = 1, #self.bodyGrid do
                self.bodyGrid[i]:update(dt)
            end
        end

        -- Getting rotation based on direction of this frame (not the next frame)
        self.rotation = ANGLE[self.direction]

        -- Updating grid 
        self.gridHeadX = self.gridHeadX + dx
        self.gridHeadY = self.gridHeadY + dy 
 
        -- Player should only be able to move, after animation/tween going from one tile to the next is finished
        Timer.tween(SNAKE_MOV, {[self] = {headX = BOARD_X + self.gridHeadX*TILE_SIZE, headY = BOARD_Y + self.gridHeadY*TILE_SIZE}})
        :finish(function() 
            self.canAct = true
         end)
    end
end

function Player:changeDirection()
    if not self.isAI then
        -- Changing direction based on previous direction and what was pressed
        if love.keyboard.wasPressed("up") and not (self.direction == "up") then
            self.direction = "up"
            
        elseif love.keyboard.wasPressed("down") and not (self.direction == "down") then
            self.direction = "down"
            
        elseif love.keyboard.wasPressed("left") and not (self.direction == "left") then
            self.direction = "left"
            
        elseif love.keyboard.wasPressed("right") and not (self.direction == "right") then
            self.direction = "right"

        else
            -- If no input was made, maintain direction
            self.direction = self.direction
        end 
    else
        if self.canAct then
            if not (self.path == nil) then
                if #self.path >= 2 then
                    -- Change direction based on next cell according to path (only if there is a path and it has more than 1 cells)
                    local nextCell = self.path[2]
                    local dj = nextCell[2] - self.gridHeadX
                    local di = nextCell[1] - self.gridHeadY

                    if dj > 0 then
                        self.direction = "right"
                    elseif dj < 0 then
                        self.direction = "left"
                    elseif di > 0 then
                        self.direction = "down"
                    elseif di < 0 then
                        self.direction = "up"
                    end

                    table.remove(self.path, 1)
                else
                    self.direction = self.direction
                end
            else
                self.direction = self.direction
            end
        end
    end
end

-- Collision with object happen if they share the same cell in the board/grid 
function Player:headCollides(object)
    local x, y = self.gridHeadX, self.gridHeadY
    local targetX, targetY = object.posGridX, object.posGridY
    
    return (x == targetX and y == targetY)
end

-- Growing snake body
function Player:grow(object)
    local x, y, gridX, gridY = nil, nil, nil, nil

    -- If first score, that body part should follow the snake head
    if self.score == 1 then
        -- Ensuring the part will spawn before the head (not on top of it)
        local dx, dy = 0, 0
        if self.direction == "up" then
            dx, dy = 0, 1
        elseif self.direction == "down" then
            dx, dy = 0, -1
        elseif self.direction == "left" then
            dx, dy = 1, 0
        elseif self.direction == "right" then
            dx, dy = -1, 0
        end

        -- Updating visual/screen position
        x = object.x + dx*TILE_SIZE
        y = object.y + dy*TILE_SIZE

        -- Updating grid
        gridX = object.posGridX + dx
        gridY = object.posGridY + dy

    -- If multiple scores had happen, follow previous body part
    else
        local body = self.bodyGrid[#self.bodyGrid]
        x = body.x
        y = body.y
        gridX = body.gridX
        gridY = body.gridY
    end

    -- Create new boody part (every body part is added at the end of the body - tail)
    local bodyPart = PlayerParts{
        x = x,
        y = y,
        gridX = gridX,
        gridY = gridY,
        isTail = true,
        direction = self.direction
    }

    -- Inserting new tail into the body grid list
    table.insert(self.bodyGrid, bodyPart)

    -- Updating previous body part so it is not the tail anymore
    if self.score > 1 then
        self.bodyGrid[#self.bodyGrid - 1].isTail = false
    end
end

function Player:updateParts(prevHeadGridX, prevHeadGridY)
    -- Updating which coordinates each body part should be following every frame that canAct is true
    if #self.bodyGrid > 0 then
        local count = #self.bodyGrid

        -- The part next to the head should follow the head's previous position (pos from last frame)
        self.bodyGrid[1].nextGridX = prevHeadGridX
        self.bodyGrid[1].nextGridY = prevHeadGridY

        -- All other body part should follow the body part next to them previous position
        while count > 1 do
            local prev = self.bodyGrid[count-1]
            local current  = self.bodyGrid[count]
            current.nextGridX = prev.gridX
            current.nextGridY = prev.gridY 

            count = count - 1
        end
    end
end

function Player:updateCells()
    for col = 0, BOARD_DIMENSIONS - 1 do
        for row = 0, BOARD_DIMENSIONS - 1 do
            -- Reset cells on the board to not occupied
            self.body[col + 1][row + 1] = false
        end
    end

    for k = 1, #self.bodyGrid do
        -- Update the position on the board (so it is marked as occupied)
        self.body[self.bodyGrid[k].gridX + 1][self.bodyGrid[k].gridY + 1] = true
    end
end

-- Getting the coordinates of each segment of the snake (head + body parts) in a list
function Player:get_segments()
    local segments = {}
    table.insert(segments, {self.gridHeadY, self.gridHeadX})
    for k = 1, #self.bodyGrid do
        table.insert(segments, {self.bodyGrid[k].gridY, self.bodyGrid[k].gridX})
    end
    return segments
end

function Player:render()

    -- Push new "virtual space"
    love.graphics.push()

    -- Compute the head's center in world pixels
    local centerX = self.headX + TILE_SIZE/2
    local centerY = self.headY + TILE_SIZE/2

    -- Compute rotation angle
    local angle = math.rad(self.rotation)

    -- Re-center the coordinate system on the head's center,
    -- Rotate there, then move the origin back.
	love.graphics.translate(centerX, centerY)
	love.graphics.rotate(angle)
    love.graphics.translate(-centerX, -centerY)


    -- Draw the head at its normal top-left, but it will now be rotated
    -- around its center because of the temporary transform above.
    local quad = gFrames["tiles"][TILE_SNAKE_HEAD]
    love.graphics.draw(gTextures["tilemap"], quad, self.headX, self.headY, 0, SCALE_X, SCALE_Y)

    -- Only apply this configuration until the pop command (this virtual world end with the pop command)
    love.graphics.pop()

    -- Rendering each body part individualy
    if self.score > 0 then
        for i = 1, #self.bodyGrid do
            self.bodyGrid[i]:render()
        end
    end
end