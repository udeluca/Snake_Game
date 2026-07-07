--[[
    GD50
    Legend of Zelda

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

GameObject = Class{}

function GameObject:init(def)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    -- dimensions
    self.x = nil
    self.y = nil
    self.width = def.width
    self.height = def.height

    --Grid positions
    self.posGridX = nil
    self.posGridY = nil
end

function GameObject:update(dt)
    
end

function GameObject:render()
    local quad = gFrames["tiles"][TILE_FOOD]
    love.graphics.draw(gTextures["tilemap"], quad, self.x, self.y, 0, SCALE_X, SCALE_Y)
end