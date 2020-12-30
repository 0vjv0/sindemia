-- Animated object. TO DO one class for all

require "game.objects.entity"
local anim8 = require 'lib.anim8'

Bird = Entity:extend()

function Bird:new(x, y, width, height, image, world, ent_name)
    Bird.super.new(self, x, y, width, height, image, world, "bird")
    self.x = x
    self.y = y    
    self.image = image
 
    local g = anim8.newGrid(32, 32, self.image:getWidth(), self.image:getHeight())
    
    local retardo = love.math.random(0,2.5)

    if love.math.random(1,2) == 1 then
        self.animation = anim8.newAnimation(g(15,'1-30'), {retardo, ['2-30']=0.09})
    else
        self.animation = anim8.newAnimation(g(16,'1-30'), {retardo, ['2-30']=0.09}) 
    end
end

function Bird:update(dt, entity, player)
    self.animation:update(dt)
end

function Bird:draw()
    self.animation:draw(self.image, self.x, self.y)
end
