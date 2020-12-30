-- Animated object. TO DO one class for all

require "game.objects.entity"
local anim8 = require 'lib.anim8'

Decor = Entity:extend()

function Decor:new(x, y, width, height, image, world, ent_name)
    Decor.super.new(self, x, y, width, height, image, world, "decor")
    self.x = x
    self.y = y    
    self.image = image
 
    local g = anim8.newGrid(32, 32, self.image:getWidth(), self.image:getHeight())
    self.animation = anim8.newAnimation(g('1-15',21), 0.06)
end

function Decor:update(dt, entity, player)
    self.animation:update(dt)
end

function Decor:draw()
    self.animation:draw(self.image, self.x, self.y)
end
