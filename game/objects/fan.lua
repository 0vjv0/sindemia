-- Animated object. TO DO one class for all

require "game.objects.entity"
local anim8 = require 'lib.anim8'

Fan = Entity:extend()

function Fan:new(x, y, width, height, image, world, ent_name)
    Fan.super.new(self, x, y, width, height, image, world, "fan")
    self.x = x
    self.y = y    
    self.image = image
 
    local g = anim8.newGrid(32, 32, self.image:getWidth(), self.image:getHeight())
    self.animation = anim8.newAnimation(g('9-10',2), 0.06)
end

function Fan:update(dt, entity, player)
    self.animation:update(dt)
end

function Fan:draw()
    self.animation:draw(self.image, self.x, self.y)
end
