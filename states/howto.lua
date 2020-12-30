-- Two slides with text and animations
-- Navigate with left and right
-- Jump From one to another with x coord. of camera

local Gamestate = require 'lib.gamestate'
local Camera = require 'lib.camera'
local tween = require 'lib.tween'
local anim8 = require 'lib.anim8'


local state = {}

local font = love.graphics.newFont('game/assets/fonts/virus43.ttf', 20)
local instructions = love.graphics.newFont("game/assets/fonts/Coronaviral.otf", 20)
local rate_font = love.graphics.newFont('game/assets/fonts/virus43.ttf', 24)

function state:enter()

    --Fade effect
    self.light = {alpha = 0}
    self.fadeTween = tween.new(1, self.light, {alpha = 1}, 'linear')

    self.camera = Camera()
    self.camerax = 400

    -- To move sprite
    self.spritex = 550

    --For rate animation
    self.number = 5

    self.howsprite1 = love.graphics.newImage('game/assets/images/sprites/sprite25.png')
    self.howsprite2 = love.graphics.newImage('game/assets/images/sprites/sprite26.png')
    self.virusImage = love.graphics.newImage('game/assets/images/sprites/cvirus.png')

    self.doctorsprite =  love.graphics.newImage('game/assets/images/endlevel/doctor.png')
    self.profesorsprite =  love.graphics.newImage('game/assets/images/endlevel/profesor.png')
    self.agentsprite =  love.graphics.newImage('game/assets/images/endlevel/davis.png')

    self.compassImage = love.graphics.newImage('game/assets/images/compass.png')

    local g = anim8.newGrid(64, 64, self.howsprite2:getWidth(), self.howsprite2:getHeight())
    self.animationLeft = anim8.newAnimation(g('1-9',10), {0, ['2-9']=0.08})
    self.animationIdle = anim8.newAnimation(g('1-7', 3), {1,0,0,0,0,0,1})
    self.animationContact =  anim8.newAnimation(g('7-10',16), 2)
    self.animationContact2 =  anim8.newAnimation(g('7-10',16), 2):flipH()

end

function state:update(dt)
    
    self.fadeTween:update(dt)

    --Simple tweening of sprite position and loop
    if self.spritex > 350 then
        self.spritex = self.spritex - (50*dt)
    else
        self.spritex = 550
        self.number = 5
    end

    self.camera:update(dt)
    self.camera:follow(self.camerax, 150)

    self.animationLeft:update(dt)
    self.animationIdle:update(dt)
    self.animationContact:update(dt)
    self.animationContact2:update(dt)

end

function state:draw()

    -- self.light.alpha in setColor provokes flash, so use it this way
    if self.light.alpha == 1 then
        
        self.camera:attach()
        love.graphics.setColor(0.9, 0.9, 0.8, self.light.alpha)
        love.graphics.setFont(font)
        
        --Slide 1
        love.graphics.setFont(font)
        love.graphics.print("The virus has reached the city.", 300,0)
        love.graphics.print("There are many people infected", 300,35)
        love.graphics.print("by not maintaining physical distance", 300,60)
        love.graphics.print("although some do not show symptoms.", 300,85)

        self.animationLeft:draw(self.howsprite2, self.spritex, 120)
        love.graphics.draw(self.virusImage, self.spritex +17, 108)
        self.animationIdle:draw(self.howsprite1, 320, 120)        
        if self.spritex < 375 then
            love.graphics.draw(self.virusImage, 341, 108)
            self.number = 6
        end

        love.graphics.print("We have to develop a vaccine", 300,190)
        love.graphics.print("before the contagion rate exceeds 90%.", 300,215)
        love.graphics.print("We need your help.", 300,250)

        love.graphics.setFont(rate_font)
        love.graphics.setColor(0, 1, 0.1, 1)
        love.graphics.print('Contagion rate: '..tostring(self.number)..'%', 30, -60)
        

        -- Slide 2
        love.graphics.setColor(0.9, 0.9, 0.8)
        love.graphics.draw(self.compassImage, 1040, -47)

        love.graphics.print("Use the compass", 900,-25)
        love.graphics.print("to find and contact three people", 900,0)
        love.graphics.print("who are collaborating", 900,25)
        love.graphics.print("with the development of a vaccine.", 900,50)

        self.animationContact2:draw(self.doctorsprite, 900, 75)
        self.animationContact:draw(self.profesorsprite, 1000, 75)
        self.animationContact:draw(self.agentsprite, 1100, 75)          

        love.graphics.print("Use the arrow keys", 900,175)
        love.graphics.print("to move around the city.", 900,200)
        
        love.graphics.print("When you find your contact,", 900,235)
        love.graphics.print("walk over and press the space key.", 900,260)

        love.graphics.print("Avoid contact with the virus.", 900,295)
       
        self.camera:detach()

        love.graphics.setColor(0, 1, 0.1, self.light.alpha)
        love.graphics.setFont(instructions)
        love.graphics.print("Left, right to navigate", 50, 350)
        love.graphics.print("Space to return", 50, 365)


    end
end

function state:keyreleased(key, code)

    if key == 'space' then
        Gamestate.pop()
    elseif key == 'right' then
        self.camerax = 1000
    elseif key == 'left' then
        self.camerax = 400
    end
end

return state