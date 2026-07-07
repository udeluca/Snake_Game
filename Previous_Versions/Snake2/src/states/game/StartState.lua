--[[
    GD50
    Snake Game

    -- Start State --

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

StartState = Class{__includes = BaseState}

function StartState:update(dt)
    -- Quit game if esc key was pressed
    if love.keyboard.wasPressed("escape") then
        love.event.quit()
    end

    -- Change to play state if enter was pressed
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change('play')
    end
end

function StartState:render()
    -- Setting title text Font
   love.graphics.setFont(gFonts["large"])

   -- Drawing game title text shadow (black with 50% opacity) and offset of 2 pixels
   local shadowOffSet = 2
   love.graphics.setColor(0, 0, 0, 0.5)
   love.graphics.printf("Snake Game", 0, ((VIRTUAL_HEIGHT - gFonts["large"]:getHeight())/2) - shadowOffSet, VIRTUAL_WIDTH - shadowOffSet, "center")

   -- Drawing game title text (purple with 60% opacity)
   love.graphics.setColor(0.5, 0, 0.5, 0.6)
   love.graphics.printf("Snake Game", 0, (VIRTUAL_HEIGHT - gFonts["large"]:getHeight())/2, VIRTUAL_WIDTH, "center")

   -- Setting text Font
   love.graphics.setFont(gFonts["medium"])

   -- Height distance between title and text
   local distText = 32

   -- Drawing text shadow (white with 25% opacity) and offset of 1 pixels
   shadowOffSet = 1
   love.graphics.setColor(1, 1, 1, 0.25)
   love.graphics.printf("Press Enter", 0, (((VIRTUAL_HEIGHT - gFonts["medium"]:getHeight())/2) - shadowOffSet) + distText, VIRTUAL_WIDTH - shadowOffSet, "center")

   -- Drawing text (black with 70% opacity)
   love.graphics.setColor(0, 0, 0, 0.7)
   love.graphics.printf("Press Enter", 0, ((VIRTUAL_HEIGHT - gFonts["medium"]:getHeight())/2) + distText, VIRTUAL_WIDTH, "center")
end