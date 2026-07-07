--[[
    GD50
    Snake Game

    -- Game Over State --

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.board = params.board
end

function GameOverState:update(dt)
    -- Quit game if esc key was pressed
    if love.keyboard.wasPressed("escape") then
        love.event.quit()
    end
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change('start')
    end
end

function GameOverState:render()

    -- Rendering board and its components
    self.board:render()

     -- Setting title text Font
   love.graphics.setFont(gFonts["large"])

   local end_game = nil

   if self.board.player.score == BOARD_DIMENSIONS*BOARD_DIMENSIONS then
        end_game = "Congratulations\nYou Win"
   else
        end_game = "Game Over"
   end

   -- Drawing Game Over text shadow (black with 25% opacity) and offset of 2 pixels
   local shadowOffSet = 2
   love.graphics.setColor(0, 0, 0, 0.25)
   love.graphics.printf(end_game, 0, ((VIRTUAL_HEIGHT - gFonts["large"]:getHeight())/2) - shadowOffSet, VIRTUAL_WIDTH - shadowOffSet, "center")

   -- Drawing Game Over text (white with 90% opacity)
   love.graphics.setColor(1, 1, 1, 0.90)
   love.graphics.printf(end_game, 0, (VIRTUAL_HEIGHT - gFonts["large"]:getHeight())/2, VIRTUAL_WIDTH, "center")

   local score = "Score: " .. tostring(self.board.player.score) 

   love.graphics.setFont(gFonts["medium"])
   -- Drawing game score shadow (black with 50% opacity) and offset of 2 pixels
   local shadowOffSet = 0.5
   love.graphics.setColor(0, 0, 0, 0.5)
   love.graphics.printf(score, 0, ((VIRTUAL_HEIGHT - gFonts["large"]:getHeight())/2) + TILE_SIZE - shadowOffSet, VIRTUAL_WIDTH - shadowOffSet, "center")

   -- Drawing game score text (purple with 60% opacity)
   love.graphics.setColor(0.5, 0, 0.5, 0.6)
   love.graphics.printf(score, 0, ((VIRTUAL_HEIGHT - gFonts["large"]:getHeight())/2) + TILE_SIZE, VIRTUAL_WIDTH, "center")
end