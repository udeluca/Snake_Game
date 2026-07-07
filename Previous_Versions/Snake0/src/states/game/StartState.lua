--[[
    GD50
    Snake Game

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

StartState = Class{__includes = BaseState}

function StartState:update(dt)
    if love.keyboard.wasPressed("escape") then
        love.event.quit()
    end

    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change('play')
    end
end

function StartState:render()
   
end