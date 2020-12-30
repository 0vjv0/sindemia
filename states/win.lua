local Gamestate = require 'lib.gamestate'
local tween = require 'lib.tween'

local Win = {}

local light = {alpha = 0}
local fadeIn = tween.new(0.5, light, {alpha = 1}, 'linear')
local fadeOut = tween.new(0.5, light, {alpha = 0}, 'linear')
local quit = false

local title = love.graphics.newFont("game/assets/fonts/Coronaviral.otf", 90)
local instructions = love.graphics.newFont("game/assets/fonts/Coronaviral.otf", 20)

local win_music = love.audio.newSource("game/assets/music/VforVictory.ogg", "stream")

function Win:enter(_, playerSprite)
    self.image = playerSprite

    love.audio.stop()
    win_music:play()
    local g = anim8.newGrid(64, 64, self.image:getWidth(), self.image:getHeight())
    self.animationDance = anim8.newAnimation(g('2-4',15, '4-2',15), 0.3)
end

function Win:update(dt)
    
    if quit == false then 
        fadeIn:update(dt)
    else
        fadeOut:update(dt)
    end

    self.animationDance:update(dt)
end

function Win:draw()

    love.graphics.setColor( 0.9, 0.9, 0.8, light.alpha)
    
    self.animationDance:draw(self.image, 350, 100)

    love.graphics.setColor( 0, 1, 0.1, light.alpha)

    love.graphics.setFont(title)
    love.graphics.print("You win", 250, 150)

    love.graphics.setFont(instructions)
    love.graphics.print("Space to restart", 50, 350)
    love.graphics.print("Q to quit", 50, 365)
end

function Win:keyreleased(key)
    if key == 'space' then
        quit = true
        love.event.quit("restart") 
    elseif key == 'q' then
        quit = true
        love.event.quit() 
    end
end

return Win
