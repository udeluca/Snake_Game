--[[
    GD50
    Snake Game

    -- Start State --

    Author: Umberto De Luca
    udeluca@student.ubc.ca
]]

StartState = Class{__includes = BaseState}

function StartState:init()
    local possible_dir = {"up", "down", "left", "right"}
    self.player = Player{
        headX = nil,
        headY = nil,
        gridHeadX = nil,
        gridHeadY = nil,
        score = 0,
        direction = possible_dir[math.random(#possible_dir)],
        isAI = true
    }

    self.object = GameObject{
        GAME_OBJECT_DEFS['food']
    }

    self.board = Board(self.player, self.object)

    local srcJ = self.board.player.gridHeadX
    local srcI = self.board.player.gridHeadY

    local destI = self.board.object.posGridY
    local destJ = self.board.object.posGridX

    self.board.player.path = self.board.player.AI:a_star_search(self.board.player.body, {srcI, srcJ}, {destI, destJ})
end

function StartState:update(dt)
    -- Quit game if esc key was pressed
    if love.keyboard.wasPressed("escape") then
        love.event.quit()
    end

    -- Change to play state if enter was pressed
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change('play')
    end

    Timer.update(dt)
    self.board:update(dt)
    

    -- Collision logic (score updates and grow & respawn functions are triggered)
    if self.board.player:headCollides(self.board.object) then
        self.board.player.score = self.board.player.score + 1
        self.board.player:grow(self.board.object)
        self.board:respawnObject()

        local srcJ = self.board.player.gridHeadX
        local srcI = self.board.player.gridHeadY

        local destI = self.board.object.posGridY
        local destJ = self.board.object.posGridX

        self.board.player.path = self.board.player.AI:a_star_search(self.board.player.body, {srcI, srcJ}, {destI, destJ})
    end

    -- Out-of-bounds checking: left/right or top/bottom; Hitting its own body part checking; Win condition checking
    local x, y = self.board.player.gridHeadX, self.board.player.gridHeadY
    if x > BOARD_DIMENSIONS - 1 or y > BOARD_DIMENSIONS - 1 or x < 0 or y < 0  then--or self.board.player.body[x + 1][y + 1] or self.board.player.score == BOARD_DIMENSIONS*BOARD_DIMENSIONS then
        gStateMachine:change('start')
    end

end

function StartState:render()
    -- Rendering board and its components
    self.board:render()

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

   --[[

   local score_locationX = BOARD_X + BOARD_DIMENSIONS*TILE_SIZE + TILE_SIZE/2
   local score_locationY = BOARD_Y
   local path = self.board.player.path
   local sPath = ""
   
   for k = #path, 1, -1 do
        sPath = sPath .. (string.format("-> %i, %i", path[k][1], path[k][2]))
    end
   
   love.graphics.setFont(gFonts["small"])
   love.graphics.print(sPath, score_locationX, score_locationY)
   ]]
end