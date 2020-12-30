--[[
    Handles the change between game levels, game over and win. 
    If level 3 is completed, player wins game.
]]

local Gamestate = require 'lib.gamestate'
local choose_player = require 'states/choose'
local level = require 'states/level'
local gameover = require 'states/gameover'
local win = require 'states/win'

local Game = {}

function Game:enter()

    self.current_level = 1
    self.counter = 0
    self.over = false
    
    Gamestate.push(choose_player)
end

function Game:resume(from)
    self.from = from
    self.current_level = self.from.current_level
    self.playerSprite = self.from.playerSprite
    self.counter = self.from.counter
    self.over = self.from.over
end

function Game:update(dt)
    
    if self.over == true then
        Gamestate.push(gameover, self.playerSprite)
        
    elseif self.current_level == 4 then
        Gamestate.push(win, self.playerSprite)
    else
        Gamestate.push(level, self.current_level, self.counter, self.playerSprite)
    end
end

function Game:draw()
end

return Game