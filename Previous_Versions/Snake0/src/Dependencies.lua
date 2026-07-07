--[[
    GD50
    Snake Game

    Author: Umberto De Luca
    udeluca@student.ubc.ca

    -- Dependencies --

    A file to organize all of the global dependencies for our project, as
    well as the assets for our game, rather than pollute our main.lua file.
]]

--
-- libraries
--
Class = require 'lib/class'

push = require 'lib/push'

-- used for timers and tweening
Timer = require 'lib/knife.timer'

--
-- our own code
--

-- utility
require 'src/StateMachine'
require 'src/Util'

-- game states
require 'src/states/BaseState'
--require 'src/states/game/GameOverState'
--require 'src/states/game/PlayState'
require 'src/states/game/StartState'

-- game constants
require 'src/constants'


gSounds = {
    ['music'] = love.audio.newSource('sounds/music2.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['error'] = love.audio.newSource('sounds/error.wav', 'static'),
    ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static')
}

gTextures = {
    ['main'] = love.graphics.newImage('graphics/Textures.png'),
    ['background'] = love.graphics.newImage('graphics/background.png')
}

gFrames = {
    
    -- divided into sets for each tile type in this game
    ['tiles'] = GenerateQuads(gTextures['main'], TILEMAP_SQUARE_PX, TILEMAP_SQUARE_PX)
}

-- this time, we're keeping our fonts in a global table for readability
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}