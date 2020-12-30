-- Animated object. TO DO one class for all

require "game.objects.entity"
local anim8 = require 'lib.anim8'

Batman2 = Entity:extend()

function Batman2:new(x, y, width, height, image, world, ent_name)
    Batman.super.new(self, x, y, width, height, image, world, "ent_batman")
    self.x = x
    self.y = y    
    self.image = image
 
    local g = anim8.newGrid(32, 32, self.image:getWidth(), self.image:getHeight())
    self.animation = anim8.newAnimation(g('25-26',21,'26-25',21,'25-30',21), 0.2)
end

function Batman2:update(dt, entity, player)
    self.animation:update(dt)
end

function Batman2:draw()
    self.animation:draw(self.image, self.x, self.y)
end
