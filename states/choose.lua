--Prompts player for sprite

local Gamestate = require 'lib.gamestate'
local tween = require 'lib.tween'

local state = {}

local choose_font = love.graphics.newFont('game/assets/fonts/virus43.ttf', 30)
local key_sound = love.audio.newSource("game/assets/sounds/key_sound.ogg", "static")
local success = love.audio.newSource("game/assets/sounds/success.ogg", "static")

function state:enter()
    self.light = {alpha = 0}
    self.fadeIn = tween.new(1, self.light, {alpha = 1}, 'linear')
    self.fadeOut = tween.new(1, self.light, {alpha = 0}, 'linear')

    self.current_level = 1
    self.counter = 0
    self.over = false

    self.playerA = love.graphics.newImage('game/assets/images/player/pAimage.png')
    self.playerB = love.graphics.newImage('game/assets/images/player/pBimage.png')
    self.shapeA = love.graphics.newImage('game/assets/images/player/pAshape.png')
    self.shapeB = love.graphics.newImage('game/assets/images/player/pBshape.png')

    self.selected = 'A'
    self.ready = false
end

function state:update(dt)
    
    self.fadeIn:update(dt)

    if self.ready == true then

        self.fadeOut:update(dt)
        
        if self.selected == 'A' then
            self.playerSprite = love.graphics.newImage('game/assets/images/player/playerA.png')
        elseif self.selected == 'B' then
            self.playerSprite = love.graphics.newImage('game/assets/images/player/playerB.png')
        end
        
        Gamestate.pop()
    end
end

function state:draw()

    love.graphics.setColor( 0.9, .9, .8, self.light.alpha)
    love.graphics.setFont(choose_font)

    love.graphics.print("Choose your player", 20, 140)

    love.graphics.setColor(0,1,0.1)

    if self.selected == 'A' then
        love.graphics.draw(self.shapeA, 300,100, 0, 1.5)
    elseif self.selected == 'B' then
        love.graphics.draw(self.shapeB, 500,100,  0, 1.5)
    end
    love.graphics.setColor( 0.9, .9, .8, self.light.alpha)

    love.graphics.draw(self.playerA, 300,100, 0, 1.5)
    love.graphics.draw(self.playerB, 500,100, 0, 1.5)
end

function state:keyreleased(key, code)
    if key == 'right' then
        if self.selected == 'A' then 
            self.selected = 'B'
            key_sound:play()
        end

    elseif key == 'left' then
        if self.selected == 'B' then
            self.selected = 'A'
            key_sound:play()
        end
    elseif key == 'space' then
        key_sound:play()
        self.ready = true
    end
end

return state