--[[
    GD50
    Snake game Remake

    Author: Umberto De Luca 
    udeluca@student.ubc.ca

    The Snake game originated with the 1976 arcade game "Blockade" by Gremlin, where players
    controlled a line that grew in length and avoided collisions. It gained massive popularity when
    preloaded on Nokia mobile phones in 1997, becoming a widely recognized classic. Over the years,
    Snake has seen numerous adaptations and expansions, from early home console versions like Atari's 
    "Surround" to modern smartphone apps, all retaining the core mechanic of maneuvering a growing 
    line to avoid collisions. Its simplicity and addictive gameplay have made it a cultural icon in the gaming world.

    The goal of the game is to increase the lenght of the snake as you play. You score a point each time you
    collect an object. You lose whenever the snake collides with something (its own body, or the limits of the map)

    As per previous projects, we'll be adopting a retro, NES-quality aesthetic.

    Credit for graphics (amazing work!):
    https://opengameart.org/users/buch

    Credit for music (awesome track):
    http://freemusicarchive.org/music/RoccoW/

    Cool texture generator, used for background:
    http://cpetry.github.io/TextureGenerator-Online/
]]

require "src/Dependencies"

-- Defining filter for when scaling Images (gives the Retro look)
love.graphics.setDefaultFilter('nearest', 'nearest')

-- Loads the game configs
function love.load()

     -- seed the RNG
    math.randomseed(os.time())

    -- Setting up the Game title when the game is loaded
    love.window.setTitle("Snake Game")

    -- Choosing my virtual game resolution and real window resolution (so the game scales itself to the virtual resolution .: playable on every screen size)
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        -- locks the game’s frame rate to your monitor refresh rate
        vsync = true,
        -- The window starts in windowed mode instead of fullscreen
        fullscreen = false,
        -- Lets the player resize the game window
        resizable = true,
        -- Tells push to render everything to an off-screen canvas before scaling it up
        canvas = true
    })

    -- set music to loop and start
    gSounds["music"]:setLooping(true)
    gSounds["music"]:play()

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change("start")

    -- initialize input table
    love.keyboard.keysPressed = {}
end

-- If push option "resizable" is true, it needs this function to actually be resizable
function love.resize(w, h)
    push:resize(w, h)
end

-- add to our table of keys pressed this frame
function love.keypressed(key)
    
    love.keyboard.keysPressed[key] = true
end

-- Checks if the some keyboard key was pressed
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

-- Updates game after each frame
function love.update(dt)
    -- Updating state machine after dt (after each frame)
    gStateMachine:update(dt)

    -- After dt (frame), empty the keys pressed list so I only take input from that frame (inside that dt)
    love.keyboard.keysPressed = {}
end

-- Draw game
function love.draw()

    -- Start the process of scalling to virtual screen dimension
    push:start()

    -- scrolling background drawn behind every state
    love.graphics.draw(gTextures['background'], 0,0)

    -- Rendering each state
    gStateMachine:render()

    push:finish()
end

