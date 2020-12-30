-- Who did what

local Gamestate = require 'lib.gamestate'
local Camera = require 'lib.camera'
local tween = require 'lib.tween'
local Timer = require "lib.timer"

local state = {}

function state:enter()
 
    self.camera = Camera()

    --Travelling effect
    self.coord = {x = 50, y = 100}
    self.travelling = tween.new(25, self.coord, {y = 1905}, 'linear')
    self.travellingOn = false

    --Fade effect
    self.light = {alpha = 0}
    self.fadeTween = tween.new(1, self.light, {alpha = 1}, 'linear')

    Timer.after(4, function() self.travellingOn = true end) 
end


function state:update(dt)

    Timer.update(dt)
    self.fadeTween:update(dt)
    
    self.camera:update(dt)
    self.camera:follow(self.coord.x, self.coord.y)
    if self.travellingOn == true then
        self.travelling:update(dt)
    end

    
end

function state:draw()
    
    -- self.light.alpha in setColor provokes flash, so use it this way
    if self.light.alpha == 1 then

        love.graphics.setColor(0, 1, 0.1)
        
        self.camera:attach()
        love.graphics.print("A", 0, 100)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("WORSE THAN 2020", 0, 135)
        love.graphics.setColor(0, 1, 0.1)
        love.graphics.print("production", 0, 160)

        love.graphics.print("Original idea and development", 0, 410)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("victorjvalbuena", 0, 445)
        love.graphics.setColor(0, 1, 0.1)

        love.graphics.print("Map tiles by", 0, 710)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("GuttyKreum", 0, 745)
        love.graphics.setColor(0, 1, 0.1)
        love.graphics.print("https://guttykreum.itch.io/", 0, 780)

        love.graphics.print("Terrain and trees tiles from", 0, 870)
        love.graphics.print("Pixel Liberate Cup Atlas by", 0, 895)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Barbara Rivera, Casper Nilsson,", 0, 930)
        love.graphics.print("Chris Phillips, Daniel Eddeland et. al", 0, 955)
        love.graphics.setColor(0, 1, 0.1)
        love.graphics.print("https://opengameart.org/content/lpc-tile-atlas2", 0, 990)
    
        love.graphics.print("Characters sprites made with the", 0, 1090)
        love.graphics.print("Universal LPC Spritesheet Character Generator by", 0, 1115)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("sanderfrenken", 0, 1145)
        love.graphics.setColor(0, 1, 0.1)
        love.graphics.print("https://sanderfrenken.github.io/", 0, 1180)
    
        love.graphics.print("with help from", 0, 1280)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Víctor Carrasco", 0, 1315)
        love.graphics.setColor(0, 1, 0.1)

        love.graphics.print("All music produced by", 0, 1415)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Jason Shaw", 0, 1440)
        love.graphics.setColor(0, 1, 0.1)
        love.graphics.print("https://audionautix.com/creative-commons-music", 0, 1475)

        love.graphics.print("Sound effects from", 0, 1575)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("freesound", 0, 1610)
        love.graphics.setColor(0, 1, 0.1)
        love.graphics.print("https://freesound.org", 0, 1645)

        love.graphics.print("..", 95, 1745)
        love.graphics.print("Made with LOVE and LOVE", 0, 1770)

        love.graphics.print("Creative Commons", 0, 1870)
        love.graphics.print("Attribution-ShareAlike 4.0 International", 0, 1895)
        love.graphics.print("Managua, 29th december 2020", 0, 1925)
        self.camera:detach()
    end
end

function state:keyreleased(key, code)
    if key == 'space' then
        Gamestate.pop()
    end
end

return state