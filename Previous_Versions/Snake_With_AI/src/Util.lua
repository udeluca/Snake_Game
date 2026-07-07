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
    local counter = 1

    -- Looping through each tile/quad in the tilemap/atlas
    for col = 0, sheetTileColumn - 1 do
        for row = 0, sheetTileRow - 1 do
            -- Getting the coordinates of the top left pixel of each tile/quads
            local topLeftPixel_xCord = col * tilewidth
            local topLeftPixel_yCord = row * tileheight
            
            -- Adding quad to quad array
            local quad = love.graphics.newQuad(topLeftPixel_xCord, topLeftPixel_yCord, tilewidth, tileheight, sheetwidth, sheetheight)
            spritesheet[counter] = quad

            counter = counter + 1
        end
    end

    return spritesheet
end

-- Helper function to vizualize and debug tilemap/atlas
function TilemapViewer(atlas, numberOfCol, numberOfRows, tilewidth, tileheight, xPosition, yPosition, scaleX, scaleY)
  -- Drawing scaled Atlas/tilemap on screen 
  love.graphics.draw(atlas, xPosition, yPosition, 0, scaleX, scaleY)

  -- Setting rectangle lines to be red and be thicker/rough
  love.graphics.setLineStyle("rough")
  love.graphics.setColor(1, 0, 0, 0.7)

    -- Printing rectangles that should represent the tiles in the tilemap
    for col = 0, numberOfCol - 1 do
        for row = 0, numberOfRows - 1 do
            -- Getting rectangles/tiles coordinates (so they are printed exactly above the atlas)
            local xCord = (tilewidth*scaleX)*col + xPosition
            local yCord = (tileheight*scaleY)*row + yPosition

            -- Printing the rectangles with the same scaling as the atlas
            love.graphics.rectangle("line", xCord, yCord, tilewidth*scaleX, tileheight*scaleY)
        end
    end
end

