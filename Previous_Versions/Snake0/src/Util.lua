--[[
    GD50
    Snake Game

    Util Class

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
]]

function GenerateQuads(atlas, tilewidth, tileheight)
    -- Getting tilemap/atlas dimensions
    local sheetwidth = atlas:getWidth()
    local sheetheight = atlas:getHeight()

    -- Getting the number of tiles in the tilemap/atlas
    local sheetTileColumn = sheetwidth/tilewidth
    local sheetTileRow = sheetheight/tileheight

    -- Initiating quad list
    local spritesheet = {}
    local counter = 0

    -- Looping through each tile/quad in the tilemap/atlas
    for col = 0, sheetTileColumn - 1 do
        for row = 0, sheetTileRow - 1 do
            -- Getting the coordinates of the top left pixel of each tile/quads
            local topLeftPixel_xCord = row * tileheight
            local topLeftPixel_yCord = col * tilewidth
            
            -- Adding quad to quad array
            local quad = love.graphics.newQuad(topLeftPixel_xCord, topLeftPixel_yCord, tilewidth, tileheight, sheetwidth, sheetheight)
            spritesheet[counter] = quad

            counter = counter + 1
        end
    end

    return spritesheet
end
